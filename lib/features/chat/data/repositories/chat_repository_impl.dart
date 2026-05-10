import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import 'package:ollama_chat/core/network/ollama_api_client.dart';
import '../datasources/chat_local_datasource.dart';
import '../../domain/repositories/chat_repository.dart';

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final OllamaApiClient apiClient;
  final ChatLocalDatasource localDatasource;
  ChatRepositoryImpl(this.apiClient, this.localDatasource);

  @override
  Stream<Either<Failure, String>> sendMessage({
    required String model,
    required List<ChatMessage> messages,
    String? systemPrompt,
  }) async* {
    try {
      await for (final token in apiClient.chat(
        model: model,
        messages: messages,
        systemPrompt: systemPrompt,
      )) {
        yield Right(token);
      }
    } on Exception catch (e) {
      yield Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String sessionId) async {
    try {
      return Right(await localDatasource.getMessages(sessionId));
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveMessage(ChatMessage message) async {
    try {
      await localDatasource.saveMessage(message);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessages(String sessionId) async {
    try {
      await localDatasource.deleteMessages(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
