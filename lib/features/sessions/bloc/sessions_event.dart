part of 'sessions_bloc.dart';

abstract class SessionsEvent extends Equatable {
  const SessionsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSessions extends SessionsEvent {}

class CreateSession extends SessionsEvent {
  final String model;
  final String? systemPrompt;
  const CreateSession({required this.model, this.systemPrompt});
  @override
  List<Object?> get props => [model, systemPrompt];
}

class DeleteSession extends SessionsEvent {
  final String sessionId;
  const DeleteSession(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class UpdateSessionTitle extends SessionsEvent {
  final String sessionId;
  final String title;
  const UpdateSessionTitle(this.sessionId, this.title);
  @override
  List<Object?> get props => [sessionId, title];
}
