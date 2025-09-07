import 'package:fpdart/fpdart.dart';
import 'package:spacebar/core/error/failure.dart';

abstract interface class IUseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
