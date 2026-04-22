import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

class UpdateVisibility extends UseCase<bool, bool> {
  final UserRepository repository;

  UpdateVisibility(this.repository);

  @override
  Future<Either<Failure, bool>> call(bool visibility) async {
    return await repository.updateVisibility(visibility);
  }
}
