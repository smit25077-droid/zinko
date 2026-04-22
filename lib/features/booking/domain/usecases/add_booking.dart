import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';

class AddBooking implements UseCase<BookingEntity, BookingEntity> {
  final BookingRepository repository;

  AddBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity booking) async {
    return await repository.addBooking(booking);
  }
}
