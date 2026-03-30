class GroupEntity {
  final String id;
  final String name;
  final String memberCount;
  final String image;
  final bool isJoined;

  const GroupEntity({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.image,
    this.isJoined = false,
  });
}
