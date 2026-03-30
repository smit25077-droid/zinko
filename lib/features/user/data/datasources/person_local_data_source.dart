import '../models/person_model.dart';

abstract class PersonLocalDataSource {
  Future<List<PersonModel>> getPeople();
  Future<void> toggleConnection(String id);
}

class PersonLocalDataSourceImpl implements PersonLocalDataSource {
  final List<PersonModel> _people = [
    PersonModel(
      id: 'm1',
      name: 'Alex Rivera',
      role: 'UI Designer',
      bio: 'Loves pixel perfect designs and artisanal coffee.',
      avatarUrl: 'https://i.pravatar.cc/150?u=m1',
      location: 'Cafe Work',
      connections: 120,
      groups: 5,
      rating: 4.8,
      skills: ['Figma', 'Sketch', 'Adobe XD'],
      isVerified: true,
      lat: 51.5033,
      lng: -0.0195,
      isConnected: false,
    ),
    // Add more here...
  ];

  @override
  Future<List<PersonModel>> getPeople() async {
    return _people;
  }

  @override
  Future<void> toggleConnection(String id) async {
    final index = _people.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _people[index];
      _people[index] = PersonModel(
        id: p.id,
        name: p.name,
        role: p.role,
        bio: p.bio,
        avatarUrl: p.avatarUrl,
        location: p.location,
        connections: p.connections,
        groups: p.groups,
        rating: p.rating,
        skills: p.skills,
        isVerified: p.isVerified,
        lat: p.lat,
        lng: p.lng,
        isConnected: !p.isConnected,
        isFavorite: p.isFavorite,
      );
    }
  }
}
