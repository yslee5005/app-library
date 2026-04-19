import 'package:flutter/material.dart';

import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/prayer_player.dart';

class TestimonyCard extends StatelessWidget {
  final String testimony;
  final String title;
  final String? audioUrl;

  const TestimonyCard({
    super.key,
    required this.testimony,
    required this.title,
    this.audioUrl,
  });

  String get _summary {
    if (testimony.length <= 40) return testimony;
    return '${testimony.substring(0, 40)}...';
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '✍️',
      title: title,
      summary: _summary,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (audioUrl != null) ...[
            PrayerPlayer(audioUrl: audioUrl!),
            const SizedBox(height: AbbaSpacing.md),
          ],
          Text(testimony, style: AbbaTypography.body),
        ],
      ),
    );
  }
}
