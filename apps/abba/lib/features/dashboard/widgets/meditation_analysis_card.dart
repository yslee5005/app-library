import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class MeditationAnalysisCard extends StatelessWidget {
  final MeditationAnalysis analysis;
  final String title;
  final String keyThemeLabel;
  final String locale;
  final bool initiallyExpanded;

  const MeditationAnalysisCard({
    super.key,
    required this.analysis,
    required this.title,
    required this.keyThemeLabel,
    required this.locale,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Phase 1 (qt_output_redesign): keyTheme is absorbed by MeditationSummary.topic
    // in new records. Fall back to insight preview when missing.
    final theme = analysis.keyTheme(locale);
    final insight = analysis.insight(locale);
    final summary = theme.isNotEmpty
        ? theme
        : (insight.length <= 40 ? insight : '${insight.substring(0, 40)}...');
    return ExpandableCard(
      icon: '🔍',
      title: title,
      summary: summary,
      initiallyExpanded: initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (theme.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.sm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AbbaRadius.sm),
              ),
              child: Text(
                '$keyThemeLabel: $theme',
                style: AbbaTypography.body.copyWith(
                  color: AbbaColors.sage,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
          ],
          Text(insight, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
