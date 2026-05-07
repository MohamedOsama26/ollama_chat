import 'package:dartz/dartz.dart';
import '../entities/entities.dart';
import '../../core/errors/failures.dart';

abstract class ChatRepository {
  Stream<Either<Failure, String>> sendMessage({
    required String model,
    required List<ChatMessage> messages,
    String? systemPrompt,
  });
}

abstract class SessionRepository {
  Future<Either<Failure, List<ChatSession>>> getSessions();
  Future<Either<Failure, ChatSession>> createSession(ChatSession session);
  Future<Either<Failure, void>> updateSession(ChatSession session);
  Future<Either<Failure, void>> deleteSession(String sessionId);
  Future<Either<Failure, List<ChatMessage>>> getMessages(String sessionId);
  Future<Either<Failure, void>> saveMessage(ChatMessage message);
  Future<Either<Failure, void>> deleteMessages(String sessionId);
}

abstract class ModelRepository {
  Future<Either<Failure, List<OllamaModel>>> getModels();
}
