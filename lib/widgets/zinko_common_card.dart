import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// A performance-optimized glass card that feels premium without heavy device load.
/// Uses gradients and highlights instead of BackdropFilter to ensure smooth performance.
class ZinkoCommonCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showBorder;
  final Color? backgroundColor;

  const ZinkoCommonCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 24.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.onTap,
    this.isSelected = false,
    this.showBorder = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.midnightNavy.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (isSelected)
            BoxShadow(
              color: AppColors.brightBlue.withValues(alpha: 0.2),
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: AppColors.brightBlue.withValues(alpha: 0.1),
            highlightColor: AppColors.brightBlue.withValues(alpha: 0.05),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: showBorder
                    ? Border.all(
                        color: isSelected 
                            ? AppColors.brightBlue.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.1),
                        width: 1.5,
                      )
                    : null,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (backgroundColor ?? AppColors.midnightNavy).withValues(alpha: 0.8),
                    (backgroundColor ?? AppColors.midnightNavy).withValues(alpha: 0.4),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Subtle highlight for glass effect
                  Positioned(
                    top: -50,
                    left: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.royalBlue.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
