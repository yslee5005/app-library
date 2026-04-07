import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class MeditationAnalysisCard extends StatelessWidget {
  final MeditationAnalysis analysis;
  final String title;
  final String keyThemeLabel;
  final String locale;

  const MeditationAnalysisCard({
    super.key,
    required this.analysis,
    required this.title,
    required this.keyThemeLabel,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🔍', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(title, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
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
          Text(
            analysis.insight(locale),
            style: AbbaTypography.body,
          ),
        ],
      ),
    );
  }
}
