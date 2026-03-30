class ConnectionEntity {
  final String id;
  final String name;
  final String role;
  final String avatar;
  final bool isConnected;

  const ConnectionEntity({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
    this.isConnected = false,
  });
}
