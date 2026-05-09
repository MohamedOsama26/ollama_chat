import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection.dart';
import '../errors/app_constants.dart';
import '../../features/sessions/bloc/sessions_bloc.dart';
import '../../features/sessions/widgets/sessions_sidebar.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SessionsBloc>()..add(LoadSessions()),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop =
              constraints.maxWidth >= AppConstants.tabletBreakpoint;
          if (isDesktop) {
            return _DesktopLayout(child: child);
          }
          return _MobileLayout(child: child);
        },
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final Widget child;
  const _DesktopLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: AppConstants.sidebarWidth,
            child: const SessionsSidebar(),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final Widget child;
  const _MobileLayout({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Color(0xFF171512),
        child: SessionsSidebar(),
      ),
      body: child,
    );
  }
}
