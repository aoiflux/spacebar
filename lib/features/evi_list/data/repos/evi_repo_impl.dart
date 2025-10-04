import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/except.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_impl.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';
import 'package:logger/logger.dart';

class EviRepoImpl implements IEviRepo {
  final Logger logger;
  final IEviRemoteDataSource rds;
  const EviRepoImpl(this.rds, this.logger);

  Future<Either<Failure, Evidence>> _getEvidence(
    Future<Evidence> Function() fn,
  ) async {
    try {
      final evidence = await fn();
      return right(evidence);
    } on ServerException catch (e) {
      logger.log(Level.error, e);
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Evidence>> getEvidenceFiles() {
    // TODO: implement getEvidenceFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> getIndexedFiles({
    required String partiFileId,
  }) {
    // TODO: implement getIndexedFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> getPartitionFiles({
    required String eviFileId,
  }) {
    // TODO: implement getPartitionFiles
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Evidence>> storeEvidence({required String eviPath}) {
    // TODO: implement storeEvidence
    throw UnimplementedError();
  }
}
