import 'package:flutter/material.dart';

class ModelBadge extends StatelessWidget {
  final String model;
  final bool ready;
  const ModelBadge({super.key, required this.model, required this.ready});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ready
                ? const Color(0xFF34D399)
                : const Color(0xFFF59E0B),
          ),
        ),
        const SizedBox(width: 6),
        Text(model.isEmpty ? 'Chat' : model,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500)),
        if (model.isNotEmpty) ...[
          const SizedBox(width: 4),
          Text(ready ? '· Ready' : '· Generating',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF78716C))),
        ],
      ],
    );
  }
}
