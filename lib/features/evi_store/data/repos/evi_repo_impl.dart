import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/cnst/cnst.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';
import 'package:spacebar/features/evi_store/data/sources/grpc_impl.dart';
import 'package:spacebar/features/evi_store/domain/repo/ievirepo.dart';
import 'package:logger/logger.dart';

class EviStoreRepoImpl implements IEviStoreRepo {
  final Logger logger;
  final IEviRemoteDataSource rds;
  const EviStoreRepoImpl(this.rds, this.logger);

  @override
  Future<Either<Failure, Evidence>> storeEvidence({
    required String eviPath,
  }) async {
    final appendRes = await rds.appendIfExists(eviPath);
    if (appendRes != null) {
      return right((appendRes));
    }

    try {
      final storeRes = await rds.streamFile(FileType.evi, eviPath);
      return right(storeRes);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
