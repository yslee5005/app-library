import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Direction of a trend indicator on [StatCard].
enum TrendDirection { up, down, neutral }

/// A card displaying a big number, label, and an optional trend indicator.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.value,
    required this.label,
    this.trend,
    this.trendValue,
    this.icon,
    this.onTap,
    this.padding,
    this.valueStyle,
    this.labelStyle,
    super.key,
  });

  /// The big number or primary value (e.g. "1,234").
  final String value;

  /// Descriptive label below the value.
  final String label;

  /// Direction of the trend arrow. Null hides the trend indicator.
  final TrendDirection? trend;

  /// Trend percentage string (e.g. "+12%"). Shown next to the arrow.
  final String? trendValue;

  /// Optional leading icon.
  final IconData? icon;

  /// Tap handler.
  final VoidCallback? onTap;

  /// Optional padding override for card content.
  final EdgeInsetsGeometry? padding;

  /// Optional text style for the value.
  final TextStyle? valueStyle;

  /// Optional text style for the label.
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 24, color: theme.colorScheme.primary),
                const SizedBox(height: AppSpacing.sm),
              ],
              Text(
                value,
                style:
                    valueStyle ??
                    theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style:
                    labelStyle ??
                    theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
              ),
              if (trend != null && trendValue != null) ...[
                const SizedBox(height: AppSpacing.sm),
                _TrendIndicator(direction: trend!, value: trendValue!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendIndicator extends StatelessWidget {
  const _TrendIndicator({required this.direction, required this.value});

  final TrendDirection direction;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final (icon, color) = switch (direction) {
      TrendDirection.up => (Icons.trending_up, Colors.green),
      TrendDirection.down => (Icons.trending_down, theme.colorScheme.error),
      TrendDirection.neutral => (
        Icons.trending_flat,
        theme.colorScheme.onSurfaceVariant,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs),
        Text(
          value,
          style: theme.textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
