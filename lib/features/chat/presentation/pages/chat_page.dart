import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_chat/features/chat/presentation/widgets/chat_view.dart';
import '../../../../core/di/injection.dart';
import '../../../sessions/presentation/bloc/sessions_bloc.dart';
import '../bloc/chat_bloc.dart';


class ChatPage extends StatelessWidget {
  final String sessionId;
  final String? initialMessage;
  final bool autoSend;
  const ChatPage({
    super.key,
    required this.sessionId,
    this.initialMessage,
    this.autoSend = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final sessionsBloc = context.read<SessionsBloc>();
        final session = sessionsBloc.state.sessions
            .where((s) => s.id == sessionId)
            .firstOrNull;
        final bloc = getIt<ChatBloc>();
        if (session != null) {
          bloc.add(SetSession(session));
          bloc.add(LoadMessages(sessionId));
        }
        return bloc;
      },
      child: ChatView(initialMessage: initialMessage, autoSend: autoSend),
    );
  }
}
