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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'hyena_adapter.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'hyena_adapter.pbenum.dart';

enum Envelope_Message {
  hello,
  ready,
  analyzeRequest,
  cancel,
  complete,
  error,
  factBatch,
  notSet
}

/// Experimental Phase 0 protocol. Package v0 carries no compatibility promise;
/// its fact data plane will evolve while Dart and TypeScript validate the
/// domain contract.
class Envelope extends $pb.GeneratedMessage {
  factory Envelope({
    $fixnum.Int64? requestId,
    Hello? hello,
    Ready? ready,
    AnalyzeRequest? analyzeRequest,
    Cancel? cancel,
    Complete? complete,
    AdapterError? error,
    FactBatch? factBatch,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (hello != null) result.hello = hello;
    if (ready != null) result.ready = ready;
    if (analyzeRequest != null) result.analyzeRequest = analyzeRequest;
    if (cancel != null) result.cancel = cancel;
    if (complete != null) result.complete = complete;
    if (error != null) result.error = error;
    if (factBatch != null) result.factBatch = factBatch;
    return result;
  }

  Envelope._();

  factory Envelope.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Envelope.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Envelope_Message> _Envelope_MessageByTag = {
    10: Envelope_Message.hello,
    11: Envelope_Message.ready,
    12: Envelope_Message.analyzeRequest,
    13: Envelope_Message.cancel,
    14: Envelope_Message.complete,
    15: Envelope_Message.error,
    16: Envelope_Message.factBatch,
    0: Envelope_Message.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Envelope',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..oo(0, [10, 11, 12, 13, 14, 15, 16])
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Hello>(10, _omitFieldNames ? '' : 'hello', subBuilder: Hello.create)
    ..aOM<Ready>(11, _omitFieldNames ? '' : 'ready', subBuilder: Ready.create)
    ..aOM<AnalyzeRequest>(12, _omitFieldNames ? '' : 'analyzeRequest',
        subBuilder: AnalyzeRequest.create)
    ..aOM<Cancel>(13, _omitFieldNames ? '' : 'cancel',
        subBuilder: Cancel.create)
    ..aOM<Complete>(14, _omitFieldNames ? '' : 'complete',
        subBuilder: Complete.create)
    ..aOM<AdapterError>(15, _omitFieldNames ? '' : 'error',
        subBuilder: AdapterError.create)
    ..aOM<FactBatch>(16, _omitFieldNames ? '' : 'factBatch',
        subBuilder: FactBatch.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Envelope clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Envelope copyWith(void Function(Envelope) updates) =>
      super.copyWith((message) => updates(message as Envelope)) as Envelope;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Envelope create() => Envelope._();
  @$core.override
  Envelope createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Envelope getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Envelope>(create);
  static Envelope? _defaultInstance;

  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  Envelope_Message whichMessage() => _Envelope_MessageByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(10)
  @$pb.TagNumber(11)
  @$pb.TagNumber(12)
  @$pb.TagNumber(13)
  @$pb.TagNumber(14)
  @$pb.TagNumber(15)
  @$pb.TagNumber(16)
  void clearMessage() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get requestId => $_getI64(0);
  @$pb.TagNumber(1)
  set requestId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(10)
  Hello get hello => $_getN(1);
  @$pb.TagNumber(10)
  set hello(Hello value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasHello() => $_has(1);
  @$pb.TagNumber(10)
  void clearHello() => $_clearField(10);
  @$pb.TagNumber(10)
  Hello ensureHello() => $_ensure(1);

  @$pb.TagNumber(11)
  Ready get ready => $_getN(2);
  @$pb.TagNumber(11)
  set ready(Ready value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReady() => $_has(2);
  @$pb.TagNumber(11)
  void clearReady() => $_clearField(11);
  @$pb.TagNumber(11)
  Ready ensureReady() => $_ensure(2);

  @$pb.TagNumber(12)
  AnalyzeRequest get analyzeRequest => $_getN(3);
  @$pb.TagNumber(12)
  set analyzeRequest(AnalyzeRequest value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasAnalyzeRequest() => $_has(3);
  @$pb.TagNumber(12)
  void clearAnalyzeRequest() => $_clearField(12);
  @$pb.TagNumber(12)
  AnalyzeRequest ensureAnalyzeRequest() => $_ensure(3);

  @$pb.TagNumber(13)
  Cancel get cancel => $_getN(4);
  @$pb.TagNumber(13)
  set cancel(Cancel value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasCancel() => $_has(4);
  @$pb.TagNumber(13)
  void clearCancel() => $_clearField(13);
  @$pb.TagNumber(13)
  Cancel ensureCancel() => $_ensure(4);

  @$pb.TagNumber(14)
  Complete get complete => $_getN(5);
  @$pb.TagNumber(14)
  set complete(Complete value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasComplete() => $_has(5);
  @$pb.TagNumber(14)
  void clearComplete() => $_clearField(14);
  @$pb.TagNumber(14)
  Complete ensureComplete() => $_ensure(5);

  @$pb.TagNumber(15)
  AdapterError get error => $_getN(6);
  @$pb.TagNumber(15)
  set error(AdapterError value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasError() => $_has(6);
  @$pb.TagNumber(15)
  void clearError() => $_clearField(15);
  @$pb.TagNumber(15)
  AdapterError ensureError() => $_ensure(6);

  @$pb.TagNumber(16)
  FactBatch get factBatch => $_getN(7);
  @$pb.TagNumber(16)
  set factBatch(FactBatch value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasFactBatch() => $_has(7);
  @$pb.TagNumber(16)
  void clearFactBatch() => $_clearField(16);
  @$pb.TagNumber(16)
  FactBatch ensureFactBatch() => $_ensure(7);
}

class ProtocolVersion extends $pb.GeneratedMessage {
  factory ProtocolVersion({
    $core.int? major,
    $core.int? minor,
  }) {
    final result = create();
    if (major != null) result.major = major;
    if (minor != null) result.minor = minor;
    return result;
  }

  ProtocolVersion._();

  factory ProtocolVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProtocolVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProtocolVersion',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'major', fieldType: $pb.PbFieldType.OU3)
    ..aI(2, _omitFieldNames ? '' : 'minor', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProtocolVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProtocolVersion copyWith(void Function(ProtocolVersion) updates) =>
      super.copyWith((message) => updates(message as ProtocolVersion))
          as ProtocolVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProtocolVersion create() => ProtocolVersion._();
  @$core.override
  ProtocolVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProtocolVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProtocolVersion>(create);
  static ProtocolVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get major => $_getIZ(0);
  @$pb.TagNumber(1)
  set major($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMajor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMajor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minor => $_getIZ(1);
  @$pb.TagNumber(2)
  set minor($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinor() => $_clearField(2);
}

class Hello extends $pb.GeneratedMessage {
  factory Hello({
    $core.String? engineName,
    $core.String? engineVersion,
    $core.Iterable<ProtocolVersion>? supportedVersions,
    $core.int? maxFrameBytes,
  }) {
    final result = create();
    if (engineName != null) result.engineName = engineName;
    if (engineVersion != null) result.engineVersion = engineVersion;
    if (supportedVersions != null)
      result.supportedVersions.addAll(supportedVersions);
    if (maxFrameBytes != null) result.maxFrameBytes = maxFrameBytes;
    return result;
  }

  Hello._();

  factory Hello.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Hello.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Hello',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'engineName')
    ..aOS(2, _omitFieldNames ? '' : 'engineVersion')
    ..pPM<ProtocolVersion>(3, _omitFieldNames ? '' : 'supportedVersions',
        subBuilder: ProtocolVersion.create)
    ..aI(4, _omitFieldNames ? '' : 'maxFrameBytes',
        fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Hello copyWith(void Function(Hello) updates) =>
      super.copyWith((message) => updates(message as Hello)) as Hello;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Hello create() => Hello._();
  @$core.override
  Hello createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Hello getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Hello>(create);
  static Hello? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get engineName => $_getSZ(0);
  @$pb.TagNumber(1)
  set engineName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEngineName() => $_has(0);
  @$pb.TagNumber(1)
  void clearEngineName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get engineVersion => $_getSZ(1);
  @$pb.TagNumber(2)
  set engineVersion($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEngineVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearEngineVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<ProtocolVersion> get supportedVersions => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get maxFrameBytes => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxFrameBytes($core.int value) => $_setUnsignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasMaxFrameBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxFrameBytes() => $_clearField(4);
}

class Ready extends $pb.GeneratedMessage {
  factory Ready({
    AdapterInfo? adapter,
    ProtocolVersion? selectedVersion,
    $core.Iterable<Capability>? capabilities,
  }) {
    final result = create();
    if (adapter != null) result.adapter = adapter;
    if (selectedVersion != null) result.selectedVersion = selectedVersion;
    if (capabilities != null) result.capabilities.addAll(capabilities);
    return result;
  }

  Ready._();

  factory Ready.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Ready.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Ready',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOM<AdapterInfo>(1, _omitFieldNames ? '' : 'adapter',
        subBuilder: AdapterInfo.create)
    ..aOM<ProtocolVersion>(2, _omitFieldNames ? '' : 'selectedVersion',
        subBuilder: ProtocolVersion.create)
    ..pPM<Capability>(3, _omitFieldNames ? '' : 'capabilities',
        subBuilder: Capability.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ready clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Ready copyWith(void Function(Ready) updates) =>
      super.copyWith((message) => updates(message as Ready)) as Ready;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Ready create() => Ready._();
  @$core.override
  Ready createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Ready getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Ready>(create);
  static Ready? _defaultInstance;

  @$pb.TagNumber(1)
  AdapterInfo get adapter => $_getN(0);
  @$pb.TagNumber(1)
  set adapter(AdapterInfo value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasAdapter() => $_has(0);
  @$pb.TagNumber(1)
  void clearAdapter() => $_clearField(1);
  @$pb.TagNumber(1)
  AdapterInfo ensureAdapter() => $_ensure(0);

  @$pb.TagNumber(2)
  ProtocolVersion get selectedVersion => $_getN(1);
  @$pb.TagNumber(2)
  set selectedVersion(ProtocolVersion value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSelectedVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearSelectedVersion() => $_clearField(2);
  @$pb.TagNumber(2)
  ProtocolVersion ensureSelectedVersion() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Capability> get capabilities => $_getList(2);
}

class AdapterInfo extends $pb.GeneratedMessage {
  factory AdapterInfo({
    $core.String? name,
    $core.String? version,
    $core.String? buildId,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (version != null) result.version = version;
    if (buildId != null) result.buildId = buildId;
    return result;
  }

  AdapterInfo._();

  factory AdapterInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdapterInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdapterInfo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'version')
    ..aOS(3, _omitFieldNames ? '' : 'buildId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdapterInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdapterInfo copyWith(void Function(AdapterInfo) updates) =>
      super.copyWith((message) => updates(message as AdapterInfo))
          as AdapterInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdapterInfo create() => AdapterInfo._();
  @$core.override
  AdapterInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdapterInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdapterInfo>(create);
  static AdapterInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get buildId => $_getSZ(2);
  @$pb.TagNumber(3)
  set buildId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBuildId() => $_has(2);
  @$pb.TagNumber(3)
  void clearBuildId() => $_clearField(3);
}

class Capability extends $pb.GeneratedMessage {
  factory Capability({
    $core.String? id,
    $core.int? version,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (version != null) result.version = version;
    return result;
  }

  Capability._();

  factory Capability.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Capability.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Capability',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aI(2, _omitFieldNames ? '' : 'version', fieldType: $pb.PbFieldType.OU3)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Capability clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Capability copyWith(void Function(Capability) updates) =>
      super.copyWith((message) => updates(message as Capability)) as Capability;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Capability create() => Capability._();
  @$core.override
  Capability createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Capability getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Capability>(create);
  static Capability? _defaultInstance;

  /// Reverse-domain or project-qualified identifier, such as
  /// "hyena.semantic.definitions". Unknown capabilities are preserved as
  /// strings and never interpreted as negative facts.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get version => $_getIZ(1);
  @$pb.TagNumber(2)
  set version($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => $_clearField(2);
}

class AnalyzeRequest extends $pb.GeneratedMessage {
  factory AnalyzeRequest({
    $core.String? workspaceRoot,
    $core.String? target,
    $core.List<$core.int>? configurationDigest,
    $core.String? variantId,
  }) {
    final result = create();
    if (workspaceRoot != null) result.workspaceRoot = workspaceRoot;
    if (target != null) result.target = target;
    if (configurationDigest != null)
      result.configurationDigest = configurationDigest;
    if (variantId != null) result.variantId = variantId;
    return result;
  }

  AnalyzeRequest._();

  factory AnalyzeRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AnalyzeRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AnalyzeRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'workspaceRoot')
    ..aOS(2, _omitFieldNames ? '' : 'target')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'configurationDigest', $pb.PbFieldType.OY)
    ..aOS(4, _omitFieldNames ? '' : 'variantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AnalyzeRequest copyWith(void Function(AnalyzeRequest) updates) =>
      super.copyWith((message) => updates(message as AnalyzeRequest))
          as AnalyzeRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnalyzeRequest create() => AnalyzeRequest._();
  @$core.override
  AnalyzeRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AnalyzeRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AnalyzeRequest>(create);
  static AnalyzeRequest? _defaultInstance;

  /// Physical workspace root granted to this trusted v0 subprocess. It is not
  /// a portable artifact identity and must not appear in findings.
  @$pb.TagNumber(1)
  $core.String get workspaceRoot => $_getSZ(0);
  @$pb.TagNumber(1)
  set workspaceRoot($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkspaceRoot() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkspaceRoot() => $_clearField(1);

  /// Portable, workspace-relative path using '/' separators.
  @$pb.TagNumber(2)
  $core.String get target => $_getSZ(1);
  @$pb.TagNumber(2)
  set target($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTarget() => $_has(1);
  @$pb.TagNumber(2)
  void clearTarget() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get configurationDigest => $_getN(2);
  @$pb.TagNumber(3)
  set configurationDigest($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasConfigurationDigest() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfigurationDigest() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get variantId => $_getSZ(3);
  @$pb.TagNumber(4)
  set variantId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVariantId() => $_has(3);
  @$pb.TagNumber(4)
  void clearVariantId() => $_clearField(4);
}

class FactBatch extends $pb.GeneratedMessage {
  factory FactBatch({
    $fixnum.Int64? sequence,
    $core.Iterable<Artifact>? artifacts,
    $core.Iterable<Symbol>? symbols,
    $core.Iterable<RetentionEdge>? retentionEdges,
    $core.Iterable<Root>? roots,
    $core.Iterable<Diagnostic>? diagnostics,
  }) {
    final result = create();
    if (sequence != null) result.sequence = sequence;
    if (artifacts != null) result.artifacts.addAll(artifacts);
    if (symbols != null) result.symbols.addAll(symbols);
    if (retentionEdges != null) result.retentionEdges.addAll(retentionEdges);
    if (roots != null) result.roots.addAll(roots);
    if (diagnostics != null) result.diagnostics.addAll(diagnostics);
    return result;
  }

  FactBatch._();

  factory FactBatch.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FactBatch.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FactBatch',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..a<$fixnum.Int64>(
        1, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..pPM<Artifact>(2, _omitFieldNames ? '' : 'artifacts',
        subBuilder: Artifact.create)
    ..pPM<Symbol>(3, _omitFieldNames ? '' : 'symbols',
        subBuilder: Symbol.create)
    ..pPM<RetentionEdge>(4, _omitFieldNames ? '' : 'retentionEdges',
        subBuilder: RetentionEdge.create)
    ..pPM<Root>(5, _omitFieldNames ? '' : 'roots', subBuilder: Root.create)
    ..pPM<Diagnostic>(6, _omitFieldNames ? '' : 'diagnostics',
        subBuilder: Diagnostic.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FactBatch clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FactBatch copyWith(void Function(FactBatch) updates) =>
      super.copyWith((message) => updates(message as FactBatch)) as FactBatch;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FactBatch create() => FactBatch._();
  @$core.override
  FactBatch createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FactBatch getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FactBatch>(create);
  static FactBatch? _defaultInstance;

  /// Monotonically increasing per request, starting at zero.
  @$pb.TagNumber(1)
  $fixnum.Int64 get sequence => $_getI64(0);
  @$pb.TagNumber(1)
  set sequence($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Artifact> get artifacts => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<Symbol> get symbols => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<RetentionEdge> get retentionEdges => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<Root> get roots => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<Diagnostic> get diagnostics => $_getList(5);
}

class Artifact extends $pb.GeneratedMessage {
  factory Artifact({
    $core.String? id,
    $core.String? language,
    $fixnum.Int64? byteLength,
    ContentDigest? contentDigest,
    SourceEncoding? sourceEncoding,
    ArtifactOrigin? origin,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (language != null) result.language = language;
    if (byteLength != null) result.byteLength = byteLength;
    if (contentDigest != null) result.contentDigest = contentDigest;
    if (sourceEncoding != null) result.sourceEncoding = sourceEncoding;
    if (origin != null) result.origin = origin;
    return result;
  }

  Artifact._();

  factory Artifact.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Artifact.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Artifact',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'language')
    ..a<$fixnum.Int64>(
        3, _omitFieldNames ? '' : 'byteLength', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<ContentDigest>(4, _omitFieldNames ? '' : 'contentDigest',
        subBuilder: ContentDigest.create)
    ..aE<SourceEncoding>(5, _omitFieldNames ? '' : 'sourceEncoding',
        enumValues: SourceEncoding.values)
    ..aE<ArtifactOrigin>(6, _omitFieldNames ? '' : 'origin',
        enumValues: ArtifactOrigin.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Artifact clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Artifact copyWith(void Function(Artifact) updates) =>
      super.copyWith((message) => updates(message as Artifact)) as Artifact;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Artifact create() => Artifact._();
  @$core.override
  Artifact createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Artifact getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Artifact>(create);
  static Artifact? _defaultInstance;

  /// Workspace-relative, '/'-separated, with no empty, '.' or '..' segments.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get language => $_getSZ(1);
  @$pb.TagNumber(2)
  set language($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLanguage() => $_has(1);
  @$pb.TagNumber(2)
  void clearLanguage() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get byteLength => $_getI64(2);
  @$pb.TagNumber(3)
  set byteLength($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasByteLength() => $_has(2);
  @$pb.TagNumber(3)
  void clearByteLength() => $_clearField(3);

  @$pb.TagNumber(4)
  ContentDigest get contentDigest => $_getN(3);
  @$pb.TagNumber(4)
  set contentDigest(ContentDigest value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasContentDigest() => $_has(3);
  @$pb.TagNumber(4)
  void clearContentDigest() => $_clearField(4);
  @$pb.TagNumber(4)
  ContentDigest ensureContentDigest() => $_ensure(3);

  @$pb.TagNumber(5)
  SourceEncoding get sourceEncoding => $_getN(4);
  @$pb.TagNumber(5)
  set sourceEncoding(SourceEncoding value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceEncoding() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceEncoding() => $_clearField(5);

  @$pb.TagNumber(6)
  ArtifactOrigin get origin => $_getN(5);
  @$pb.TagNumber(6)
  set origin(ArtifactOrigin value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasOrigin() => $_has(5);
  @$pb.TagNumber(6)
  void clearOrigin() => $_clearField(6);
}

class ContentDigest extends $pb.GeneratedMessage {
  factory ContentDigest({
    $core.String? algorithm,
    $core.List<$core.int>? value,
  }) {
    final result = create();
    if (algorithm != null) result.algorithm = algorithm;
    if (value != null) result.value = value;
    return result;
  }

  ContentDigest._();

  factory ContentDigest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ContentDigest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ContentDigest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'algorithm')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentDigest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContentDigest copyWith(void Function(ContentDigest) updates) =>
      super.copyWith((message) => updates(message as ContentDigest))
          as ContentDigest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContentDigest create() => ContentDigest._();
  @$core.override
  ContentDigest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ContentDigest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ContentDigest>(create);
  static ContentDigest? _defaultInstance;

  /// Lowercase registered algorithm name. V0 Dart adapters use "sha256".
  @$pb.TagNumber(1)
  $core.String get algorithm => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithm($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAlgorithm() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithm() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

class SourceSpan extends $pb.GeneratedMessage {
  factory SourceSpan({
    $core.String? artifactId,
    $fixnum.Int64? startByte,
    $fixnum.Int64? endByte,
  }) {
    final result = create();
    if (artifactId != null) result.artifactId = artifactId;
    if (startByte != null) result.startByte = startByte;
    if (endByte != null) result.endByte = endByte;
    return result;
  }

  SourceSpan._();

  factory SourceSpan.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SourceSpan.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SourceSpan',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'artifactId')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'startByte', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'endByte', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceSpan clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SourceSpan copyWith(void Function(SourceSpan) updates) =>
      super.copyWith((message) => updates(message as SourceSpan)) as SourceSpan;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SourceSpan create() => SourceSpan._();
  @$core.override
  SourceSpan createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SourceSpan getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SourceSpan>(create);
  static SourceSpan? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get artifactId => $_getSZ(0);
  @$pb.TagNumber(1)
  set artifactId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasArtifactId() => $_has(0);
  @$pb.TagNumber(1)
  void clearArtifactId() => $_clearField(1);

  /// Zero-based, half-open UTF-8 byte offsets: [start_byte, end_byte).
  @$pb.TagNumber(2)
  $fixnum.Int64 get startByte => $_getI64(1);
  @$pb.TagNumber(2)
  set startByte($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStartByte() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartByte() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get endByte => $_getI64(2);
  @$pb.TagNumber(3)
  set endByte($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEndByte() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndByte() => $_clearField(3);
}

class SymbolKey extends $pb.GeneratedMessage {
  factory SymbolKey({
    $core.String? scheme,
    $core.int? schemeVersion,
    $core.List<$core.int>? value,
    SymbolStability? stability,
  }) {
    final result = create();
    if (scheme != null) result.scheme = scheme;
    if (schemeVersion != null) result.schemeVersion = schemeVersion;
    if (value != null) result.value = value;
    if (stability != null) result.stability = stability;
    return result;
  }

  SymbolKey._();

  factory SymbolKey.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SymbolKey.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SymbolKey',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'scheme')
    ..aI(2, _omitFieldNames ? '' : 'schemeVersion',
        fieldType: $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OY)
    ..aE<SymbolStability>(4, _omitFieldNames ? '' : 'stability',
        enumValues: SymbolStability.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymbolKey clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SymbolKey copyWith(void Function(SymbolKey) updates) =>
      super.copyWith((message) => updates(message as SymbolKey)) as SymbolKey;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SymbolKey create() => SymbolKey._();
  @$core.override
  SymbolKey createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SymbolKey getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SymbolKey>(create);
  static SymbolKey? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get scheme => $_getSZ(0);
  @$pb.TagNumber(1)
  set scheme($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasScheme() => $_has(0);
  @$pb.TagNumber(1)
  void clearScheme() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get schemeVersion => $_getIZ(1);
  @$pb.TagNumber(2)
  set schemeVersion($core.int value) => $_setUnsignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSchemeVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchemeVersion() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get value => $_getN(2);
  @$pb.TagNumber(3)
  set value($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasValue() => $_has(2);
  @$pb.TagNumber(3)
  void clearValue() => $_clearField(3);

  @$pb.TagNumber(4)
  SymbolStability get stability => $_getN(3);
  @$pb.TagNumber(4)
  set stability(SymbolStability value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasStability() => $_has(3);
  @$pb.TagNumber(4)
  void clearStability() => $_clearField(4);
}

class Symbol extends $pb.GeneratedMessage {
  factory Symbol({
    SymbolKey? key,
    $core.String? displayName,
    $core.String? qualifiedName,
    SymbolKind? kind,
    SourceSpan? declaration,
    Visibility? visibility,
    ExportStatus? exportStatus,
  }) {
    final result = create();
    if (key != null) result.key = key;
    if (displayName != null) result.displayName = displayName;
    if (qualifiedName != null) result.qualifiedName = qualifiedName;
    if (kind != null) result.kind = kind;
    if (declaration != null) result.declaration = declaration;
    if (visibility != null) result.visibility = visibility;
    if (exportStatus != null) result.exportStatus = exportStatus;
    return result;
  }

  Symbol._();

  factory Symbol.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Symbol.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Symbol',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOM<SymbolKey>(1, _omitFieldNames ? '' : 'key',
        subBuilder: SymbolKey.create)
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'qualifiedName')
    ..aE<SymbolKind>(4, _omitFieldNames ? '' : 'kind',
        enumValues: SymbolKind.values)
    ..aOM<SourceSpan>(5, _omitFieldNames ? '' : 'declaration',
        subBuilder: SourceSpan.create)
    ..aE<Visibility>(6, _omitFieldNames ? '' : 'visibility',
        enumValues: Visibility.values)
    ..aE<ExportStatus>(7, _omitFieldNames ? '' : 'exportStatus',
        enumValues: ExportStatus.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Symbol clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Symbol copyWith(void Function(Symbol) updates) =>
      super.copyWith((message) => updates(message as Symbol)) as Symbol;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Symbol create() => Symbol._();
  @$core.override
  Symbol createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Symbol getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Symbol>(create);
  static Symbol? _defaultInstance;

  @$pb.TagNumber(1)
  SymbolKey get key => $_getN(0);
  @$pb.TagNumber(1)
  set key(SymbolKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);
  @$pb.TagNumber(1)
  SymbolKey ensureKey() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get qualifiedName => $_getSZ(2);
  @$pb.TagNumber(3)
  set qualifiedName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQualifiedName() => $_has(2);
  @$pb.TagNumber(3)
  void clearQualifiedName() => $_clearField(3);

  @$pb.TagNumber(4)
  SymbolKind get kind => $_getN(3);
  @$pb.TagNumber(4)
  set kind(SymbolKind value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasKind() => $_has(3);
  @$pb.TagNumber(4)
  void clearKind() => $_clearField(4);

  @$pb.TagNumber(5)
  SourceSpan get declaration => $_getN(4);
  @$pb.TagNumber(5)
  set declaration(SourceSpan value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDeclaration() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeclaration() => $_clearField(5);
  @$pb.TagNumber(5)
  SourceSpan ensureDeclaration() => $_ensure(4);

  @$pb.TagNumber(6)
  Visibility get visibility => $_getN(5);
  @$pb.TagNumber(6)
  set visibility(Visibility value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasVisibility() => $_has(5);
  @$pb.TagNumber(6)
  void clearVisibility() => $_clearField(6);

  @$pb.TagNumber(7)
  ExportStatus get exportStatus => $_getN(6);
  @$pb.TagNumber(7)
  set exportStatus(ExportStatus value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasExportStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearExportStatus() => $_clearField(7);
}

class RetentionEdge extends $pb.GeneratedMessage {
  factory RetentionEdge({
    SymbolKey? source,
    SymbolKey? target,
    RetentionEdgeKind? kind,
    SourceSpan? evidence,
  }) {
    final result = create();
    if (source != null) result.source = source;
    if (target != null) result.target = target;
    if (kind != null) result.kind = kind;
    if (evidence != null) result.evidence = evidence;
    return result;
  }

  RetentionEdge._();

  factory RetentionEdge.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RetentionEdge.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RetentionEdge',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOM<SymbolKey>(1, _omitFieldNames ? '' : 'source',
        subBuilder: SymbolKey.create)
    ..aOM<SymbolKey>(2, _omitFieldNames ? '' : 'target',
        subBuilder: SymbolKey.create)
    ..aE<RetentionEdgeKind>(3, _omitFieldNames ? '' : 'kind',
        enumValues: RetentionEdgeKind.values)
    ..aOM<SourceSpan>(4, _omitFieldNames ? '' : 'evidence',
        subBuilder: SourceSpan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionEdge clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RetentionEdge copyWith(void Function(RetentionEdge) updates) =>
      super.copyWith((message) => updates(message as RetentionEdge))
          as RetentionEdge;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetentionEdge create() => RetentionEdge._();
  @$core.override
  RetentionEdge createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RetentionEdge getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RetentionEdge>(create);
  static RetentionEdge? _defaultInstance;

  @$pb.TagNumber(1)
  SymbolKey get source => $_getN(0);
  @$pb.TagNumber(1)
  set source(SymbolKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSource() => $_has(0);
  @$pb.TagNumber(1)
  void clearSource() => $_clearField(1);
  @$pb.TagNumber(1)
  SymbolKey ensureSource() => $_ensure(0);

  @$pb.TagNumber(2)
  SymbolKey get target => $_getN(1);
  @$pb.TagNumber(2)
  set target(SymbolKey value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTarget() => $_has(1);
  @$pb.TagNumber(2)
  void clearTarget() => $_clearField(2);
  @$pb.TagNumber(2)
  SymbolKey ensureTarget() => $_ensure(1);

  @$pb.TagNumber(3)
  RetentionEdgeKind get kind => $_getN(2);
  @$pb.TagNumber(3)
  set kind(RetentionEdgeKind value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasKind() => $_has(2);
  @$pb.TagNumber(3)
  void clearKind() => $_clearField(3);

  @$pb.TagNumber(4)
  SourceSpan get evidence => $_getN(3);
  @$pb.TagNumber(4)
  set evidence(SourceSpan value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEvidence() => $_has(3);
  @$pb.TagNumber(4)
  void clearEvidence() => $_clearField(4);
  @$pb.TagNumber(4)
  SourceSpan ensureEvidence() => $_ensure(3);
}

class Root extends $pb.GeneratedMessage {
  factory Root({
    SymbolKey? symbol,
    RootKind? kind,
    SourceSpan? evidence,
    $core.String? reasonCode,
  }) {
    final result = create();
    if (symbol != null) result.symbol = symbol;
    if (kind != null) result.kind = kind;
    if (evidence != null) result.evidence = evidence;
    if (reasonCode != null) result.reasonCode = reasonCode;
    return result;
  }

  Root._();

  factory Root.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Root.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Root',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOM<SymbolKey>(1, _omitFieldNames ? '' : 'symbol',
        subBuilder: SymbolKey.create)
    ..aE<RootKind>(2, _omitFieldNames ? '' : 'kind',
        enumValues: RootKind.values)
    ..aOM<SourceSpan>(3, _omitFieldNames ? '' : 'evidence',
        subBuilder: SourceSpan.create)
    ..aOS(4, _omitFieldNames ? '' : 'reasonCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Root clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Root copyWith(void Function(Root) updates) =>
      super.copyWith((message) => updates(message as Root)) as Root;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Root create() => Root._();
  @$core.override
  Root createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Root getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Root>(create);
  static Root? _defaultInstance;

  @$pb.TagNumber(1)
  SymbolKey get symbol => $_getN(0);
  @$pb.TagNumber(1)
  set symbol(SymbolKey value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSymbol() => $_has(0);
  @$pb.TagNumber(1)
  void clearSymbol() => $_clearField(1);
  @$pb.TagNumber(1)
  SymbolKey ensureSymbol() => $_ensure(0);

  @$pb.TagNumber(2)
  RootKind get kind => $_getN(1);
  @$pb.TagNumber(2)
  set kind(RootKind value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasKind() => $_has(1);
  @$pb.TagNumber(2)
  void clearKind() => $_clearField(2);

  @$pb.TagNumber(3)
  SourceSpan get evidence => $_getN(2);
  @$pb.TagNumber(3)
  set evidence(SourceSpan value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEvidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvidence() => $_clearField(3);
  @$pb.TagNumber(3)
  SourceSpan ensureEvidence() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get reasonCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set reasonCode($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasReasonCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearReasonCode() => $_clearField(4);
}

class Diagnostic extends $pb.GeneratedMessage {
  factory Diagnostic({
    DiagnosticSeverity? severity,
    $core.String? code,
    $core.String? message,
    SourceSpan? span,
  }) {
    final result = create();
    if (severity != null) result.severity = severity;
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (span != null) result.span = span;
    return result;
  }

  Diagnostic._();

  factory Diagnostic.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Diagnostic.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Diagnostic',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aE<DiagnosticSeverity>(1, _omitFieldNames ? '' : 'severity',
        enumValues: DiagnosticSeverity.values)
    ..aOS(2, _omitFieldNames ? '' : 'code')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOM<SourceSpan>(4, _omitFieldNames ? '' : 'span',
        subBuilder: SourceSpan.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnostic clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Diagnostic copyWith(void Function(Diagnostic) updates) =>
      super.copyWith((message) => updates(message as Diagnostic)) as Diagnostic;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Diagnostic create() => Diagnostic._();
  @$core.override
  Diagnostic createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Diagnostic getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Diagnostic>(create);
  static Diagnostic? _defaultInstance;

  @$pb.TagNumber(1)
  DiagnosticSeverity get severity => $_getN(0);
  @$pb.TagNumber(1)
  set severity(DiagnosticSeverity value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSeverity() => $_has(0);
  @$pb.TagNumber(1)
  void clearSeverity() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get code => $_getSZ(1);
  @$pb.TagNumber(2)
  set code($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  SourceSpan get span => $_getN(3);
  @$pb.TagNumber(4)
  set span(SourceSpan value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSpan() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpan() => $_clearField(4);
  @$pb.TagNumber(4)
  SourceSpan ensureSpan() => $_ensure(3);
}

class Cancel extends $pb.GeneratedMessage {
  factory Cancel({
    $core.String? reason,
  }) {
    final result = create();
    if (reason != null) result.reason = reason;
    return result;
  }

  Cancel._();

  factory Cancel.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Cancel.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Cancel',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cancel clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Cancel copyWith(void Function(Cancel) updates) =>
      super.copyWith((message) => updates(message as Cancel)) as Cancel;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Cancel create() => Cancel._();
  @$core.override
  Cancel createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Cancel getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Cancel>(create);
  static Cancel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reason => $_getSZ(0);
  @$pb.TagNumber(1)
  set reason($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReason() => $_has(0);
  @$pb.TagNumber(1)
  void clearReason() => $_clearField(1);
}

class Complete extends $pb.GeneratedMessage {
  factory Complete({
    CompletionStatus? status,
    $core.Iterable<Completeness>? dimensions,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (dimensions != null) result.dimensions.addAll(dimensions);
    return result;
  }

  Complete._();

  factory Complete.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Complete.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Complete',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aE<CompletionStatus>(1, _omitFieldNames ? '' : 'status',
        enumValues: CompletionStatus.values)
    ..pPM<Completeness>(2, _omitFieldNames ? '' : 'dimensions',
        subBuilder: Completeness.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Complete clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Complete copyWith(void Function(Complete) updates) =>
      super.copyWith((message) => updates(message as Complete)) as Complete;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Complete create() => Complete._();
  @$core.override
  Complete createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Complete getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Complete>(create);
  static Complete? _defaultInstance;

  /// Terminal response for a successful or partial request. AdapterError is
  /// independently terminal; an adapter must not send both for one request.
  @$pb.TagNumber(1)
  CompletionStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(CompletionStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Completeness> get dimensions => $_getList(1);
}

class Completeness extends $pb.GeneratedMessage {
  factory Completeness({
    $core.String? capabilityId,
    CompletenessStatus? status,
    $core.String? reasonCode,
  }) {
    final result = create();
    if (capabilityId != null) result.capabilityId = capabilityId;
    if (status != null) result.status = status;
    if (reasonCode != null) result.reasonCode = reasonCode;
    return result;
  }

  Completeness._();

  factory Completeness.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Completeness.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Completeness',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'capabilityId')
    ..aE<CompletenessStatus>(2, _omitFieldNames ? '' : 'status',
        enumValues: CompletenessStatus.values)
    ..aOS(3, _omitFieldNames ? '' : 'reasonCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Completeness clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Completeness copyWith(void Function(Completeness) updates) =>
      super.copyWith((message) => updates(message as Completeness))
          as Completeness;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Completeness create() => Completeness._();
  @$core.override
  Completeness createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Completeness getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Completeness>(create);
  static Completeness? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get capabilityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set capabilityId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCapabilityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCapabilityId() => $_clearField(1);

  @$pb.TagNumber(2)
  CompletenessStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(CompletenessStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reasonCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set reasonCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReasonCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearReasonCode() => $_clearField(3);
}

class AdapterError extends $pb.GeneratedMessage {
  factory AdapterError({
    $core.String? code,
    $core.String? message,
    $core.bool? retryable,
  }) {
    final result = create();
    if (code != null) result.code = code;
    if (message != null) result.message = message;
    if (retryable != null) result.retryable = retryable;
    return result;
  }

  AdapterError._();

  factory AdapterError.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdapterError.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdapterError',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'hyena.adapter.v0'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOB(3, _omitFieldNames ? '' : 'retryable')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdapterError clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdapterError copyWith(void Function(AdapterError) updates) =>
      super.copyWith((message) => updates(message as AdapterError))
          as AdapterError;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdapterError create() => AdapterError._();
  @$core.override
  AdapterError createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdapterError getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdapterError>(create);
  static AdapterError? _defaultInstance;

  /// Terminal response for the request_id carried by the enclosing Envelope.
  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get retryable => $_getBF(2);
  @$pb.TagNumber(3)
  set retryable($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRetryable() => $_has(2);
  @$pb.TagNumber(3)
  void clearRetryable() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
