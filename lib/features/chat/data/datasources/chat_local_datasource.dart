import 'package:ollama_chat/core/domain/entities/entities.dart';

abstract class ChatLocalDatasource {
  Future<List<ChatMessage>> getMessages(String sessionId);
  Future<void> saveMessage(ChatMessage message);
  Future<void> deleteMessages(String sessionId);
}
