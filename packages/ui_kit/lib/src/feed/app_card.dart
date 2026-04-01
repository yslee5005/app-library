import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Layout direction for [AppCard].
enum AppCardLayout { vertical, horizontal }

/// A card with optional image, title, subtitle, and trailing action.
///
/// Supports both vertical (image on top) and horizontal (image on left) layouts.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.title,
    this.subtitle,
    this.image,
    this.trailing,
    this.onTap,
    this.layout = AppCardLayout.vertical,
    this.imageHeight = 160.0,
    this.imageWidth = 120.0,
    super.key,
  });

  /// Card title.
  final String title;

  /// Optional subtitle.
  final String? subtitle;

  /// Optional image widget.
  final Widget? image;

  /// Optional trailing action widget (e.g. icon button, badge).
  final Widget? trailing;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Layout direction.
  final AppCardLayout layout;

  /// Image height for vertical layout.
  final double imageHeight;

  /// Image width for horizontal layout.
  final double imageWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: layout == AppCardLayout.vertical
            ? _buildVertical(theme)
            : _buildHorizontal(theme),
      ),
    );
  }

  Widget _buildVertical(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          SizedBox(
            height: imageHeight,
            width: double.infinity,
            child: image,
          ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontal(ThemeData theme) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (image != null)
            SizedBox(
              width: imageWidth,
              child: image,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: trailing,
            ),
        ],
      ),
    );
  }
}
