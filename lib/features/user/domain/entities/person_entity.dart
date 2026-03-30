class PersonEntity {
  final String id;
  final String name;
  final String role;
  final String bio;
  final String avatarUrl;
  final String location;
  final int connections;
  final int groups;
  final double rating;
  final List<String> skills;
  final bool isVerified;
  final double lat;
  final double lng;
  bool isConnected;
  bool isFavorite;

  PersonEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.bio,
    required this.avatarUrl,
    required this.location,
    this.connections = 0,
    this.groups = 0,
    this.rating = 0.0,
    this.skills = const [],
    this.isVerified = false,
    this.lat = 51.5074,
    this.lng = -0.1278,
    this.isConnected = false,
    this.isFavorite = false,
  });
}
