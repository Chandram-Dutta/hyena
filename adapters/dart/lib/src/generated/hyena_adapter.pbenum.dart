// This is a generated file - do not edit.
//
// Generated from hyena_adapter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SourceEncoding extends $pb.ProtobufEnum {
  static const SourceEncoding SOURCE_ENCODING_UNSPECIFIED =
      SourceEncoding._(0, _omitEnumNames ? '' : 'SOURCE_ENCODING_UNSPECIFIED');
  static const SourceEncoding SOURCE_ENCODING_UTF8 =
      SourceEncoding._(1, _omitEnumNames ? '' : 'SOURCE_ENCODING_UTF8');

  static const $core.List<SourceEncoding> values = <SourceEncoding>[
    SOURCE_ENCODING_UNSPECIFIED,
    SOURCE_ENCODING_UTF8,
  ];

  static final $core.List<SourceEncoding?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static SourceEncoding? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SourceEncoding._(super.value, super.name);
}

class ArtifactOrigin extends $pb.ProtobufEnum {
  static const ArtifactOrigin ARTIFACT_ORIGIN_UNSPECIFIED =
      ArtifactOrigin._(0, _omitEnumNames ? '' : 'ARTIFACT_ORIGIN_UNSPECIFIED');
  static const ArtifactOrigin ARTIFACT_ORIGIN_SOURCE =
      ArtifactOrigin._(1, _omitEnumNames ? '' : 'ARTIFACT_ORIGIN_SOURCE');
  static const ArtifactOrigin ARTIFACT_ORIGIN_GENERATED =
      ArtifactOrigin._(2, _omitEnumNames ? '' : 'ARTIFACT_ORIGIN_GENERATED');

  static const $core.List<ArtifactOrigin> values = <ArtifactOrigin>[
    ARTIFACT_ORIGIN_UNSPECIFIED,
    ARTIFACT_ORIGIN_SOURCE,
    ARTIFACT_ORIGIN_GENERATED,
  ];

  static final $core.List<ArtifactOrigin?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ArtifactOrigin? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ArtifactOrigin._(super.value, super.name);
}

class SymbolStability extends $pb.ProtobufEnum {
  static const SymbolStability SYMBOL_STABILITY_UNSPECIFIED = SymbolStability._(
      0, _omitEnumNames ? '' : 'SYMBOL_STABILITY_UNSPECIFIED');
  static const SymbolStability SYMBOL_STABILITY_SNAPSHOT =
      SymbolStability._(1, _omitEnumNames ? '' : 'SYMBOL_STABILITY_SNAPSHOT');
  static const SymbolStability SYMBOL_STABILITY_CROSS_SNAPSHOT =
      SymbolStability._(
          2, _omitEnumNames ? '' : 'SYMBOL_STABILITY_CROSS_SNAPSHOT');

  static const $core.List<SymbolStability> values = <SymbolStability>[
    SYMBOL_STABILITY_UNSPECIFIED,
    SYMBOL_STABILITY_SNAPSHOT,
    SYMBOL_STABILITY_CROSS_SNAPSHOT,
  ];

  static final $core.List<SymbolStability?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static SymbolStability? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SymbolStability._(super.value, super.name);
}

class SymbolKind extends $pb.ProtobufEnum {
  static const SymbolKind SYMBOL_KIND_UNSPECIFIED =
      SymbolKind._(0, _omitEnumNames ? '' : 'SYMBOL_KIND_UNSPECIFIED');
  static const SymbolKind SYMBOL_KIND_CLASS =
      SymbolKind._(1, _omitEnumNames ? '' : 'SYMBOL_KIND_CLASS');
  static const SymbolKind SYMBOL_KIND_MIXIN =
      SymbolKind._(2, _omitEnumNames ? '' : 'SYMBOL_KIND_MIXIN');
  static const SymbolKind SYMBOL_KIND_EXTENSION =
      SymbolKind._(3, _omitEnumNames ? '' : 'SYMBOL_KIND_EXTENSION');
  static const SymbolKind SYMBOL_KIND_EXTENSION_TYPE =
      SymbolKind._(4, _omitEnumNames ? '' : 'SYMBOL_KIND_EXTENSION_TYPE');
  static const SymbolKind SYMBOL_KIND_ENUM =
      SymbolKind._(5, _omitEnumNames ? '' : 'SYMBOL_KIND_ENUM');
  static const SymbolKind SYMBOL_KIND_ENUM_VALUE =
      SymbolKind._(6, _omitEnumNames ? '' : 'SYMBOL_KIND_ENUM_VALUE');
  static const SymbolKind SYMBOL_KIND_FUNCTION =
      SymbolKind._(7, _omitEnumNames ? '' : 'SYMBOL_KIND_FUNCTION');
  static const SymbolKind SYMBOL_KIND_CONSTRUCTOR =
      SymbolKind._(8, _omitEnumNames ? '' : 'SYMBOL_KIND_CONSTRUCTOR');
  static const SymbolKind SYMBOL_KIND_METHOD =
      SymbolKind._(9, _omitEnumNames ? '' : 'SYMBOL_KIND_METHOD');
  static const SymbolKind SYMBOL_KIND_GETTER =
      SymbolKind._(10, _omitEnumNames ? '' : 'SYMBOL_KIND_GETTER');
  static const SymbolKind SYMBOL_KIND_SETTER =
      SymbolKind._(11, _omitEnumNames ? '' : 'SYMBOL_KIND_SETTER');
  static const SymbolKind SYMBOL_KIND_TOP_LEVEL_VARIABLE =
      SymbolKind._(12, _omitEnumNames ? '' : 'SYMBOL_KIND_TOP_LEVEL_VARIABLE');
  static const SymbolKind SYMBOL_KIND_FIELD =
      SymbolKind._(13, _omitEnumNames ? '' : 'SYMBOL_KIND_FIELD');
  static const SymbolKind SYMBOL_KIND_TYPE_ALIAS =
      SymbolKind._(14, _omitEnumNames ? '' : 'SYMBOL_KIND_TYPE_ALIAS');

  static const $core.List<SymbolKind> values = <SymbolKind>[
    SYMBOL_KIND_UNSPECIFIED,
    SYMBOL_KIND_CLASS,
    SYMBOL_KIND_MIXIN,
    SYMBOL_KIND_EXTENSION,
    SYMBOL_KIND_EXTENSION_TYPE,
    SYMBOL_KIND_ENUM,
    SYMBOL_KIND_ENUM_VALUE,
    SYMBOL_KIND_FUNCTION,
    SYMBOL_KIND_CONSTRUCTOR,
    SYMBOL_KIND_METHOD,
    SYMBOL_KIND_GETTER,
    SYMBOL_KIND_SETTER,
    SYMBOL_KIND_TOP_LEVEL_VARIABLE,
    SYMBOL_KIND_FIELD,
    SYMBOL_KIND_TYPE_ALIAS,
  ];

  static final $core.List<SymbolKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 14);
  static SymbolKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SymbolKind._(super.value, super.name);
}

class Visibility extends $pb.ProtobufEnum {
  static const Visibility VISIBILITY_UNSPECIFIED =
      Visibility._(0, _omitEnumNames ? '' : 'VISIBILITY_UNSPECIFIED');
  static const Visibility VISIBILITY_PUBLIC =
      Visibility._(1, _omitEnumNames ? '' : 'VISIBILITY_PUBLIC');
  static const Visibility VISIBILITY_PRIVATE =
      Visibility._(2, _omitEnumNames ? '' : 'VISIBILITY_PRIVATE');

  static const $core.List<Visibility> values = <Visibility>[
    VISIBILITY_UNSPECIFIED,
    VISIBILITY_PUBLIC,
    VISIBILITY_PRIVATE,
  ];

  static final $core.List<Visibility?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Visibility? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Visibility._(super.value, super.name);
}

class ExportStatus extends $pb.ProtobufEnum {
  static const ExportStatus EXPORT_STATUS_UNSPECIFIED =
      ExportStatus._(0, _omitEnumNames ? '' : 'EXPORT_STATUS_UNSPECIFIED');
  static const ExportStatus EXPORT_STATUS_EXPORTED =
      ExportStatus._(1, _omitEnumNames ? '' : 'EXPORT_STATUS_EXPORTED');
  static const ExportStatus EXPORT_STATUS_NOT_EXPORTED =
      ExportStatus._(2, _omitEnumNames ? '' : 'EXPORT_STATUS_NOT_EXPORTED');

  static const $core.List<ExportStatus> values = <ExportStatus>[
    EXPORT_STATUS_UNSPECIFIED,
    EXPORT_STATUS_EXPORTED,
    EXPORT_STATUS_NOT_EXPORTED,
  ];

  static final $core.List<ExportStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static ExportStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ExportStatus._(super.value, super.name);
}

class RetentionEdgeKind extends $pb.ProtobufEnum {
  static const RetentionEdgeKind RETENTION_EDGE_KIND_UNSPECIFIED =
      RetentionEdgeKind._(
          0, _omitEnumNames ? '' : 'RETENTION_EDGE_KIND_UNSPECIFIED');
  static const RetentionEdgeKind RETENTION_EDGE_KIND_REFERENCE =
      RetentionEdgeKind._(
          1, _omitEnumNames ? '' : 'RETENTION_EDGE_KIND_REFERENCE');
  static const RetentionEdgeKind RETENTION_EDGE_KIND_CALL =
      RetentionEdgeKind._(2, _omitEnumNames ? '' : 'RETENTION_EDGE_KIND_CALL');
  static const RetentionEdgeKind RETENTION_EDGE_KIND_TYPE_USE =
      RetentionEdgeKind._(
          3, _omitEnumNames ? '' : 'RETENTION_EDGE_KIND_TYPE_USE');
  static const RetentionEdgeKind RETENTION_EDGE_KIND_DECLARATION_OWNER =
      RetentionEdgeKind._(
          4, _omitEnumNames ? '' : 'RETENTION_EDGE_KIND_DECLARATION_OWNER');

  static const $core.List<RetentionEdgeKind> values = <RetentionEdgeKind>[
    RETENTION_EDGE_KIND_UNSPECIFIED,
    RETENTION_EDGE_KIND_REFERENCE,
    RETENTION_EDGE_KIND_CALL,
    RETENTION_EDGE_KIND_TYPE_USE,
    RETENTION_EDGE_KIND_DECLARATION_OWNER,
  ];

  static final $core.List<RetentionEdgeKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static RetentionEdgeKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RetentionEdgeKind._(super.value, super.name);
}

class RootKind extends $pb.ProtobufEnum {
  static const RootKind ROOT_KIND_UNSPECIFIED =
      RootKind._(0, _omitEnumNames ? '' : 'ROOT_KIND_UNSPECIFIED');
  static const RootKind ROOT_KIND_ENTRY_POINT =
      RootKind._(1, _omitEnumNames ? '' : 'ROOT_KIND_ENTRY_POINT');
  static const RootKind ROOT_KIND_TOP_LEVEL_EFFECT =
      RootKind._(2, _omitEnumNames ? '' : 'ROOT_KIND_TOP_LEVEL_EFFECT');
  static const RootKind ROOT_KIND_PUBLIC_API =
      RootKind._(3, _omitEnumNames ? '' : 'ROOT_KIND_PUBLIC_API');
  static const RootKind ROOT_KIND_OVERRIDE =
      RootKind._(4, _omitEnumNames ? '' : 'ROOT_KIND_OVERRIDE');
  static const RootKind ROOT_KIND_DYNAMIC_DISPATCH =
      RootKind._(5, _omitEnumNames ? '' : 'ROOT_KIND_DYNAMIC_DISPATCH');
  static const RootKind ROOT_KIND_USER_KEEP =
      RootKind._(6, _omitEnumNames ? '' : 'ROOT_KIND_USER_KEEP');

  static const $core.List<RootKind> values = <RootKind>[
    ROOT_KIND_UNSPECIFIED,
    ROOT_KIND_ENTRY_POINT,
    ROOT_KIND_TOP_LEVEL_EFFECT,
    ROOT_KIND_PUBLIC_API,
    ROOT_KIND_OVERRIDE,
    ROOT_KIND_DYNAMIC_DISPATCH,
    ROOT_KIND_USER_KEEP,
  ];

  static final $core.List<RootKind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static RootKind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const RootKind._(super.value, super.name);
}

class DiagnosticSeverity extends $pb.ProtobufEnum {
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_UNSPECIFIED =
      DiagnosticSeverity._(
          0, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_UNSPECIFIED');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_INFO =
      DiagnosticSeverity._(1, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_INFO');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_WARNING =
      DiagnosticSeverity._(
          2, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_WARNING');
  static const DiagnosticSeverity DIAGNOSTIC_SEVERITY_ERROR =
      DiagnosticSeverity._(
          3, _omitEnumNames ? '' : 'DIAGNOSTIC_SEVERITY_ERROR');

  static const $core.List<DiagnosticSeverity> values = <DiagnosticSeverity>[
    DIAGNOSTIC_SEVERITY_UNSPECIFIED,
    DIAGNOSTIC_SEVERITY_INFO,
    DIAGNOSTIC_SEVERITY_WARNING,
    DIAGNOSTIC_SEVERITY_ERROR,
  ];

  static final $core.List<DiagnosticSeverity?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static DiagnosticSeverity? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const DiagnosticSeverity._(super.value, super.name);
}

class CompletionStatus extends $pb.ProtobufEnum {
  static const CompletionStatus COMPLETION_STATUS_UNSPECIFIED =
      CompletionStatus._(
          0, _omitEnumNames ? '' : 'COMPLETION_STATUS_UNSPECIFIED');
  static const CompletionStatus COMPLETION_STATUS_SUCCEEDED =
      CompletionStatus._(
          1, _omitEnumNames ? '' : 'COMPLETION_STATUS_SUCCEEDED');
  static const CompletionStatus COMPLETION_STATUS_PARTIAL =
      CompletionStatus._(2, _omitEnumNames ? '' : 'COMPLETION_STATUS_PARTIAL');
  static const CompletionStatus COMPLETION_STATUS_CANCELLED =
      CompletionStatus._(
          3, _omitEnumNames ? '' : 'COMPLETION_STATUS_CANCELLED');
  static const CompletionStatus COMPLETION_STATUS_FAILED =
      CompletionStatus._(4, _omitEnumNames ? '' : 'COMPLETION_STATUS_FAILED');

  static const $core.List<CompletionStatus> values = <CompletionStatus>[
    COMPLETION_STATUS_UNSPECIFIED,
    COMPLETION_STATUS_SUCCEEDED,
    COMPLETION_STATUS_PARTIAL,
    COMPLETION_STATUS_CANCELLED,
    COMPLETION_STATUS_FAILED,
  ];

  static final $core.List<CompletionStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static CompletionStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CompletionStatus._(super.value, super.name);
}

class CompletenessStatus extends $pb.ProtobufEnum {
  static const CompletenessStatus COMPLETENESS_STATUS_UNSPECIFIED =
      CompletenessStatus._(
          0, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_UNSPECIFIED');
  static const CompletenessStatus COMPLETENESS_STATUS_COMPLETE =
      CompletenessStatus._(
          1, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_COMPLETE');
  static const CompletenessStatus COMPLETENESS_STATUS_PARTIAL =
      CompletenessStatus._(
          2, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_PARTIAL');
  static const CompletenessStatus COMPLETENESS_STATUS_UNSUPPORTED =
      CompletenessStatus._(
          3, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_UNSUPPORTED');
  static const CompletenessStatus COMPLETENESS_STATUS_FAILED =
      CompletenessStatus._(
          4, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_FAILED');
  static const CompletenessStatus COMPLETENESS_STATUS_NOT_REQUESTED =
      CompletenessStatus._(
          5, _omitEnumNames ? '' : 'COMPLETENESS_STATUS_NOT_REQUESTED');

  static const $core.List<CompletenessStatus> values = <CompletenessStatus>[
    COMPLETENESS_STATUS_UNSPECIFIED,
    COMPLETENESS_STATUS_COMPLETE,
    COMPLETENESS_STATUS_PARTIAL,
    COMPLETENESS_STATUS_UNSUPPORTED,
    COMPLETENESS_STATUS_FAILED,
    COMPLETENESS_STATUS_NOT_REQUESTED,
  ];

  static final $core.List<CompletenessStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static CompletenessStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CompletenessStatus._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
