import 'package:flutter/material.dart';

/// A row of star icons for rating input or display.
///
/// Set [onRatingChanged] to null for read-only mode.
class AppRatingBar extends StatelessWidget {
  const AppRatingBar({
    required this.rating,
    this.onRatingChanged,
    this.maxRating = 5,
    this.size = 28.0,
    this.activeColor,
    this.inactiveColor,
    this.allowHalf = false,
    super.key,
  });

  /// Current rating value.
  final double rating;

  /// Called when the user taps a star. Null makes the bar read-only.
  final ValueChanged<double>? onRatingChanged;

  /// Number of stars to display.
  final int maxRating;

  /// Size of each star icon.
  final double size;

  /// Color of filled stars. Defaults to [ColorScheme.primary].
  final Color? activeColor;

  /// Color of empty stars. Defaults to [ColorScheme.outlineVariant].
  final Color? inactiveColor;

  /// When true, tapping the left half of a star sets a .5 value.
  final bool allowHalf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.outlineVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        IconData icon;

        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        final color = rating >= starValue - 0.5 ? active : inactive;

        if (onRatingChanged == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(icon, size: size, color: color),
          );
        }

        return GestureDetector(
          onTapUp: (details) {
            if (allowHalf) {
              final isLeftHalf = details.localPosition.dx < size / 2;
              onRatingChanged!(isLeftHalf ? starValue - 0.5 : starValue.toDouble());
            } else {
              onRatingChanged!(starValue.toDouble());
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(icon, size: size, color: color),
          ),
        );
      }),
    );
  }
}
