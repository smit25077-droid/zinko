import 'package:zinko_app/features/chat/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.name,
    required super.lastMessage,
    required super.time,
    required super.avatar,
    required super.unreadCount,
    required super.isOnline,
    super.isPremiumLocked,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      time: json['time'],
      avatar: json['avatar'],
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
      isPremiumLocked: json['isPremiumLocked'] ?? false,
    );
  }
}

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.text,
    required super.time,
    required super.isMe,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      text: json['text'],
      time: json['time'],
      isMe: json['isMe'] ?? false,
    );
  }
}
