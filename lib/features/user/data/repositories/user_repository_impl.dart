import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/user/domain/entities/user_entity.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';
import 'package:zinko_app/features/user/data/datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() async {
    try {
      final remoteUser = await remoteDataSource.getUserProfile();
      return Right(remoteUser);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
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
  }) async {
    try {
      final remoteUser = await remoteDataSource.updateUserProfile(
        name: name,
        email: email,
        phone: phone,
        role: role,
        bio: bio,
        userCode: userCode,
        profileImage: profileImage,
        membership: membership,
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        city: city,
        state: state,
        gender: gender,
        birthdate: birthdate,
        companyName: companyName,
      );
      return Right(remoteUser);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> addMoney(double amount) async {
    try {
      final remoteUser = await remoteDataSource.addMoney(amount);
      return Right(remoteUser);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> redeemReferral(String code) async {
    try {
      final remoteUser = await remoteDataSource.redeemReferral(code);
      return Right(remoteUser);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateVisibility(bool visibility) async {
    try {
      final result = await remoteDataSource.updateVisibility(visibility);
      return Right(result);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> sendEmailOtp(String email) async {
    try {
      final result = await remoteDataSource.sendEmailOtp(email);
      return Right(result);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyEmailOtp({
    required String userCode,
    required String otp,
  }) async {
    try {
      final result = await remoteDataSource.verifyEmailOtp(
        userCode: userCode,
        otp: otp,
      );
      return Right(result);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(int userCode) async {
    try {
      final result = await remoteDataSource.deleteUser(userCode);
      return Right(result);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> changePassword(
      {required int userCode, required String password}) async {
    try {
      final result = await remoteDataSource.changePassword(
        userCode: userCode,
        password: password,
      );
      return Right(result);
    } on DioException catch (e) {
      String message = 'Server error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? e.message ?? message;
      } else {
        message = e.message ?? message;
      }
      return Left(ServerFailure(message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
