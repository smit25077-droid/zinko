import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

class DeleteUser implements UseCase<bool, int> {
  final UserRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(int userCode) async {
    return await repository.deleteUser(userCode);
  }
}
