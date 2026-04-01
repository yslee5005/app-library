import 'package:flutter/material.dart';

/// Visual variant for [AppDialog].
enum AppDialogVariant { info, success, error, confirm }

/// A configurable dialog with title, content, and primary/secondary actions.
class AppDialog extends StatelessWidget {
  const AppDialog({
    required this.title,
    this.content,
    this.contentWidget,
    this.variant = AppDialogVariant.info,
    this.primaryLabel,
    this.secondaryLabel,
    this.onPrimary,
    this.onSecondary,
    this.icon,
    super.key,
  });

  /// Dialog title.
  final String title;

  /// Plain text content. Ignored when [contentWidget] is provided.
  final String? content;

  /// Custom content widget.
  final Widget? contentWidget;

  /// Visual variant controlling the default icon and primary button colour.
  final AppDialogVariant variant;

  /// Primary action button label.
  final String? primaryLabel;

  /// Secondary action button label.
  final String? secondaryLabel;

  /// Called when the primary button is tapped.
  final VoidCallback? onPrimary;

  /// Called when the secondary button is tapped.
  final VoidCallback? onSecondary;

  /// Custom icon. If null a default is chosen based on [variant].
  final IconData? icon;

  /// Convenience method to show the dialog.
  static Future<void> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    AppDialogVariant variant = AppDialogVariant.info,
    String? primaryLabel,
    String? secondaryLabel,
    VoidCallback? onPrimary,
    VoidCallback? onSecondary,
    IconData? icon,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        content: content,
        contentWidget: contentWidget,
        variant: variant,
        primaryLabel: primaryLabel,
        secondaryLabel: secondaryLabel,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        icon: icon,
      ),
    );
  }

  IconData get _defaultIcon => switch (variant) {
        AppDialogVariant.info => Icons.info_outline,
        AppDialogVariant.success => Icons.check_circle_outline,
        AppDialogVariant.error => Icons.error_outline,
        AppDialogVariant.confirm => Icons.help_outline,
      };

  Color _iconColor(ThemeData theme) => switch (variant) {
        AppDialogVariant.info => theme.colorScheme.primary,
        AppDialogVariant.success => Colors.green,
        AppDialogVariant.error => theme.colorScheme.error,
        AppDialogVariant.confirm => theme.colorScheme.primary,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        icon ?? _defaultIcon,
        size: 40,
        color: _iconColor(theme),
      ),
      title: Text(title, textAlign: TextAlign.center),
      content: contentWidget ??
          (content != null
              ? Text(
                  content!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                )
              : null),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        if (secondaryLabel != null)
          TextButton(
            onPressed: onSecondary ?? () => Navigator.of(context).pop(),
            child: Text(secondaryLabel!),
          ),
        if (primaryLabel != null)
          FilledButton(
            onPressed: onPrimary ?? () => Navigator.of(context).pop(),
            child: Text(primaryLabel!),
          ),
      ],
    );
  }
}
