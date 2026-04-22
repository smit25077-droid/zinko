import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/user/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    required int userCode,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    String? city,
    String? state,
    String? gender,
    String? birthdate,
    String? companyName,
  });
  Future<Either<Failure, UserEntity>> addMoney(double amount);
  Future<Either<Failure, UserEntity>> redeemReferral(String code);
  Future<Either<Failure, bool>> updateVisibility(bool visibility);
  Future<Either<Failure, bool>> sendEmailOtp(String email);
  Future<Either<Failure, bool>> verifyEmailOtp(
      {required String userCode, required String otp});
  Future<Either<Failure, bool>> deleteUser(int userCode);
  Future<Either<Failure, bool>> changePassword(
      {required int userCode, required String password});
}
