import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;

  const ZinkoBackground({super.key, this.child, this.showOverlay = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;




    return Stack(
      children: [
        // The background image toggle based on theme
        Positioned.fill(
          child: Image.asset(
            isDark ? 'assets/images/dark_theme_bg.png' : 'assets/images/light_theme_bg.png',
            fit: BoxFit.cover,
            cacheWidth: 1080, 
          ),
        ),
        // Premium Blur and Theme Overlay for deep visibility
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.6)
                    : AppColors.backgroundLight.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}
