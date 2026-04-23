import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;
  final ImageProvider<Object>? image;
  final Color? backgroundColor;

  const ZinkoBackground({
    super.key,
    this.child,
    this.showOverlay = true,
    this.image,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Static Background Layer - uses physical screen size to ignore keyboard resizing
        Positioned(
          top: 0,
          left: 0,
          width: screenSize.width,
          height: screenSize.height,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor ?? AppColors.backgroundDark,
              image: DecorationImage(
                image: image ??
                    const AssetImage('assets/images/dark_theme_bg.png'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: showOverlay
                      ? OptimizedColors.backgroundDark70
                      : Colors.transparent,
                ),
              ),
            ),
          ),
        ),
        // Content Layer
        if (child != null) child!,
      ],
    );
  }
}
