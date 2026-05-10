import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'session_local_datasource.dart';

@Singleton(as: SessionLocalDatasource)
class SessionLocalDatasourceImpl implements SessionLocalDatasource {
  static const String _box = 'sessions';

  @override
  Future<List<ChatSession>> getSessions() async {
    final box = Hive.box<Map>(_box);
    return box.values.map(_toEntity).toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<void> saveSession(ChatSession session) async {
    final box = Hive.box<Map>(_box);
    await box.put(session.id, _toMap(session));
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final box = Hive.box<Map>(_box);
    await box.delete(sessionId);
  }

  Map _toMap(ChatSession s) => {
        'id': s.id,
        'title': s.title,
        'model': s.model,
        'createdAt': s.createdAt.toIso8601String(),
        'updatedAt': s.updatedAt.toIso8601String(),
        'systemPrompt': s.systemPrompt,
      };

  ChatSession _toEntity(Map m) => ChatSession(
        id: m['id'],
        title: m['title'],
        model: m['model'],
        createdAt: DateTime.parse(m['createdAt']),
        updatedAt: DateTime.parse(m['updatedAt']),
        systemPrompt: m['systemPrompt'],
      );
}
