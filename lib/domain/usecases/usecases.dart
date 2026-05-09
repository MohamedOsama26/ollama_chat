import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../entities/entities.dart';
import '../repositories/repositories.dart';
import '../../core/errors/failures.dart';

@injectable
class SendMessageUseCase {
  final ChatRepository repository;
  SendMessageUseCase(this.repository);

  Stream<Either<Failure, String>> call({
    required String model,
    required List<ChatMessage> messages,
    String? systemPrompt,
  }) =>
      repository.sendMessage(
        model: model,
        messages: messages,
        systemPrompt: systemPrompt,
      );
}

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

@injectable
class GetMessagesUseCase {
  final SessionRepository repository;
  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(String sessionId) =>
      repository.getMessages(sessionId);
}

@injectable
class SaveMessageUseCase {
  final SessionRepository repository;
  SaveMessageUseCase(this.repository);

  Future<Either<Failure, void>> call(ChatMessage message) =>
      repository.saveMessage(message);
}

@injectable
class ListModelsUseCase {
  final ModelRepository repository;
  ListModelsUseCase(this.repository);

  Future<Either<Failure, List<OllamaModel>>> call() => repository.getModels();
}
