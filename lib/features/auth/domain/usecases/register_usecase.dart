import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/models/auth_requests.dart';
import '../../data/models/auth_responses.dart';
import '../repositories/auth_repository.dart';

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
