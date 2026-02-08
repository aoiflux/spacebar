import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/core/utils/grpc_channel_stub.dart'
    if (dart.library.html) 'package:spacebar/core/utils/grpc_channel_web.dart'
    if (dart.library.io) 'package:spacebar/core/utils/grpc_channel_io.dart';
import 'package:spacebar/features/evi_store/data/repos/evi_repo_impl.dart';
import 'package:spacebar/features/evi_store/data/sources/grpc_impl.dart';
import 'package:spacebar/features/evi_store/domain/repo/ievirepo.dart';
import 'package:spacebar/features/evi_store/domain/usecases/evi_store_case.dart';
import 'package:spacebar/features/evi_store/presentation/bloc/evi_store_bloc/evi_store_bloc.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

final serviceLocator = GetIt.instance;
Future<void> initDeps() async {
  final channel = createGrpcChannel(GrpCnst.host, GrpCnst.port);
  final client = DuesServiceClient(channel);
  final logger = Logger();

  serviceLocator
    ..registerLazySingleton(() => client)
    ..registerLazySingleton(() => logger);

  _initEviClient();
}

void _initEviClient() {
  serviceLocator
    ..registerFactory<IEviRemoteDataSource>(
      () => GrpcImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<IEviStoreRepo>(
      () => EviStoreRepoImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => EviStoreCase(serviceLocator()))
    ..registerLazySingleton(() => EviBloc(serviceLocator()));
}
