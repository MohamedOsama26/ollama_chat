import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_chat/features/settings/presentation/bloc/settings_bloc.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      icon: Icon(isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          size: 20),
      color: const Color(0xFF78716C),
      onPressed: () {
        context
            .read<SettingsBloc>()
            .add(UpdateTheme(isDark ? ThemeMode.light : ThemeMode.dark));
      },
    );
  }
}
