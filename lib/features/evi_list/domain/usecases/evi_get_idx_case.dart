import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class IdxFilesCase implements IUseCase<List<Evidence>, IdxFilesParams> {
  final IEviRepo repo;
  IdxFilesCase(this.repo);

  @override
  Future<Either<Failure, List<Evidence>>> call(IdxFilesParams params) async {
    return await repo.getIdxFiles(partiFileId: params.partiFileId);
  }
}

class IdxFilesParams {
  final String partiFileId;
  IdxFilesParams(this.partiFileId);
}
