import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class EviStoreCase implements IUseCase<Evidence, EvidenceStoreParams> {
  final IEviRepo repo;
  EviStoreCase(this.repo);

  @override
  Future<Either<Failure, Evidence>> call(EvidenceStoreParams params) async {
    return await repo.storeEvidence(eviPath: params.evipath);
  }
}

class EvidenceStoreParams {
  final String evipath;
  EvidenceStoreParams(this.evipath);
}
