import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<Either<Failure, List<EventEntity>>> getEvents();
  Future<Either<Failure, EventEntity>> toggleFavoriteEvent(String id);
  Future<Either<Failure, EventEntity>> registerEvent(String id);
}
