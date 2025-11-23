import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_list/domain/entities/upload_progress.dart';

abstract class IEviRepo {
  Future<Either<Failure, Evidence>> getEvidenceFiles();
  Future<Either<Failure, Evidence>> getPartitionFiles({
    required String eviFileId,
  });
  Future<Either<Failure, Evidence>> getIndexedFiles({
    required String partiFileId,
  });
  Future<Either<Failure, Evidence>> storeEvidence({
    required String eviPath,
    Function(UploadProgress, UploadStatus)? onProgress,
  });
}
