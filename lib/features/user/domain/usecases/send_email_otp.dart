import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

class SendEmailOtp implements UseCase<bool, String> {
  final UserRepository repository;

  SendEmailOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.sendEmailOtp(email);
  }
}
