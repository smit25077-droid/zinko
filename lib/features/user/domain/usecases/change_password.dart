import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

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
