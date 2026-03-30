import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class AddBooking implements UseCase<BookingEntity, BookingEntity> {
  final BookingRepository repository;

  AddBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(BookingEntity booking) async {
    return await repository.addBooking(booking);
  }
}
