// This is a generated file - do not edit.
//
// Generated from protos/dues.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'dues.pb.dart' as $0;

export 'dues.pb.dart';

@$pb.GrpcServiceName('dues.DuesService')
class DuesServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  DuesServiceClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.AppendIfExistsRes> appendIfExists(
    $0.AppendIfExistsReq request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$appendIfExists, request, options: options);
  }

  $grpc.ResponseFuture<$0.StreamFileRes> streamFile(
    $async.Stream<$0.StreamFileReq> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$streamFile, request, options: options).single;
  }

  $grpc.ResponseFuture<$0.GetEviFilesRes> getEviFiles(
    $0.GetEviFilesReq request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getEviFiles, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetPartiFilesRes> getPartiFiles(
    $0.GetPartiFilesReq request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPartiFiles, request, options: options);
  }

  $grpc.ResponseFuture<$0.GetIdxFilesRes> getIdxFiles(
    $0.GetIdxFilesReq request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getIdxFiles, request, options: options);
  }

  $grpc.ResponseFuture<$0.SearchRes> search(
    $0.SearchReq request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$search, request, options: options);
  }

  // method descriptors

  static final _$appendIfExists =
      $grpc.ClientMethod<$0.AppendIfExistsReq, $0.AppendIfExistsRes>(
          '/dues.DuesService/AppendIfExists',
          ($0.AppendIfExistsReq value) => value.writeToBuffer(),
          $0.AppendIfExistsRes.fromBuffer);
  static final _$streamFile =
      $grpc.ClientMethod<$0.StreamFileReq, $0.StreamFileRes>(
          '/dues.DuesService/StreamFile',
          ($0.StreamFileReq value) => value.writeToBuffer(),
          $0.StreamFileRes.fromBuffer);
  static final _$getEviFiles =
      $grpc.ClientMethod<$0.GetEviFilesReq, $0.GetEviFilesRes>(
          '/dues.DuesService/GetEviFiles',
          ($0.GetEviFilesReq value) => value.writeToBuffer(),
          $0.GetEviFilesRes.fromBuffer);
  static final _$getPartiFiles =
      $grpc.ClientMethod<$0.GetPartiFilesReq, $0.GetPartiFilesRes>(
          '/dues.DuesService/GetPartiFiles',
          ($0.GetPartiFilesReq value) => value.writeToBuffer(),
          $0.GetPartiFilesRes.fromBuffer);
  static final _$getIdxFiles =
      $grpc.ClientMethod<$0.GetIdxFilesReq, $0.GetIdxFilesRes>(
          '/dues.DuesService/GetIdxFiles',
          ($0.GetIdxFilesReq value) => value.writeToBuffer(),
          $0.GetIdxFilesRes.fromBuffer);
  static final _$search = $grpc.ClientMethod<$0.SearchReq, $0.SearchRes>(
      '/dues.DuesService/Search',
      ($0.SearchReq value) => value.writeToBuffer(),
      $0.SearchRes.fromBuffer);
}

@$pb.GrpcServiceName('dues.DuesService')
abstract class DuesServiceBase extends $grpc.Service {
  $core.String get $name => 'dues.DuesService';

  DuesServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AppendIfExistsReq, $0.AppendIfExistsRes>(
        'AppendIfExists',
        appendIfExists_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AppendIfExistsReq.fromBuffer(value),
        ($0.AppendIfExistsRes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.StreamFileReq, $0.StreamFileRes>(
        'StreamFile',
        streamFile,
        true,
        false,
        ($core.List<$core.int> value) => $0.StreamFileReq.fromBuffer(value),
        ($0.StreamFileRes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetEviFilesReq, $0.GetEviFilesRes>(
        'GetEviFiles',
        getEviFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetEviFilesReq.fromBuffer(value),
        ($0.GetEviFilesRes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPartiFilesReq, $0.GetPartiFilesRes>(
        'GetPartiFiles',
        getPartiFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetPartiFilesReq.fromBuffer(value),
        ($0.GetPartiFilesRes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetIdxFilesReq, $0.GetIdxFilesRes>(
        'GetIdxFiles',
        getIdxFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetIdxFilesReq.fromBuffer(value),
        ($0.GetIdxFilesRes value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SearchReq, $0.SearchRes>(
        'Search',
        search_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SearchReq.fromBuffer(value),
        ($0.SearchRes value) => value.writeToBuffer()));
  }

  $async.Future<$0.AppendIfExistsRes> appendIfExists_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.AppendIfExistsReq> $request) async {
    return appendIfExists($call, await $request);
  }

  $async.Future<$0.AppendIfExistsRes> appendIfExists(
      $grpc.ServiceCall call, $0.AppendIfExistsReq request);

  $async.Future<$0.StreamFileRes> streamFile(
      $grpc.ServiceCall call, $async.Stream<$0.StreamFileReq> request);

  $async.Future<$0.GetEviFilesRes> getEviFiles_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetEviFilesReq> $request) async {
    return getEviFiles($call, await $request);
  }

  $async.Future<$0.GetEviFilesRes> getEviFiles(
      $grpc.ServiceCall call, $0.GetEviFilesReq request);

  $async.Future<$0.GetPartiFilesRes> getPartiFiles_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPartiFilesReq> $request) async {
    return getPartiFiles($call, await $request);
  }

  $async.Future<$0.GetPartiFilesRes> getPartiFiles(
      $grpc.ServiceCall call, $0.GetPartiFilesReq request);

  $async.Future<$0.GetIdxFilesRes> getIdxFiles_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetIdxFilesReq> $request) async {
    return getIdxFiles($call, await $request);
  }

  $async.Future<$0.GetIdxFilesRes> getIdxFiles(
      $grpc.ServiceCall call, $0.GetIdxFilesReq request);

  $async.Future<$0.SearchRes> search_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.SearchReq> $request) async {
    return search($call, await $request);
  }

  $async.Future<$0.SearchRes> search(
      $grpc.ServiceCall call, $0.SearchReq request);
}
