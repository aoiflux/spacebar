import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_list/domain/entities/upload_progress.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class EviStoreCase {
  final IEviRepo repo;
  EviStoreCase(this.repo);

  Future<Either<Failure, Evidence>> call(
    EvidenceStoreParams params, {
    Function(UploadProgress, UploadStatus)? onProgress,
  }) async {
    return await repo.storeEvidence(
      eviPath: params.evipath,
      onProgress: onProgress,
    );
  }
}

class EvidenceStoreParams {
  final String evipath;
  EvidenceStoreParams(this.evipath);
}
