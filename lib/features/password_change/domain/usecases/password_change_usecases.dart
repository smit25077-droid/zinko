import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/password_change/domain/repositories/password_change_repository.dart';

class SendPasswordResetOtp implements UseCase<bool, String> {
  final PasswordChangeRepository repository;
  SendPasswordResetOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.sendOtp(email);
  }
}

class VerifyPasswordResetOtp implements UseCase<int, VerifyOtpParams> {
  final PasswordChangeRepository repository;
  VerifyPasswordResetOtp(this.repository);

  @override
  Future<Either<Failure, int>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(email: params.email, otp: params.otp);
  }
}

class ResetPassword implements UseCase<bool, ResetPasswordParams> {
  final PasswordChangeRepository repository;
  ResetPassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(ResetPasswordParams params) async {
    return await repository.changePassword(userCode: params.userCode, password: params.password);
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;
  VerifyOtpParams({required this.email, required this.otp});
}

class ResetPasswordParams {
  final int userCode;
  final String password;
  ResetPasswordParams({required this.userCode, required this.password});
}
