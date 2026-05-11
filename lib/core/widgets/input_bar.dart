import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ollama_chat/core/theme/app_theme.dart';

class InputBar extends StatefulWidget {
  final TextEditingController? controller;
  final List<String> chips;
  final void Function(String) onSend;
  final void Function(String)? onChipTap;
  final bool isStreaming;
  final VoidCallback? onStop;

  const InputBar({
    super.key,
    this.controller,
    this.chips = const [],
    required this.onSend,
    this.onChipTap,
    this.isStreaming = false,
    this.onStop,
  });

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

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmpty = _controller.text.isEmpty;
    final showChips = widget.chips.isNotEmpty && !widget.isStreaming;
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: scaffoldBg,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showChips)
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: widget.chips.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => ActionChip(
                    label: Text(widget.chips[i],
                        style: const TextStyle(fontSize: 12)),
                    onPressed: () =>
                        (widget.onChipTap ?? widget.onSend)(widget.chips[i]),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    side: BorderSide(color: colorScheme.outlineVariant),
                    labelStyle: TextStyle(color: colorScheme.onSurface),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: colorScheme.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      color: colorScheme.onSurfaceVariant,
                      onPressed: widget.isStreaming ? null : () {},
                      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: CallbackShortcuts(
                        bindings: {
                          const SingleActivator(LogicalKeyboardKey.enter): () {
                            if (!HardwareKeyboard.instance.isShiftPressed) {
                              _send();
                            }
                          },
                        },
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          maxLines: 5,
                          minLines: 1,
                          enabled: !widget.isStreaming,
                          textInputAction: TextInputAction.newline,
                          onSubmitted: (_) => _send(),
                          decoration: InputDecoration(
                            hintText: widget.isStreaming
                                ? 'Generating...'
                                : 'Ask anything...',
                            hintStyle: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 14),
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 4),
                          ),
                          style: TextStyle(
                              color: colorScheme.onSurface, fontSize: 14),
                        ),
                      ),
                    ),
                    if (widget.isStreaming)
                      IconButton(
                        icon: const Icon(Icons.stop_circle_outlined, size: 22),
                        color: colorScheme.error,
                        onPressed: widget.onStop,
                        padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
                        constraints: const BoxConstraints(),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isEmpty
                              ? Colors.transparent
                              : AppTheme.primary.withValues(alpha: 0.15),
                        ),
                        child: IconButton(
                          icon: isEmpty
                              ? const Icon(Icons.mic_none_rounded, size: 20)
                              : const Icon(Icons.send_rounded, size: 20),
                          color: isEmpty
                              ? colorScheme.onSurfaceVariant
                              : AppTheme.primary,
                          onPressed: isEmpty ? null : _send,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.expand(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
