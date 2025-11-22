// This is a generated file - do not edit.
//
// Generated from protos/dues.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class BaseFile extends $pb.GeneratedMessage {
  factory BaseFile({
    $core.String? filePath,
    $core.String? fileId,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>? chunkMap,
  }) {
    final result = create();
    if (filePath != null) result.filePath = filePath;
    if (fileId != null) result.fileId = fileId;
    if (chunkMap != null) result.chunkMap.addEntries(chunkMap);
    return result;
  }

  BaseFile._();

  factory BaseFile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory BaseFile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BaseFile',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..m<$core.String, $fixnum.Int64>(3, _omitFieldNames ? '' : 'chunkMap',
        entryClassName: 'BaseFile.ChunkMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('dues'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BaseFile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BaseFile copyWith(void Function(BaseFile) updates) =>
      super.copyWith((message) => updates(message as BaseFile)) as BaseFile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BaseFile create() => BaseFile._();
  @$core.override
  BaseFile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static BaseFile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseFile>(create);
  static BaseFile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $fixnum.Int64> get chunkMap => $_getMap(2);
}

class AppendIfExistsReq extends $pb.GeneratedMessage {
  factory AppendIfExistsReq({
    $core.String? fileHash,
    $core.String? filePath,
  }) {
    final result = create();
    if (fileHash != null) result.fileHash = fileHash;
    if (filePath != null) result.filePath = filePath;
    return result;
  }

  AppendIfExistsReq._();

  factory AppendIfExistsReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppendIfExistsReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppendIfExistsReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileHash')
    ..aOS(2, _omitFieldNames ? '' : 'filePath')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendIfExistsReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendIfExistsReq copyWith(void Function(AppendIfExistsReq) updates) =>
      super.copyWith((message) => updates(message as AppendIfExistsReq))
          as AppendIfExistsReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppendIfExistsReq create() => AppendIfExistsReq._();
  @$core.override
  AppendIfExistsReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppendIfExistsReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppendIfExistsReq>(create);
  static AppendIfExistsReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get filePath => $_getSZ(1);
  @$pb.TagNumber(2)
  set filePath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilePath() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilePath() => $_clearField(2);
}

class AppendIfExistsRes extends $pb.GeneratedMessage {
  factory AppendIfExistsRes({
    $core.bool? exists,
    $core.bool? appended,
    BaseFile? eviFile,
    $core.String? err,
  }) {
    final result = create();
    if (exists != null) result.exists = exists;
    if (appended != null) result.appended = appended;
    if (eviFile != null) result.eviFile = eviFile;
    if (err != null) result.err = err;
    return result;
  }

  AppendIfExistsRes._();

  factory AppendIfExistsRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AppendIfExistsRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AppendIfExistsRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'exists')
    ..aOB(2, _omitFieldNames ? '' : 'appended')
    ..aOM<BaseFile>(3, _omitFieldNames ? '' : 'eviFile',
        subBuilder: BaseFile.create)
    ..aOS(4, _omitFieldNames ? '' : 'err')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendIfExistsRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AppendIfExistsRes copyWith(void Function(AppendIfExistsRes) updates) =>
      super.copyWith((message) => updates(message as AppendIfExistsRes))
          as AppendIfExistsRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AppendIfExistsRes create() => AppendIfExistsRes._();
  @$core.override
  AppendIfExistsRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AppendIfExistsRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AppendIfExistsRes>(create);
  static AppendIfExistsRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get exists => $_getBF(0);
  @$pb.TagNumber(1)
  set exists($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasExists() => $_has(0);
  @$pb.TagNumber(1)
  void clearExists() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get appended => $_getBF(1);
  @$pb.TagNumber(2)
  set appended($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAppended() => $_has(1);
  @$pb.TagNumber(2)
  void clearAppended() => $_clearField(2);

  @$pb.TagNumber(3)
  BaseFile get eviFile => $_getN(2);
  @$pb.TagNumber(3)
  set eviFile(BaseFile value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEviFile() => $_has(2);
  @$pb.TagNumber(3)
  void clearEviFile() => $_clearField(3);
  @$pb.TagNumber(3)
  BaseFile ensureEviFile() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get err => $_getSZ(3);
  @$pb.TagNumber(4)
  set err($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasErr() => $_has(3);
  @$pb.TagNumber(4)
  void clearErr() => $_clearField(4);
}

class StreamFileMeta extends $pb.GeneratedMessage {
  factory StreamFileMeta({
    $core.String? filePath,
    $fixnum.Int64? fileSize,
    $core.String? fileType,
    $core.String? fileHash,
  }) {
    final result = create();
    if (filePath != null) result.filePath = filePath;
    if (fileSize != null) result.fileSize = fileSize;
    if (fileType != null) result.fileType = fileType;
    if (fileHash != null) result.fileHash = fileHash;
    return result;
  }

  StreamFileMeta._();

  factory StreamFileMeta.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamFileMeta.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamFileMeta',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..aInt64(2, _omitFieldNames ? '' : 'fileSize')
    ..aOS(3, _omitFieldNames ? '' : 'fileType')
    ..aOS(4, _omitFieldNames ? '' : 'fileHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileMeta clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileMeta copyWith(void Function(StreamFileMeta) updates) =>
      super.copyWith((message) => updates(message as StreamFileMeta))
          as StreamFileMeta;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamFileMeta create() => StreamFileMeta._();
  @$core.override
  StreamFileMeta createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamFileMeta getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamFileMeta>(create);
  static StreamFileMeta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get fileSize => $_getI64(1);
  @$pb.TagNumber(2)
  set fileSize($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get fileType => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileType($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileType() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileHash => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileHash($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFileHash() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileHash() => $_clearField(4);
}

enum StreamFileReq_Payload { file, fileMeta, notSet }

class StreamFileReq extends $pb.GeneratedMessage {
  factory StreamFileReq({
    $core.List<$core.int>? file,
    StreamFileMeta? fileMeta,
  }) {
    final result = create();
    if (file != null) result.file = file;
    if (fileMeta != null) result.fileMeta = fileMeta;
    return result;
  }

  StreamFileReq._();

  factory StreamFileReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamFileReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, StreamFileReq_Payload>
      _StreamFileReq_PayloadByTag = {
    1: StreamFileReq_Payload.file,
    2: StreamFileReq_Payload.fileMeta,
    0: StreamFileReq_Payload.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamFileReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'file', $pb.PbFieldType.OY)
    ..aOM<StreamFileMeta>(2, _omitFieldNames ? '' : 'fileMeta',
        subBuilder: StreamFileMeta.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileReq copyWith(void Function(StreamFileReq) updates) =>
      super.copyWith((message) => updates(message as StreamFileReq))
          as StreamFileReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamFileReq create() => StreamFileReq._();
  @$core.override
  StreamFileReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamFileReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamFileReq>(create);
  static StreamFileReq? _defaultInstance;

  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  StreamFileReq_Payload whichPayload() =>
      _StreamFileReq_PayloadByTag[$_whichOneof(0)]!;
  @$pb.TagNumber(1)
  @$pb.TagNumber(2)
  void clearPayload() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<$core.int> get file => $_getN(0);
  @$pb.TagNumber(1)
  set file($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => $_clearField(1);

  @$pb.TagNumber(2)
  StreamFileMeta get fileMeta => $_getN(1);
  @$pb.TagNumber(2)
  set fileMeta(StreamFileMeta value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFileMeta() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileMeta() => $_clearField(2);
  @$pb.TagNumber(2)
  StreamFileMeta ensureFileMeta() => $_ensure(1);
}

class StreamFileRes extends $pb.GeneratedMessage {
  factory StreamFileRes({
    $core.bool? done,
    $core.String? err,
    BaseFile? eviFile,
  }) {
    final result = create();
    if (done != null) result.done = done;
    if (err != null) result.err = err;
    if (eviFile != null) result.eviFile = eviFile;
    return result;
  }

  StreamFileRes._();

  factory StreamFileRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StreamFileRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StreamFileRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'done')
    ..aOS(2, _omitFieldNames ? '' : 'err')
    ..aOM<BaseFile>(3, _omitFieldNames ? '' : 'eviFile',
        subBuilder: BaseFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StreamFileRes copyWith(void Function(StreamFileRes) updates) =>
      super.copyWith((message) => updates(message as StreamFileRes))
          as StreamFileRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamFileRes create() => StreamFileRes._();
  @$core.override
  StreamFileRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StreamFileRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StreamFileRes>(create);
  static StreamFileRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get err => $_getSZ(1);
  @$pb.TagNumber(2)
  set err($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErr() => $_has(1);
  @$pb.TagNumber(2)
  void clearErr() => $_clearField(2);

  @$pb.TagNumber(3)
  BaseFile get eviFile => $_getN(2);
  @$pb.TagNumber(3)
  set eviFile(BaseFile value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEviFile() => $_has(2);
  @$pb.TagNumber(3)
  void clearEviFile() => $_clearField(3);
  @$pb.TagNumber(3)
  BaseFile ensureEviFile() => $_ensure(2);
}

class GetEviFilesReq extends $pb.GeneratedMessage {
  factory GetEviFilesReq() => create();

  GetEviFilesReq._();

  factory GetEviFilesReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEviFilesReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEviFilesReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEviFilesReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEviFilesReq copyWith(void Function(GetEviFilesReq) updates) =>
      super.copyWith((message) => updates(message as GetEviFilesReq))
          as GetEviFilesReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEviFilesReq create() => GetEviFilesReq._();
  @$core.override
  GetEviFilesReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEviFilesReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEviFilesReq>(create);
  static GetEviFilesReq? _defaultInstance;
}

class GetEviFilesRes extends $pb.GeneratedMessage {
  factory GetEviFilesRes({
    $core.bool? done,
    $core.String? err,
    $core.Iterable<BaseFile>? eviFile,
  }) {
    final result = create();
    if (done != null) result.done = done;
    if (err != null) result.err = err;
    if (eviFile != null) result.eviFile.addAll(eviFile);
    return result;
  }

  GetEviFilesRes._();

  factory GetEviFilesRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetEviFilesRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetEviFilesRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'done')
    ..aOS(2, _omitFieldNames ? '' : 'err')
    ..pPM<BaseFile>(3, _omitFieldNames ? '' : 'eviFile',
        subBuilder: BaseFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEviFilesRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetEviFilesRes copyWith(void Function(GetEviFilesRes) updates) =>
      super.copyWith((message) => updates(message as GetEviFilesRes))
          as GetEviFilesRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetEviFilesRes create() => GetEviFilesRes._();
  @$core.override
  GetEviFilesRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetEviFilesRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetEviFilesRes>(create);
  static GetEviFilesRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get err => $_getSZ(1);
  @$pb.TagNumber(2)
  set err($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErr() => $_has(1);
  @$pb.TagNumber(2)
  void clearErr() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BaseFile> get eviFile => $_getList(2);
}

class GetPartiFilesReq extends $pb.GeneratedMessage {
  factory GetPartiFilesReq({
    $core.String? eviFileId,
  }) {
    final result = create();
    if (eviFileId != null) result.eviFileId = eviFileId;
    return result;
  }

  GetPartiFilesReq._();

  factory GetPartiFilesReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPartiFilesReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPartiFilesReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eviFileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPartiFilesReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPartiFilesReq copyWith(void Function(GetPartiFilesReq) updates) =>
      super.copyWith((message) => updates(message as GetPartiFilesReq))
          as GetPartiFilesReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPartiFilesReq create() => GetPartiFilesReq._();
  @$core.override
  GetPartiFilesReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPartiFilesReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPartiFilesReq>(create);
  static GetPartiFilesReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eviFileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eviFileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEviFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEviFileId() => $_clearField(1);
}

class GetPartiFilesRes extends $pb.GeneratedMessage {
  factory GetPartiFilesRes({
    $core.bool? done,
    $core.String? err,
    $core.Iterable<BaseFile>? partitionFile,
  }) {
    final result = create();
    if (done != null) result.done = done;
    if (err != null) result.err = err;
    if (partitionFile != null) result.partitionFile.addAll(partitionFile);
    return result;
  }

  GetPartiFilesRes._();

  factory GetPartiFilesRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPartiFilesRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPartiFilesRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'done')
    ..aOS(2, _omitFieldNames ? '' : 'err')
    ..pPM<BaseFile>(3, _omitFieldNames ? '' : 'partitionFile',
        subBuilder: BaseFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPartiFilesRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPartiFilesRes copyWith(void Function(GetPartiFilesRes) updates) =>
      super.copyWith((message) => updates(message as GetPartiFilesRes))
          as GetPartiFilesRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPartiFilesRes create() => GetPartiFilesRes._();
  @$core.override
  GetPartiFilesRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPartiFilesRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPartiFilesRes>(create);
  static GetPartiFilesRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get err => $_getSZ(1);
  @$pb.TagNumber(2)
  set err($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErr() => $_has(1);
  @$pb.TagNumber(2)
  void clearErr() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BaseFile> get partitionFile => $_getList(2);
}

class GetIdxFilesReq extends $pb.GeneratedMessage {
  factory GetIdxFilesReq({
    $core.String? partiFileId,
  }) {
    final result = create();
    if (partiFileId != null) result.partiFileId = partiFileId;
    return result;
  }

  GetIdxFilesReq._();

  factory GetIdxFilesReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIdxFilesReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIdxFilesReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'partiFileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIdxFilesReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIdxFilesReq copyWith(void Function(GetIdxFilesReq) updates) =>
      super.copyWith((message) => updates(message as GetIdxFilesReq))
          as GetIdxFilesReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIdxFilesReq create() => GetIdxFilesReq._();
  @$core.override
  GetIdxFilesReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIdxFilesReq getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIdxFilesReq>(create);
  static GetIdxFilesReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get partiFileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set partiFileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPartiFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPartiFileId() => $_clearField(1);
}

class GetIdxFilesRes extends $pb.GeneratedMessage {
  factory GetIdxFilesRes({
    $core.bool? done,
    $core.String? err,
    $core.Iterable<BaseFile>? indexedFile,
  }) {
    final result = create();
    if (done != null) result.done = done;
    if (err != null) result.err = err;
    if (indexedFile != null) result.indexedFile.addAll(indexedFile);
    return result;
  }

  GetIdxFilesRes._();

  factory GetIdxFilesRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetIdxFilesRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetIdxFilesRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'done')
    ..aOS(2, _omitFieldNames ? '' : 'err')
    ..pPM<BaseFile>(3, _omitFieldNames ? '' : 'indexedFile',
        subBuilder: BaseFile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIdxFilesRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetIdxFilesRes copyWith(void Function(GetIdxFilesRes) updates) =>
      super.copyWith((message) => updates(message as GetIdxFilesRes))
          as GetIdxFilesRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetIdxFilesRes create() => GetIdxFilesRes._();
  @$core.override
  GetIdxFilesRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetIdxFilesRes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetIdxFilesRes>(create);
  static GetIdxFilesRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get err => $_getSZ(1);
  @$pb.TagNumber(2)
  set err($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErr() => $_has(1);
  @$pb.TagNumber(2)
  void clearErr() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<BaseFile> get indexedFile => $_getList(2);
}

class SearchReq extends $pb.GeneratedMessage {
  factory SearchReq({
    $core.String? keyword,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  SearchReq._();

  factory SearchReq.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchReq.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchReq',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReq clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchReq copyWith(void Function(SearchReq) updates) =>
      super.copyWith((message) => updates(message as SearchReq)) as SearchReq;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchReq create() => SearchReq._();
  @$core.override
  SearchReq createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchReq getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchReq>(create);
  static SearchReq? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class SearchRes extends $pb.GeneratedMessage {
  factory SearchRes({
    $core.String? err,
    $fixnum.Int64? totalCount,
    $core.Iterable<$core.MapEntry<$core.String, $fixnum.Int64>>?
        keywordCountMap,
  }) {
    final result = create();
    if (err != null) result.err = err;
    if (totalCount != null) result.totalCount = totalCount;
    if (keywordCountMap != null)
      result.keywordCountMap.addEntries(keywordCountMap);
    return result;
  }

  SearchRes._();

  factory SearchRes.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchRes.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dues'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'err')
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..m<$core.String, $fixnum.Int64>(
        3, _omitFieldNames ? '' : 'keywordCountMap',
        entryClassName: 'SearchRes.KeywordCountMapEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.O6,
        packageName: const $pb.PackageName('dues'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRes clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRes copyWith(void Function(SearchRes) updates) =>
      super.copyWith((message) => updates(message as SearchRes)) as SearchRes;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchRes create() => SearchRes._();
  @$core.override
  SearchRes createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchRes getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchRes>(create);
  static SearchRes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get err => $_getSZ(0);
  @$pb.TagNumber(1)
  set err($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasErr() => $_has(0);
  @$pb.TagNumber(1)
  void clearErr() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $fixnum.Int64> get keywordCountMap => $_getMap(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
