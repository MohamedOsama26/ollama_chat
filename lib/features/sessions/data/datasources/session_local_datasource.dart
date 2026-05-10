import 'package:ollama_chat/core/domain/entities/entities.dart';

abstract class SessionLocalDatasource {
  Future<List<ChatSession>> getSessions();
  Future<void> saveSession(ChatSession session);
  Future<void> deleteSession(String sessionId);
}
