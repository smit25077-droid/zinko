import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_request_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/workspace_repository.dart';

class CreateBookingUseCase {
  final WorkspaceRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Either<Failure, BookingResponseEntity>> call(BookingRequestEntity request) async {
    return await repository.createBooking(request);
  }
}
