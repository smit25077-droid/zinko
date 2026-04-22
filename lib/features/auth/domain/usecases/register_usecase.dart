import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/auth/data/models/auth_requests.dart';
import 'package:zinko_app/features/auth/data/models/auth_responses.dart';
import 'package:zinko_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase
    implements UseCase<AuthResponse<dynamic>, RegisterRequest> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponse<dynamic>>> call(
      RegisterRequest params) async {
    return await repository.register(params);
  }
}
