import 'package:flutter/material.dart';

import '../theme/abba_theme.dart';

class StreakBadge extends StatelessWidget {
  final int days;

  const StreakBadge({super.key, required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AbbaColors.streak.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AbbaRadius.xl),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 20)),
          const SizedBox(width: AbbaSpacing.xs),
          Text(
            '$days',
            style: AbbaTypography.h2.copyWith(
              color: AbbaColors.streak,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
