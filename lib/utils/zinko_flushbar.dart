import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ZinkoFlushbar {
  static void showSuccess({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition? position,
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Success",
      backgroundColor: Colors.green.withValues(alpha: 0.9),
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      duration: duration,
      position: position ?? FlushbarPosition.TOP,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    FlushbarPosition? position,
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Error",
      backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: duration,
    position: position ?? FlushbarPosition.TOP,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
    FlushbarPosition? position,
    Color? backgroundColor,
  }) {
    _show(
      context: context,
      message: message,
      title: title ?? "Information",
      backgroundColor: backgroundColor ?? Colors.blueAccent.withValues(alpha: 0.9),
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: duration,
      position: position ?? FlushbarPosition.TOP,
    );
  }

  static void _show({
    required BuildContext context,
    required String message,
    required String title,
    required Color backgroundColor,
    required Icon icon,
    required Duration duration,
    required FlushbarPosition position,
  }) {
    if (!context.mounted) return;

    Flushbar(
      title: title,
      message: message,
      duration: duration,
      flushbarPosition: position,
      backgroundColor: backgroundColor,
      icon: icon,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      isDismissible: false,
    ).show(context);
  }

  static void showToast({
    required String message,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
