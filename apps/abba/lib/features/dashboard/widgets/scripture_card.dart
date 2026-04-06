import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class ScriptureCard extends StatelessWidget {
  final Scripture scripture;
  final String title;
  final String locale;

  const ScriptureCard({
    super.key,
    required this.scripture,
    required this.title,
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
              const Text('📜', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(title, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(scripture.verse(locale), style: AbbaTypography.body),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            '— ${scripture.reference}',
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.muted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
