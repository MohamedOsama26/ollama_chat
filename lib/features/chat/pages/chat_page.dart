import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../features/sessions/bloc/sessions_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';

class ChatPage extends StatelessWidget {
  final String sessionId;
  const ChatPage({super.key, required this.sessionId});

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
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView();

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final ScrollController _scrollController = ScrollController();

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
            icon: const Icon(Icons.menu),
            onPressed: () {
              final scaffold = Scaffold.maybeOf(context);
              if (scaffold?.hasDrawer == true) {
                scaffold!.openDrawer();
              }
            },
          ),
        ),
        title: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) => Text(
            state.session?.title ?? 'Chat',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        actions: [
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) => Chip(
              label: Text(
                state.session?.model ?? '',
                style: const TextStyle(fontSize: 12),
              ),
              avatar: const Icon(Icons.smart_toy_outlined, size: 14),
            ),
          ),
          const SizedBox(width: 8),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.messages.isEmpty) {
                  return const _EmptyChat();
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
          Icon(Icons.smart_toy_outlined,
              size: 64, color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text('Start a conversation',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Type a message below to begin',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
