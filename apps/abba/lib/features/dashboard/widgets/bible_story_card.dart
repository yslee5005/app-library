import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class BibleStoryCard extends StatelessWidget {
  final BibleStory bibleStory;
  final String title;

  const BibleStoryCard({
    super.key,
    required this.bibleStory,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '📖',
      title: title,
      summary: bibleStory.title,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bibleStory.title,
            style: AbbaTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(bibleStory.summary, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
