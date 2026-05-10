import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import '../repositories/session_repository.dart';

@injectable
class GetSessionsUseCase {
  final SessionRepository repository;
  GetSessionsUseCase(this.repository);

  Future<Either<Failure, List<ChatSession>>> call() => repository.getSessions();
}

@injectable
class CreateSessionUseCase {
  final SessionRepository repository;
  CreateSessionUseCase(this.repository);

  Future<Either<Failure, ChatSession>> call(ChatSession session) =>
      repository.createSession(session);
}

@injectable
class DeleteSessionUseCase {
  final SessionRepository repository;
  DeleteSessionUseCase(this.repository);

  Future<Either<Failure, void>> call(String sessionId) =>
      repository.deleteSession(sessionId);
}
