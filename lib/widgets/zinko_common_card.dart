import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/common_util.dart';

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
  final Color? borderColor;
  final List<Color>? gradientColors;

  const ZinkoCommonCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = CommonUtil.r24,
    this.padding = CommonUtil.pAll16,
    this.margin,
    this.onTap,
    this.isSelected = false,
    this.showBorder = true,
    this.backgroundColor,
    this.borderColor,
    this.gradientColors,
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
            color: AppColors.backgroundDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (isSelected)
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.2),
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
            splashColor: AppColors.secondary.withValues(alpha: 0.1),
            highlightColor: AppColors.secondary.withValues(alpha: 0.05),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: showBorder
                    ? Border.all(
                        color: borderColor ?? (isSelected 
                            ? AppColors.secondary.withValues(alpha: 0.5)
                            : Colors.white.withValues(alpha: 0.1)),
                        width: 1.5,
                      )
                    : null,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors ?? [
                    (backgroundColor ?? AppColors.backgroundDark).withValues(alpha: 0.8),
                    (backgroundColor ?? AppColors.backgroundDark).withValues(alpha: 0.4),
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
                            AppColors.primaryDark.withValues(alpha: 0.1),
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
