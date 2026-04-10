import 'package:dartz/dartz.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

class GetChats implements UseCase<List<ChatEntity>, NoParams> {
  final ChatRepository repository;
  GetChats(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(NoParams params) async {
    return await repository.getChats();
  }
}

class GetMessages implements UseCase<List<MessageEntity>, String> {
  final ChatRepository repository;
  GetMessages(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String chatId) async {
    return await repository.getMessages(chatId);
  }
}

class SendMessage extends UseCase<MessageEntity, SendMessageParams> {
  final ChatRepository repository;
  SendMessage(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.chatId, params.text);
  }
}

class SendMessageParams {
  final String chatId;
  final String text;
  SendMessageParams({required this.chatId, required this.text});
}
