import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookings implements UseCase<List<BookingEntity>, NoParams> {
  final BookingRepository repository;

  GetBookings(this.repository);

  @override
  Future<Either<Failure, List<BookingEntity>>> call(NoParams params) async {
    return await repository.getBookings();
  }
}
