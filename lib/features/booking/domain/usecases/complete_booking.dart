import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class CompleteBooking implements UseCase<BookingEntity, String> {
  final BookingRepository repository;

  CompleteBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(String id) async {
    return await repository.completeBooking(id);
  }
}
