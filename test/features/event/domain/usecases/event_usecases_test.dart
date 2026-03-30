import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/event/domain/entities/event_entity.dart';
import 'package:zinko_app/features/event/domain/repositories/event_repository.dart';
import 'package:zinko_app/features/event/domain/usecases/event_usecases.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  late GetEvents getEventsUsecase;
  late ToggleFavoriteEvent toggleFavoriteUsecase;
  late RegisterEvent registerEventUsecase;
  late MockEventRepository mockRepository;

  setUp(() {
    mockRepository = MockEventRepository();
    getEventsUsecase = GetEvents(mockRepository);
    toggleFavoriteUsecase = ToggleFavoriteEvent(mockRepository);
    registerEventUsecase = RegisterEvent(mockRepository);
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

  group('GetEvents', () {
    test('should return a list of events on success', () async {
      // Arrange
      when(() => mockRepository.getEvents())
          .thenAnswer((_) async => const Right(tEventList));

      // Act
      final result = await getEventsUsecase(NoParams());

      // Assert
      expect(result, const Right(tEventList));
      verify(() => mockRepository.getEvents()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a ServerFailure on error', () async {
      // Arrange
      when(() => mockRepository.getEvents())
          .thenAnswer((_) async => Left(ServerFailure('Server Error')));

      // Act
      final result = await getEventsUsecase(NoParams());

      // Assert
      expect(result, isA<Left<Failure, List<EventEntity>>>());
      verify(() => mockRepository.getEvents()).called(1);
    });
  });

  group('ToggleFavoriteEvent', () {
    test('should return an updated event with isFavorite toggled', () async {
      // Arrange
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
        isFavorite: true, // toggled
      );

      when(() => mockRepository.toggleFavoriteEvent('evt1'))
          .thenAnswer((_) async => const Right(updatedEvent));

      // Act
      final result = await toggleFavoriteUsecase('evt1');

      // Assert
      expect(result, const Right(updatedEvent));
      verify(() => mockRepository.toggleFavoriteEvent('evt1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('RegisterEvent', () {
    test('should return an updated event with isRegistered true', () async {
      // Arrange
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
        isRegistered: true, // registered
      );

      when(() => mockRepository.registerEvent('evt1'))
          .thenAnswer((_) async => const Right(updatedEvent));

      // Act
      final result = await registerEventUsecase('evt1');

      // Assert
      expect(result, const Right(updatedEvent));
      verify(() => mockRepository.registerEvent('evt1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
