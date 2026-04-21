import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/pro_blur.dart';

class HistoricalStoryCard extends StatelessWidget {
  final HistoricalStory historicalStory;
  final String title;
  final String lessonLabel;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const HistoricalStoryCard({
    super.key,
    required this.historicalStory,
    required this.title,
    required this.lessonLabel,
    required this.onUnlock,
    required this.isUserPremium,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = historicalStory.isPremium && !isUserPremium;

    // Locked: show ProBlur with 3-line preview
    if (isLocked) {
      return ProBlur(
        title: title,
        icon: '📖',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    // Unlocked: show ExpandableCard, collapsed by default with 3-line summary
    return ExpandableCard(
      icon: '📖',
      title: title,
      summary: historicalStory.title,
      initiallyExpanded: false,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (historicalStory.reference.isNotEmpty) ...[
            Text(
              historicalStory.reference,
              style: AbbaTypography.caption.copyWith(
                color: AbbaColors.muted,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
          ],
          Text(
            historicalStory.summary,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.7,
            ),
          ),
          if (historicalStory.lesson.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Container(
              padding: const EdgeInsets.all(AbbaSpacing.md),
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AbbaRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lessonLabel,
                          style: AbbaTypography.label.copyWith(
                            color: AbbaColors.sage,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AbbaSpacing.xs),
                        Text(
                          historicalStory.lesson,
                          style: AbbaTypography.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
