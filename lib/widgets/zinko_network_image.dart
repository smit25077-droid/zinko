import 'package:cached_network_image/cached_network_image.dart';
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
  final String? placeholderAsset;

  const ZinkoNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.shadow,
    this.border,
    this.placeholderAsset,
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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit,
          placeholder: (context, url) => _buildPlaceholder(isDark),
          errorWidget: (context, url, error) => _buildErrorWidget(fit),
          fadeInDuration: 300.ms,
          fadeOutDuration: 300.ms,
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      width: width,
      height: height,
      color: isDark ? const Color(0xFF1E1E2C) : const Color(0xFFF2F4F7),
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 1200.ms,
          color: isDark ? Colors.white.withAlpha(20) : Colors.white.withAlpha(255),
        );
  }

  Widget _buildErrorWidget(BoxFit fit) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          placeholderAsset ?? 'assets/images/cafe_hotel_bg.png',
          width: width,
          height: height,
          fit: fit,
        ),
        Container(
          color: Colors.black.withValues(alpha: 0.3),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: Colors.white70,
                size: 24,
              ),
              SizedBox(height: 4),
              Text(
               'Tap to retry',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
