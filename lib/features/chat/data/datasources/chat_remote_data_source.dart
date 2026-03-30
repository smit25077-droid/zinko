import '../models/chat_model.dart';
import '../../../../models/app_models.dart' hide ChatModel;

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChats();
  Future<List<MessageModel>> getMessages(String chatId);
  Future<MessageModel> sendMessage(String chatId, String text);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final List<ChatModel> _mockChats = kAllChats.map((c) => ChatModel(
    id: c.id,
    name: c.name,
    lastMessage: c.lastMessage,
    time: c.time,
    avatar: c.avatar,
    unreadCount: c.unreadCount,
    isOnline: c.isOnline,
    isPremiumLocked: c.isPremiumLocked,
  )).toList();

  final Map<String, List<MessageModel>> _messagesMap = {
    '1': [
      const MessageModel(id: 'm1', text: "Hey! Are you going to the Flutter workshop?", time: "10:00 AM", isMe: false),
      const MessageModel(id: 'm2', text: "Yes, I just registered! Are you?", time: "10:02 AM", isMe: true),
      const MessageModel(id: 'm3', text: "Thinking about it. Is there a group discount?", time: "10:05 AM", isMe: false),
    ],
  };

  @override
  Future<List<ChatModel>> getChats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockChats;
  }

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _messagesMap[chatId] ?? [];
  }

  @override
  Future<MessageModel> sendMessage(String chatId, String text) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newMsg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      time: "Just now",
      isMe: true,
    );
    _messagesMap.putIfAbsent(chatId, () => []);
    _messagesMap[chatId]!.add(newMsg);
    
    // Update last message in chat list
    final index = _mockChats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      _mockChats[index] = ChatModel(
        id: _mockChats[index].id,
        name: _mockChats[index].name,
        lastMessage: text,
        time: "Just now",
        avatar: _mockChats[index].avatar,
        unreadCount: _mockChats[index].unreadCount,
        isOnline: _mockChats[index].isOnline,
        isPremiumLocked: _mockChats[index].isPremiumLocked,
      );
    }
    
    return newMsg;
  }
}
