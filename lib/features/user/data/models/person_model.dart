import 'package:zinko_app/features/user/domain/entities/person_entity.dart';

class PersonModel extends PersonEntity {
  PersonModel({
    required super.id,
    required super.name,
    required super.role,
    required super.bio,
    required super.avatarUrl,
    required super.location,
    super.connections,
    super.groups,
    super.rating,
    super.skills,
    super.isVerified,
    super.lat,
    super.lng,
    super.isConnected,
    super.isFavorite,
  });
}
