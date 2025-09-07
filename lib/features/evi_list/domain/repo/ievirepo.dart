import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/common/entities/evidence.dart';
import 'package:spacebar/core/error/failure.dart';

abstract class IEviRepo {
  Future<Either<Failure, Evidence>> listEvidence();
  Future<Either<Failure, Evidence>> storeEvidence({required String eviPath});
}
