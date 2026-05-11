import 'package:flutter/material.dart';

class ModelBadge extends StatelessWidget {
  final String model;
  final bool ready;
  const ModelBadge({super.key, required this.model, this.ready = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dotColor =
        ready ? const Color(0xFF34D399) : const Color(0xFFF59E0B);
    final label = model.isEmpty ? 'Chat' : model;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF292524) : const Color(0xFFF5F5F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF44403C) : const Color(0xFFE7E5E4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              boxShadow: [
                BoxShadow(
                  color: dotColor.withValues(alpha: 0.55),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          if (model.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              ready ? '· ready' : '· generating…',
              style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? const Color(0xFF78716C)
                    : const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
