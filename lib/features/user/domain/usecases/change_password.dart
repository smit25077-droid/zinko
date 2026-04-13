import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class ChangePassword implements UseCase<bool, ChangePasswordParams> {
  final UserRepository repository;

  ChangePassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(ChangePasswordParams params) async {
    return await repository.changePassword(
      userCode: params.userCode,
      password: params.password,
    );
  }
}

class ChangePasswordParams {
  final int userCode;
  final String password;

  ChangePasswordParams({required this.userCode, required this.password});
}
