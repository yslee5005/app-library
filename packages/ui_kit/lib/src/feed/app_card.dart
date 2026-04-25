import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Layout direction for [AppCard].
enum AppCardLayout {
  /// Image on top, text below.
  vertical,

  /// Image on left, text on right.
  horizontal,

  /// Image fills the card, text overlaid on a gradient at the bottom.
  overlay,
}

/// A card with optional image, title, subtitle, and trailing action.
///
/// Supports vertical (image on top), horizontal (image on left),
/// and overlay (text over image with gradient) layouts.
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
    this.aspectRatio,
    this.overlayGradient,
    this.titleStyle,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
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

  /// Aspect ratio for the card (used in overlay layout).
  /// When set, overrides imageHeight.
  final double? aspectRatio;

  /// Custom gradient for overlay layout.
  /// Defaults to a bottom-to-top black gradient.
  final Gradient? overlayGradient;

  /// Custom text style for the title in overlay mode.
  final TextStyle? titleStyle;

  /// Optional content padding override.
  final EdgeInsetsGeometry? padding;

  /// Optional border radius override.
  final double? borderRadius;

  /// Optional card elevation override.
  final double? elevation;

  /// Optional card background color override.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: elevation,
      color: backgroundColor,
      shape:
          borderRadius != null
              ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              )
              : null,
      child: InkWell(
        onTap: onTap,
        child: switch (layout) {
          AppCardLayout.vertical => _buildVertical(theme),
          AppCardLayout.horizontal => _buildHorizontal(theme),
          AppCardLayout.overlay => _buildOverlay(theme),
        },
      ),
    );
  }

  Widget _buildVertical(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          SizedBox(height: imageHeight, width: double.infinity, child: image),
        Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
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
          if (image != null) SizedBox(width: imageWidth, child: image),
          Expanded(
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
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

  Widget _buildOverlay(ThemeData theme) {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        if (image != null) image!,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient:
                  overlayGradient ??
                  LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
            ),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style:
                        titleStyle ??
                        theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (trailing != null)
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: trailing!,
          ),
      ],
    );

    if (aspectRatio != null) {
      return AspectRatio(aspectRatio: aspectRatio!, child: content);
    }
    return SizedBox(height: imageHeight, child: content);
  }
}
