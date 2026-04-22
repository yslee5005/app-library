import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

/// First card of the QT Dashboard (qt_output_redesign Phase 1).
///
/// Shows a single-field summary of the user's meditation ([MeditationSummary.summary])
/// plus the passage topic ([MeditationSummary.topic]). Mirrors the
/// "Today's prayer" summary on the Prayer Dashboard.
///
/// Hides itself when both fields are empty (legacy records).
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
        ],
      ),
    );
  }
}
