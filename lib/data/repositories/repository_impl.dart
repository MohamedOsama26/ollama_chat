import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../core/errors/failures.dart';
import '../datasources/ollama_api_client.dart';
import '../datasources/local_datasource.dart';

@Singleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final OllamaApiClient apiClient;
  ChatRepositoryImpl(this.apiClient);

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
}

@Singleton(as: SessionRepository)
class SessionRepositoryImpl implements SessionRepository {
  final LocalDatasource localDatasource;
  SessionRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, List<ChatSession>>> getSessions() async {
    try {
      return Right(await localDatasource.getSessions());
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatSession>> createSession(ChatSession session) async {
    try {
      await localDatasource.saveSession(session);
      return Right(session);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSession(ChatSession session) async {
    try {
      await localDatasource.saveSession(session);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteSession(String sessionId) async {
    try {
      await localDatasource.deleteSession(sessionId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
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

@Singleton(as: ModelRepository)
class ModelRepositoryImpl implements ModelRepository {
  final OllamaApiClient apiClient;
  ModelRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, List<OllamaModel>>> getModels() async {
    try {
      return Right(await apiClient.getModels());
    } on Exception catch (_) {
      return const Left(OllamaUnreachableFailure());
    }
  }
}
