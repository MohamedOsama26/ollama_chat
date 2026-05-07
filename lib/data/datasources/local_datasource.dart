import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/entities.dart';

class LocalDatasource {
  static const String _sessionsBox = 'sessions';
  static const String _messagesPrefix = 'messages_';

  Future<void> init() async {
    await Hive.openBox<Map>(_sessionsBox);
  }

  // Sessions
  Future<List<ChatSession>> getSessions() async {
    final box = Hive.box<Map>(_sessionsBox);
    return box.values.map(_mapToSession).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<void> saveSession(ChatSession session) async {
    final box = Hive.box<Map>(_sessionsBox);
    await box.put(session.id, _sessionToMap(session));
  }

  Future<void> deleteSession(String sessionId) async {
    final box = Hive.box<Map>(_sessionsBox);
    await box.delete(sessionId);
    // Also delete messages
    final msgBox = await Hive.openBox<Map>('$_messagesPrefix$sessionId');
    await msgBox.deleteFromDisk();
  }

  // Messages
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final box = await Hive.openBox<Map>('$_messagesPrefix$sessionId');
    return box.values.map(_mapToMessage).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> saveMessage(ChatMessage message) async {
    final box = await Hive.openBox<Map>('$_messagesPrefix${message.sessionId}');
    await box.put(message.id, _messageToMap(message));
  }

  Future<void> deleteMessages(String sessionId) async {
    final box = await Hive.openBox<Map>('$_messagesPrefix$sessionId');
    await box.clear();
  }

  // Mappers
  Map _sessionToMap(ChatSession s) => {
        'id': s.id,
        'title': s.title,
        'model': s.model,
        'createdAt': s.createdAt.toIso8601String(),
        'updatedAt': s.updatedAt.toIso8601String(),
        'systemPrompt': s.systemPrompt,
      };

  ChatSession _mapToSession(Map m) => ChatSession(
        id: m['id'],
        title: m['title'],
        model: m['model'],
        createdAt: DateTime.parse(m['createdAt']),
        updatedAt: DateTime.parse(m['updatedAt']),
        systemPrompt: m['systemPrompt'],
      );

  Map _messageToMap(ChatMessage m) => {
        'id': m.id,
        'sessionId': m.sessionId,
        'role': m.role,
        'content': m.content,
        'createdAt': m.createdAt.toIso8601String(),
      };

  ChatMessage _mapToMessage(Map m) => ChatMessage(
        id: m['id'],
        sessionId: m['sessionId'],
        role: m['role'],
        content: m['content'],
        createdAt: DateTime.parse(m['createdAt']),
      );
}
