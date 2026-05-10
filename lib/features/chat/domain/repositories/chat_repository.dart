import 'package:dartz/dartz.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';

abstract class ChatRepository {
  Stream<Either<Failure, String>> sendMessage({
    required String model,
    required List<ChatMessage> messages,
    String? systemPrompt,
  });

  Future<Either<Failure, List<ChatMessage>>> getMessages(String sessionId);
  Future<Either<Failure, void>> saveMessage(ChatMessage message);
  Future<Either<Failure, void>> deleteMessages(String sessionId);
}
