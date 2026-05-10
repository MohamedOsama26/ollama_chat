
import 'package:flutter/material.dart';
import 'package:ollama_chat/core/theme/app_theme.dart' show AppTheme;

class EmptyChat extends StatelessWidget {
  const EmptyChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.primary, AppTheme.amber],
              ),
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Start the conversation',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          const SizedBox(height: 6),
          const Text('Type a message below to begin',
              style: TextStyle(
                  fontSize: 13, color: Color(0xFF78716C))),
        ],
      ),
    );
  }
}
