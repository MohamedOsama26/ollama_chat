part of 'chat_bloc.dart';

// Events
abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String sessionId;
  const LoadMessages(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class SetSession extends ChatEvent {
  final ChatSession session;
  const SetSession(this.session);
  @override
  List<Object?> get props => [session];
}

class InitChat extends ChatEvent {
  final ChatSession session;
  final String? autoSendMessage;
  const InitChat(this.session, {this.autoSendMessage});
  @override
  List<Object?> get props => [session, autoSendMessage];
}

class SendChatMessage extends ChatEvent {
  final String content;
  const SendChatMessage(this.content);
  @override
  List<Object?> get props => [content];
}

class AppendToken extends ChatEvent {
  final String token;
  const AppendToken(this.token);
  @override
  List<Object?> get props => [token];
}

class StreamingDone extends ChatEvent {}

class StreamingError extends ChatEvent {
  final String message;
  const StreamingError(this.message);
  @override
  List<Object?> get props => [message];
}

class CancelStreaming extends ChatEvent {}
