import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';

class CompleteBooking implements UseCase<BookingEntity, String> {
  final BookingRepository repository;

  CompleteBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(String id) async {
    return await repository.completeBooking(id);
  }
}
