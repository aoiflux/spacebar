// This is a generated file - do not edit.
//
// Generated from protos/dues.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use baseFileDescriptor instead')
const BaseFile$json = {
  '1': 'BaseFile',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
    {
      '1': 'chunk_map',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.dues.BaseFile.ChunkMapEntry',
      '10': 'chunkMap'
    },
  ],
  '3': [BaseFile_ChunkMapEntry$json],
};

@$core.Deprecated('Use baseFileDescriptor instead')
const BaseFile_ChunkMapEntry$json = {
  '1': 'ChunkMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `BaseFile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List baseFileDescriptor = $convert.base64Decode(
    'CghCYXNlRmlsZRIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRoEjkKCWNodW5rX21hcBgCIA'
    'MoCzIcLmR1ZXMuQmFzZUZpbGUuQ2h1bmtNYXBFbnRyeVIIY2h1bmtNYXAaOwoNQ2h1bmtNYXBF'
    'bnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoA1IFdmFsdWU6AjgB');

@$core.Deprecated('Use appendIfExistsReqDescriptor instead')
const AppendIfExistsReq$json = {
  '1': 'AppendIfExistsReq',
  '2': [
    {'1': 'file_hash', '3': 1, '4': 1, '5': 9, '10': 'fileHash'},
    {'1': 'file_path', '3': 2, '4': 1, '5': 9, '10': 'filePath'},
  ],
};

/// Descriptor for `AppendIfExistsReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appendIfExistsReqDescriptor = $convert.base64Decode(
    'ChFBcHBlbmRJZkV4aXN0c1JlcRIbCglmaWxlX2hhc2gYASABKAlSCGZpbGVIYXNoEhsKCWZpbG'
    'VfcGF0aBgCIAEoCVIIZmlsZVBhdGg=');

@$core.Deprecated('Use appendIfExistsResDescriptor instead')
const AppendIfExistsRes$json = {
  '1': 'AppendIfExistsRes',
  '2': [
    {'1': 'exists', '3': 1, '4': 1, '5': 8, '10': 'exists'},
    {'1': 'appended', '3': 2, '4': 1, '5': 8, '10': 'appended'},
    {'1': 'err', '3': 3, '4': 1, '5': 9, '10': 'err'},
  ],
};

/// Descriptor for `AppendIfExistsRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appendIfExistsResDescriptor = $convert.base64Decode(
    'ChFBcHBlbmRJZkV4aXN0c1JlcxIWCgZleGlzdHMYASABKAhSBmV4aXN0cxIaCghhcHBlbmRlZB'
    'gCIAEoCFIIYXBwZW5kZWQSEAoDZXJyGAMgASgJUgNlcnI=');

@$core.Deprecated('Use streamFileMetaDescriptor instead')
const StreamFileMeta$json = {
  '1': 'StreamFileMeta',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'file_size', '3': 2, '4': 1, '5': 3, '10': 'fileSize'},
    {'1': 'file_type', '3': 3, '4': 1, '5': 9, '10': 'fileType'},
    {'1': 'file_hash', '3': 4, '4': 1, '5': 9, '10': 'fileHash'},
  ],
};

/// Descriptor for `StreamFileMeta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamFileMetaDescriptor = $convert.base64Decode(
    'Cg5TdHJlYW1GaWxlTWV0YRIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRoEhsKCWZpbGVfc2'
    'l6ZRgCIAEoA1IIZmlsZVNpemUSGwoJZmlsZV90eXBlGAMgASgJUghmaWxlVHlwZRIbCglmaWxl'
    'X2hhc2gYBCABKAlSCGZpbGVIYXNo');

@$core.Deprecated('Use streamFileReqDescriptor instead')
const StreamFileReq$json = {
  '1': 'StreamFileReq',
  '2': [
    {'1': 'file', '3': 1, '4': 1, '5': 12, '9': 0, '10': 'file'},
    {
      '1': 'file_meta',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.dues.StreamFileMeta',
      '9': 0,
      '10': 'fileMeta'
    },
  ],
  '8': [
    {'1': 'payload'},
  ],
};

/// Descriptor for `StreamFileReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamFileReqDescriptor = $convert.base64Decode(
    'Cg1TdHJlYW1GaWxlUmVxEhQKBGZpbGUYASABKAxIAFIEZmlsZRIzCglmaWxlX21ldGEYAiABKA'
    'syFC5kdWVzLlN0cmVhbUZpbGVNZXRhSABSCGZpbGVNZXRhQgkKB3BheWxvYWQ=');

@$core.Deprecated('Use streamFileResDescriptor instead')
const StreamFileRes$json = {
  '1': 'StreamFileRes',
  '2': [
    {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    {'1': 'err', '3': 2, '4': 1, '5': 9, '10': 'err'},
    {
      '1': 'evi_file',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.dues.BaseFile',
      '10': 'eviFile'
    },
  ],
};

/// Descriptor for `StreamFileRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamFileResDescriptor = $convert.base64Decode(
    'Cg1TdHJlYW1GaWxlUmVzEhIKBGRvbmUYASABKAhSBGRvbmUSEAoDZXJyGAIgASgJUgNlcnISKQ'
    'oIZXZpX2ZpbGUYAyABKAsyDi5kdWVzLkJhc2VGaWxlUgdldmlGaWxl');

@$core.Deprecated('Use getEviFilesReqDescriptor instead')
const GetEviFilesReq$json = {
  '1': 'GetEviFilesReq',
};

/// Descriptor for `GetEviFilesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEviFilesReqDescriptor =
    $convert.base64Decode('Cg5HZXRFdmlGaWxlc1JlcQ==');

@$core.Deprecated('Use getEviFilesResDescriptor instead')
const GetEviFilesRes$json = {
  '1': 'GetEviFilesRes',
  '2': [
    {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    {'1': 'err', '3': 2, '4': 1, '5': 9, '10': 'err'},
    {
      '1': 'evi_file',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.dues.BaseFile',
      '10': 'eviFile'
    },
  ],
};

/// Descriptor for `GetEviFilesRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getEviFilesResDescriptor = $convert.base64Decode(
    'Cg5HZXRFdmlGaWxlc1JlcxISCgRkb25lGAEgASgIUgRkb25lEhAKA2VychgCIAEoCVIDZXJyEi'
    'kKCGV2aV9maWxlGAMgAygLMg4uZHVlcy5CYXNlRmlsZVIHZXZpRmlsZQ==');

@$core.Deprecated('Use getPartitionFilesReqDescriptor instead')
const GetPartitionFilesReq$json = {
  '1': 'GetPartitionFilesReq',
  '2': [
    {'1': 'evi_file_id', '3': 1, '4': 1, '5': 9, '10': 'eviFileId'},
  ],
};

/// Descriptor for `GetPartitionFilesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPartitionFilesReqDescriptor = $convert.base64Decode(
    'ChRHZXRQYXJ0aXRpb25GaWxlc1JlcRIeCgtldmlfZmlsZV9pZBgBIAEoCVIJZXZpRmlsZUlk');

@$core.Deprecated('Use getPartitionFilesResDescriptor instead')
const GetPartitionFilesRes$json = {
  '1': 'GetPartitionFilesRes',
  '2': [
    {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    {'1': 'err', '3': 2, '4': 1, '5': 9, '10': 'err'},
    {
      '1': 'partition_file',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.dues.BaseFile',
      '10': 'partitionFile'
    },
  ],
};

/// Descriptor for `GetPartitionFilesRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPartitionFilesResDescriptor = $convert.base64Decode(
    'ChRHZXRQYXJ0aXRpb25GaWxlc1JlcxISCgRkb25lGAEgASgIUgRkb25lEhAKA2VychgCIAEoCV'
    'IDZXJyEjUKDnBhcnRpdGlvbl9maWxlGAMgAygLMg4uZHVlcy5CYXNlRmlsZVINcGFydGl0aW9u'
    'RmlsZQ==');

@$core.Deprecated('Use getIndexedFilesReqDescriptor instead')
const GetIndexedFilesReq$json = {
  '1': 'GetIndexedFilesReq',
  '2': [
    {'1': 'parti_file_id', '3': 1, '4': 1, '5': 9, '10': 'partiFileId'},
  ],
};

/// Descriptor for `GetIndexedFilesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIndexedFilesReqDescriptor = $convert.base64Decode(
    'ChJHZXRJbmRleGVkRmlsZXNSZXESIgoNcGFydGlfZmlsZV9pZBgBIAEoCVILcGFydGlGaWxlSW'
    'Q=');

@$core.Deprecated('Use getIndexedFilesResDescriptor instead')
const GetIndexedFilesRes$json = {
  '1': 'GetIndexedFilesRes',
  '2': [
    {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    {'1': 'err', '3': 2, '4': 1, '5': 9, '10': 'err'},
    {
      '1': 'indexed_file',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.dues.BaseFile',
      '10': 'indexedFile'
    },
  ],
};

/// Descriptor for `GetIndexedFilesRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIndexedFilesResDescriptor = $convert.base64Decode(
    'ChJHZXRJbmRleGVkRmlsZXNSZXMSEgoEZG9uZRgBIAEoCFIEZG9uZRIQCgNlcnIYAiABKAlSA2'
    'VychIxCgxpbmRleGVkX2ZpbGUYAyADKAsyDi5kdWVzLkJhc2VGaWxlUgtpbmRleGVkRmlsZQ==');

@$core.Deprecated('Use searchReqDescriptor instead')
const SearchReq$json = {
  '1': 'SearchReq',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `SearchReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchReqDescriptor = $convert
    .base64Decode('CglTZWFyY2hSZXESGAoHa2V5d29yZBgBIAEoCVIHa2V5d29yZA==');

@$core.Deprecated('Use searchResDescriptor instead')
const SearchRes$json = {
  '1': 'SearchRes',
  '2': [
    {'1': 'err', '3': 1, '4': 1, '5': 9, '10': 'err'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
    {
      '1': 'keyword_count_map',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.dues.SearchRes.KeywordCountMapEntry',
      '10': 'keywordCountMap'
    },
  ],
  '3': [SearchRes_KeywordCountMapEntry$json],
};

@$core.Deprecated('Use searchResDescriptor instead')
const SearchRes_KeywordCountMapEntry$json = {
  '1': 'KeywordCountMapEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 3, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `SearchRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResDescriptor = $convert.base64Decode(
    'CglTZWFyY2hSZXMSEAoDZXJyGAEgASgJUgNlcnISHwoLdG90YWxfY291bnQYAiABKANSCnRvdG'
    'FsQ291bnQSUAoRa2V5d29yZF9jb3VudF9tYXAYAyADKAsyJC5kdWVzLlNlYXJjaFJlcy5LZXl3'
    'b3JkQ291bnRNYXBFbnRyeVIPa2V5d29yZENvdW50TWFwGkIKFEtleXdvcmRDb3VudE1hcEVudH'
    'J5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgDUgV2YWx1ZToCOAE=');
