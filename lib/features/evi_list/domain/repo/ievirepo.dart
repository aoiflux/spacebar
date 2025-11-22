import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';

abstract class IEviRepo {
  Future<Either<Failure, List<Evidence>>> getEviFiles();
  Future<Either<Failure, List<Evidence>>> getPartiFiles({
    required String eviFileId,
  });
  Future<Either<Failure, List<Evidence>>> getIdxFiles({
    required String partiFileId,
  });
  Future<Either<Failure, Evidence>> storeEvidence({required String eviPath});
}
