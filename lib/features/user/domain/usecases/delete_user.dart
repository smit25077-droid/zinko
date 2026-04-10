import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class DeleteUser implements UseCase<bool, int> {
  final UserRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Either<Failure, bool>> call(int userCode) async {
    return await repository.deleteUser(userCode);
  }
}
