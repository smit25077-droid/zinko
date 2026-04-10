import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/booking_repository.dart';

class UserCheckInParams {
  final String bookingCode;
  final String otp;

  UserCheckInParams({required this.bookingCode, required this.otp});
}

class UserCheckIn implements UseCase<void, UserCheckInParams> {
  final BookingRepository repository;

  UserCheckIn(this.repository);

  @override
  Future<Either<Failure, void>> call(UserCheckInParams params) async {
    return await repository.userCheckIn(params.bookingCode, params.otp);
  }
}
