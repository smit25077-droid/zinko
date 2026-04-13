import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ZinkoFlushbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Success",
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Error",
      backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Information",
      backgroundColor: Colors.blueAccent.withValues(alpha: 0.9),
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: duration,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required String title,
    required Color backgroundColor,
    required Icon icon,
    required Duration duration,
  }) {
    Flushbar(
      title: title,
      message: message,
      duration: duration,
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: backgroundColor,
      icon: icon,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
    ).show(context);
  }
}
