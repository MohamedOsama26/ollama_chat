import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String sessionId;
  final String role; // 'user' | 'assistant' | 'system'
  final String content;
  final DateTime createdAt;
  final bool isStreaming;

  const ChatMessage({
    required this.id,
    required this.sessionId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? content,
    bool? isStreaming,
  }) =>
      ChatMessage(
        id: id,
        sessionId: sessionId,
        role: role,
        content: content ?? this.content,
        createdAt: createdAt,
        isStreaming: isStreaming ?? this.isStreaming,
      );

  Map<String, dynamic> toOllamaJson() => {
        'role': role,
        'content': content,
      };

  @override
  List<Object?> get props => [id, sessionId, role, content, createdAt, isStreaming];
}

class ChatSession extends Equatable {
  final String id;
  final String title;
  final String model;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? systemPrompt;

  const ChatSession({
    required this.id,
    required this.title,
    required this.model,
    required this.createdAt,
    required this.updatedAt,
    this.systemPrompt,
  });

  ChatSession copyWith({
    String? title,
    String? model,
    DateTime? updatedAt,
    String? systemPrompt,
  }) =>
      ChatSession(
        id: id,
        title: title ?? this.title,
        model: model ?? this.model,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        systemPrompt: systemPrompt ?? this.systemPrompt,
      );

  @override
  List<Object?> get props => [id, title, model, createdAt, updatedAt, systemPrompt];
}

class OllamaModel extends Equatable {
  final String name;
  final int size;
  final DateTime modifiedAt;

  const OllamaModel({
    required this.name,
    required this.size,
    required this.modifiedAt,
  });

  String get displayName => name.split(':').first;

  String get sizeLabel {
    if (size > 1024 * 1024 * 1024) {
      return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
    return '${(size / (1024 * 1024)).toStringAsFixed(0)} MB';
  }

  @override
  List<Object?> get props => [name, size, modifiedAt];
}
