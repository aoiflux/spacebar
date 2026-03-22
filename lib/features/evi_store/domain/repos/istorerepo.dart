import 'package:fpdart/fpdart.dart';

import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/common/models/progress_state.dart';
import 'package:spacebar/core/error/failure.dart';

typedef OnProgressChanged = Function(ProgressUpdate progress);

abstract class IEviStoreRepo {
  Future<Either<Failure, Evidence>> storeEvidence({
    required PickedFileData eviData,
    OnProgressChanged? onProgress,
  });
}
