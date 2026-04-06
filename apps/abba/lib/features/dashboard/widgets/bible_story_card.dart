import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class BibleStoryCard extends StatelessWidget {
  final BibleStory bibleStory;
  final String title;
  final String locale;

  const BibleStoryCard({
    super.key,
    required this.bibleStory,
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
              const Text('📖', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Expanded(child: Text(title, style: AbbaTypography.h2)),
            ],
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            bibleStory.title(locale),
            style: AbbaTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(bibleStory.summary(locale), style: AbbaTypography.body),
        ],
      ),
    );
  }
}
