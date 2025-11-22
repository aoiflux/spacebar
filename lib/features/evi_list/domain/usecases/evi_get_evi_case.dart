import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/core/iusecase/iusecase.dart';
import 'package:spacebar/features/evi_list/domain/repo/ievirepo.dart';

class EviFilesCase implements IUseCase<List<Evidence>, EviFilesParams> {
  final IEviRepo repo;
  EviFilesCase(this.repo);

  @override
  Future<Either<Failure, List<Evidence>>> call(EviFilesParams params) async {
    return await repo.getEviFiles();
  }
}

class EviFilesParams {}
