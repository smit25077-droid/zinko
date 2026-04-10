import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetUserBookings implements UseCase<List<UserBookingEntity>, NoParams> {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  @override
  Future<Either<Failure, List<UserBookingEntity>>> call(NoParams params) async {
    return await repository.getUserBookingDetails();
  }
}
