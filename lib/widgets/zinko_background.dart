import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Static Background Layer - Wrapped in RepaintBoundary to prevent 
        // the background from repainting when the child (scrolling content) repaints.
        Positioned(
          child: RepaintBoundary(
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.glassBlack,
                image: DecorationImage(
                  image: image ?? const AssetImage('assets/images/cafe_hotel_bg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  opacity: 0.4,
                ),
              ),
              child: showOverlay
                  ? Container(
                      decoration: BoxDecoration(
                        color: backgroundColor ??  Colors.black.withValues(alpha: 0.5),
                      ),
                    )
                  : null,
            ),
          ),
        ),
        // Content Layer
        if (child != null) child!,
      ],
    );
  }
}
