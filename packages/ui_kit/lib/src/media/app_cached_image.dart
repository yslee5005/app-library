import 'package:flutter/material.dart';

/// A network image with placeholder, error fallback, and fade-in animation.
///
/// This is a pure Flutter implementation that does not depend on
/// `cached_network_image`. For production caching, consider wrapping with
/// that package or using a similar approach.
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

    Widget image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame != null ? 1.0 : 0.0,
          duration: fadeInDuration,
          curve: Curves.easeIn,
          child: child,
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Container(
              width: width,
              height: height,
              color: theme.colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: theme.colorScheme.surfaceContainerHighest,
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            );
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}
