import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';
import 'chat_local_datasource.dart';

@Singleton(as: ChatLocalDatasource)
class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  static const String _prefix = 'messages_';

  @override
  Future<List<ChatMessage>> getMessages(String sessionId) async {
    final box = await Hive.openBox<Map>('$_prefix$sessionId');
    return box.values.map(_toEntity).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Future<void> saveMessage(ChatMessage message) async {
    final box = await Hive.openBox<Map>('$_prefix${message.sessionId}');
    await box.put(message.id, _toMap(message));
  }

  @override
  Future<void> deleteMessages(String sessionId) async {
    final box = await Hive.openBox<Map>('$_prefix$sessionId');
    await box.clear();
  }

  Map _toMap(ChatMessage m) => {
        'id': m.id,
        'sessionId': m.sessionId,
        'role': m.role,
        'content': m.content,
        'createdAt': m.createdAt.toIso8601String(),
      };

  ChatMessage _toEntity(Map m) => ChatMessage(
        id: m['id'],
        sessionId: m['sessionId'],
        role: m['role'],
        content: m['content'],
        createdAt: DateTime.parse(m['createdAt']),
      );
}
