import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ollama_chat/core/enum/model_status.dart';
import 'package:ollama_chat/features/sessions/presentation/bloc/sessions_bloc.dart';

class ModelBadge extends StatelessWidget {
  final String model;
  final bool? ready;
  const ModelBadge({super.key, required this.model, this.ready});

  static const _modelStatusColors = {
    ModelStatus.Ready: Color(0xFF34D399),
    ModelStatus.Loading: Color(0xFFFFD700),
    ModelStatus.Error: Color(0xFFEF4444),
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionsBloc, SessionsState>(builder: (context, state) {
      return Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3B3531),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF34D399),
              ),
              margin: EdgeInsets.only(right: model.isNotEmpty ? 8 : 0),
            ),
            Text(model,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 4),
            const Text('· Ready',
                style: TextStyle(fontSize: 12, color: Color(0xFF78716C))),
            const SizedBox(width: 6),
          ],
        ),
      );
    });
  }
}
