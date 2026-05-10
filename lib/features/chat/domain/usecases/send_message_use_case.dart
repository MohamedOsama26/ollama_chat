import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'package:ollama_chat/core/errors/failures.dart';
import '../repositories/chat_repository.dart';

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
