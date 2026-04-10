import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/repositories/community_repository.dart';
import 'package:zinko_app/features/community/domain/usecases/person_usecases.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  late GetPeople usecase;
  late MockCommunityRepository mockRepository;

  setUp(() {
    mockRepository = MockCommunityRepository();
    usecase = GetPeople(mockRepository);
  });

  final tPersonEntity = PersonEntity(
    id: '1',
    name: 'Alice Smith',
    role: 'Flutter Developer',
    bio: 'Loves clean code.',
    avatarUrl: 'https://example.com/alice.png',
    location: 'London',
    isConnected: false,
  );

  group('GetPeople', () {
    test('should return a list of PersonEntity on success', () async {
      // Arrange
      when(() => mockRepository.getPeople())
          .thenAnswer((_) async => Right([tPersonEntity]));

      // Act
      final result = await usecase(NoParams());

      // Assert
      result.fold(
        (failure) =>
            fail('Expected success but got failure: ${failure.message}'),
        (people) {
          expect(people.length, 1);
          expect(people.first.name, 'Alice Smith');
        },
      );
      verify(() => mockRepository.getPeople()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
