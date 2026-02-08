import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_store/domain/repo/ievirepo.dart';

class EviStoreCase implements IUseCase<Evidence, EvidenceStoreParams> {
  final IEviStoreRepo repo;
  EviStoreCase(this.repo);

  @override
  Future<Either<Failure, Evidence>> call(EvidenceStoreParams params) async {
    return await repo.storeEvidence(
      eviPath: params.evipath,
      onProgress: params.onProgress,
    );
  }
}

class EvidenceStoreParams {
  final String evipath;
  final OnProgressChanged? onProgress;
  EvidenceStoreParams(this.evipath, {this.onProgress});
}
