import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ollama_chat/core/utils/app_assets.dart';

class ChatAvatar extends StatefulWidget {
  final double size;
  const ChatAvatar({super.key, this.size = 100});

  @override
  State<ChatAvatar> createState() => _ChatAvatarState();
}

class _ChatAvatarState extends State<ChatAvatar> with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _winkCtrl;
  Timer? _winkTimer;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _winkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _winkTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) _winkCtrl.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _winkCtrl.dispose();
    _winkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // float: -8px (up) → +8px (down), smooth easeInOut loop
    final float = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: Listenable.merge([_floatCtrl, _winkCtrl]),
        builder: (_, child) => Transform.translate(
          offset: Offset(0, float.value),
          child: child,
        ),
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: SvgPicture.asset(AppAssets.logoMascotBlob),
        ),
      ),
    );
  }
}
