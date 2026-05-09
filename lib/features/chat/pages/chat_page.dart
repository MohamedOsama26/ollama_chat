import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/sessions/bloc/sessions_bloc.dart';
import '../../../features/settings/bloc/settings_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';

class ChatPage extends StatelessWidget {
  final String sessionId;
  final String? initialMessage;
  const ChatPage({super.key, required this.sessionId, this.initialMessage});

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
      child: _ChatView(initialMessage: initialMessage),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String? initialMessage;
  const _ChatView({this.initialMessage});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatBloc>().add(SendChatMessage(widget.initialMessage!));
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, size: 20),
            onPressed: () {
              final scaffold = Scaffold.maybeOf(context);
              if (scaffold?.hasDrawer == true) scaffold!.openDrawer();
            },
          ),
        ),
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) => _ModelBadge(
            model: state.session?.model ?? '',
            ready: !state.isStreaming,
          ),
        ),
        actions: [
          _ThemeToggle(),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state.isStreaming || state.messages.isNotEmpty) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primary, strokeWidth: 2));
                }
                if (state.messages.isEmpty) {
                  return const _EmptyChat();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 8),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) =>
                      MessageBubble(message: state.messages[index]),
                );
              },
            ),
          ),
          const InputBar(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.amber],
              ),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Start the conversation',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Type a message below to begin',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF78716C))),
        ],
      ),
    );
  }
}

class _ModelBadge extends StatelessWidget {
  final String model;
  final bool ready;
  const _ModelBadge({required this.model, required this.ready});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ready
                ? const Color(0xFF34D399)
                : const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 6),
        Text(model.isEmpty ? 'Chat' : model,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500)),
        if (model.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(ready ? '· Ready' : '· Generating',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF78716C))),
        ],
      ],
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      icon: Icon(
          isDark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
          size: 20),
      color: const Color(0xFF78716C),
      onPressed: () {
        context.read<SettingsBloc>().add(
            UpdateTheme(isDark ? ThemeMode.light : ThemeMode.dark));
      },
    );
  }
}
