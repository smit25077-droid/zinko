import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class SendEmailOtp implements UseCase<bool, String> {
  final UserRepository repository;

  SendEmailOtp(this.repository);

  @override
  Future<Either<Failure, bool>> call(String email) async {
    return await repository.sendEmailOtp(email);
  }
}
