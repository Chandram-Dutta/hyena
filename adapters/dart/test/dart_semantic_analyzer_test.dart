import 'dart:convert';
import 'dart:io';

import 'package:fixnum/fixnum.dart';
import 'package:hyena_dart_adapter/hyena_dart_adapter.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  late Directory fixture;

  setUp(() async {
    fixture = await Directory.systemTemp.createTemp('hyena_dart_adapter_');
    await File(p.join(fixture.path, 'pubspec.yaml')).writeAsString('''
name: adapter_fixture
environment:
  sdk: ^3.10.0
''');
  });

  tearDown(() async {
    if (await fixture.exists()) await fixture.delete(recursive: true);
  });

  Future<DartAnalysisFacts> analyze(String source) async {
    final library = await Directory(p.join(fixture.path, 'lib')).create();
    await File(p.join(library.path, 'main.dart')).writeAsString(source);
    final pub = await Process.run(Platform.resolvedExecutable, [
      'pub',
      'get',
    ], workingDirectory: fixture.path);
    if (pub.exitCode != 0) {
      fail('dart pub get failed: ${pub.stderr}');
    }
    return DartSemanticAnalyzer().analyze(
      AnalyzeRequest(
        workspaceRoot: fixture.path,
        target: 'lib',
        variantId: 'default',
      ),
    );
  }

  test('emits deterministic semantic facts with UTF-8 byte spans', () async {
    const source = '''
// 😀 offsets must be UTF-8 bytes.
class Used {
  void hello() => print('used');
}

class Dead {
  void hello() => print('dead');
}

void main() {
  Used().hello();
}
''';

    final facts = await analyze(source);
    final byName = {
      for (final symbol in facts.symbols) symbol.qualifiedName: symbol,
    };

    expect(facts.artifacts.map((artifact) => artifact.id), ['lib/main.dart']);
    expect(facts.artifacts.single.contentDigest.value, hasLength(32));
    expect(
      byName.keys,
      containsAll(['Used', 'Used.hello', 'Dead', 'Dead.hello', 'main']),
    );
    expect(
      facts.roots.map((root) => root.reasonCode),
      contains('dart.main_entry_point'),
    );

    final mainKey = byName['main']!.key.value;
    final usedKey = byName['Used']!.key.value;
    final helloKey = byName['Used.hello']!.key.value;
    expect(
      facts.retentionEdges,
      contains(
        isA<RetentionEdge>()
            .having((edge) => edge.source.value, 'source', mainKey)
            .having((edge) => edge.target.value, 'target', usedKey),
      ),
    );
    expect(
      facts.retentionEdges,
      contains(
        isA<RetentionEdge>()
            .having((edge) => edge.source.value, 'source', mainKey)
            .having((edge) => edge.target.value, 'target', helloKey),
      ),
    );

    final used = byName['Used']!;
    final expectedStart = utf8
        .encode(source.substring(0, source.indexOf('Used')))
        .length;
    expect(used.declaration.startByte, Int64(expectedStart));
    expect(used.declaration.endByte, Int64(expectedStart + 'Used'.length));

    for (final symbol in facts.symbols) {
      final key = utf8.decode(symbol.key.value);
      expect(key, isNot(contains(fixture.path)));
      expect(
        symbol.key.stability,
        SymbolStability.SYMBOL_STABILITY_CROSS_SNAPSHOT,
      );
    }
    expect(
      facts.completeness
          .singleWhere(
            (value) => value.capabilityId == dynamicBehaviorDimension,
          )
          .status,
      CompletenessStatus.COMPLETENESS_STATUS_PARTIAL,
    );
  });

  test('degrades semantic completeness when a file has errors', () async {
    final facts = await analyze('void main( {');

    expect(facts.diagnostics, isNotEmpty);
    expect(
      facts.completeness
          .singleWhere(
            (value) => value.capabilityId == semanticResolutionDimension,
          )
          .status,
      CompletenessStatus.COMPLETENESS_STATUS_PARTIAL,
    );
  });

  test('links references to declarations across libraries', () async {
    final library = await Directory(p.join(fixture.path, 'lib')).create();
    await File(
      p.join(library.path, 'used.dart'),
    ).writeAsString('class Used {}');
    final facts = await analyze('''
import 'package:adapter_fixture/used.dart';

void main() {
  Used();
}
''');
    final byName = {
      for (final symbol in facts.symbols) symbol.qualifiedName: symbol,
    };

    expect(
      facts.retentionEdges,
      contains(
        isA<RetentionEdge>()
            .having(
              (edge) => edge.source.value,
              'source',
              byName['main']!.key.value,
            )
            .having(
              (edge) => edge.target.value,
              'target',
              byName['Used']!.key.value,
            ),
      ),
    );
  });

  test(
    'does not treat a local function named main as an entry point',
    () async {
      final facts = await analyze('''
void outer() {
  void main() {}
}
''');

      expect(facts.roots, isEmpty);
      expect(
        facts.symbols
            .singleWhere((symbol) => symbol.displayName == 'main')
            .key
            .stability,
        SymbolStability.SYMBOL_STABILITY_SNAPSHOT,
      );
    },
  );

  test('reports generated omissions and honors analyzer exclusions', () async {
    final library = await Directory(p.join(fixture.path, 'lib')).create();
    await File(
      p.join(library.path, 'main.dart'),
    ).writeAsString('void main() {}');
    await File(
      p.join(library.path, 'main.g.dart'),
    ).writeAsString('void generated() {}');
    await File(p.join(fixture.path, 'analysis_options.yaml')).writeAsString('''
analyzer:
  exclude:
    - test/fixtures/**
''');
    final nested = await Directory(
      p.join(fixture.path, 'test', 'fixtures', 'nested'),
    ).create(recursive: true);
    await File(p.join(nested.path, 'pubspec.yaml')).writeAsString('''
name: nested_fixture
environment:
  sdk: ^3.10.0
''');
    final nestedLibrary = await Directory(p.join(nested.path, 'lib')).create();
    await File(
      p.join(nestedLibrary.path, 'nested.dart'),
    ).writeAsString('void nested() {}');

    final pub = await Process.run(Platform.resolvedExecutable, [
      'pub',
      'get',
    ], workingDirectory: fixture.path);
    if (pub.exitCode != 0) {
      fail('dart pub get failed: ${pub.stderr}');
    }
    final facts = await DartSemanticAnalyzer().analyze(
      AnalyzeRequest(
        workspaceRoot: fixture.path,
        target: '.',
        variantId: 'default',
      ),
    );

    expect(facts.artifacts.map((artifact) => artifact.id), ['lib/main.dart']);
    final sourceDiscovery = facts.completeness.singleWhere(
      (value) => value.capabilityId == sourceDiscoveryDimension,
    );
    expect(
      sourceDiscovery.status,
      CompletenessStatus.COMPLETENESS_STATUS_PARTIAL,
    );
    expect(sourceDiscovery.reasonCode, 'dart.generated_sources_excluded');
  });

  test('rejects targets that can escape the workspace', () async {
    await expectLater(
      DartSemanticAnalyzer().analyze(
        AnalyzeRequest(workspaceRoot: fixture.path, target: '../outside'),
      ),
      throwsA(isA<FormatException>()),
    );
  });
}
