import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/sessions_bloc.dart';
import '../../models/bloc/models_bloc.dart';
import '../../../core/di/injection.dart';

class SessionsSidebar extends StatelessWidget {
  const SessionsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        // Header
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.smart_toy_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text('Ollama Chat',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  tooltip: 'Settings',
                ),
              ],
            ),
          ),
        ),
        // New chat button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FilledButton.icon(
            onPressed: () => _newChat(context),
            icon: const Icon(Icons.add),
            label: const Text('New chat'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1),
        // Sessions list
        Expanded(
          child: BlocBuilder<SessionsBloc, SessionsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.sessions.isEmpty) {
                return const Center(
                  child: Text('No chats yet',
                      style: TextStyle(fontSize: 13)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.sessions.length,
                itemBuilder: (context, index) {
                  final session = state.sessions[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.chat_bubble_outline, size: 18),
                    title: Text(
                      session.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                    subtitle: Text(
                      session.model,
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, size: 16),
                      onPressed: () => _confirmDelete(context, session.id),
                    ),
                    onTap: () => context.go('/chat/${session.id}'),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _newChat(BuildContext context) {
    // Show model picker first
    showModalBottomSheet(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) => getIt<ModelsBloc>()..add(LoadModels()),
        child: _ModelPickerSheet(
          onModelSelected: (model) {
            context.read<SessionsBloc>().add(CreateSession(model: model));
            Navigator.pop(context);
            // Navigate to newest session
            Future.delayed(const Duration(milliseconds: 100), () {
              final sessions = context.read<SessionsBloc>().state.sessions;
              if (sessions.isNotEmpty) {
                context.go('/chat/${sessions.first.id}');
              }
            });
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String sessionId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete chat?'),
        content: const Text('This will permanently delete this conversation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<SessionsBloc>().add(DeleteSession(sessionId));
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Choose a model',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              )
            else if (state.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Could not load models: ${state.error}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error)),
              )
            else
              ...state.models.map(
                (m) => ListTile(
                  leading: const Icon(Icons.memory),
                  title: Text(m.displayName),
                  subtitle: Text(m.sizeLabel),
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
