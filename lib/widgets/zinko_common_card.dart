import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/common_util.dart';

/// A premium glassmorphic card component.
/// Uses BackdropFilter for real-time background blurring and subtle gradients
/// to achieve a high-end glass effect.
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
  final double blur;
  final double opacity;

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
    this.blur = 15.0,
    this.opacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    final glassBaseColor = backgroundColor ?? AppColors.backgroundDark;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          if (isSelected)
            BoxShadow(
              color: AppColors.secondary.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: 2,
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            // Forces the filter to paint even during scroll optimization
            color: Colors.white.withValues(alpha: 0.001),
            child: Material(
              color: Colors.transparent,
            child: InkWell(
              splashFactory: InkRipple.splashFactory,
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
                      glassBaseColor.withValues(alpha: opacity + 0.1),
                      glassBaseColor.withValues(alpha: opacity),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle highlight for glass depth effect
                    Positioned(
                      top: -40,
                      left: -40,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.05),
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
      ),
    ),
    );
  }
}
