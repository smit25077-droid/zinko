import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse<UserData>>> login(LoginRequest params);
  Future<Either<Failure, AuthResponse<dynamic>>> register(
      RegisterRequest params);
  Future<Either<Failure, UserData?>> getCachedUser();
  Future<Either<Failure, void>> logout();
}
