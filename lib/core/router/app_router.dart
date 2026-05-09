import 'package:go_router/go_router.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/sessions/pages/sessions_page.dart';
import '../../features/settings/pages/settings_page.dart';
import '../../features/models/pages/model_picker_page.dart';
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
            builder: (context, state) => ChatPage(
              sessionId: state.pathParameters['sessionId']!,
              initialMessage: state.extra as String?,
            ),
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
