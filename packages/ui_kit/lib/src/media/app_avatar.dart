import 'package:flutter/material.dart';

/// Predefined avatar sizes.
enum AvatarSize {
  /// 24 px radius.
  sm(24),

  /// 36 px radius.
  md(36),

  /// 48 px radius.
  lg(48);

  const AvatarSize(this.radius);

  /// Radius in logical pixels.
  final double radius;
}

/// A circle avatar that shows an image from [imageUrl] and falls back to
/// initials when the image is unavailable.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    this.imageUrl,
    this.name,
    this.size = AvatarSize.md,
    this.customRadius,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  /// Network image URL.
  final String? imageUrl;

  /// Full name used to derive initials when [imageUrl] is null or fails.
  final String? name;

  /// Predefined size.
  final AvatarSize size;

  /// Custom radius that overrides [size].
  final double? customRadius;

  /// Background colour for the initials fallback.
  final Color? backgroundColor;

  /// Text colour for the initials fallback.
  final Color? foregroundColor;

  String _initials() {
    if (name == null || name!.trim().isEmpty) return '?';
    final parts = name!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = customRadius ?? size.radius;
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final fg = foregroundColor ?? theme.colorScheme.onPrimaryContainer;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bg,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        _initials(),
        style: theme.textTheme.titleMedium?.copyWith(
          color: fg,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
