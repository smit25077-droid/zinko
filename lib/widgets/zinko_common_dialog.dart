import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zinko_app/core/theme/app_colors.dart';
import 'package:zinko_app/utils/glass_theme.dart';

class ZinkoCommonDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? customContent;
  final IconData? icon;
  final Color? iconColor;
  final String actionLabel;
  final Color? actionColor;
  final VoidCallback onAction;
  final String cancelLabel;
  final VoidCallback? onCancel;

  const ZinkoCommonDialog({
    super.key,
    required this.title,
    this.message,
    this.customContent,
    this.icon,
    this.iconColor,
    required this.actionLabel,
    this.actionColor,
    required this.onAction,
    this.cancelLabel = 'CANCEL',
    this.onCancel,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? message,
    Widget? customContent,
    IconData? icon,
    Color? iconColor,
    required String actionLabel,
    Color? actionColor,
    required VoidCallback onAction,
    String cancelLabel = 'CANCEL',
    VoidCallback? onCancel,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => ZinkoCommonDialog(
        title: title,
        message: message,
        customContent: customContent,
        icon: icon,
        iconColor: iconColor,
        actionLabel: actionLabel,
        actionColor: actionColor,
        onAction: onAction,
        cancelLabel: cancelLabel,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF111111).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: iconColor ?? Colors.white, size: 40),
                const SizedBox(height: 20),
              ],
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: GlassTheme.textColor(context),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              if (message != null)
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: GlassTheme.textColor(context).withValues(alpha: 0.6),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              if (customContent != null) ...[
                const SizedBox(height: 8),
                customContent!,
              ],
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: onCancel ?? () => Navigator.pop(context),
                      child: Text(
                        cancelLabel,
                        style: TextStyle(
                          color: GlassTheme.textColor(context).withValues(alpha: 0.3),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionColor ?? AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        actionLabel,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
