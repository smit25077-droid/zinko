import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import 'package:zinko_app/features/chat/domain/entities/chat_entity.dart';
import 'package:zinko_app/features/chat/domain/usecases/chat_usecases.dart';
import 'package:zinko_app/features/chat/presentation/bloc/chat_event.dart';
import 'package:zinko_app/features/chat/presentation/bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetChats getChats;
  final GetMessages getMessages;
  final SendMessage sendChatMessage;
  List<ChatEntity> _chats = [];

  ChatBloc({
    required this.getChats,
    required this.getMessages,
    required this.sendChatMessage,
  }) : super(ChatInitial()) {
    on<GetChatsEvent>(_onGetChats);
    on<GetMessagesEvent>(_onGetMessages);
    on<SendChatMessageEvent>(_onSendMessage);
  }

  Future<void> _onGetChats(GetChatsEvent event, Emitter<ChatState> emit) async {
    emit(ChatsLoading());
    final result = await getChats(NoParams());
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (chats) {
        _chats = chats;
        emit(ChatsLoaded(chats));
      },
    );
  }

  Future<void> _onGetMessages(
      GetMessagesEvent event, Emitter<ChatState> emit) async {
    emit(MessagesLoading());
    final result = await getMessages(event.chatId);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesLoaded(messages, chats: _chats)),
    );
  }

  Future<void> _onSendMessage(
      SendChatMessageEvent event, Emitter<ChatState> emit) async {
    final result = await sendChatMessage(
        SendMessageParams(chatId: event.chatId, text: event.text));
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (message) {
        if (state is MessagesLoaded) {
          final currentState = state as MessagesLoaded;
          final updatedMessages =
              List<MessageEntity>.from(currentState.messages)..add(message);
          emit(MessagesLoaded(updatedMessages, chats: _chats));
        }
      },
    );
  }
}
