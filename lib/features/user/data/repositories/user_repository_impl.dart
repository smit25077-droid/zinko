import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final remoteUser = await remoteDataSource.getUserProfile();
      return Right(remoteUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
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
  }) async {
    try {
      final remoteUser = await remoteDataSource.updateUserProfile(
        name: name,
        email: email,
        phone: phone,
        role: role,
        bio: bio,
        profileImage: profileImage,
        membership: membership,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
      );
      return Right(remoteUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> addMoney(double amount) async {
    try {
      final remoteUser = await remoteDataSource.addMoney(amount);
      return Right(remoteUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> redeemReferral(String code) async {
    try {
      final remoteUser = await remoteDataSource.redeemReferral(code);
      return Right(remoteUser);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
