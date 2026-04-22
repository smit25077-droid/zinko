import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/booking/domain/entities/user_booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';

class GetUserBookings implements UseCase<List<UserBookingEntity>, NoParams> {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  @override
  Future<Either<Failure, List<UserBookingEntity>>> call(NoParams params) async {
    return await repository.getUserBookingDetails();
  }
}
