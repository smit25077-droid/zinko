import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/booking/domain/entities/booking_entity.dart';
import 'package:zinko_app/features/booking/domain/repositories/booking_repository.dart';
import 'package:zinko_app/features/booking/domain/usecases/get_bookings.dart';
import 'package:zinko_app/features/booking/domain/usecases/add_booking.dart';
import 'package:zinko_app/features/booking/domain/usecases/complete_booking.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_event.dart';
import 'package:zinko_app/features/booking/presentation/bloc/booking_state.dart';

class MockBookingRepository extends Mock implements BookingRepository {}
class MockGetBookings extends Mock implements GetBookings {}
class MockAddBooking extends Mock implements AddBooking {}
class MockCompleteBooking extends Mock implements CompleteBooking {}

void main() {
  late BookingBloc bloc;
  late MockBookingRepository mockRepository;
  late MockGetBookings mockGetBookings;
  late MockAddBooking mockAddBooking;
  late MockCompleteBooking mockCompleteBooking;

  final tBooking = BookingEntity(
    id: 'booking1',
    placeId: 'ws1',
    placeName: 'TechHub London',
    location: '123 Tech Street, London',
    imageUrl: 'https://example.com/techub.png',
    date: DateTime(2026, 3, 15),
    timeSlot: '09:00 AM - 05:00 PM',
    tableNumber: 'T-7',
    subtotal: 40.0,
    tax: 8.0,
    total: 48.0,
    isCompleted: false,
    placeType: BookingPlaceType.coworking,
  );

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(tBooking);
  });

  setUp(() {
    mockRepository = MockBookingRepository();
    mockGetBookings = MockGetBookings();
    mockAddBooking = MockAddBooking();
    mockCompleteBooking = MockCompleteBooking();

    bloc = BookingBloc(
      getBookings: mockGetBookings,
      addBooking: mockAddBooking,
      completeBooking: mockCompleteBooking,
      repository: mockRepository,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is BookingInitial', () {
    expect(bloc.state, isA<BookingInitial>());
  });

  group('GetBookingsEvent (full booking flow)', () {
    test('emits [BookingLoading, BookingsLoaded] with bookings list', () async {
      // Arrange
      when(() => mockGetBookings(any()))
          .thenAnswer((_) async => Right([tBooking]));

      // Act
      bloc.add(GetBookingsEvent());
      await Future.delayed(Duration.zero);

      // Assert
      expect(bloc.state, isA<BookingsLoaded>());
      final loadedState = bloc.state as BookingsLoaded;
      expect(loadedState.bookings.length, 1);
      expect(loadedState.bookings.first.placeName, 'TechHub London');
    });

    test('emits [BookingLoading, BookingError] when fetch fails', () async {
      // Arrange
      when(() => mockGetBookings(any()))
          .thenAnswer((_) async => Left(ServerFailure('Network Error')));

      // Act
      bloc.add(GetBookingsEvent());
      await Future.delayed(Duration.zero);

      // Assert
      expect(bloc.state, isA<BookingError>());
      expect((bloc.state as BookingError).message, contains('Network Error'));
    });
  });

  group('AddBookingEvent (booking creation)', () {
    test('adds a booking and then refreshes booking list', () async {
      // Arrange – addBooking succeeds; getBookings returns updated list
      when(() => mockAddBooking(any()))
          .thenAnswer((_) async => Right(tBooking));
      when(() => mockGetBookings(any()))
          .thenAnswer((_) async => Right([tBooking]));

      // Act
      bloc.add(AddBookingEvent(tBooking));
      // Give the bloc time to process AddBookingEvent AND the subsequent GetBookingsEvent
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert: final state should be BookingsLoaded
      expect(bloc.state, isA<BookingsLoaded>());
      final state = bloc.state as BookingsLoaded;
      expect(state.bookings.first.id, 'booking1');
    });

    test('emits BookingError when addBooking fails', () async {
      // Arrange
      when(() => mockAddBooking(any()))
          .thenAnswer((_) async => Left(ServerFailure('Add failed')));

      // Act
      bloc.add(AddBookingEvent(tBooking));
      await Future.delayed(Duration.zero);

      // Assert
      expect(bloc.state, isA<BookingError>());
    });
  });

  group('CompleteBookingEvent (check-in)', () {
    final tCheckedInBooking = BookingEntity(
      id: 'booking1',
      placeId: 'ws1',
      placeName: 'TechHub London',
      location: '123 Tech Street, London',
      imageUrl: 'https://example.com/techub.png',
      date: DateTime(2026, 3, 15),
      timeSlot: '09:00 AM - 05:00 PM',
      tableNumber: 'T-7',
      subtotal: 40.0,
      tax: 8.0,
      total: 48.0,
      isCompleted: true, // checked in
      placeType: BookingPlaceType.coworking,
    );

    test('completes (checks-in) a booking and refreshes the list', () async {
      // Arrange
      when(() => mockCompleteBooking(any()))
          .thenAnswer((_) async => Right(tCheckedInBooking));
      when(() => mockGetBookings(any()))
          .thenAnswer((_) async => Right([tCheckedInBooking]));

      // Act
      bloc.add(CompleteBookingEvent('booking1'));
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert: booking list reflects the completed state
      expect(bloc.state, isA<BookingsLoaded>());
      final state = bloc.state as BookingsLoaded;
      expect(state.bookings.first.isCompleted, true);
    });

    test('emits BookingError when check-in fails', () async {
      // Arrange
      when(() => mockCompleteBooking(any()))
          .thenAnswer((_) async => Left(ServerFailure('Check-in failed')));

      // Act
      bloc.add(CompleteBookingEvent('booking1'));
      await Future.delayed(Duration.zero);

      // Assert
      expect(bloc.state, isA<BookingError>());
      expect(
        (bloc.state as BookingError).message,
        contains('Check-in failed'),
      );
    });
  });

  group('RemoveBookingEvent (cancellation)', () {
    test('removes a booking and refreshes the list', () async {
      // Arrange
      when(() => mockRepository.removeBooking('booking1'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockGetBookings(any()))
          .thenAnswer((_) async => const Right([]));

      // Act
      bloc.add(RemoveBookingEvent('booking1'));
      await Future.delayed(const Duration(milliseconds: 100));

      // Assert: booking list is now empty
      expect(bloc.state, isA<BookingsLoaded>());
      expect((bloc.state as BookingsLoaded).bookings, isEmpty);
    });
  });
}
