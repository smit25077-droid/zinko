import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_data_source.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EventEntity>>> getEvents() async {
    try {
      final remoteEvents = await remoteDataSource.getEvents();
      return Right(remoteEvents.cast<EventEntity>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> toggleFavoriteEvent(String id) async {
    try {
      final updatedEvent = await remoteDataSource.toggleFavoriteEvent(id);
      return Right(updatedEvent);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EventEntity>> registerEvent(String id) async {
    try {
      final updatedEvent = await remoteDataSource.registerEvent(id);
      return Right(updatedEvent);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
