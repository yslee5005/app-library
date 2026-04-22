import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

/// First card of the QT Dashboard (qt_output_redesign Phase 1 + 5C).
///
/// Shows three fields in a unified card:
///   - [MeditationSummary.summary]: 1-2 sentence summary of the user's meditation
///   - [MeditationSummary.topic]: passage topic (short line)
///   - [MeditationSummary.insight]: AI insight on how the passage meets the
///     meditation (absorbed from the removed MeditationAnalysisCard in Phase 5C)
///
/// Hides itself when all three fields are empty (legacy records).
class MeditationSummaryCard extends StatelessWidget {
  final MeditationSummary meditationSummary;
  final String title;
  final String topicLabel;

  const MeditationSummaryCard({
    super.key,
    required this.meditationSummary,
    required this.title,
    required this.topicLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (meditationSummary.isEmpty) {
      return const SizedBox.shrink();
    }
    final summary = meditationSummary.summary;
    final topic = meditationSummary.topic;
    final insight = meditationSummary.insight;

    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌱', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: AbbaTypography.h2.copyWith(
                    color: AbbaColors.warmBrown,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (summary.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Text(
              summary,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.7,
              ),
            ),
          ],
          if (topic.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.sm),
            Row(
              children: [
                Text(
                  '$topicLabel · ',
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Text(
                    topic,
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          // Phase 5C — AI insight section (absorbed from MeditationAnalysisCard).
          // Rendered below summary/topic with a subtle divider and magnifier icon.
          if (insight.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Container(
              height: 1,
              color: AbbaColors.sage.withValues(alpha: 0.25),
            ),
            const SizedBox(height: AbbaSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔍', style: TextStyle(fontSize: 18)),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Text(
                    insight,
                    style: AbbaTypography.bodySmall.copyWith(
                      color: AbbaColors.warmBrown,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
