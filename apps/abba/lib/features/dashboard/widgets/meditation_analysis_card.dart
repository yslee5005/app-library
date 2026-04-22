import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class MeditationAnalysisCard extends StatelessWidget {
  final MeditationAnalysis analysis;
  final String title;
  final bool initiallyExpanded;

  const MeditationAnalysisCard({
    super.key,
    required this.analysis,
    required this.title,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // Phase 5A (qt_output_redesign): single-field `insight` in user's locale.
    // keyTheme is gone (MeditationSummary.topic supersedes it).
    final insight = analysis.insight;
    final summary = insight.length <= 40
        ? insight
        : '${insight.substring(0, 40)}...';
    return ExpandableCard(
      icon: '🔍',
      title: title,
      summary: summary,
      initiallyExpanded: initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(insight, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
