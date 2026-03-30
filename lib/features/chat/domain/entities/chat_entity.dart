import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
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

  @override
  List<Object?> get props => [id, name, lastMessage, time, avatar, unreadCount, isOnline, isPremiumLocked];
}

class MessageEntity extends Equatable {
  final String id;
  final String text;
  final String time;
  final bool isMe;

  const MessageEntity({
    required this.id,
    required this.text,
    required this.time,
    required this.isMe,
  });

  @override
  List<Object?> get props => [id, text, time, isMe];
}
