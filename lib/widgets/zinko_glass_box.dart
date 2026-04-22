import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zinko_app/utils/glass_theme.dart';

/// Performance-optimized Glassmorphism widget
/// Standardizes blur levels across the project.
class ZinkoGlassBox extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final Border? border;
  final bool useBlur;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;
  final Color? color;

  const ZinkoGlassBox({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2, // Base opacity for glass background
    this.borderRadius = 24.0,
    this.border,
    this.useBlur = true, // Critical for list view performance
    this.padding,
    this.boxShadow,
    this.color,
  });

  /// Standard Light Glass preset (Low Blur, Subtle Alpha)
  const factory ZinkoGlassBox.light({
    required Widget child,
    bool useBlur,
    double borderRadius,
    EdgeInsetsGeometry? padding,
  }) = _ZinkoGlassLight;

  /// Standard Thick Glass preset (High Blur, Frosty Alpha)
  const factory ZinkoGlassBox.thick({
    required Widget child,
    bool useBlur,
    double borderRadius,
    EdgeInsetsGeometry? padding,
    double blur,
    Color? color,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) = _ZinkoGlassThick;

  @override
  Widget build(BuildContext context) {
    // If not using blur for performance, we use a fallback color from OptimizedColors
    final glassBase = color ?? GlassTheme.glassColor(context).withValues(alpha: opacity);
    final borderColor = border ?? Border.all(color: GlassTheme.glassBorder(context));

    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: useBlur ? glassBase : glassBase.withValues(alpha: opacity + 0.1), // Slightly more opaque for clarity without blur
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderColor,
        boxShadow: boxShadow ?? [GlassTheme.glassShadow(context)],
      ),
      child: child,
    );

    if (useBlur && blur > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        ),
      );
    }

    return content;
  }
}

class _ZinkoGlassLight extends ZinkoGlassBox {
  const _ZinkoGlassLight({
    required super.child,
    super.useBlur = true,
    super.borderRadius = 24.0,
    super.padding,
  }) : super(
          blur: 6.0,
          opacity: 0.1,
          boxShadow: null,
        );
}

class _ZinkoGlassThick extends ZinkoGlassBox {
  const _ZinkoGlassThick({
    required super.child,
    super.useBlur = true,
    super.borderRadius = 24.0,
    super.padding,
    super.blur = 20.0,
    super.color,
    super.border,
    super.boxShadow,
  }) : super(
          opacity: 0.6,
        );
}
