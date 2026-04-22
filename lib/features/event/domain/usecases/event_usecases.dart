import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/event/domain/entities/event_entity.dart';
import 'package:zinko_app/features/event/domain/repositories/event_repository.dart';

class GetEvents implements UseCase<List<EventEntity>, NoParams> {
  final EventRepository repository;
  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<EventEntity>>> call(NoParams params) async {
    return await repository.getEvents();
  }
}

class ToggleFavoriteEvent implements UseCase<EventEntity, String> {
  final EventRepository repository;
  ToggleFavoriteEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(String id) async {
    return await repository.toggleFavoriteEvent(id);
  }
}

class RegisterEvent implements UseCase<EventEntity, String> {
  final EventRepository repository;
  RegisterEvent(this.repository);

  @override
  Future<Either<Failure, EventEntity>> call(String id) async {
    return await repository.registerEvent(id);
  }
}
