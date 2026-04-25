import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/pro_blur.dart';

class GrowthStoryCard extends StatelessWidget {
  final GrowthStory growthStory;
  final String title;
  final String lessonLabel;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const GrowthStoryCard({
    super.key,
    required this.growthStory,
    required this.title,
    required this.lessonLabel,
    required this.onUnlock,
    required this.isUserPremium,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = growthStory.isPremium && !isUserPremium;

    return ProBlur(
      title: title,
      icon: '🌱',
      isLocked: isLocked,
      onUnlock: onUnlock,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            growthStory.title,
            style: AbbaTypography.body.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(growthStory.summary, style: AbbaTypography.bodySmall),
          const SizedBox(height: AbbaSpacing.md),
          Container(
            padding: const EdgeInsets.all(AbbaSpacing.sm),
            decoration: BoxDecoration(
              color: AbbaColors.sage.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AbbaRadius.md),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lessonLabel,
                        style: AbbaTypography.caption.copyWith(
                          color: AbbaColors.sage,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        growthStory.lesson,
                        style: AbbaTypography.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
