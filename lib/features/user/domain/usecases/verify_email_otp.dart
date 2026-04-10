import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class VerifyEmailOtp implements UseCase<bool, VerifyEmailOtpParams> {
  final UserRepository repository;

  VerifyEmailOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(VerifyEmailOtpParams params) async {
    return await repository.verifyEmailOtp(
      userCode: params.userCode,
      otp: params.otp,
    );
  }
}

class VerifyEmailOtpParams {
  final String userCode;
  final String otp;

  VerifyEmailOtpParams({required this.userCode, required this.otp});
}
