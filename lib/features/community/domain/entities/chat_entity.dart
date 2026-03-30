class ChatEntity {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatar;
  final int unreadCount;
  final bool isOnline;
  final bool isPremiumLocked;

  const ChatEntity({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatar,
    required this.unreadCount,
    required this.isOnline,
    this.isPremiumLocked = false,
  });
}
