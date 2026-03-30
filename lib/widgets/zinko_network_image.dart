import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ZinkoNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final BoxShadow? shadow;
  final Border? border;

  const ZinkoNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.shadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadow != null ? [shadow!] : null,
        border: border,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return Container(
              width: width,
              height: height,
              color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF2F4F7),
            ).animate(onPlay: (controller) => controller.repeat()).shimmer(
                  duration: 1200.ms,
                  color: isDark
                      ? Colors.white.withAlpha(20)
                      : Colors.white.withAlpha(255),
                );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: width,
              height: height,
              color: isDark
                  ? Colors.white.withAlpha(10)
                  : Colors.black.withAlpha(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: isDark ? Colors.white24 : Colors.black12,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap to retry',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white24 : Colors.black12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
