import 'package:fpdart/fpdart.dart';

import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/core/error/failure.dart';

typedef OnProgressChanged = Function(ProgressUpdate progress);

abstract class IEviListRepo {
  Future<Either<Failure, List<Evidence>>> getEviFiles();
  Future<Either<Failure, List<Evidence>>> getPartiFiles({
    required String eviFileId,
  });
  Future<Either<Failure, List<Evidence>>> getIdxFiles({
    required String partiFileId,
  });
}
