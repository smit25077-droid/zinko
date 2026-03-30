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

  /// Primary text color that adapts to the theme
  static Color textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
  }

  /// Secondary text color (muted)
  static Color secondaryTextColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
  }

  /// Tertiary text color (more muted)
  static Color tertiaryTextColor(BuildContext context) {
    return OptimizedColors.secondaryTextColor(context);
  }

  /// Background overlay factor for general screens
  static Color backgroundOverlay(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? OptimizedColors.backgroundDark70
        : OptimizedColors.backgroundLight50;
  }

  /// Shadow color for glass depth
  static Color shadowColor(BuildContext context) {
    return OptimizedColors.black30;
  }

  /// Icon color for navigation and UI elements
  static Color iconColor(BuildContext context, {bool isSelected = false}) {
    return OptimizedColors.iconColor(context, isSelected: isSelected);
  }

  /// Shadow for extra depth on glass containers
  static BoxShadow glassShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxShadow(
      color: isDark
          ? OptimizedColors.black30
          : OptimizedColors.black05,
      blurRadius: 20,
      offset: const Offset(0, 10),
    );
  }
}
