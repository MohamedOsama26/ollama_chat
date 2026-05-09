import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ollama_chat/core/widgets/chat_avatar.dart';
import 'package:ollama_chat/features/sessions/widgets/greeting.dart';
import 'package:ollama_chat/features/sessions/widgets/home_input_bar.dart';
import 'package:ollama_chat/features/sessions/widgets/model_badge.dart';
import 'package:ollama_chat/features/sessions/widgets/suggestion_card.dart';
import 'package:ollama_chat/features/sessions/widgets/theme_toggle.dart';
import '../bloc/sessions_bloc.dart';
import '../../settings/bloc/settings_bloc.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();

  static const _suggestions = [
    (
      icon: Icons.calendar_today_outlined,
      color: Color(0xFFEA580C),
      title: 'Plan my day',
      sub: 'Help me prioritize tasks'
    ),
    (
      icon: Icons.restaurant_outlined,
      color: Color(0xFF10B981),
      title: 'Quick recipe',
      sub: 'What can I cook with what I have?'
    ),
    (
      icon: Icons.help_outline_rounded,
      color: Color(0xFF3B82F6),
      title: 'Explain simply',
      sub: 'Break down a complex topic'
    ),
    (
      icon: Icons.edit_outlined,
      color: Color(0xFF8B5CF6),
      title: 'Draft a message',
      sub: 'Email, text, or post'
    ),
  ];

  static const _chips = [
    'Summarize this',
    'Translate to Arabic',
    'Make it shorter',
    'Code review',
    'Brainstorm ideas',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startChat(BuildContext context, String message) {
    if (message.trim().isEmpty) return;
    // Dismiss keyboard / unfocus text fields before navigating to avoid the
    // Flutter web "DOM element not currently active" assertion.
    FocusManager.instance.primaryFocus?.unfocus();
    _controller.clear();
    final msg = message.trim();
    final model = context.read<SettingsBloc>().state.defaultModel;
    final sessionsBloc = context.read<SessionsBloc>();
    final router = GoRouter.of(context);
    sessionsBloc.add(CreateSession(model: model));
    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      final sessions = sessionsBloc.state.sessions;
      if (sessions.isNotEmpty) {
        router.go('/chat/${sessions.first.id}', extra: msg);
      }
    });
  }

  void _startChatFromSuggestion(BuildContext context, String title) {
    _startChat(context, title);
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
        title: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) => ModelBadge(model: state.defaultModel),
        ),
        actions: const [
          ThemeToggle(),
          SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        const ChatAvatar(),
                        const SizedBox(height: 24),
                        const Greeting(),
                        const SizedBox(height: 40),
                        ..._suggestions.map((s) => SuggestionCard(
                              icon: s.icon,
                              iconColor: s.color,
                              title: s.title,
                              subtitle: s.sub,
                              onTap: () =>
                                  _startChatFromSuggestion(context, s.title),
                            )),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          HomeInputBar(
            controller: _controller,
            chips: _chips,
            onSend: (msg) => _startChat(context, msg),
            onChipTap: (chip) => _startChat(context, chip),
          ),
        ],
      ),
    );
  }
}
