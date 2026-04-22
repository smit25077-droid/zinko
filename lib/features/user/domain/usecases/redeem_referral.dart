import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/entities/user_entity.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

class RedeemReferral implements UseCase<UserEntity, String> {
  final UserRepository repository;

  RedeemReferral(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String code) async {
    return await repository.redeemReferral(code);
  }
}
