import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/chat_bloc.dart';
import '../../../../core/theme/app_theme.dart';

class InputBar extends StatefulWidget {
  final TextEditingController? controller;
  const InputBar({super.key, this.controller});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  static const _chips = [
    'Summarize this',
    'Translate to Arabic',
    'Make it shorter',
    'Code review',
    'Brainstorm ideas',
  ];

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(SendChatMessage(text));
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.bgDark,
            border: Border(top: BorderSide(color: Color(0xFF292524))),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!state.isStreaming)
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _chips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) => ActionChip(
                        label: Text(_chips[i],
                            style: const TextStyle(fontSize: 12)),
                        onPressed: () {
                          _controller.text = _chips[i];
                          _focusNode.requestFocus();
                        },
                        backgroundColor: AppTheme.surfaceDark,
                        side: const BorderSide(color: Color(0xFF3B3531)),
                        labelStyle:
                            const TextStyle(color: Color(0xFFD6D3D1)),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(28),
                      border:
                          Border.all(color: const Color(0xFF3B3531)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          color: const Color(0xFF78716C),
                          onPressed: state.isStreaming ? null : () {},
                          padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                          constraints: const BoxConstraints(),
                        ),
                        Expanded(
                          child: CallbackShortcuts(
                            bindings: {
                              const SingleActivator(LogicalKeyboardKey.enter):
                                  () {
                                if (!HardwareKeyboard.instance
                                    .isShiftPressed) _send();
                              },
                            },
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              maxLines: 5,
                              minLines: 1,
                              enabled: !state.isStreaming,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                hintText: state.isStreaming
                                    ? 'Generating...'
                                    : 'Ask anything...',
                                hintStyle: const TextStyle(
                                    color: Color(0xFF57534E),
                                    fontSize: 14),
                                border: InputBorder.none,
                                filled: false,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 4),
                              ),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                        if (state.isStreaming)
                          IconButton(
                            icon: const Icon(Icons.stop_circle_outlined,
                                size: 22),
                            color: const Color(0xFFF87171),
                            onPressed: () => context
                                .read<ChatBloc>()
                                .add(CancelStreaming()),
                            padding:
                                const EdgeInsets.fromLTRB(4, 12, 12, 12),
                            constraints: const BoxConstraints(),
                          )
                        else
                          IconButton(
                            icon: _controller.text.isEmpty
                                ? const Icon(Icons.mic_none_rounded, size: 20)
                                : const Icon(Icons.send_rounded, size: 20),
                            color: _controller.text.isEmpty
                                ? const Color(0xFF78716C)
                                : AppTheme.primary,
                            onPressed: _controller.text.isEmpty ? null : _send,
                            padding:
                                const EdgeInsets.fromLTRB(4, 12, 12, 12),
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
