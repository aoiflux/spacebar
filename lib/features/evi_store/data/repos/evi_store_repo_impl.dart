import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_store/data/sources/grpc_store_impl.dart';
import 'package:spacebar/features/evi_store/domain/repos/istorerepo.dart';
import 'package:logger/logger.dart';

class EviStoreRepoImpl implements IEviStoreRepo {
  final Logger logger;
  final IEviStoreRemoteDataSource rds;
  const EviStoreRepoImpl(this.rds, this.logger);

  static const _fileTypeOverride = String.fromEnvironment(
    'DUES_FILE_TYPE',
    defaultValue: '',
  );

  @override
  Future<Either<Failure, Evidence>> storeEvidence({
    required PickedFileData eviData,
    OnProgressChanged? onProgress,
  }) async {
    final sourceName = eviData.path ?? eviData.name;
    final fileType = _fileTypeOverride.trim().isNotEmpty
        ? _fileTypeOverride.trim()
        : FileType.resolveFromFileName(sourceName);

    logger.i('Resolved upload fileType=$fileType for file=$sourceName');

    final appendRes = await rds.appendIfExists(eviData, onProgress: onProgress);
    if (appendRes != null) {
      return right((appendRes));
    }

    try {
      final storeRes = await rds.streamFile(
        fileType,
        eviData,
        onProgress: onProgress,
      );
      return right(storeRes);
    } catch (e, st) {
      logger.e('storeEvidence failed: $e', error: e, stackTrace: st);
      return left(Failure(e.toString()));
    }
  }
}
