import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/event/domain/entities/event_entity.dart';
import 'package:zinko_app/features/event/domain/usecases/event_usecases.dart';
import 'package:zinko_app/features/event/presentation/bloc/event_bloc.dart';
import 'package:zinko_app/features/event/presentation/bloc/event_event.dart';
import 'package:zinko_app/features/event/presentation/bloc/event_state.dart';

class MockGetEvents extends Mock implements GetEvents {}
class MockToggleFavoriteEvent extends Mock implements ToggleFavoriteEvent {}
class MockRegisterEvent extends Mock implements RegisterEvent {}

void main() {
  late EventBloc bloc;
  late MockGetEvents mockGetEvents;
  late MockToggleFavoriteEvent mockToggleFavoriteEvent;
  late MockRegisterEvent mockRegisterEvent;

  setUpAll(() {
    registerFallbackValue(NoParams());
  });

  setUp(() {
    mockGetEvents = MockGetEvents();
    mockToggleFavoriteEvent = MockToggleFavoriteEvent();
    mockRegisterEvent = MockRegisterEvent();
    bloc = EventBloc(
      getEvents: mockGetEvents,
      toggleFavoriteEvent: mockToggleFavoriteEvent,
      registerEvent: mockRegisterEvent,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const tEvent = EventEntity(
    id: 'evt1',
    title: 'Flutter Workshop',
    category: 'Tech',
    date: '26',
    month: 'FEB',
    location: 'London',
    price: 'Free',
    hostName: 'Zinko',
    hostImage: 'https://example.com/host.png',
    imageUrl: 'https://example.com/event.png',
  );

  const tEventList = [tEvent];

  test('initial state should be EventInitial', () {
    expect(bloc.state, isA<EventInitial>());
  });

  group('GetEventsEvent', () {
    blocTest<EventBloc, EventState>(
      'emits [EventLoading, EventLoaded] when GetEventsEvent is added successfully',
      build: () {
        when(() => mockGetEvents(any()))
            .thenAnswer((_) async => const Right(tEventList));
        return bloc;
      },
      act: (bloc) => bloc.add(GetEventsEvent()),
      expect: () => [
        isA<EventLoading>(),
        isA<EventLoaded>()
            .having((s) => s.events, 'events', tEventList),
      ],
    );

    blocTest<EventBloc, EventState>(
      'emits [EventLoading, EventError] when GetEventsEvent fails',
      build: () {
        when(() => mockGetEvents(any()))
            .thenAnswer((_) async => Left(ServerFailure('Server Error')));
        return bloc;
      },
      act: (bloc) => bloc.add(GetEventsEvent()),
      expect: () => [
        isA<EventLoading>(),
        isA<EventError>()
            .having((s) => s.message, 'message', contains('Server Error')),
      ],
    );
  });

  group('ToggleFavoriteEventEvent', () {
    const updatedEvent = EventEntity(
      id: 'evt1',
      title: 'Flutter Workshop',
      category: 'Tech',
      date: '26',
      month: 'FEB',
      location: 'London',
      price: 'Free',
      hostName: 'Zinko',
      hostImage: 'https://example.com/host.png',
      imageUrl: 'https://example.com/event.png',
      isFavorite: true,
    );

    blocTest<EventBloc, EventState>(
      'emits [EventLoaded] with updated favorite when ToggleFavoriteEventEvent is added',
      build: () {
        when(() => mockGetEvents(any()))
            .thenAnswer((_) async => const Right(tEventList));
        when(() => mockToggleFavoriteEvent(any()))
            .thenAnswer((_) async => const Right(updatedEvent));
        return bloc;
      },
      seed: () => const EventLoaded(events: tEventList),
      act: (bloc) => bloc.add(ToggleFavoriteEventEvent('evt1')),
      expect: () => [
        isA<EventLoaded>().having(
          (s) => s.events.first.isFavorite,
          'isFavorite',
          true,
        ),
      ],
    );
  });

  group('RegisterEventEvent', () {
    const updatedEvent = EventEntity(
      id: 'evt1',
      title: 'Flutter Workshop',
      category: 'Tech',
      date: '26',
      month: 'FEB',
      location: 'London',
      price: 'Free',
      hostName: 'Zinko',
      hostImage: 'https://example.com/host.png',
      imageUrl: 'https://example.com/event.png',
      isRegistered: true,
    );

    blocTest<EventBloc, EventState>(
      'emits [EventLoaded] with isRegistered=true when RegisterEventEvent is added',
      build: () {
        when(() => mockRegisterEvent(any()))
            .thenAnswer((_) async => const Right(updatedEvent));
        return bloc;
      },
      seed: () => const EventLoaded(events: tEventList),
      act: (bloc) => bloc.add(RegisterEventEvent('evt1')),
      expect: () => [
        isA<EventLoaded>().having(
          (s) => s.events.first.isRegistered,
          'isRegistered',
          true,
        ),
      ],
    );
  });
}
