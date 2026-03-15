import 'package:flutter/material.dart';

class SharedSnackBar {
  static void showError(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.red);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, backgroundColor: Colors.green);
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
