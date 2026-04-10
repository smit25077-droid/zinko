import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/auth_requests.dart';
import '../../data/models/auth_responses.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthResponse<UserData>, LoginRequest> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponse<UserData>>> call(
      LoginRequest params) async {
    return await repository.login(params);
  }
}
