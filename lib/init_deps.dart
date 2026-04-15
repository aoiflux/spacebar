import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/core/utils/grpc_channel_stub.dart'
    if (dart.library.html) 'package:spacebar/core/utils/grpc_channel_web.dart'
    if (dart.library.io) 'package:spacebar/core/utils/grpc_channel_io.dart';
import 'package:spacebar/features/evi_list/data/repos/evi_list_repo_impl.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_list_impl.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievlistirepo.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_evi_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_idx_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_parti_case.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_list_bloc.dart';
import 'package:spacebar/features/evi_store/data/repos/evi_store_repo_impl.dart';
import 'package:spacebar/features/evi_store/data/sources/grpc_store_impl.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:spacebar/features/evi_store/domain/usecases/evi_store_case.dart';
import 'package:spacebar/features/evi_store/presentation/bloc/evi_store_bloc/evi_store_bloc.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

final serviceLocator = GetIt.instance;
Future<void> initDeps() async {
  final logger = Logger();

  final defaultHost = GrpCnst.host;
  final defaultPort = GrpCnst.port;

  final host = const String.fromEnvironment(
    'GRPC_HOST',
    defaultValue: '',
  ).trim();
  const port = int.fromEnvironment('GRPC_PORT', defaultValue: -1);
  final webUrl = const String.fromEnvironment(
    'GRPC_WEB_URL',
    defaultValue: '',
  ).trim();

  final resolvedHost = host.isNotEmpty
      ? host
      : (kIsWeb && defaultHost == 'localhost' && Uri.base.host.isNotEmpty
            ? Uri.base.host
            : defaultHost);
  final resolvedPort = port > 0 ? port : defaultPort;

  if (kIsWeb && webUrl.isNotEmpty) {
    logger.i('Using gRPC web endpoint: $webUrl');
  } else {
    logger.i('Using gRPC endpoint: $resolvedHost:$resolvedPort');
  }

  final channel = createGrpcChannel(
    resolvedHost,
    resolvedPort,
    webUrl: webUrl,
  );
  final client = DuesServiceClient(channel);

  serviceLocator
    ..registerLazySingleton(() => logger)
    ..registerLazySingleton(() => client);

  _initEviClient();
}

void _initEviClient() {
  serviceLocator
    ..registerFactory<IEviStoreRemoteDataSource>(
      () => GrpcStoreImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<IEviStoreRepo>(
      () => EviStoreRepoImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<IEviListRemoteDataSource>(
      () => GrpcListImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<IEviListRepo>(
      () => EviListRepoImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => EviStoreCase(serviceLocator()))
    ..registerFactory(() => EviFilesCase(serviceLocator()))
    ..registerFactory(() => PartiFilesCase(serviceLocator()))
    ..registerFactory(() => IdxFilesCase(serviceLocator()))
    ..registerLazySingleton(
      () => EviListBloc(serviceLocator(), serviceLocator(), serviceLocator()),
    )
    ..registerLazySingleton(() => EviBloc(serviceLocator()));
}
