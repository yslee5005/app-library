import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';

/// Shows a soft, themed snackbar for errors and notices.
void showAbbaSnackBar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 4),
  VoidCallback? onRetry,
  String? retryLabel,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.warmBrown),
      ),
      backgroundColor: AbbaColors.cream,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.md),
        side: BorderSide(color: AbbaColors.sage.withValues(alpha: 0.3)),
      ),
      duration: duration,
      action: onRetry != null
          ? SnackBarAction(
              label: retryLabel ?? AppLocalizations.of(context)?.retryButton ?? 'Retry',
              textColor: AbbaColors.sage,
              onPressed: onRetry,
            )
          : null,
    ),
  );
}
