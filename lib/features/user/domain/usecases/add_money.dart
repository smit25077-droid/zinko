import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

class AddMoney implements UseCase<UserEntity, double> {
  final UserRepository repository;

  AddMoney(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(double amount) async {
    return await repository.addMoney(amount);
  }
}
