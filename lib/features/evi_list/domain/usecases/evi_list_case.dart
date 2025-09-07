import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class EviListCase implements IUseCase<Evidence, EvidenceListParams> {
  final IEviRepo repo;
  EviListCase(this.repo);

  @override
  Future<Either<Failure, Evidence>> call(EvidenceListParams params) async {
    return await repo.listEvidence();
  }
}

class EvidenceListParams {}
