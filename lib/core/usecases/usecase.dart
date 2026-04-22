import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';

abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

class NoParams {}
