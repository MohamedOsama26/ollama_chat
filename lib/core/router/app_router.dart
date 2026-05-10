import 'package:go_router/go_router.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/sessions/presentation/pages/sessions_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/models/presentation/pages/model_picker_page.dart';
import '../shell/main_shell.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/chat',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/chat',
            builder: (context, state) => const SessionsPage(),
          ),
          GoRoute(
            path: '/chat/:sessionId',
            builder: (context, state) {
              final args =
                  state.extra as ({String message, bool autoSend})?;
              return ChatPage(
                sessionId: state.pathParameters['sessionId']!,
                initialMessage: args?.message,
                autoSend: args?.autoSend ?? false,
              );
            },
          ),
          GoRoute(
            path: '/models',
            builder: (context, state) => const ModelPickerPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
