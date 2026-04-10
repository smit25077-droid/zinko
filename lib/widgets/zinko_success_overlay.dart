import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/app_colors.dart';

class ZinkoSuccessOverlay extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onFinish;

  const ZinkoSuccessOverlay({
    super.key,
    required this.title,
    required this.subtitle,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: Stack(
        children: [
          // Glass Background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Color.lerp(AppColors.black.withValues(alpha: 0.85),
                    AppColors.primary.withValues(alpha: 0.1), 0.1),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Tick Circle
                RepaintBoundary(
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 50,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Glow Ring
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.2),
                                width: 1.5),
                          ),
                        )
                            .animate(
                                onPlay: (controller) => controller.repeat())
                            .scale(
                                duration: 2.seconds,
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1))
                            .fadeOut(duration: 2.seconds),

                        // Main Vessel
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.white.withValues(alpha: 0.1),
                                width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.success,
                                    AppColors.success.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppColors.success.withValues(alpha: 0.5),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: AppColors.white,
                                size: 56,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .scale(
                          duration: 800.ms,
                          begin: const Offset(0.4, 0.4),
                          curve: Curves.elasticOut)
                      .then()
                      .shimmer(
                          duration: 2.seconds,
                          color: AppColors.white.withValues(alpha: 0.3)),
                ),

                const SizedBox(height: 56),

                // Success Title
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    height: 1.1,
                    shadows: [
                      Shadow(
                          color: AppColors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                ).animate(delay: 300.ms).fadeIn(),

                const SizedBox(height: 20),

                // Subtitle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.white.withValues(alpha: 0.5),
                      fontSize: 17,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.2,
                    ),
                  ),
                ).animate(delay: 500.ms).fadeIn(),

                const SizedBox(height: 60),

                // Animated Pulse Effect
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .scale(
                        duration: 1.5.seconds,
                        begin: const Offset(1, 1),
                        end: const Offset(30, 30))
                    .fadeOut(duration: 1.5.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void show(BuildContext context,
      {required String title,
      required String subtitle,
      Duration duration = const Duration(seconds: 3),
      VoidCallback? onFinish}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => ZinkoSuccessOverlay(
        title: title,
        subtitle: subtitle,
      ),
    );

    Future.delayed(duration, () {
      if (context.mounted) {
        Navigator.pop(context); // Close dialog
        if (onFinish != null) onFinish();
      }
    });
  }
}
