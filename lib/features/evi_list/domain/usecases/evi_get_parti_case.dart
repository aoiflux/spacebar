import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class PartiFilesCase implements IUseCase<List<Evidence>, PartiFilesParams> {
  final IEviRepo repo;
  PartiFilesCase(this.repo);

  @override
  Future<Either<Failure, List<Evidence>>> call(PartiFilesParams params) async {
    return await repo.getPartiFiles(eviFileId: params.eviFileId);
  }
}

class PartiFilesParams {
  final String eviFileId;
  PartiFilesParams(this.eviFileId);
}
