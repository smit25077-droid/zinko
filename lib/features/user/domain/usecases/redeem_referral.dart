import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class RedeemReferral implements UseCase<UserEntity, String> {
  final UserRepository repository;

  RedeemReferral(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String code) async {
    return await repository.redeemReferral(code);
  }
}
