part of 'sessions_bloc.dart';

class SessionsState extends Equatable {
  final List<ChatSession> sessions;
  final bool isLoading;
  final String? error;

  const SessionsState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
  });

  SessionsState copyWith({
    List<ChatSession>? sessions,
    bool? isLoading,
    String? error,
  }) =>
      SessionsState(
        sessions: sessions ?? this.sessions,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );

  @override
  List<Object?> get props => [sessions, isLoading, error];
}
