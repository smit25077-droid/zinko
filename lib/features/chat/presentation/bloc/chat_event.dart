import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class GetChatsEvent extends ChatEvent {}

class GetMessagesEvent extends ChatEvent {
  final String chatId;
  const GetMessagesEvent(this.chatId);
  @override
  List<Object?> get props => [chatId];
}

class SendChatMessageEvent extends ChatEvent {
  final String chatId;
  final String text;
  const SendChatMessageEvent(this.chatId, this.text);
  @override
  List<Object?> get props => [chatId, text];
}
