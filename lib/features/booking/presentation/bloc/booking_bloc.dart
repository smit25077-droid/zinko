import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_bookings.dart';
import '../../domain/usecases/add_booking.dart';
import '../../domain/usecases/complete_booking.dart';
import '../../domain/usecases/get_user_bookings.dart';
import '../../domain/usecases/user_check_in.dart';
import '../../../../core/usecases/usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetBookings getBookings;
  final GetUserBookings getUserBookings;
  final UserCheckIn userCheckIn;
  final AddBooking addBooking;
  final CompleteBooking completeBooking;
  final BookingRepository repository;

  BookingBloc({
    required this.getBookings,
    required this.getUserBookings,
    required this.userCheckIn,
    required this.addBooking,
    required this.completeBooking,
    required this.repository,
  }) : super(BookingInitial()) {
    on<GetBookingsEvent>(_onGetBookings);
    on<AddBookingEvent>(_onAddBooking);
    on<CancelBookingEvent>(_onCancelBooking);
    on<CompleteBookingEvent>(_onCompleteBooking);
    on<FilterBookingsByTabEvent>(_onFilterByTab);
    on<UserCheckInEvent>(_onUserCheckIn);
  }

  Future<void> _onUserCheckIn(UserCheckInEvent event, Emitter<BookingState> emit) async {
    emit(BookingCheckInLoading());
    final result = await userCheckIn(UserCheckInParams(
      bookingCode: event.bookingCode,
      otp: event.otp,
    ));
    result.fold(
      (failure) => emit(CheckInError(failure.message)),
      (_) {
        emit(const BookingOperationSuccess('Checked in successfully!'));
        add(GetBookingsEvent());
      },
    );
  }

  Future<void> _onGetBookings(GetBookingsEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await getUserBookings(NoParams());
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) {
        final currentTabIndex = state is BookingsLoaded ? (state as BookingsLoaded).tabIndex : 0;
        emit(BookingsLoaded(bookings, tabIndex: currentTabIndex));
      },
    );
  }

  void _onFilterByTab(FilterBookingsByTabEvent event, Emitter<BookingState> emit) {
    if (state is BookingsLoaded) {
      emit((state as BookingsLoaded).copyWith(tabIndex: event.tabIndex));
    }
  }

  Future<void> _onAddBooking(AddBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await addBooking(event.booking);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => add(GetBookingsEvent()),
    );
  }

  Future<void> _onCancelBooking(CancelBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await repository.cancelBooking(event.bookingCode);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) {
        emit(const BookingOperationSuccess('Booking cancelled successfully'));
        add(GetBookingsEvent());
      },
    );
  }

  Future<void> _onCompleteBooking(CompleteBookingEvent event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await completeBooking(event.id);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) {
        emit(const BookingOperationSuccess('Booking completed successfully'));
        add(GetBookingsEvent());
      },
    );
  }
}
