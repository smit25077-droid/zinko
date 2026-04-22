import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';
import 'package:zinko_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthResponse<UserData>, LoginRequest> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponse<UserData>>> call(
      LoginRequest params) async {
    return await repository.login(params);
  }
}
