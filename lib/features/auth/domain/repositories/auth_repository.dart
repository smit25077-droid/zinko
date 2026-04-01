import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/auth_requests.dart';
import '../../data/models/auth_responses.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse<UserData>>> login(LoginRequest params);
  Future<Either<Failure, AuthResponse<dynamic>>> register(RegisterRequest params);
  Future<Either<Failure, UserData?>> getCachedUser();
  Future<Either<Failure, void>> logout();
}
