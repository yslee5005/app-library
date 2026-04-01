import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Type of progress indicator.
enum ProgressBarType { linear, circular }

/// A themed progress indicator with label and percentage text.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    required this.value,
    this.type = ProgressBarType.linear,
    this.label,
    this.showPercentage = true,
    this.height = 8,
    this.circularSize = 64,
    this.color,
    this.backgroundColor,
    super.key,
  });

  /// Progress value between 0.0 and 1.0.
  final double value;

  /// Linear or circular indicator.
  final ProgressBarType type;

  /// Optional label above/below the indicator.
  final String? label;

  /// Whether to display the percentage text.
  final bool showPercentage;

  /// Height of the linear bar.
  final double height;

  /// Size of the circular indicator.
  final double circularSize;

  /// Active colour. Defaults to [ColorScheme.primary].
  final Color? color;

  /// Track colour. Defaults to a low-opacity surface.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = color ?? theme.colorScheme.primary;
    final trackColor =
        backgroundColor ?? theme.colorScheme.surfaceContainerHighest;
    final percentText = '${(value.clamp(0, 1) * 100).round()}%';

    return switch (type) {
      ProgressBarType.linear => _buildLinear(theme, activeColor, trackColor, percentText),
      ProgressBarType.circular => _buildCircular(theme, activeColor, trackColor, percentText),
    };
  }

  Widget _buildLinear(
    ThemeData theme,
    Color activeColor,
    Color trackColor,
    String percentText,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(label!, style: theme.textTheme.labelMedium),
                if (showPercentage)
                  Text(
                    percentText,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: height,
            color: activeColor,
            backgroundColor: trackColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCircular(
    ThemeData theme,
    Color activeColor,
    Color trackColor,
    String percentText,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: circularSize,
          height: circularSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value.clamp(0, 1),
                strokeWidth: 6,
                color: activeColor,
                backgroundColor: trackColor,
              ),
              if (showPercentage)
                Text(
                  percentText,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(label!, style: theme.textTheme.labelMedium),
        ],
      ],
    );
  }
}
