import 'package:logger/logger.dart';
import 'package:spacebar/generated/dues.pbgrpc.dart';

abstract interface class IEviRemoteDataSource {}

class GrpcImpl implements IEviRemoteDataSource {
  final Logger logger;
  late final DuesServiceClient client;
  GrpcImpl(this.client, this.logger);
}
