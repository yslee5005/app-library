import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A centered placeholder shown when a list or section has no content.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    required this.title,
    this.subtitle,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.iconSize = 64,
    this.spacing,
    super.key,
  });

  /// Primary message.
  final String title;

  /// Secondary explanatory text.
  final String? subtitle;

  /// Large icon shown above the title.
  final IconData? icon;

  /// Label for the optional action button.
  final String? actionLabel;

  /// Called when the action button is tapped.
  final VoidCallback? onAction;

  /// Size of the [icon].
  final double iconSize;

  /// Optional spacing between elements.
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize,
                color: theme.colorScheme.onSurfaceVariant.withAlpha(160),
              ),
              SizedBox(height: spacing ?? AppSpacing.md),
            ],
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: spacing ?? AppSpacing.sm),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: spacing ?? AppSpacing.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
