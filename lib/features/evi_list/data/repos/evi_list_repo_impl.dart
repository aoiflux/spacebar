import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_list/data/sources/grpc_list_impl.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievlistirepo.dart';

class EviListRepoImpl implements IEviListRepo {
  final Logger logger;
  final IEviListRemoteDataSource rds;
  const EviListRepoImpl(this.rds, this.logger);

  @override
  Future<Either<Failure, List<Evidence>>> getEviFiles() async {
    try {
      final res = await rds.getEviFiles();
      return right(res);
    } catch (e) {
      logger.e('Error in getEviFiles repo: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Evidence>>> getPartiFiles({
    required String eviFileId,
  }) async {
    try {
      final res = await rds.getPartiFiles(eviFileId);
      return right(res);
    } catch (e) {
      logger.e('Error in getPartiFiles repo: $e');
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Evidence>>> getIdxFiles({
    required String partiFileId,
  }) async {
    try {
      final res = await rds.getIdxFiles(partiFileId);
      return right(res);
    } catch (e) {
      logger.e('Error in getIdxFiles repo: $e');
      return left(Failure(e.toString()));
    }
  }
}
