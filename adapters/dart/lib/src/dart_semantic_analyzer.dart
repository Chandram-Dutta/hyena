import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/diagnostic/diagnostic.dart' as analyzer_diagnostic;
import 'package:analyzer/error/error.dart' as analyzer_error;
import 'package:crypto/crypto.dart';
import 'package:fixnum/fixnum.dart';
import 'package:path/path.dart' as p;

import 'generated/hyena_adapter.pb.dart';

const sourceDiscoveryDimension = 'hyena.dead_code.source_discovery';
const semanticResolutionDimension = 'hyena.dead_code.semantic_resolution';
const rootsDimension = 'hyena.dead_code.roots';
const retentionEdgesDimension = 'hyena.dead_code.retention_edges';
const dynamicBehaviorDimension = 'hyena.dead_code.dynamic_behavior';

class DartAnalysisFacts {
  final List<Artifact> artifacts;
  final List<Symbol> symbols;
  final List<RetentionEdge> retentionEdges;
  final List<Root> roots;
  final List<Diagnostic> diagnostics;
  final List<Completeness> completeness;

  const DartAnalysisFacts({
    required this.artifacts,
    required this.symbols,
    required this.retentionEdges,
    required this.roots,
    required this.diagnostics,
    required this.completeness,
  });

  bool get isPartial => completeness.any(
    (dimension) =>
        dimension.status != CompletenessStatus.COMPLETENESS_STATUS_COMPLETE,
  );
}

class DartSemanticAnalyzer {
  Future<DartAnalysisFacts> analyze(AnalyzeRequest request) async {
    final workspaceRoot = await _resolveWorkspaceRoot(request.workspaceRoot);
    final target = await _resolveTarget(workspaceRoot, request.target);
    final discovery = await _collectDartFiles(target);
    final dartFiles = discovery.files;
    final artifacts = <Artifact>[];
    final diagnostics = <Diagnostic>[];
    final sources = <String, _SourceFile>{};

    final symbols = <String, Symbol>{};
    final parents = <String, _PendingParent>{};
    final pendingEdges = <_PendingEdge>[];
    final pendingRoots = <_PendingRoot>[];
    final unresolvedMembers = <_UnresolvedMember>[];
    var semanticResolutionComplete = true;

    final collection = AnalysisContextCollection(
      includedPaths: [target],
      sdkPath: _dartSdkPath(),
    );
    try {
      dartFiles.removeWhere(
        (file) => !collection.contexts.any(
          (context) => context.contextRoot.isAnalyzed(file),
        ),
      );

      for (final file in dartFiles) {
        final bytes = await File(file).readAsBytes();
        final source = utf8.decode(bytes);
        final artifactId = _artifactId(workspaceRoot, file);
        final sourceFile = _SourceFile(
          artifactId: artifactId,
          text: source,
          bytes: bytes,
        );
        sources[file] = sourceFile;
        artifacts.add(sourceFile.artifact);
      }

      for (final file in dartFiles) {
        final source = sources[file]!;
        final result = await collection
            .contextFor(file)
            .currentSession
            .getResolvedUnit(file);
        if (result is! ResolvedUnitResult) {
          semanticResolutionComplete = false;
          diagnostics.add(
            Diagnostic(
              severity: DiagnosticSeverity.DIAGNOSTIC_SEVERITY_ERROR,
              code: 'dart.resolution.unavailable',
              message: 'The Dart analyzer did not return a resolved unit.',
              span: source.span(0, 0),
            ),
          );
          continue;
        }

        final errors = result.diagnostics.where(
          (diagnostic) =>
              diagnostic.diagnosticCode.severity ==
              analyzer_error.DiagnosticSeverity.ERROR,
        );
        if (errors.isNotEmpty) {
          semanticResolutionComplete = false;
          diagnostics.addAll(
            result.diagnostics.map(
              (diagnostic) => _diagnostic(source, diagnostic),
            ),
          );
          continue;
        }

        diagnostics.addAll(
          result.diagnostics.map(
            (diagnostic) => _diagnostic(source, diagnostic),
          ),
        );
        result.unit.accept(
          _SemanticVisitor(
            workspaceRoot: workspaceRoot,
            source: source,
            symbols: symbols,
            parents: parents,
            pendingEdges: pendingEdges,
            pendingRoots: pendingRoots,
            unresolvedMembers: unresolvedMembers,
          ),
        );
      }
    } finally {
      await collection.dispose();
    }

    final declaredKeys = symbols.keys.toSet();
    final edgesByIdentity = <String, RetentionEdge>{};
    for (final edge in pendingEdges) {
      if (!declaredKeys.contains(edge.source.value) ||
          !declaredKeys.contains(edge.target.value)) {
        continue;
      }
      edgesByIdentity.putIfAbsent(edge.identity, () => edge.toProtocol);
    }
    for (final entry in parents.entries) {
      final parent = entry.value;
      if (!declaredKeys.contains(parent.parent.value)) continue;
      final edge = _PendingEdge(
        source: parent.child,
        target: parent.parent,
        kind: RetentionEdgeKind.RETENTION_EDGE_KIND_DECLARATION_OWNER,
        evidence: parent.evidence,
      );
      edgesByIdentity.putIfAbsent(edge.identity, () => edge.toProtocol);
    }

    final rootsByIdentity = <String, Root>{};
    for (final root in pendingRoots) {
      if (!declaredKeys.contains(root.symbol.value)) continue;
      rootsByIdentity.putIfAbsent(root.identity, () => root.toProtocol);
    }
    for (final unresolved in unresolvedMembers) {
      for (final symbol in symbols.values) {
        if (symbol.displayName != unresolved.name || !symbol.hasKey()) {
          continue;
        }
        final identity = _identityFromProtocol(symbol.key);
        final root = _PendingRoot(
          symbol: identity,
          kind: RootKind.ROOT_KIND_DYNAMIC_DISPATCH,
          evidence: unresolved.evidence,
          reasonCode: 'dart.unresolved_member_name',
        );
        rootsByIdentity.putIfAbsent(root.identity, () => root.toProtocol);
      }
    }

    final orderedArtifacts = artifacts..sort((a, b) => a.id.compareTo(b.id));
    final orderedSymbols = symbols.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final orderedEdges = edgesByIdentity.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final orderedRoots = rootsByIdentity.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    diagnostics.sort((a, b) {
      final byArtifact = a.span.artifactId.compareTo(b.span.artifactId);
      if (byArtifact != 0) return byArtifact;
      return a.span.startByte.compareTo(b.span.startByte);
    });

    final semanticStatus = semanticResolutionComplete
        ? CompletenessStatus.COMPLETENESS_STATUS_COMPLETE
        : CompletenessStatus.COMPLETENESS_STATUS_PARTIAL;
    final retentionStatus =
        semanticResolutionComplete && unresolvedMembers.isEmpty
        ? CompletenessStatus.COMPLETENESS_STATUS_COMPLETE
        : CompletenessStatus.COMPLETENESS_STATUS_PARTIAL;

    return DartAnalysisFacts(
      artifacts: orderedArtifacts,
      symbols: orderedSymbols.map((entry) => entry.value).toList(),
      retentionEdges: orderedEdges.map((entry) => entry.value).toList(),
      roots: orderedRoots.map((entry) => entry.value).toList(),
      diagnostics: diagnostics,
      completeness: [
        _completeness(
          sourceDiscoveryDimension,
          discovery.generatedSourcesExcluded
              ? CompletenessStatus.COMPLETENESS_STATUS_PARTIAL
              : CompletenessStatus.COMPLETENESS_STATUS_COMPLETE,
          discovery.generatedSourcesExcluded
              ? 'dart.generated_sources_excluded'
              : '',
        ),
        _completeness(
          semanticResolutionDimension,
          semanticStatus,
          semanticStatus == CompletenessStatus.COMPLETENESS_STATUS_PARTIAL
              ? 'dart.resolution_failed'
              : '',
        ),
        _completeness(
          rootsDimension,
          CompletenessStatus.COMPLETENESS_STATUS_PARTIAL,
          'dart.framework_and_reflection_roots_not_modeled',
        ),
        _completeness(
          retentionEdgesDimension,
          retentionStatus,
          retentionStatus == CompletenessStatus.COMPLETENESS_STATUS_PARTIAL
              ? 'dart.unresolved_or_failed_resolution'
              : '',
        ),
        _completeness(
          dynamicBehaviorDimension,
          CompletenessStatus.COMPLETENESS_STATUS_PARTIAL,
          'dart.dynamic_dispatch_and_reflection_not_closed',
        ),
      ],
    );
  }
}

Completeness _completeness(
  String capabilityId,
  CompletenessStatus status, [
  String reasonCode = '',
]) => Completeness(
  capabilityId: capabilityId,
  status: status,
  reasonCode: reasonCode,
);

String _dartSdkPath() {
  final configured = Platform.environment['DART_SDK'];
  if (configured != null && _isDartSdk(configured)) {
    return p.normalize(p.absolute(configured));
  }

  final resolvedExecutable = _sdkForExecutable(Platform.resolvedExecutable);
  if (resolvedExecutable != null) return resolvedExecutable;

  final path = Platform.environment['PATH'] ?? '';
  final separator = Platform.isWindows ? ';' : ':';
  final executableName = Platform.isWindows ? 'dart.exe' : 'dart';
  for (final directory
      in path.split(separator).where((value) => value.isNotEmpty)) {
    final sdk = _sdkForExecutable(p.join(directory, executableName));
    if (sdk != null) return sdk;
  }
  throw StateError(
    'Could not locate the Dart SDK. Set DART_SDK or put dart on PATH.',
  );
}

String? _sdkForExecutable(String executable) {
  try {
    final resolved = File(executable).resolveSymbolicLinksSync();
    final binDirectory = p.dirname(resolved);
    final direct = p.dirname(binDirectory);
    if (_isDartSdk(direct)) return direct;
    final flutter = p.join(binDirectory, 'cache', 'dart-sdk');
    if (_isDartSdk(flutter)) return flutter;
  } on FileSystemException {
    return null;
  }
  return null;
}

bool _isDartSdk(String path) => File(
  p.join(path, 'lib', '_internal', 'allowed_experiments.json'),
).existsSync();

Future<String> _resolveWorkspaceRoot(String requested) async {
  if (requested.isEmpty) {
    throw const FormatException('workspace_root must not be empty');
  }
  final directory = Directory(p.normalize(p.absolute(requested)));
  if (!await directory.exists()) {
    throw FormatException('workspace_root does not exist: $requested');
  }
  return directory.resolveSymbolicLinks();
}

Future<String> _resolveTarget(String workspaceRoot, String requested) async {
  final target = requested.isEmpty ? '.' : requested;
  if (p.isAbsolute(target) ||
      p.split(target).any((segment) => segment == '..')) {
    throw FormatException(
      'target must be a workspace-relative path without .. segments: '
      '$requested',
    );
  }

  final entity = p.normalize(p.join(workspaceRoot, target));
  final type = await FileSystemEntity.type(entity, followLinks: true);
  if (type == FileSystemEntityType.notFound) {
    throw FormatException('target does not exist: $requested');
  }
  final resolved = type == FileSystemEntityType.directory
      ? await Directory(entity).resolveSymbolicLinks()
      : await File(entity).resolveSymbolicLinks();
  if (!p.equals(workspaceRoot, resolved) &&
      !p.isWithin(workspaceRoot, resolved)) {
    throw FormatException('target resolves outside workspace_root: $requested');
  }
  return resolved;
}

Future<({List<String> files, bool generatedSourcesExcluded})> _collectDartFiles(
  String target,
) async {
  final type = await FileSystemEntity.type(target, followLinks: true);
  if (type == FileSystemEntityType.file) {
    if (!target.endsWith('.dart')) {
      throw FormatException('target file is not Dart source: $target');
    }
    return (files: [target], generatedSourcesExcluded: false);
  }
  if (type != FileSystemEntityType.directory) {
    throw FormatException('target must be a Dart file or directory: $target');
  }

  final files = <String>[];
  var generatedSourcesExcluded = false;
  await for (final entity in Directory(
    target,
  ).list(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (_isExcluded(entity.path)) {
      generatedSourcesExcluded |= _isGenerated(entity.path);
      continue;
    }
    files.add(p.normalize(p.absolute(entity.path)));
  }
  files.sort();
  return (files: files, generatedSourcesExcluded: generatedSourcesExcluded);
}

bool _isExcluded(String file) {
  final segments = p.split(file);
  return segments.any(
        (segment) =>
            segment == '.dart_tool' ||
            segment == 'build' ||
            segment == 'generated',
      ) ||
      file.endsWith('.g.dart') ||
      file.endsWith('.freezed.dart') ||
      file.endsWith('.mocks.dart');
}

bool _isGenerated(String file) {
  final segments = p.split(file);
  return segments.contains('generated') ||
      file.endsWith('.g.dart') ||
      file.endsWith('.freezed.dart') ||
      file.endsWith('.mocks.dart');
}

String _artifactId(String workspaceRoot, String file) {
  final relative = p.relative(file, from: workspaceRoot);
  if (relative == '.' || p.isAbsolute(relative) || relative.startsWith('..')) {
    throw FormatException('source artifact is outside workspace_root: $file');
  }
  return p.posix.joinAll(p.split(relative));
}

Diagnostic _diagnostic(
  _SourceFile source,
  analyzer_diagnostic.Diagnostic diagnostic,
) => Diagnostic(
  severity: switch (diagnostic.diagnosticCode.severity) {
    analyzer_error.DiagnosticSeverity.ERROR =>
      DiagnosticSeverity.DIAGNOSTIC_SEVERITY_ERROR,
    analyzer_error.DiagnosticSeverity.WARNING =>
      DiagnosticSeverity.DIAGNOSTIC_SEVERITY_WARNING,
    _ => DiagnosticSeverity.DIAGNOSTIC_SEVERITY_INFO,
  },
  code: diagnostic.diagnosticCode.name,
  message: diagnostic.message,
  span: source.span(diagnostic.offset, diagnostic.length),
);

class _SourceFile {
  final String artifactId;
  final String text;
  final List<int> bytes;
  late final List<int> _utf8Offsets = _buildUtf8Offsets(text);

  _SourceFile({
    required this.artifactId,
    required this.text,
    required this.bytes,
  });

  Artifact get artifact => Artifact(
    id: artifactId,
    language: 'dart',
    byteLength: Int64(bytes.length),
    contentDigest: ContentDigest(
      algorithm: 'sha256',
      value: sha256.convert(bytes).bytes,
    ),
    sourceEncoding: SourceEncoding.SOURCE_ENCODING_UTF8,
    origin: _isExcluded(artifactId)
        ? ArtifactOrigin.ARTIFACT_ORIGIN_GENERATED
        : ArtifactOrigin.ARTIFACT_ORIGIN_SOURCE,
  );

  SourceSpan span(int offset, int length) {
    final start = offset.clamp(0, text.length);
    final end = (offset + length).clamp(start, text.length);
    return SourceSpan(
      artifactId: artifactId,
      startByte: Int64(_utf8Offsets[start]),
      endByte: Int64(_utf8Offsets[end]),
    );
  }
}

List<int> _buildUtf8Offsets(String source) {
  final offsets = List<int>.filled(source.length + 1, 0);
  var codeUnitOffset = 0;
  var byteOffset = 0;
  for (final rune in source.runes) {
    final codeUnits = rune > 0xffff ? 2 : 1;
    final utf8Bytes = rune <= 0x7f
        ? 1
        : rune <= 0x7ff
        ? 2
        : rune <= 0xffff
        ? 3
        : 4;
    offsets[codeUnitOffset] = byteOffset;
    if (codeUnits == 2) offsets[codeUnitOffset + 1] = byteOffset;
    codeUnitOffset += codeUnits;
    byteOffset += utf8Bytes;
    offsets[codeUnitOffset] = byteOffset;
  }
  return offsets;
}

class _SemanticVisitor extends RecursiveAstVisitor<void> {
  final String workspaceRoot;
  final _SourceFile source;
  final Map<String, Symbol> symbols;
  final Map<String, _PendingParent> parents;
  final List<_PendingEdge> pendingEdges;
  final List<_PendingRoot> pendingRoots;
  final List<_UnresolvedMember> unresolvedMembers;
  _SemanticIdentity? _currentDeclaration;

  _SemanticVisitor({
    required this.workspaceRoot,
    required this.source,
    required this.symbols,
    required this.parents,
    required this.pendingEdges,
    required this.pendingRoots,
    required this.unresolvedMembers,
  });

  void _visitDeclaration(
    Element? element,
    Token name,
    SymbolKind kind,
    void Function() visit, {
    bool isRoot = false,
    bool isOverride = false,
    String? displayName,
  }) {
    final identity = _identity(element, workspaceRoot);
    if (identity == null) {
      visit();
      return;
    }

    final declarationName = displayName ?? name.lexeme;
    final symbol = Symbol(
      key: identity.toProtocol,
      displayName: declarationName,
      qualifiedName: _qualifiedName(element!),
      kind: kind,
      declaration: source.span(name.offset, name.length),
      visibility: declarationName.startsWith('_')
          ? Visibility.VISIBILITY_PRIVATE
          : Visibility.VISIBILITY_PUBLIC,
      exportStatus: ExportStatus.EXPORT_STATUS_UNSPECIFIED,
    );
    symbols.putIfAbsent(identity.value, () => symbol);

    final parent = _declarationParent(element, workspaceRoot);
    if (parent != null) {
      parents.putIfAbsent(
        identity.value,
        () => _PendingParent(
          child: identity,
          parent: parent,
          evidence: symbol.declaration,
        ),
      );
    }
    if (isRoot || isOverride) {
      pendingRoots.add(
        _PendingRoot(
          symbol: identity,
          kind: isOverride
              ? RootKind.ROOT_KIND_OVERRIDE
              : RootKind.ROOT_KIND_ENTRY_POINT,
          evidence: symbol.declaration,
          reasonCode: isOverride
              ? 'dart.override_contract'
              : 'dart.main_entry_point',
        ),
      );
    }

    final previous = _currentDeclaration;
    _currentDeclaration = identity;
    visit();
    _currentDeclaration = previous;
  }

  void _recordElement(
    Element? element,
    AstNode evidence, {
    RetentionEdgeKind kind = RetentionEdgeKind.RETENTION_EDGE_KIND_REFERENCE,
  }) {
    if (element == null) return;
    final candidates = <Element>[element.baseElement];
    if (element is PropertyAccessorElement) {
      candidates.add(element.variable.baseElement);
    }
    for (final candidate in candidates) {
      final target = _identity(candidate, workspaceRoot);
      if (target == null) continue;
      final span = source.span(evidence.offset, evidence.length);
      final current = _currentDeclaration;
      if (current == null) {
        pendingRoots.add(
          _PendingRoot(
            symbol: target,
            kind: RootKind.ROOT_KIND_TOP_LEVEL_EFFECT,
            evidence: span,
            reasonCode: 'dart.top_level_reference',
          ),
        );
      } else {
        pendingEdges.add(
          _PendingEdge(
            source: current,
            target: target,
            kind: kind,
            evidence: span,
          ),
        );
      }
    }
  }

  void _recordUnresolved(SimpleIdentifier identifier) {
    unresolvedMembers.add(
      _UnresolvedMember(
        name: identifier.name,
        evidence: source.span(identifier.offset, identifier.length),
      ),
    );
  }

  bool _isResolvedByCompoundParent(Expression node) {
    final parent = node.parent;
    if (parent is AssignmentExpression &&
        identical(parent.leftHandSide, node)) {
      return parent.readElement != null || parent.writeElement != null;
    }
    if (parent is PrefixExpression && identical(parent.operand, node)) {
      return parent.readElement != null || parent.writeElement != null;
    }
    if (parent is PostfixExpression && identical(parent.operand, node)) {
      return parent.readElement != null || parent.writeElement != null;
    }
    return false;
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_CLASS,
      () => super.visitClassDeclaration(node),
    );
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_MIXIN,
      () => super.visitMixinDeclaration(node),
    );
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    final name = node.name;
    if (name == null) {
      super.visitExtensionDeclaration(node);
      return;
    }
    _visitDeclaration(
      node.declaredFragment?.element,
      name,
      SymbolKind.SYMBOL_KIND_EXTENSION,
      () => super.visitExtensionDeclaration(node),
    );
  }

  @override
  void visitExtensionTypeDeclaration(ExtensionTypeDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_EXTENSION_TYPE,
      () => super.visitExtensionTypeDeclaration(node),
    );
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_ENUM,
      () => super.visitEnumDeclaration(node),
    );
  }

  @override
  void visitEnumConstantDeclaration(EnumConstantDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_ENUM_VALUE,
      () => super.visitEnumConstantDeclaration(node),
    );
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final kind = node.isGetter
        ? SymbolKind.SYMBOL_KIND_GETTER
        : node.isSetter
        ? SymbolKind.SYMBOL_KIND_SETTER
        : SymbolKind.SYMBOL_KIND_FUNCTION;
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      kind,
      () => super.visitFunctionDeclaration(node),
      isRoot: node.name.lexeme == 'main' && node.parent is CompilationUnit,
    );
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final kind = node.isGetter
        ? SymbolKind.SYMBOL_KIND_GETTER
        : node.isSetter
        ? SymbolKind.SYMBOL_KIND_SETTER
        : SymbolKind.SYMBOL_KIND_METHOD;
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      kind,
      () => super.visitMethodDeclaration(node),
      isOverride: _isOverridingMember(node),
    );
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name ?? node.returnType.beginToken,
      SymbolKind.SYMBOL_KIND_CONSTRUCTOR,
      () => super.visitConstructorDeclaration(node),
      displayName: node.name?.lexeme ?? 'new',
    );
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    final element = node.declaredFragment?.element;
    final parent = node.parent?.parent;
    if (element is FieldElement && parent is FieldDeclaration) {
      _visitDeclaration(
        element,
        node.name,
        SymbolKind.SYMBOL_KIND_FIELD,
        () => super.visitVariableDeclaration(node),
        isOverride: _isOverridingField(parent, node),
      );
    } else if (element is TopLevelVariableElement) {
      _visitDeclaration(
        element,
        node.name,
        SymbolKind.SYMBOL_KIND_TOP_LEVEL_VARIABLE,
        () => super.visitVariableDeclaration(node),
      );
    } else {
      super.visitVariableDeclaration(node);
    }
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_TYPE_ALIAS,
      () => super.visitFunctionTypeAlias(node),
    );
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    _visitDeclaration(
      node.declaredFragment?.element,
      node.name,
      SymbolKind.SYMBOL_KIND_TYPE_ALIAS,
      () => super.visitGenericTypeAlias(node),
    );
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _recordElement(node.element, node);
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.methodName.element == null) {
      _recordUnresolved(node.methodName);
    }
    _recordElement(
      node.methodName.element,
      node.methodName,
      kind: RetentionEdgeKind.RETENTION_EDGE_KIND_CALL,
    );
    super.visitMethodInvocation(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    if (node.identifier.element == null &&
        node.prefix.element != null &&
        !_isResolvedByCompoundParent(node)) {
      _recordUnresolved(node.identifier);
    }
    super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.propertyName.element == null &&
        !_isResolvedByCompoundParent(node)) {
      _recordUnresolved(node.propertyName);
    }
    super.visitPropertyAccess(node);
  }

  @override
  void visitConstructorName(ConstructorName node) {
    _recordElement(
      node.element,
      node,
      kind: RetentionEdgeKind.RETENTION_EDGE_KIND_CALL,
    );
    _recordElement(
      node.type.element,
      node.type,
      kind: RetentionEdgeKind.RETENTION_EDGE_KIND_TYPE_USE,
    );
    super.visitConstructorName(node);
  }

  @override
  void visitNamedType(NamedType node) {
    _recordElement(
      node.element,
      node,
      kind: RetentionEdgeKind.RETENTION_EDGE_KIND_TYPE_USE,
    );
    super.visitNamedType(node);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _recordElement(node.readElement, node.leftHandSide);
    _recordElement(node.writeElement, node.leftHandSide);
    super.visitAssignmentExpression(node);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    _recordElement(node.readElement, node.operand);
    _recordElement(node.writeElement, node.operand);
    super.visitPostfixExpression(node);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    _recordElement(node.readElement, node.operand);
    _recordElement(node.writeElement, node.operand);
    super.visitPrefixExpression(node);
  }
}

_SemanticIdentity? _identity(Element? element, String workspaceRoot) {
  if (element == null || element.library == null) return null;
  final baseElement = element.baseElement;
  if (baseElement is LocalFunctionElement) {
    final libraryUri = element.library!.uri;
    final library = libraryUri.scheme == 'file'
        ? _portableFileUri(libraryUri, workspaceRoot)
        : libraryUri.toString();
    final sourceUri = baseElement.firstFragment.libraryFragment.source.uri;
    final source = sourceUri.scheme == 'file'
        ? _portableFileUri(sourceUri, workspaceRoot)
        : sourceUri.toString();
    return _SemanticIdentity(
      value: jsonEncode([
        library,
        'local-function:$source@${baseElement.firstFragment.offset}',
      ]),
      stability: SymbolStability.SYMBOL_STABILITY_SNAPSHOT,
    );
  }

  final descriptors = <String>[];
  var current = baseElement;
  var stability = SymbolStability.SYMBOL_STABILITY_CROSS_SNAPSHOT;
  while (current is! LibraryElement) {
    var name = current.lookupName ?? current.displayName;
    if (name.isEmpty) {
      name = '@${current.firstFragment.offset}';
      stability = SymbolStability.SYMBOL_STABILITY_SNAPSHOT;
    }
    descriptors.add('${current.kind.name}:$name');
    final parent = current.enclosingElement;
    if (parent == null) break;
    current = parent.baseElement;
  }
  if (descriptors.isEmpty) return null;

  final uri = element.library!.uri;
  final library = uri.scheme == 'file'
      ? _portableFileUri(uri, workspaceRoot)
      : uri.toString();
  final value = jsonEncode([library, ...descriptors.reversed]);
  return _SemanticIdentity(value: value, stability: stability);
}

String _portableFileUri(Uri uri, String workspaceRoot) {
  final file = p.normalize(uri.toFilePath());
  if (p.equals(file, workspaceRoot) || p.isWithin(workspaceRoot, file)) {
    final relative = p.relative(file, from: workspaceRoot);
    return 'workspace:${p.posix.joinAll(p.split(relative))}';
  }
  return uri.toString();
}

_SemanticIdentity? _declarationParent(Element element, String workspaceRoot) {
  var parent = element.enclosingElement;
  while (parent != null && parent is! LibraryElement) {
    if (parent is InterfaceElement ||
        parent is ExtensionElement ||
        parent is ExtensionTypeElement) {
      return _identity(parent, workspaceRoot);
    }
    parent = parent.enclosingElement;
  }
  return null;
}

String _qualifiedName(Element element) {
  final names = <String>[];
  Element? current = element;
  while (current != null && current is! LibraryElement) {
    final name = current.displayName;
    if (name.isNotEmpty) names.add(name);
    current = current.enclosingElement;
  }
  return names.reversed.join('.');
}

bool _isOverridingMember(MethodDeclaration node) {
  if (_hasOverrideAnnotation(node)) return true;
  final element = node.declaredFragment?.element;
  final name = '${node.name.lexeme}${node.isSetter ? '=' : ''}';
  return element != null && _isOverridingExecutable(element, name);
}

bool _isOverridingField(
  FieldDeclaration declaration,
  VariableDeclaration variable,
) {
  if (_hasOverrideAnnotation(declaration)) return true;
  final element = variable.declaredFragment?.element;
  if (element is! FieldElement) return false;
  final name = variable.name.lexeme;
  final getter = element.getter;
  final setter = element.setter;
  return (getter != null && _isOverridingExecutable(getter, name)) ||
      (setter != null && _isOverridingExecutable(setter, '$name='));
}

bool _hasOverrideAnnotation(AnnotatedNode node) =>
    node.metadata.any((annotation) => annotation.name.name == 'override');

bool _isOverridingExecutable(ExecutableElement element, String name) {
  final enclosing = element.enclosingElement;
  if (enclosing is! InterfaceElement) return false;
  final overridden = enclosing.getOverridden(
    Name.forLibrary(element.library, name),
  );
  return overridden != null && overridden.isNotEmpty;
}

class _SemanticIdentity {
  final String value;
  final SymbolStability stability;

  const _SemanticIdentity({required this.value, required this.stability});

  SymbolKey get toProtocol => SymbolKey(
    scheme: 'dart.element',
    schemeVersion: 1,
    value: utf8.encode(value),
    stability: stability,
  );
}

_SemanticIdentity _identityFromProtocol(SymbolKey key) =>
    _SemanticIdentity(value: utf8.decode(key.value), stability: key.stability);

class _PendingParent {
  final _SemanticIdentity child;
  final _SemanticIdentity parent;
  final SourceSpan evidence;

  const _PendingParent({
    required this.child,
    required this.parent,
    required this.evidence,
  });
}

class _PendingEdge {
  final _SemanticIdentity source;
  final _SemanticIdentity target;
  final RetentionEdgeKind kind;
  final SourceSpan evidence;

  const _PendingEdge({
    required this.source,
    required this.target,
    required this.kind,
    required this.evidence,
  });

  String get identity =>
      '${source.value}\u0000${target.value}\u0000${kind.value}\u0000'
      '${evidence.artifactId}\u0000${evidence.startByte}';

  RetentionEdge get toProtocol => RetentionEdge(
    source: source.toProtocol,
    target: target.toProtocol,
    kind: kind,
    evidence: evidence,
  );
}

class _PendingRoot {
  final _SemanticIdentity symbol;
  final RootKind kind;
  final SourceSpan evidence;
  final String reasonCode;

  const _PendingRoot({
    required this.symbol,
    required this.kind,
    required this.evidence,
    required this.reasonCode,
  });

  String get identity =>
      '${symbol.value}\u0000${kind.value}\u0000$reasonCode\u0000'
      '${evidence.artifactId}\u0000${evidence.startByte}';

  Root get toProtocol => Root(
    symbol: symbol.toProtocol,
    kind: kind,
    evidence: evidence,
    reasonCode: reasonCode,
  );
}

class _UnresolvedMember {
  final String name;
  final SourceSpan evidence;

  const _UnresolvedMember({required this.name, required this.evidence});
}
