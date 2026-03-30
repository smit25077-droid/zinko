import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required String name,
    required String email,
    required String phone,
    required String role,
    required String bio,
    String? profileImage,
    String? membership,
    bool? isEmailVerified,
    bool? isPhoneVerified,
  });
  Future<Either<Failure, UserEntity>> addMoney(double amount);
  Future<Either<Failure, UserEntity>> redeemReferral(String code);
}
