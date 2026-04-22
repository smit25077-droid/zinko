import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';

class GetBookings implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  GetBookings(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) async {
    return await repository.getBookings();
  }
}
