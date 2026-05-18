import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:zinko_app/core/error/failures.dart';
import 'package:zinko_app/features/chat/domain/entities/chat_entity.dart';
import 'package:zinko_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:zinko_app/features/chat/data/datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatEntity>>> getChats() async {
    try {
      final chats = await remoteDataSource.getChats();
      return Right(chats.cast<ChatEntity>());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
      String chatId) async {
    try {
      final messages = await remoteDataSource.getMessages(chatId);
      return Right(messages.cast<MessageEntity>());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(
      String chatId, String text) async {
    try {
      final message = await remoteDataSource.sendMessage(chatId, text);
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
