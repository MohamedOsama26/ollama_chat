import 'package:flutter/material.dart';
import 'package:ollama_chat/core/theme/app_theme.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hey there, ',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              TextSpan(
                text: 'friend',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "What's on your mind today?",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF78716C),
              ),
        ),
      ],
    );
  }
}
