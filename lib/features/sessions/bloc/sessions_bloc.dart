import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';

part 'sessions_event.dart';
part 'sessions_state.dart';

class SessionsBloc extends Bloc<SessionsEvent, SessionsState> {
  final GetSessionsUseCase getSessions;
  final CreateSessionUseCase createSession;
  final DeleteSessionUseCase deleteSession;

  SessionsBloc({
    required this.getSessions,
    required this.createSession,
    required this.deleteSession,
  }) : super(const SessionsState()) {
    on<LoadSessions>(_onLoad);
    on<CreateSession>(_onCreate);
    on<DeleteSession>(_onDelete);
    on<UpdateSessionTitle>(_onUpdateTitle);
  }

  Future<void> _onLoad(LoadSessions event, Emitter<SessionsState> emit) async {
    emit(state.copyWith(isLoading: true));
    final result = await getSessions();
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (sessions) => emit(state.copyWith(isLoading: false, sessions: sessions)),
    );
  }

  Future<void> _onCreate(CreateSession event, Emitter<SessionsState> emit) async {
    final session = ChatSession(
      id: const Uuid().v4(),
      title: 'New chat',
      model: event.model,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      systemPrompt: event.systemPrompt,
    );
    final result = await createSession(session);
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (s) => emit(state.copyWith(sessions: [s, ...state.sessions])),
    );
  }

  Future<void> _onDelete(DeleteSession event, Emitter<SessionsState> emit) async {
    await deleteSession(event.sessionId);
    emit(state.copyWith(
        sessions: state.sessions.where((s) => s.id != event.sessionId).toList()));
  }

  void _onUpdateTitle(UpdateSessionTitle event, Emitter<SessionsState> emit) {
    final updated = state.sessions.map((s) {
      return s.id == event.sessionId ? s.copyWith(title: event.title) : s;
    }).toList();
    emit(state.copyWith(sessions: updated));
  }
}
