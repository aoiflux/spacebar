import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/common/models/picked_file_data.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_store/domain/repo/ievirepo.dart';

class EviStoreCase implements IUseCase<Evidence, EvidenceStoreParams> {
  final IEviStoreRepo repo;
  EviStoreCase(this.repo);

  @override
  Future<Either<Failure, Evidence>> call(EvidenceStoreParams params) async {
    return await repo.storeEvidence(
      eviData: params.eviData,
      onProgress: params.onProgress,
    );
  }
}

class EvidenceStoreParams {
  final PickedFileData eviData;
  final OnProgressChanged? onProgress;
  EvidenceStoreParams(this.eviData, {this.onProgress});
}
