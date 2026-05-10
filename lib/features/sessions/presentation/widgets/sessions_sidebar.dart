import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/sessions_bloc.dart';
import '../../../models/presentation/bloc/models_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:ollama_chat/core/domain/entities/entities.dart';

class SessionsSidebar extends StatelessWidget {
  const SessionsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF171512) : const Color(0xFFF5F5F4);

    return Container(
      color: bg,
      child: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _SidebarHeader(onNewChat: () => _newChat(context)),
          ),
          const _SearchBar(),
          Expanded(child: _SessionList()),
          const _SidebarFooter(),
        ],
      ),
    );
  }

  void _newChat(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => getIt<ModelsBloc>()..add(LoadModels()),
        child: _ModelPickerSheet(
          onModelSelected: (model) {
            context.read<SessionsBloc>().add(CreateSession(model: model));
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 120), () {
              final sessions = context.read<SessionsBloc>().state.sessions;
              if (sessions.isNotEmpty && context.mounted) {
                context.go('/chat/${sessions.first.id}');
              }
            });
          },
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  final VoidCallback onNewChat;
  const _SidebarHeader({required this.onNewChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.primary, AppTheme.amber],
                  ),
                ),
                child: const Icon(Icons.smart_toy_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Local AI',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                  Text('Powered by Ollama',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF78716C),
                            fontSize: 11,
                          )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onNewChat,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New chat',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF57534E)),
                backgroundColor: const Color(0xFF292524),
                padding:
                    const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search,
              size: 18, color: Color(0xFF78716C)),
          hintText: 'Search chats',
          hintStyle: const TextStyle(color: Color(0xFF57534E), fontSize: 13),
          filled: true,
          fillColor: const Color(0xFF292524),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

class _SessionList extends StatelessWidget {
  _SessionList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
              child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (state.sessions.isEmpty) {
          return Center(
            child: Text('No chats yet',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13)),
          );
        }

        final groups = _groupSessions(state.sessions);
        final items = <Widget>[];

        for (final entry in groups.entries) {
          if (entry.value.isEmpty) continue;
          items.add(_GroupLabel(entry.key));
          for (final session in entry.value) {
            items.add(_SessionTile(session: session));
          }
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 8),
          children: items,
        );
      },
    );
  }

  Map<String, List<ChatSession>> _groupSessions(
      List<ChatSession> sessions) {
    final now = DateTime.now();
    final today =
        DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final groups = <String, List<ChatSession>>{
      'TODAY': [],
      'YESTERDAY': [],
      'EARLIER': [],
    };

    for (final s in sessions) {
      final d = DateTime(
          s.updatedAt.year, s.updatedAt.month, s.updatedAt.day);
      if (d == today) {
        groups['TODAY']!.add(s);
      } else if (d == yesterday) {
        groups['YESTERDAY']!.add(s);
      } else {
        groups['EARLIER']!.add(s);
      }
    }

    return groups;
  }
}

class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF57534E),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final ChatSession session;
  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isActive = currentPath == '/chat/${session.id}';

    return InkWell(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        context.go('/chat/${session.id}');
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF292524)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_bubble_outline,
                size: 15, color: Color(0xFF78716C)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isActive
                          ? Colors.white
                          : const Color(0xFFD6D3D1),
                    ),
                  ),
                  Text(
                    session.model,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF57534E)),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 14),
              color: const Color(0xFF57534E),
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 24, minHeight: 24),
              onPressed: () => _confirmDelete(context, session.id),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        title: const Text('Delete chat?',
            style: TextStyle(color: Colors.white)),
        content: const Text(
            'This will permanently delete this conversation.',
            style: TextStyle(color: Color(0xFFA8A29E))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFFA8A29E))),
          ),
          FilledButton(
            onPressed: () {
              context.read<SessionsBloc>().add(DeleteSession(sessionId));
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF991B1B)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(color: Color(0xFF292524), width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF292524),
              ),
              child: const Icon(Icons.person_outline,
                  size: 18, color: Color(0xFF78716C)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('You',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  Text('All chats stay on this device',
                      style: TextStyle(
                          fontSize: 10, color: Color(0xFF57534E))),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined, size: 18),
              color: const Color(0xFF78716C),
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () => context.go('/settings'),
              tooltip: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class _ModelPickerSheet extends StatelessWidget {
  final void Function(String model) onModelSelected;
  const _ModelPickerSheet({required this.onModelSelected});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelsBloc, ModelsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF57534E),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text('Choose a model',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: AppTheme.primary),
              )
            else if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load models: ${state.error}',
                    style: const TextStyle(color: Color(0xFFF87171))),
              )
            else
              ...state.models.map(
                (m) => ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B3531),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.memory,
                        size: 18, color: AppTheme.primary),
                  ),
                  title: Text(m.displayName,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14)),
                  subtitle: Text(m.sizeLabel,
                      style: const TextStyle(
                          color: Color(0xFF78716C), fontSize: 12)),
                  onTap: () => onModelSelected(m.name),
                ),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
