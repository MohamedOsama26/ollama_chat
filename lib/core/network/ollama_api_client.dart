import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ollama_chat/core/enum/model_status.dart';
import '../domain/entities/entities.dart';
import '../errors/app_constants.dart';

class OllamaApiClient {
  late Dio _dio;
  String _baseUrl;

  OllamaApiClient({String? baseUrl})
      : _baseUrl = baseUrl ?? AppConstants.defaultOllamaHost {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(minutes: 5),
    ));
  }

  void updateBaseUrl(String url) {
    _baseUrl = url;
    _dio.options.baseUrl = url;
  }

  Future<bool> testConnection() async {
    try {
      final response = await _dio.get('/api/tags');
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<ModelStatus> getModelStatus(String modelName) async {
    try {
      final response = await _dio.get('/models/$modelName/status');
      final status = response.data['status'] as String? ?? 'error';
      switch (status.toLowerCase()) {
        case 'ready':
          return ModelStatus.Ready;
        case 'loading':
          return ModelStatus.Loading;
        default:
          return ModelStatus.Error;
      }
    } catch (_) {
      return ModelStatus.Error;
    }
  }

  Future<List<OllamaModel>> getModels() async {
    final response = await _dio.get(AppConstants.apiTags);
    final models = response.data['models'] as List;
    return models
        .map((m) => OllamaModel(
              name: m['name'],
              size: m['size'] ?? 0,
              modifiedAt: DateTime.tryParse(m['modified_at'] ?? '') ?? DateTime.now(),
            ))
        .toList();
  }

  Stream<String> chat({
    required String model,
    required List<ChatMessage> messages,
    String? systemPrompt,
  }) async* {
    final messageList = <Map<String, dynamic>>[];

    if (systemPrompt != null && systemPrompt.isNotEmpty) {
      messageList.add({'role': 'system', 'content': systemPrompt});
    }
    messageList.addAll(
      messages.where((m) => m.role != 'system').map((m) => m.toOllamaJson()),
    );

    final response = await _dio.post(
      AppConstants.apiChat,
      data: {'model': model, 'messages': messageList, 'stream': true},
      options: Options(responseType: ResponseType.stream),
    );

    final stream = response.data.stream as Stream<List<int>>;
    String buffer = '';

    await for (final chunk in stream) {
      buffer += utf8.decode(chunk);
      final lines = buffer.split('\n');
      buffer = lines.removeLast();

      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          final json = jsonDecode(line);
          final content = json['message']?['content'] as String?;
          final done = json['done'] as bool? ?? false;
          if (content != null && content.isNotEmpty) yield content;
          if (done) return;
        } catch (_) {}
      }
    }
  }
}
