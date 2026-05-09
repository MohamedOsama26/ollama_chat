import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../domain/repositories/repositories.dart';

part 'chat_event.dart';
part 'chat_state.dart';

@injectable
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessage;
  final SaveMessageUseCase saveMessage;
  final GetMessagesUseCase getMessages;
  final SessionRepository updateSession;
  StreamSubscription<dynamic>? _streamSub;

  ChatBloc({
    required this.sendMessage,
    required this.saveMessage,
    required this.getMessages,
    required this.updateSession,
  }) : super(const ChatState()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendChatMessage>(_onSendMessage);
    on<AppendToken>(_onAppendToken);
    on<StreamingDone>(_onStreamingDone);
    on<StreamingError>(_onStreamingError);
    on<CancelStreaming>(_onCancelStreaming);
    on<SetSession>(_onSetSession);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getMessages(event.sessionId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (messages) => emit(state.copyWith(isLoading: false, messages: messages, error: null)),
    );
  }

  void _onSetSession(SetSession event, Emitter<ChatState> emit) {
    emit(state.copyWith(session: event.session, messages: const []));
  }

  Future<void> _onSendMessage(SendChatMessage event, Emitter<ChatState> emit) async {
    final session = state.session;
    if (session == null) return;

    final userMsg = ChatMessage(
      id: const Uuid().v4(),
      sessionId: session.id,
      role: 'user',
      content: event.content,
      createdAt: DateTime.now(),
    );

    final assistantMsg = ChatMessage(
      id: const Uuid().v4(),
      sessionId: session.id,
      role: 'assistant',
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    final updatedMessages = [...state.messages, userMsg, assistantMsg];
    emit(state.copyWith(messages: updatedMessages, isStreaming: true, error: null));

    await saveMessage(userMsg);

    final allMessages = updatedMessages
        .where((m) => m.role != 'assistant' || m.id != assistantMsg.id)
        .toList();

    _streamSub = sendMessage(
      model: session.model,
      messages: allMessages,
      systemPrompt: session.systemPrompt,
    ).listen(
      (result) => result.fold(
        (failure) => add(StreamingError(failure.message)),
        (token) => add(AppendToken(token)),
      ),
      onDone: () => add(StreamingDone()),
      onError: (e) => add(StreamingError(e.toString())),
    );
  }

  void _onAppendToken(AppendToken event, Emitter<ChatState> emit) {
    final messages = state.messages.toList();
    final lastIdx = messages.lastIndexWhere((m) => m.role == 'assistant' && m.isStreaming);
    if (lastIdx == -1) return;
    messages[lastIdx] = messages[lastIdx].copyWith(
      content: messages[lastIdx].content + event.token,
    );
    emit(state.copyWith(messages: messages));
  }

  Future<void> _onStreamingDone(StreamingDone event, Emitter<ChatState> emit) async {
    final messages = state.messages.toList();
    final lastIdx = messages.lastIndexWhere((m) => m.role == 'assistant' && m.isStreaming);
    if (lastIdx != -1) {
      messages[lastIdx] = messages[lastIdx].copyWith(isStreaming: false);
      await saveMessage(messages[lastIdx]);
    }
    emit(state.copyWith(messages: messages, isStreaming: false));
  }

  void _onStreamingError(StreamingError event, Emitter<ChatState> emit) {
    emit(state.copyWith(isStreaming: false, error: event.message));
  }

  Future<void> _onCancelStreaming(CancelStreaming event, Emitter<ChatState> emit) async {
    await _streamSub?.cancel();
    _streamSub = null;
    final messages = state.messages.toList();
    final lastIdx = messages.lastIndexWhere((m) => m.role == 'assistant' && m.isStreaming);
    if (lastIdx != -1) {
      messages[lastIdx] = messages[lastIdx].copyWith(isStreaming: false);
    }
    emit(state.copyWith(messages: messages, isStreaming: false));
  }

  @override
  Future<void> close() {
    _streamSub?.cancel();
    return super.close();
  }
}
