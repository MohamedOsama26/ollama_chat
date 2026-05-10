import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import '../repositories/chat_repository.dart';

@injectable
class GetMessagesUseCase {
  final ChatRepository repository;
  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<ChatMessage>>> call(String sessionId) =>
      repository.getMessages(sessionId);
}

@injectable
class SaveMessageUseCase {
  final ChatRepository repository;
  SaveMessageUseCase(this.repository);

  Future<Either<Failure, void>> call(ChatMessage message) =>
      repository.saveMessage(message);
}
