import 'package:dartz/dartz.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';

abstract class SessionRepository {
  Future<Either<Failure, List<ChatSession>>> getSessions();
  Future<Either<Failure, ChatSession>> createSession(ChatSession session);
  Future<Either<Failure, void>> updateSession(ChatSession session);
  Future<Either<Failure, void>> deleteSession(String sessionId);
}
