import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class PasswordChangeRepository {
  Future<Either<Failure, bool>> sendOtp(String email);
  Future<Either<Failure, int>> verifyOtp({required String email, required String otp});
  Future<Either<Failure, bool>> changePassword({required int userCode, required String password});
}
