import 'package:flutter/material.dart';

/// Gamification streak badge with customizable icon levels.
class StreakBadge extends StatelessWidget {
  const StreakBadge({
    super.key,
    required this.days,
    this.levels = defaultLevels,
    this.daysStyle,
    this.labelStyle,
  });

  final int days;
  final List<StreakLevel> levels;
  final TextStyle? daysStyle;
  final TextStyle? labelStyle;

  static const defaultLevels = [
    StreakLevel(threshold: 1, icon: '🌱'),
    StreakLevel(threshold: 8, icon: '🌿'),
    StreakLevel(threshold: 15, icon: '🌷'),
    StreakLevel(threshold: 31, icon: '🌸'),
    StreakLevel(threshold: 60, icon: '🌳'),
  ];

  String get icon {
    var result = levels.first.icon;
    for (final level in levels) {
      if (days >= level.threshold) result = level.icon;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 8),
        Text('$days', style: daysStyle ?? Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

class StreakLevel {
  const StreakLevel({required this.threshold, required this.icon});

  final int threshold;
  final String icon;
}
