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
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {
      '1': 'chunk_map',
      '3': 3,
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
    'CghCYXNlRmlsZRIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRoEhcKB2ZpbGVfaWQYAiABKA'
    'lSBmZpbGVJZBI5CgljaHVua19tYXAYAyADKAsyHC5kdWVzLkJhc2VGaWxlLkNodW5rTWFwRW50'
    'cnlSCGNodW5rTWFwGjsKDUNodW5rTWFwRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdW'
    'UYAiABKANSBXZhbHVlOgI4AQ==');

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
    {
      '1': 'evi_file',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.dues.BaseFile',
      '10': 'eviFile'
    },
    {'1': 'err', '3': 4, '4': 1, '5': 9, '10': 'err'},
  ],
};

/// Descriptor for `AppendIfExistsRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List appendIfExistsResDescriptor = $convert.base64Decode(
    'ChFBcHBlbmRJZkV4aXN0c1JlcxIWCgZleGlzdHMYASABKAhSBmV4aXN0cxIaCghhcHBlbmRlZB'
    'gCIAEoCFIIYXBwZW5kZWQSKQoIZXZpX2ZpbGUYAyABKAsyDi5kdWVzLkJhc2VGaWxlUgdldmlG'
    'aWxlEhAKA2VychgEIAEoCVIDZXJy');

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

@$core.Deprecated('Use getPartiFilesReqDescriptor instead')
const GetPartiFilesReq$json = {
  '1': 'GetPartiFilesReq',
  '2': [
    {'1': 'evi_file_id', '3': 1, '4': 1, '5': 9, '10': 'eviFileId'},
  ],
};

/// Descriptor for `GetPartiFilesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPartiFilesReqDescriptor = $convert.base64Decode(
    'ChBHZXRQYXJ0aUZpbGVzUmVxEh4KC2V2aV9maWxlX2lkGAEgASgJUglldmlGaWxlSWQ=');

@$core.Deprecated('Use getPartiFilesResDescriptor instead')
const GetPartiFilesRes$json = {
  '1': 'GetPartiFilesRes',
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

/// Descriptor for `GetPartiFilesRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPartiFilesResDescriptor = $convert.base64Decode(
    'ChBHZXRQYXJ0aUZpbGVzUmVzEhIKBGRvbmUYASABKAhSBGRvbmUSEAoDZXJyGAIgASgJUgNlcn'
    'ISNQoOcGFydGl0aW9uX2ZpbGUYAyADKAsyDi5kdWVzLkJhc2VGaWxlUg1wYXJ0aXRpb25GaWxl');

@$core.Deprecated('Use getIdxFilesReqDescriptor instead')
const GetIdxFilesReq$json = {
  '1': 'GetIdxFilesReq',
  '2': [
    {'1': 'parti_file_id', '3': 1, '4': 1, '5': 9, '10': 'partiFileId'},
  ],
};

/// Descriptor for `GetIdxFilesReq`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIdxFilesReqDescriptor = $convert.base64Decode(
    'Cg5HZXRJZHhGaWxlc1JlcRIiCg1wYXJ0aV9maWxlX2lkGAEgASgJUgtwYXJ0aUZpbGVJZA==');

@$core.Deprecated('Use getIdxFilesResDescriptor instead')
const GetIdxFilesRes$json = {
  '1': 'GetIdxFilesRes',
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

/// Descriptor for `GetIdxFilesRes`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getIdxFilesResDescriptor = $convert.base64Decode(
    'Cg5HZXRJZHhGaWxlc1JlcxISCgRkb25lGAEgASgIUgRkb25lEhAKA2VychgCIAEoCVIDZXJyEj'
    'EKDGluZGV4ZWRfZmlsZRgDIAMoCzIOLmR1ZXMuQmFzZUZpbGVSC2luZGV4ZWRGaWxl');

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
