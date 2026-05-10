part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final ChatSession? session;
  final List<ChatMessage> messages;
  final bool isStreaming;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.session,
    this.messages = const [],
    this.isStreaming = false,
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    ChatSession? session,
    List<ChatMessage>? messages,
    bool? isStreaming,
    bool? isLoading,
    String? error,
  }) =>
      ChatState(
        session: session ?? this.session,
        messages: messages ?? this.messages,
        isStreaming: isStreaming ?? this.isStreaming,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  @override
  List<Object?> get props => [session, messages, isStreaming, isLoading, error];
}
