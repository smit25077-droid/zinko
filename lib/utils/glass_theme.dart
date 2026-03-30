import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/optimized_colors.dart';

class GlassTheme {
  /// Base background color for glass containers
  static Color glassColor(BuildContext context) {
    return OptimizedColors.glassColor(context);
  }

  /// Border color for glass containers to define edges
  static Color glassBorder(BuildContext context) {
    return OptimizedColors.glassBorder(context);
  }

  /// Primary text color (Forced Dark)
  static Color textColor(BuildContext context) {
    return AppColors.textPrimaryDark;
  }

  /// Secondary text color (Forced Dark)
  static Color secondaryTextColor(BuildContext context) {
    return AppColors.textSecondaryDark;
  }

  /// Tertiary text color (more muted)
  static Color tertiaryTextColor(BuildContext context) {
    return OptimizedColors.secondaryTextColor(context);
  }

  /// Background overlay factor (Forced Dark)
  static Color backgroundOverlay(BuildContext context) {
    return OptimizedColors.backgroundDark70;
  }

  /// Shadow color for glass depth
  static Color shadowColor(BuildContext context) {
    return OptimizedColors.black30;
  }

  /// Icon color for navigation and UI elements
  static Color iconColor(BuildContext context, {bool isSelected = false}) {
    return OptimizedColors.iconColor(context, isSelected: isSelected);
  }

  /// Shadow for extra depth (Forced Dark)
  static BoxShadow glassShadow(BuildContext context) {
    return const BoxShadow(
      color: OptimizedColors.black30,
      blurRadius: 20,
      offset: Offset(0, 10),
    );
  }
}
