import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;
  final ImageProvider<Object>? image;
  final Color? backgroundColor;

  const ZinkoBackground({super.key, this.child, this.showOverlay = true, this.image, this.backgroundColor});

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
                image: image ?? const AssetImage('assets/images/dark_theme_bg.png'),
                fit: BoxFit.cover,
                opacity: backgroundColor != null ? 0.7 : 0.3,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
        ),
        // Content Layer
        child ?? SizedBox(),
      ],
    );
  }
}
