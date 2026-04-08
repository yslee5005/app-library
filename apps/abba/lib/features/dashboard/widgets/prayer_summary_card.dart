import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class PrayerSummaryCard extends StatelessWidget {
  final PrayerSummary prayerSummary;
  final String title;
  final String gratitudeLabel;
  final String petitionLabel;
  final String intercessionLabel;

  const PrayerSummaryCard({
    super.key,
    required this.prayerSummary,
    required this.title,
    required this.gratitudeLabel,
    required this.petitionLabel,
    required this.intercessionLabel,
  });

  String get _summary {
    final parts = <String>[];
    if (prayerSummary.gratitude.isNotEmpty) {
      parts.add('$gratitudeLabel ${prayerSummary.gratitude.length}');
    }
    if (prayerSummary.petition.isNotEmpty) {
      parts.add('$petitionLabel ${prayerSummary.petition.length}');
    }
    if (prayerSummary.intercession.isNotEmpty) {
      parts.add('$intercessionLabel ${prayerSummary.intercession.length}');
    }
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '📋',
      title: title,
      summary: _summary,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prayerSummary.gratitude.isNotEmpty)
            _buildSection(gratitudeLabel, prayerSummary.gratitude, AbbaColors.sage),
          if (prayerSummary.petition.isNotEmpty)
            _buildSection(petitionLabel, prayerSummary.petition, AbbaColors.softGold),
          if (prayerSummary.intercession.isNotEmpty)
            _buildSection(
              intercessionLabel,
              prayerSummary.intercession,
              AbbaColors.softPink,
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String label, List<String> items, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AbbaSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AbbaRadius.sm),
            ),
            child: Text(
              label,
              style: AbbaTypography.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: AbbaSpacing.sm, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: AbbaTypography.bodySmall),
                  Expanded(
                    child: Text(item, style: AbbaTypography.bodySmall),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
