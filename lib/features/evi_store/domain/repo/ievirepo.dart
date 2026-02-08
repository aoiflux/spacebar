import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/core/error/failure.dart';

typedef OnProgressChanged = Function(ProgressUpdate progress);

abstract class IEviStoreRepo {
  // Future<Either<Failure, List<Evidence>>> getEviFiles();
  // Future<Either<Failure, List<Evidence>>> getPartiFiles({
  //   required String eviFileId,
  // });
  // Future<Either<Failure, List<Evidence>>> getIdxFiles({
  //   required String partiFileId,
  // });
  Future<Either<Failure, Evidence>> storeEvidence({
    required String eviPath,
    OnProgressChanged? onProgress,
  });
}
