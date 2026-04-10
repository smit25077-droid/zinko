import '../entities/booking_request_entity.dart';
import '../repositories/workspace_repository.dart';

class CreateBookingUseCase {
  final WorkspaceRepository repository;

  CreateBookingUseCase(this.repository);

  Future<BookingResponseEntity> call(BookingRequestEntity request) async {
    return await repository.createBooking(request);
  }
}
