import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;

  const ZinkoBackground({super.key, this.child, this.showOverlay = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Forced Dark Theme Background
        Positioned.fill(
          child: Image.asset(
            'assets/images/dark_theme_bg.png',
            fit: BoxFit.cover,
            cacheWidth: 1080,
          ),
        ),
        // Premium Dark Blur Overlay
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundDark.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
