import 'package:grpc/grpc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/features/evi_list/data/repos/evi_repo_impl.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_impl.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_get_evi_case.dart';
import 'package:spacebar/features/evi_list/domain/usecases/evi_store_case.dart';
import 'package:spacebar/features/evi_list/presentation/bloc/evi_bloc/evi_bloc.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDeps() async {
  _initEviClient();

  final logger = Logger();
  serviceLocator.registerLazySingleton(() => logger);

  final channel = ClientChannel(
    GrpCnst.host,
    port: GrpCnst.port,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );
  final client = DuesServiceClient(channel);
  serviceLocator.registerLazySingleton(() => client);
}

void _initEviClient() {
  serviceLocator
    ..registerFactory<IEviRemoteDataSource>(
      () => GrpcImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory<IEviRepo>(
      () => EviRepoImpl(serviceLocator(), serviceLocator()),
    )
    ..registerFactory(() => EviFilesCase(serviceLocator()))
    ..registerFactory(() => EviStoreCase(serviceLocator()))
    ..registerLazySingleton(() => EviBloc(serviceLocator(), serviceLocator()));
}
