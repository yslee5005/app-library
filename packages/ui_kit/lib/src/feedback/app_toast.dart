import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Visual variant for [AppToast].
enum AppToastVariant { success, error, info, warning }

/// Static helper to show themed snackbar / toast messages.
///
/// Usage:
/// ```dart
/// AppToast.show(context, message: 'Saved!', variant: AppToastVariant.success);
/// ```
class AppToast {
  AppToast._();

  /// Show a themed snackbar.
  static void show(
    BuildContext context, {
    required String message,
    AppToastVariant variant = AppToastVariant.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    Color? backgroundColor,
    double? borderRadius,
  }) {
    final theme = Theme.of(context);
    final (bg, fg, icon) = _style(variant, theme);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: fg, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: fg),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor ?? bg,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.md),
          ),
          margin: const EdgeInsets.all(AppSpacing.md),
          duration: duration,
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: fg,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }

  static (Color bg, Color fg, IconData icon) _style(
    AppToastVariant variant,
    ThemeData theme,
  ) {
    return switch (variant) {
      AppToastVariant.success => (
          Colors.green.shade800,
          Colors.white,
          Icons.check_circle,
        ),
      AppToastVariant.error => (
          theme.colorScheme.error,
          theme.colorScheme.onError,
          Icons.error,
        ),
      AppToastVariant.info => (
          theme.colorScheme.inverseSurface,
          theme.colorScheme.onInverseSurface,
          Icons.info,
        ),
      AppToastVariant.warning => (
          Colors.orange.shade800,
          Colors.white,
          Icons.warning_amber,
        ),
    };
  }
}
