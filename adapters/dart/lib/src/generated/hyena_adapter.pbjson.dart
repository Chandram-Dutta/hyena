// This is a generated file - do not edit.
//
// Generated from hyena_adapter.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use sourceEncodingDescriptor instead')
const SourceEncoding$json = {
  '1': 'SourceEncoding',
  '2': [
    {'1': 'SOURCE_ENCODING_UNSPECIFIED', '2': 0},
    {'1': 'SOURCE_ENCODING_UTF8', '2': 1},
  ],
};

/// Descriptor for `SourceEncoding`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List sourceEncodingDescriptor = $convert.base64Decode(
    'Cg5Tb3VyY2VFbmNvZGluZxIfChtTT1VSQ0VfRU5DT0RJTkdfVU5TUEVDSUZJRUQQABIYChRTT1'
    'VSQ0VfRU5DT0RJTkdfVVRGOBAB');

@$core.Deprecated('Use artifactOriginDescriptor instead')
const ArtifactOrigin$json = {
  '1': 'ArtifactOrigin',
  '2': [
    {'1': 'ARTIFACT_ORIGIN_UNSPECIFIED', '2': 0},
    {'1': 'ARTIFACT_ORIGIN_SOURCE', '2': 1},
    {'1': 'ARTIFACT_ORIGIN_GENERATED', '2': 2},
  ],
};

/// Descriptor for `ArtifactOrigin`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List artifactOriginDescriptor = $convert.base64Decode(
    'Cg5BcnRpZmFjdE9yaWdpbhIfChtBUlRJRkFDVF9PUklHSU5fVU5TUEVDSUZJRUQQABIaChZBUl'
    'RJRkFDVF9PUklHSU5fU09VUkNFEAESHQoZQVJUSUZBQ1RfT1JJR0lOX0dFTkVSQVRFRBAC');

@$core.Deprecated('Use symbolStabilityDescriptor instead')
const SymbolStability$json = {
  '1': 'SymbolStability',
  '2': [
    {'1': 'SYMBOL_STABILITY_UNSPECIFIED', '2': 0},
    {'1': 'SYMBOL_STABILITY_SNAPSHOT', '2': 1},
    {'1': 'SYMBOL_STABILITY_CROSS_SNAPSHOT', '2': 2},
  ],
};

/// Descriptor for `SymbolStability`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List symbolStabilityDescriptor = $convert.base64Decode(
    'Cg9TeW1ib2xTdGFiaWxpdHkSIAocU1lNQk9MX1NUQUJJTElUWV9VTlNQRUNJRklFRBAAEh0KGV'
    'NZTUJPTF9TVEFCSUxJVFlfU05BUFNIT1QQARIjCh9TWU1CT0xfU1RBQklMSVRZX0NST1NTX1NO'
    'QVBTSE9UEAI=');

@$core.Deprecated('Use symbolKindDescriptor instead')
const SymbolKind$json = {
  '1': 'SymbolKind',
  '2': [
    {'1': 'SYMBOL_KIND_UNSPECIFIED', '2': 0},
    {'1': 'SYMBOL_KIND_CLASS', '2': 1},
    {'1': 'SYMBOL_KIND_MIXIN', '2': 2},
    {'1': 'SYMBOL_KIND_EXTENSION', '2': 3},
    {'1': 'SYMBOL_KIND_EXTENSION_TYPE', '2': 4},
    {'1': 'SYMBOL_KIND_ENUM', '2': 5},
    {'1': 'SYMBOL_KIND_ENUM_VALUE', '2': 6},
    {'1': 'SYMBOL_KIND_FUNCTION', '2': 7},
    {'1': 'SYMBOL_KIND_CONSTRUCTOR', '2': 8},
    {'1': 'SYMBOL_KIND_METHOD', '2': 9},
    {'1': 'SYMBOL_KIND_GETTER', '2': 10},
    {'1': 'SYMBOL_KIND_SETTER', '2': 11},
    {'1': 'SYMBOL_KIND_TOP_LEVEL_VARIABLE', '2': 12},
    {'1': 'SYMBOL_KIND_FIELD', '2': 13},
    {'1': 'SYMBOL_KIND_TYPE_ALIAS', '2': 14},
  ],
};

/// Descriptor for `SymbolKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List symbolKindDescriptor = $convert.base64Decode(
    'CgpTeW1ib2xLaW5kEhsKF1NZTUJPTF9LSU5EX1VOU1BFQ0lGSUVEEAASFQoRU1lNQk9MX0tJTk'
    'RfQ0xBU1MQARIVChFTWU1CT0xfS0lORF9NSVhJThACEhkKFVNZTUJPTF9LSU5EX0VYVEVOU0lP'
    'ThADEh4KGlNZTUJPTF9LSU5EX0VYVEVOU0lPTl9UWVBFEAQSFAoQU1lNQk9MX0tJTkRfRU5VTR'
    'AFEhoKFlNZTUJPTF9LSU5EX0VOVU1fVkFMVUUQBhIYChRTWU1CT0xfS0lORF9GVU5DVElPThAH'
    'EhsKF1NZTUJPTF9LSU5EX0NPTlNUUlVDVE9SEAgSFgoSU1lNQk9MX0tJTkRfTUVUSE9EEAkSFg'
    'oSU1lNQk9MX0tJTkRfR0VUVEVSEAoSFgoSU1lNQk9MX0tJTkRfU0VUVEVSEAsSIgoeU1lNQk9M'
    'X0tJTkRfVE9QX0xFVkVMX1ZBUklBQkxFEAwSFQoRU1lNQk9MX0tJTkRfRklFTEQQDRIaChZTWU'
    '1CT0xfS0lORF9UWVBFX0FMSUFTEA4=');

@$core.Deprecated('Use visibilityDescriptor instead')
const Visibility$json = {
  '1': 'Visibility',
  '2': [
    {'1': 'VISIBILITY_UNSPECIFIED', '2': 0},
    {'1': 'VISIBILITY_PUBLIC', '2': 1},
    {'1': 'VISIBILITY_PRIVATE', '2': 2},
  ],
};

/// Descriptor for `Visibility`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List visibilityDescriptor = $convert.base64Decode(
    'CgpWaXNpYmlsaXR5EhoKFlZJU0lCSUxJVFlfVU5TUEVDSUZJRUQQABIVChFWSVNJQklMSVRZX1'
    'BVQkxJQxABEhYKElZJU0lCSUxJVFlfUFJJVkFURRAC');

@$core.Deprecated('Use exportStatusDescriptor instead')
const ExportStatus$json = {
  '1': 'ExportStatus',
  '2': [
    {'1': 'EXPORT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'EXPORT_STATUS_EXPORTED', '2': 1},
    {'1': 'EXPORT_STATUS_NOT_EXPORTED', '2': 2},
  ],
};

/// Descriptor for `ExportStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List exportStatusDescriptor = $convert.base64Decode(
    'CgxFeHBvcnRTdGF0dXMSHQoZRVhQT1JUX1NUQVRVU19VTlNQRUNJRklFRBAAEhoKFkVYUE9SVF'
    '9TVEFUVVNfRVhQT1JURUQQARIeChpFWFBPUlRfU1RBVFVTX05PVF9FWFBPUlRFRBAC');

@$core.Deprecated('Use retentionEdgeKindDescriptor instead')
const RetentionEdgeKind$json = {
  '1': 'RetentionEdgeKind',
  '2': [
    {'1': 'RETENTION_EDGE_KIND_UNSPECIFIED', '2': 0},
    {'1': 'RETENTION_EDGE_KIND_REFERENCE', '2': 1},
    {'1': 'RETENTION_EDGE_KIND_CALL', '2': 2},
    {'1': 'RETENTION_EDGE_KIND_TYPE_USE', '2': 3},
    {'1': 'RETENTION_EDGE_KIND_DECLARATION_OWNER', '2': 4},
  ],
};

/// Descriptor for `RetentionEdgeKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List retentionEdgeKindDescriptor = $convert.base64Decode(
    'ChFSZXRlbnRpb25FZGdlS2luZBIjCh9SRVRFTlRJT05fRURHRV9LSU5EX1VOU1BFQ0lGSUVEEA'
    'ASIQodUkVURU5USU9OX0VER0VfS0lORF9SRUZFUkVOQ0UQARIcChhSRVRFTlRJT05fRURHRV9L'
    'SU5EX0NBTEwQAhIgChxSRVRFTlRJT05fRURHRV9LSU5EX1RZUEVfVVNFEAMSKQolUkVURU5USU'
    '9OX0VER0VfS0lORF9ERUNMQVJBVElPTl9PV05FUhAE');

@$core.Deprecated('Use rootKindDescriptor instead')
const RootKind$json = {
  '1': 'RootKind',
  '2': [
    {'1': 'ROOT_KIND_UNSPECIFIED', '2': 0},
    {'1': 'ROOT_KIND_ENTRY_POINT', '2': 1},
    {'1': 'ROOT_KIND_TOP_LEVEL_EFFECT', '2': 2},
    {'1': 'ROOT_KIND_PUBLIC_API', '2': 3},
    {'1': 'ROOT_KIND_OVERRIDE', '2': 4},
    {'1': 'ROOT_KIND_DYNAMIC_DISPATCH', '2': 5},
    {'1': 'ROOT_KIND_USER_KEEP', '2': 6},
  ],
};

/// Descriptor for `RootKind`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List rootKindDescriptor = $convert.base64Decode(
    'CghSb290S2luZBIZChVST09UX0tJTkRfVU5TUEVDSUZJRUQQABIZChVST09UX0tJTkRfRU5UUl'
    'lfUE9JTlQQARIeChpST09UX0tJTkRfVE9QX0xFVkVMX0VGRkVDVBACEhgKFFJPT1RfS0lORF9Q'
    'VUJMSUNfQVBJEAMSFgoSUk9PVF9LSU5EX09WRVJSSURFEAQSHgoaUk9PVF9LSU5EX0RZTkFNSU'
    'NfRElTUEFUQ0gQBRIXChNST09UX0tJTkRfVVNFUl9LRUVQEAY=');

@$core.Deprecated('Use diagnosticSeverityDescriptor instead')
const DiagnosticSeverity$json = {
  '1': 'DiagnosticSeverity',
  '2': [
    {'1': 'DIAGNOSTIC_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'DIAGNOSTIC_SEVERITY_INFO', '2': 1},
    {'1': 'DIAGNOSTIC_SEVERITY_WARNING', '2': 2},
    {'1': 'DIAGNOSTIC_SEVERITY_ERROR', '2': 3},
  ],
};

/// Descriptor for `DiagnosticSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List diagnosticSeverityDescriptor = $convert.base64Decode(
    'ChJEaWFnbm9zdGljU2V2ZXJpdHkSIwofRElBR05PU1RJQ19TRVZFUklUWV9VTlNQRUNJRklFRB'
    'AAEhwKGERJQUdOT1NUSUNfU0VWRVJJVFlfSU5GTxABEh8KG0RJQUdOT1NUSUNfU0VWRVJJVFlf'
    'V0FSTklORxACEh0KGURJQUdOT1NUSUNfU0VWRVJJVFlfRVJST1IQAw==');

@$core.Deprecated('Use completionStatusDescriptor instead')
const CompletionStatus$json = {
  '1': 'CompletionStatus',
  '2': [
    {'1': 'COMPLETION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'COMPLETION_STATUS_SUCCEEDED', '2': 1},
    {'1': 'COMPLETION_STATUS_PARTIAL', '2': 2},
    {'1': 'COMPLETION_STATUS_CANCELLED', '2': 3},
    {'1': 'COMPLETION_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `CompletionStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List completionStatusDescriptor = $convert.base64Decode(
    'ChBDb21wbGV0aW9uU3RhdHVzEiEKHUNPTVBMRVRJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEAASHw'
    'obQ09NUExFVElPTl9TVEFUVVNfU1VDQ0VFREVEEAESHQoZQ09NUExFVElPTl9TVEFUVVNfUEFS'
    'VElBTBACEh8KG0NPTVBMRVRJT05fU1RBVFVTX0NBTkNFTExFRBADEhwKGENPTVBMRVRJT05fU1'
    'RBVFVTX0ZBSUxFRBAE');

@$core.Deprecated('Use completenessStatusDescriptor instead')
const CompletenessStatus$json = {
  '1': 'CompletenessStatus',
  '2': [
    {'1': 'COMPLETENESS_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'COMPLETENESS_STATUS_COMPLETE', '2': 1},
    {'1': 'COMPLETENESS_STATUS_PARTIAL', '2': 2},
    {'1': 'COMPLETENESS_STATUS_UNSUPPORTED', '2': 3},
    {'1': 'COMPLETENESS_STATUS_FAILED', '2': 4},
    {'1': 'COMPLETENESS_STATUS_NOT_REQUESTED', '2': 5},
  ],
};

/// Descriptor for `CompletenessStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List completenessStatusDescriptor = $convert.base64Decode(
    'ChJDb21wbGV0ZW5lc3NTdGF0dXMSIwofQ09NUExFVEVORVNTX1NUQVRVU19VTlNQRUNJRklFRB'
    'AAEiAKHENPTVBMRVRFTkVTU19TVEFUVVNfQ09NUExFVEUQARIfChtDT01QTEVURU5FU1NfU1RB'
    'VFVTX1BBUlRJQUwQAhIjCh9DT01QTEVURU5FU1NfU1RBVFVTX1VOU1VQUE9SVEVEEAMSHgoaQ0'
    '9NUExFVEVORVNTX1NUQVRVU19GQUlMRUQQBBIlCiFDT01QTEVURU5FU1NfU1RBVFVTX05PVF9S'
    'RVFVRVNURUQQBQ==');

@$core.Deprecated('Use envelopeDescriptor instead')
const Envelope$json = {
  '1': 'Envelope',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '10': 'requestId'},
    {
      '1': 'hello',
      '3': 10,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.Hello',
      '9': 0,
      '10': 'hello'
    },
    {
      '1': 'ready',
      '3': 11,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.Ready',
      '9': 0,
      '10': 'ready'
    },
    {
      '1': 'analyze_request',
      '3': 12,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.AnalyzeRequest',
      '9': 0,
      '10': 'analyzeRequest'
    },
    {
      '1': 'cancel',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.Cancel',
      '9': 0,
      '10': 'cancel'
    },
    {
      '1': 'complete',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.Complete',
      '9': 0,
      '10': 'complete'
    },
    {
      '1': 'error',
      '3': 15,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.AdapterError',
      '9': 0,
      '10': 'error'
    },
    {
      '1': 'fact_batch',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.FactBatch',
      '9': 0,
      '10': 'factBatch'
    },
  ],
  '8': [
    {'1': 'message'},
  ],
  '9': [
    {'1': 2, '2': 10},
  ],
};

/// Descriptor for `Envelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List envelopeDescriptor = $convert.base64Decode(
    'CghFbnZlbG9wZRIdCgpyZXF1ZXN0X2lkGAEgASgEUglyZXF1ZXN0SWQSLwoFaGVsbG8YCiABKA'
    'syFy5oeWVuYS5hZGFwdGVyLnYwLkhlbGxvSABSBWhlbGxvEi8KBXJlYWR5GAsgASgLMhcuaHll'
    'bmEuYWRhcHRlci52MC5SZWFkeUgAUgVyZWFkeRJLCg9hbmFseXplX3JlcXVlc3QYDCABKAsyIC'
    '5oeWVuYS5hZGFwdGVyLnYwLkFuYWx5emVSZXF1ZXN0SABSDmFuYWx5emVSZXF1ZXN0EjIKBmNh'
    'bmNlbBgNIAEoCzIYLmh5ZW5hLmFkYXB0ZXIudjAuQ2FuY2VsSABSBmNhbmNlbBI4Cghjb21wbG'
    'V0ZRgOIAEoCzIaLmh5ZW5hLmFkYXB0ZXIudjAuQ29tcGxldGVIAFIIY29tcGxldGUSNgoFZXJy'
    'b3IYDyABKAsyHi5oeWVuYS5hZGFwdGVyLnYwLkFkYXB0ZXJFcnJvckgAUgVlcnJvchI8CgpmYW'
    'N0X2JhdGNoGBAgASgLMhsuaHllbmEuYWRhcHRlci52MC5GYWN0QmF0Y2hIAFIJZmFjdEJhdGNo'
    'QgkKB21lc3NhZ2VKBAgCEAo=');

@$core.Deprecated('Use protocolVersionDescriptor instead')
const ProtocolVersion$json = {
  '1': 'ProtocolVersion',
  '2': [
    {'1': 'major', '3': 1, '4': 1, '5': 13, '10': 'major'},
    {'1': 'minor', '3': 2, '4': 1, '5': 13, '10': 'minor'},
  ],
};

/// Descriptor for `ProtocolVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protocolVersionDescriptor = $convert.base64Decode(
    'Cg9Qcm90b2NvbFZlcnNpb24SFAoFbWFqb3IYASABKA1SBW1ham9yEhQKBW1pbm9yGAIgASgNUg'
    'VtaW5vcg==');

@$core.Deprecated('Use helloDescriptor instead')
const Hello$json = {
  '1': 'Hello',
  '2': [
    {'1': 'engine_name', '3': 1, '4': 1, '5': 9, '10': 'engineName'},
    {'1': 'engine_version', '3': 2, '4': 1, '5': 9, '10': 'engineVersion'},
    {
      '1': 'supported_versions',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.ProtocolVersion',
      '10': 'supportedVersions'
    },
    {'1': 'max_frame_bytes', '3': 4, '4': 1, '5': 13, '10': 'maxFrameBytes'},
  ],
};

/// Descriptor for `Hello`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List helloDescriptor = $convert.base64Decode(
    'CgVIZWxsbxIfCgtlbmdpbmVfbmFtZRgBIAEoCVIKZW5naW5lTmFtZRIlCg5lbmdpbmVfdmVyc2'
    'lvbhgCIAEoCVINZW5naW5lVmVyc2lvbhJQChJzdXBwb3J0ZWRfdmVyc2lvbnMYAyADKAsyIS5o'
    'eWVuYS5hZGFwdGVyLnYwLlByb3RvY29sVmVyc2lvblIRc3VwcG9ydGVkVmVyc2lvbnMSJgoPbW'
    'F4X2ZyYW1lX2J5dGVzGAQgASgNUg1tYXhGcmFtZUJ5dGVz');

@$core.Deprecated('Use readyDescriptor instead')
const Ready$json = {
  '1': 'Ready',
  '2': [
    {
      '1': 'adapter',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.AdapterInfo',
      '10': 'adapter'
    },
    {
      '1': 'selected_version',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.ProtocolVersion',
      '10': 'selectedVersion'
    },
    {
      '1': 'capabilities',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Capability',
      '10': 'capabilities'
    },
  ],
};

/// Descriptor for `Ready`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List readyDescriptor = $convert.base64Decode(
    'CgVSZWFkeRI3CgdhZGFwdGVyGAEgASgLMh0uaHllbmEuYWRhcHRlci52MC5BZGFwdGVySW5mb1'
    'IHYWRhcHRlchJMChBzZWxlY3RlZF92ZXJzaW9uGAIgASgLMiEuaHllbmEuYWRhcHRlci52MC5Q'
    'cm90b2NvbFZlcnNpb25SD3NlbGVjdGVkVmVyc2lvbhJACgxjYXBhYmlsaXRpZXMYAyADKAsyHC'
    '5oeWVuYS5hZGFwdGVyLnYwLkNhcGFiaWxpdHlSDGNhcGFiaWxpdGllcw==');

@$core.Deprecated('Use adapterInfoDescriptor instead')
const AdapterInfo$json = {
  '1': 'AdapterInfo',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'version', '3': 2, '4': 1, '5': 9, '10': 'version'},
    {'1': 'build_id', '3': 3, '4': 1, '5': 9, '10': 'buildId'},
  ],
};

/// Descriptor for `AdapterInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adapterInfoDescriptor = $convert.base64Decode(
    'CgtBZGFwdGVySW5mbxISCgRuYW1lGAEgASgJUgRuYW1lEhgKB3ZlcnNpb24YAiABKAlSB3Zlcn'
    'Npb24SGQoIYnVpbGRfaWQYAyABKAlSB2J1aWxkSWQ=');

@$core.Deprecated('Use capabilityDescriptor instead')
const Capability$json = {
  '1': 'Capability',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'version', '3': 2, '4': 1, '5': 13, '10': 'version'},
  ],
};

/// Descriptor for `Capability`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List capabilityDescriptor = $convert.base64Decode(
    'CgpDYXBhYmlsaXR5Eg4KAmlkGAEgASgJUgJpZBIYCgd2ZXJzaW9uGAIgASgNUgd2ZXJzaW9u');

@$core.Deprecated('Use analyzeRequestDescriptor instead')
const AnalyzeRequest$json = {
  '1': 'AnalyzeRequest',
  '2': [
    {'1': 'workspace_root', '3': 1, '4': 1, '5': 9, '10': 'workspaceRoot'},
    {'1': 'target', '3': 2, '4': 1, '5': 9, '10': 'target'},
    {
      '1': 'configuration_digest',
      '3': 3,
      '4': 1,
      '5': 12,
      '10': 'configurationDigest'
    },
    {'1': 'variant_id', '3': 4, '4': 1, '5': 9, '10': 'variantId'},
  ],
};

/// Descriptor for `AnalyzeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeRequestDescriptor = $convert.base64Decode(
    'Cg5BbmFseXplUmVxdWVzdBIlCg53b3Jrc3BhY2Vfcm9vdBgBIAEoCVINd29ya3NwYWNlUm9vdB'
    'IWCgZ0YXJnZXQYAiABKAlSBnRhcmdldBIxChRjb25maWd1cmF0aW9uX2RpZ2VzdBgDIAEoDFIT'
    'Y29uZmlndXJhdGlvbkRpZ2VzdBIdCgp2YXJpYW50X2lkGAQgASgJUgl2YXJpYW50SWQ=');

@$core.Deprecated('Use factBatchDescriptor instead')
const FactBatch$json = {
  '1': 'FactBatch',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 4, '10': 'sequence'},
    {
      '1': 'artifacts',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Artifact',
      '10': 'artifacts'
    },
    {
      '1': 'symbols',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Symbol',
      '10': 'symbols'
    },
    {
      '1': 'retention_edges',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.RetentionEdge',
      '10': 'retentionEdges'
    },
    {
      '1': 'roots',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Root',
      '10': 'roots'
    },
    {
      '1': 'diagnostics',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Diagnostic',
      '10': 'diagnostics'
    },
  ],
};

/// Descriptor for `FactBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List factBatchDescriptor = $convert.base64Decode(
    'CglGYWN0QmF0Y2gSGgoIc2VxdWVuY2UYASABKARSCHNlcXVlbmNlEjgKCWFydGlmYWN0cxgCIA'
    'MoCzIaLmh5ZW5hLmFkYXB0ZXIudjAuQXJ0aWZhY3RSCWFydGlmYWN0cxIyCgdzeW1ib2xzGAMg'
    'AygLMhguaHllbmEuYWRhcHRlci52MC5TeW1ib2xSB3N5bWJvbHMSSAoPcmV0ZW50aW9uX2VkZ2'
    'VzGAQgAygLMh8uaHllbmEuYWRhcHRlci52MC5SZXRlbnRpb25FZGdlUg5yZXRlbnRpb25FZGdl'
    'cxIsCgVyb290cxgFIAMoCzIWLmh5ZW5hLmFkYXB0ZXIudjAuUm9vdFIFcm9vdHMSPgoLZGlhZ2'
    '5vc3RpY3MYBiADKAsyHC5oeWVuYS5hZGFwdGVyLnYwLkRpYWdub3N0aWNSC2RpYWdub3N0aWNz');

@$core.Deprecated('Use artifactDescriptor instead')
const Artifact$json = {
  '1': 'Artifact',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'language', '3': 2, '4': 1, '5': 9, '10': 'language'},
    {'1': 'byte_length', '3': 3, '4': 1, '5': 4, '10': 'byteLength'},
    {
      '1': 'content_digest',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.ContentDigest',
      '10': 'contentDigest'
    },
    {
      '1': 'source_encoding',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.SourceEncoding',
      '10': 'sourceEncoding'
    },
    {
      '1': 'origin',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.ArtifactOrigin',
      '10': 'origin'
    },
  ],
};

/// Descriptor for `Artifact`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List artifactDescriptor = $convert.base64Decode(
    'CghBcnRpZmFjdBIOCgJpZBgBIAEoCVICaWQSGgoIbGFuZ3VhZ2UYAiABKAlSCGxhbmd1YWdlEh'
    '8KC2J5dGVfbGVuZ3RoGAMgASgEUgpieXRlTGVuZ3RoEkYKDmNvbnRlbnRfZGlnZXN0GAQgASgL'
    'Mh8uaHllbmEuYWRhcHRlci52MC5Db250ZW50RGlnZXN0Ug1jb250ZW50RGlnZXN0EkkKD3NvdX'
    'JjZV9lbmNvZGluZxgFIAEoDjIgLmh5ZW5hLmFkYXB0ZXIudjAuU291cmNlRW5jb2RpbmdSDnNv'
    'dXJjZUVuY29kaW5nEjgKBm9yaWdpbhgGIAEoDjIgLmh5ZW5hLmFkYXB0ZXIudjAuQXJ0aWZhY3'
    'RPcmlnaW5SBm9yaWdpbg==');

@$core.Deprecated('Use contentDigestDescriptor instead')
const ContentDigest$json = {
  '1': 'ContentDigest',
  '2': [
    {'1': 'algorithm', '3': 1, '4': 1, '5': 9, '10': 'algorithm'},
    {'1': 'value', '3': 2, '4': 1, '5': 12, '10': 'value'},
  ],
};

/// Descriptor for `ContentDigest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contentDigestDescriptor = $convert.base64Decode(
    'Cg1Db250ZW50RGlnZXN0EhwKCWFsZ29yaXRobRgBIAEoCVIJYWxnb3JpdGhtEhQKBXZhbHVlGA'
    'IgASgMUgV2YWx1ZQ==');

@$core.Deprecated('Use sourceSpanDescriptor instead')
const SourceSpan$json = {
  '1': 'SourceSpan',
  '2': [
    {'1': 'artifact_id', '3': 1, '4': 1, '5': 9, '10': 'artifactId'},
    {'1': 'start_byte', '3': 2, '4': 1, '5': 4, '10': 'startByte'},
    {'1': 'end_byte', '3': 3, '4': 1, '5': 4, '10': 'endByte'},
  ],
};

/// Descriptor for `SourceSpan`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sourceSpanDescriptor = $convert.base64Decode(
    'CgpTb3VyY2VTcGFuEh8KC2FydGlmYWN0X2lkGAEgASgJUgphcnRpZmFjdElkEh0KCnN0YXJ0X2'
    'J5dGUYAiABKARSCXN0YXJ0Qnl0ZRIZCghlbmRfYnl0ZRgDIAEoBFIHZW5kQnl0ZQ==');

@$core.Deprecated('Use symbolKeyDescriptor instead')
const SymbolKey$json = {
  '1': 'SymbolKey',
  '2': [
    {'1': 'scheme', '3': 1, '4': 1, '5': 9, '10': 'scheme'},
    {'1': 'scheme_version', '3': 2, '4': 1, '5': 13, '10': 'schemeVersion'},
    {'1': 'value', '3': 3, '4': 1, '5': 12, '10': 'value'},
    {
      '1': 'stability',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.SymbolStability',
      '10': 'stability'
    },
  ],
};

/// Descriptor for `SymbolKey`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List symbolKeyDescriptor = $convert.base64Decode(
    'CglTeW1ib2xLZXkSFgoGc2NoZW1lGAEgASgJUgZzY2hlbWUSJQoOc2NoZW1lX3ZlcnNpb24YAi'
    'ABKA1SDXNjaGVtZVZlcnNpb24SFAoFdmFsdWUYAyABKAxSBXZhbHVlEj8KCXN0YWJpbGl0eRgE'
    'IAEoDjIhLmh5ZW5hLmFkYXB0ZXIudjAuU3ltYm9sU3RhYmlsaXR5UglzdGFiaWxpdHk=');

@$core.Deprecated('Use symbolDescriptor instead')
const Symbol$json = {
  '1': 'Symbol',
  '2': [
    {
      '1': 'key',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SymbolKey',
      '10': 'key'
    },
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'qualified_name', '3': 3, '4': 1, '5': 9, '10': 'qualifiedName'},
    {
      '1': 'kind',
      '3': 4,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.SymbolKind',
      '10': 'kind'
    },
    {
      '1': 'declaration',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SourceSpan',
      '10': 'declaration'
    },
    {
      '1': 'visibility',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.Visibility',
      '10': 'visibility'
    },
    {
      '1': 'export_status',
      '3': 7,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.ExportStatus',
      '10': 'exportStatus'
    },
  ],
};

/// Descriptor for `Symbol`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List symbolDescriptor = $convert.base64Decode(
    'CgZTeW1ib2wSLQoDa2V5GAEgASgLMhsuaHllbmEuYWRhcHRlci52MC5TeW1ib2xLZXlSA2tleR'
    'IhCgxkaXNwbGF5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEiUKDnF1YWxpZmllZF9uYW1lGAMg'
    'ASgJUg1xdWFsaWZpZWROYW1lEjAKBGtpbmQYBCABKA4yHC5oeWVuYS5hZGFwdGVyLnYwLlN5bW'
    'JvbEtpbmRSBGtpbmQSPgoLZGVjbGFyYXRpb24YBSABKAsyHC5oeWVuYS5hZGFwdGVyLnYwLlNv'
    'dXJjZVNwYW5SC2RlY2xhcmF0aW9uEjwKCnZpc2liaWxpdHkYBiABKA4yHC5oeWVuYS5hZGFwdG'
    'VyLnYwLlZpc2liaWxpdHlSCnZpc2liaWxpdHkSQwoNZXhwb3J0X3N0YXR1cxgHIAEoDjIeLmh5'
    'ZW5hLmFkYXB0ZXIudjAuRXhwb3J0U3RhdHVzUgxleHBvcnRTdGF0dXM=');

@$core.Deprecated('Use retentionEdgeDescriptor instead')
const RetentionEdge$json = {
  '1': 'RetentionEdge',
  '2': [
    {
      '1': 'source',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SymbolKey',
      '10': 'source'
    },
    {
      '1': 'target',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SymbolKey',
      '10': 'target'
    },
    {
      '1': 'kind',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.RetentionEdgeKind',
      '10': 'kind'
    },
    {
      '1': 'evidence',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SourceSpan',
      '10': 'evidence'
    },
  ],
};

/// Descriptor for `RetentionEdge`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List retentionEdgeDescriptor = $convert.base64Decode(
    'Cg1SZXRlbnRpb25FZGdlEjMKBnNvdXJjZRgBIAEoCzIbLmh5ZW5hLmFkYXB0ZXIudjAuU3ltYm'
    '9sS2V5UgZzb3VyY2USMwoGdGFyZ2V0GAIgASgLMhsuaHllbmEuYWRhcHRlci52MC5TeW1ib2xL'
    'ZXlSBnRhcmdldBI3CgRraW5kGAMgASgOMiMuaHllbmEuYWRhcHRlci52MC5SZXRlbnRpb25FZG'
    'dlS2luZFIEa2luZBI4CghldmlkZW5jZRgEIAEoCzIcLmh5ZW5hLmFkYXB0ZXIudjAuU291cmNl'
    'U3BhblIIZXZpZGVuY2U=');

@$core.Deprecated('Use rootDescriptor instead')
const Root$json = {
  '1': 'Root',
  '2': [
    {
      '1': 'symbol',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SymbolKey',
      '10': 'symbol'
    },
    {
      '1': 'kind',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.RootKind',
      '10': 'kind'
    },
    {
      '1': 'evidence',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SourceSpan',
      '10': 'evidence'
    },
    {'1': 'reason_code', '3': 4, '4': 1, '5': 9, '10': 'reasonCode'},
  ],
};

/// Descriptor for `Root`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rootDescriptor = $convert.base64Decode(
    'CgRSb290EjMKBnN5bWJvbBgBIAEoCzIbLmh5ZW5hLmFkYXB0ZXIudjAuU3ltYm9sS2V5UgZzeW'
    '1ib2wSLgoEa2luZBgCIAEoDjIaLmh5ZW5hLmFkYXB0ZXIudjAuUm9vdEtpbmRSBGtpbmQSOAoI'
    'ZXZpZGVuY2UYAyABKAsyHC5oeWVuYS5hZGFwdGVyLnYwLlNvdXJjZVNwYW5SCGV2aWRlbmNlEh'
    '8KC3JlYXNvbl9jb2RlGAQgASgJUgpyZWFzb25Db2Rl');

@$core.Deprecated('Use diagnosticDescriptor instead')
const Diagnostic$json = {
  '1': 'Diagnostic',
  '2': [
    {
      '1': 'severity',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.DiagnosticSeverity',
      '10': 'severity'
    },
    {'1': 'code', '3': 2, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {
      '1': 'span',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.hyena.adapter.v0.SourceSpan',
      '10': 'span'
    },
  ],
};

/// Descriptor for `Diagnostic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diagnosticDescriptor = $convert.base64Decode(
    'CgpEaWFnbm9zdGljEkAKCHNldmVyaXR5GAEgASgOMiQuaHllbmEuYWRhcHRlci52MC5EaWFnbm'
    '9zdGljU2V2ZXJpdHlSCHNldmVyaXR5EhIKBGNvZGUYAiABKAlSBGNvZGUSGAoHbWVzc2FnZRgD'
    'IAEoCVIHbWVzc2FnZRIwCgRzcGFuGAQgASgLMhwuaHllbmEuYWRhcHRlci52MC5Tb3VyY2VTcG'
    'FuUgRzcGFu');

@$core.Deprecated('Use cancelDescriptor instead')
const Cancel$json = {
  '1': 'Cancel',
  '2': [
    {'1': 'reason', '3': 1, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `Cancel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelDescriptor =
    $convert.base64Decode('CgZDYW5jZWwSFgoGcmVhc29uGAEgASgJUgZyZWFzb24=');

@$core.Deprecated('Use completeDescriptor instead')
const Complete$json = {
  '1': 'Complete',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.CompletionStatus',
      '10': 'status'
    },
    {
      '1': 'dimensions',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.hyena.adapter.v0.Completeness',
      '10': 'dimensions'
    },
  ],
};

/// Descriptor for `Complete`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completeDescriptor = $convert.base64Decode(
    'CghDb21wbGV0ZRI6CgZzdGF0dXMYASABKA4yIi5oeWVuYS5hZGFwdGVyLnYwLkNvbXBsZXRpb2'
    '5TdGF0dXNSBnN0YXR1cxI+CgpkaW1lbnNpb25zGAIgAygLMh4uaHllbmEuYWRhcHRlci52MC5D'
    'b21wbGV0ZW5lc3NSCmRpbWVuc2lvbnM=');

@$core.Deprecated('Use completenessDescriptor instead')
const Completeness$json = {
  '1': 'Completeness',
  '2': [
    {'1': 'capability_id', '3': 1, '4': 1, '5': 9, '10': 'capabilityId'},
    {
      '1': 'status',
      '3': 2,
      '4': 1,
      '5': 14,
      '6': '.hyena.adapter.v0.CompletenessStatus',
      '10': 'status'
    },
    {'1': 'reason_code', '3': 3, '4': 1, '5': 9, '10': 'reasonCode'},
  ],
};

/// Descriptor for `Completeness`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List completenessDescriptor = $convert.base64Decode(
    'CgxDb21wbGV0ZW5lc3MSIwoNY2FwYWJpbGl0eV9pZBgBIAEoCVIMY2FwYWJpbGl0eUlkEjwKBn'
    'N0YXR1cxgCIAEoDjIkLmh5ZW5hLmFkYXB0ZXIudjAuQ29tcGxldGVuZXNzU3RhdHVzUgZzdGF0'
    'dXMSHwoLcmVhc29uX2NvZGUYAyABKAlSCnJlYXNvbkNvZGU=');

@$core.Deprecated('Use adapterErrorDescriptor instead')
const AdapterError$json = {
  '1': 'AdapterError',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'retryable', '3': 3, '4': 1, '5': 8, '10': 'retryable'},
  ],
};

/// Descriptor for `AdapterError`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List adapterErrorDescriptor = $convert.base64Decode(
    'CgxBZGFwdGVyRXJyb3ISEgoEY29kZRgBIAEoCVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEhwKCXJldHJ5YWJsZRgDIAEoCFIJcmV0cnlhYmxl');
