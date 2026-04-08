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
    return ExpandableCard(
      icon: '🔍',
      title: title,
      summary: analysis.keyTheme(locale),
      initiallyExpanded: initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              '$keyThemeLabel: ${analysis.keyTheme(locale)}',
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.sage,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(analysis.insight(locale), style: AbbaTypography.body),
        ],
      ),
    );
  }
}
