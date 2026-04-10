import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class ZinkoBackground extends StatelessWidget {
  final Widget? child;
  final bool showOverlay;

  const ZinkoBackground({super.key, this.child, this.showOverlay = true});

  @override
  Widget build(BuildContext context) {
    final view = View.of(context);
    final screenSize = view.physicalSize / view.devicePixelRatio;

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
              color: AppColors.backgroundDark,
              image: const DecorationImage(
                image: AssetImage('assets/images/dark_theme_bg.png'),
                fit: BoxFit.cover,
                opacity: 0.2,
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
