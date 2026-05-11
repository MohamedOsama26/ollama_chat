import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_chat/core/theme/app_theme.dart';
import 'package:ollama_chat/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ollama_chat/features/chat/presentation/widgets/empty_chat.dart';
import 'package:ollama_chat/core/widgets/input_bar.dart';
import 'package:ollama_chat/features/chat/presentation/widgets/message_bubble.dart';
import 'package:ollama_chat/features/sessions/presentation/widgets/model_badge.dart';
import 'package:ollama_chat/features/sessions/presentation/widgets/theme_toggle.dart';

class ChatView extends StatefulWidget {
  final String? initialMessage;
  const ChatView({super.key, this.initialMessage});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final msg = widget.initialMessage;
    if (msg != null && msg.isNotEmpty) {
      _inputController.text = msg;
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
  void dispose() {
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
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
          builder: (context, state) => ModelBadge(
            model: state.session?.model ?? '',
            ready: !state.isStreaming,
          ),
        ),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 4),
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
                  return const EmptyChat();
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
          BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) => InputBar(
              controller: _inputController,
              onSend: (msg) =>
                  context.read<ChatBloc>().add(SendChatMessage(msg)),
              isStreaming: state.isStreaming,
              onStop: () =>
                  context.read<ChatBloc>().add(CancelStreaming()),
            ),
          ),
        ],
      ),
    );
  }
}
