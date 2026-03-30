import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_entity.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatsLoading extends ChatState {}

class ChatsLoaded extends ChatState {
  final List<ChatEntity> chats;
  const ChatsLoaded(this.chats);
  @override
  List<Object?> get props => [chats];
}

class MessagesLoading extends ChatState {}

class MessagesLoaded extends ChatState {
  final List<MessageEntity> messages;
  final List<ChatEntity>? chats; // To keep chat list if needed
  const MessagesLoaded(this.messages, {this.chats});
  @override
  List<Object?> get props => [messages, chats];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
