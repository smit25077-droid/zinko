import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:zinko_app/features/user/domain/entities/person_entity.dart';
import 'package:zinko_app/features/community/domain/repositories/community_repository.dart';
import 'package:zinko_app/features/community/domain/usecases/person_usecases.dart';

class MockCommunityRepository extends Mock implements CommunityRepository {}

void main() {
  late ToggleConnection usecase;
  late MockCommunityRepository mockRepository;

  setUp(() {
    mockRepository = MockCommunityRepository();
    usecase = ToggleConnection(mockRepository);
  });

  final tPersonEntity = PersonEntity(
    id: '1',
    name: 'Alice Smith',
    role: 'Flutter Developer',
    bio: 'Loves clean code.',
    avatarUrl: 'https://example.com/alice.png',
    location: 'London',
    isConnected: true, // toggled to connected
  );

  group('ToggleConnection', () {
    test('should toggle connection state of a PersonEntity', () async {
      // Arrange
      when(() => mockRepository.toggleConnection('1'))
          .thenAnswer((_) async => Right(tPersonEntity));

      // Act
      final result = await usecase('1');

      // Assert
      expect(result, Right(tPersonEntity));
      verify(() => mockRepository.toggleConnection('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
