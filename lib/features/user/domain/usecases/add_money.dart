import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/entities/user_entity.dart';
import 'package:zinko_app/features/user/domain/repositories/user_repository.dart';

class AddMoney implements UseCase<UserEntity, double> {
  final UserRepository repository;

  AddMoney(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(double amount) async {
    return await repository.addMoney(amount);
  }
}
