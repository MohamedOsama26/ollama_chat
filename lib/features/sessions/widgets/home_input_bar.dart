import 'package:flutter/material.dart';
import 'package:ollama_chat/core/theme/app_theme.dart';

class HomeInputBar extends StatefulWidget {
  final TextEditingController controller;
  final List<String> chips;
  final void Function(String) onSend;
  final void Function(String) onChipTap;

  const HomeInputBar({super.key, 
    required this.controller,
    required this.chips,
    required this.onSend,
    required this.onChipTap,
  });

  @override
  State<HomeInputBar> createState() => _HomeInputBarState();
}

class _HomeInputBarState extends State<HomeInputBar> {
  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => widget.onChipTap(widget.chips[i]),
                  backgroundColor: AppTheme.surfaceDark,
                  side: const BorderSide(color: Color(0xFF3B3531)),
                  labelStyle:
                      const TextStyle(color: Color(0xFFD6D3D1)),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
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
                      onPressed: () {},
                      padding: const EdgeInsets.fromLTRB(12, 12, 4, 12),
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        maxLines: 4,
                        minLines: 1,
                        onSubmitted: (v) {
                          widget.onSend(v);
                          widget.controller.clear();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Ask anything...',
                          hintStyle: TextStyle(
                              color: Color(0xFF57534E), fontSize: 14),
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 4),
                        ),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_none_rounded, size: 20),
                      color: const Color(0xFF78716C),
                      onPressed: () {},
                      padding: const EdgeInsets.fromLTRB(4, 12, 12, 12),
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
  }
}

