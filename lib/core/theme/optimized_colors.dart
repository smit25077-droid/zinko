import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';

/// Optimized color utilities to replace deprecated .withOpacity() calls
/// These provide better performance and avoid precision loss
class OptimizedColors {
  // --- PERFECTED GLASS WHITES (Dark mode depth) ---
  static const Color white04 = Color(0x0AFFFFFF);
  static const Color white08 = Color(0x14FFFFFF);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white12 = Color(0x1EFFFFFF); // Perfect base for dark chips
  static const Color white16 = Color(0x29FFFFFF);
  static const Color white20 = Color(0x33FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white40 = Color(0x66FFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white60 = Color(0x99FFFFFF);
  static const Color white70 =
      Color(0xB3FFFFFF); // Perfect for secondary text on dark
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white90 = Color(0xE6FFFFFF);

  // Legacy mappings for compatibility
  // static const Color glassWhite40 = white40;
  // static const Color glassWhite60 = white60;
  static const Color white05 = Color(0x0DFFFFFF);

  // --- PERFECTED GLASS BLACKS (Light mode depth) ---
  static const Color black04 = Color(0x0A000000);
  static const Color black08 =
      Color(0x14000000); // Perfect base for light chips
  static const Color black10 = Color(0x1A000000);
  static const Color black12 = Color(0x1E000000);
  static const Color black20 = Color(0x33000000);
  static const Color black30 = Color(0x4D000000);
  static const Color black40 =
      Color(0x66000000); // Good for muted icons on light
  static const Color black50 = Color(0x80000000);
  static const Color black60 = Color(0x99000000);
  static const Color black70 =
      Color(0xB3000000); // Perfect for secondary text on light
  static const Color black80 = Color(0xCC000000);

  // Legacy mappings for compatibility
  static const Color glassBlack40 = black40;
  static const Color glassBlack60 = black60;
  static const Color black05 = Color(0x0D000000);
  static const Color black55 = Color(0x8C000000);

  // --- BACKGROUNDS & OVERLAYS ---
  static const Color backgroundDark70 = Color(0xB30D121B);
  static const Color backgroundLight50 = Color(0x80F4F6F8);
  static const Color backgroundLight70 = Color(0xB3F4F6F8);

  // --- TEXT COLORS (Vibrant Visibility) ---
  // Increased intensity for secondary text (was 0.5, now ~0.7-0.8)
  static const Color textSecondaryDark =
      Color(0xCCB3B3B3); // 0.8 opacity intensity
  static const Color textSecondaryLight =
      Color(0xCC757575); // 0.8 opacity intensity

  // Legacy / Lower intensity mappings
  static const Color textSecondaryDark50 = Color(0x80B3B3B3);
  static const Color textSecondaryLight50 = Color(0x80757575);

  // --- BORDERS (High Definition) ---
  // Optimized for sharp, visible edges on glass
  static const Color glassBorderLight = Color(0x40FFFFFF); // 0.25 opacity white
  static const Color glassBorderDark = Color(0x26000000); // 0.15 opacity black

  // Legacy mappings for compatibility
  static const Color glassBorderLight12 =
      Color(0x1FFFFFFF); // kept for very subtle look
  static const Color glassBorderDark10 = Color(0x1A000000);

  // --- ACCENTS & BRAND ---
  static const Color primary08 = Color(0x141E88E5);
  static const Color primary15 = Color(0x261E88E5);
  static const Color primary25 = Color(0x401E88E5);
  static const Color success20 = Color(0x3343A047);
  static const Color success40 = Color(0x6643A047);
  static const Color success50 = Color(0x8043A047);
  static const Color success80 = Color(0xCC43A047);
  static const Color error08 = Color(0x14E53935);
  static const Color error20 = Color(0x33E53935);
  static const Color error25 = Color(0x40E53935);
  static const Color red90 = Color(0xE6E53935);

  /// Helper to apply alpha to any color in an optimized way
  static Color applyAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  /// Helper method to get the perfect glass surface color
  /// Forced to Dark Mode for consistent Zinko premium aesthetic
  /// Uses Midnight Navy as the deep base
  static Color glassColor(BuildContext context, {bool isSelected = false}) {
    if (isSelected) {
      return applyAlpha(AppColors.secondary, 0.3); // Vibrant blue for selection
    }
    return applyAlpha(AppColors.backgroundDark, 0.7); // Deep navy base for glass
  }

  /// Helper method to get high-definition glass border
  /// Uses a subtle blue-white mix
  static Color glassBorder(BuildContext context) {
    return applyAlpha(AppColors.secondary, 0.2);
  }

  /// Helper method to get vibrant secondary text color
  static Color secondaryTextColor(BuildContext context) {
    return textSecondaryDark;
  }

  /// Helper method to get high-visibility icons
  /// Uses brand colors for selection
  static Color iconColor(BuildContext context, {bool isSelected = false}) {
    if (isSelected) {
      return AppColors.secondary;
    }
    return white70;
  }
}
