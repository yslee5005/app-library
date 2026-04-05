import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A network image with disk/memory caching, placeholder, error fallback,
/// and fade-in animation.
///
/// Wraps [CachedNetworkImage] for automatic disk and memory caching.
class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    super.key,
  });

  /// URL of the image to load.
  final String imageUrl;

  /// Width constraint.
  final double? width;

  /// Height constraint.
  final double? height;

  /// How the image should be inscribed in its bounds.
  final BoxFit fit;

  /// Optional border radius for clipping.
  final BorderRadius? borderRadius;

  /// Widget shown while the image is loading.
  final Widget? placeholder;

  /// Widget shown when the image fails to load.
  final Widget? errorWidget;

  /// Duration of the fade-in animation.
  final Duration fadeInDuration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: fadeInDuration,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: theme.colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: theme.colorScheme.surfaceContainerHighest,
            alignment: Alignment.center,
            child: Icon(
              Icons.broken_image_outlined,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}
