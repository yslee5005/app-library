import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/prayer_player.dart';
import '../../../widgets/typewriter_text.dart';

class PrayerSummaryCard extends StatelessWidget {
  final PrayerSummary prayerSummary;
  final String title;
  final String gratitudeLabel;
  final String petitionLabel;
  final String intercessionLabel;
  final String? audioUrl;
  final String? audioLabel;

  /// 2026-04-23 Phase 4 — ChatGPT-style fake streaming for the first
  /// time a user sees this summary after AI analysis completes. Forces
  /// the card open (no tap-to-expand gate) and types each item out at
  /// ~25 chars/second. Revisits from Calendar/History should pass false
  /// so the summary renders instantly.
  final bool animate;

  const PrayerSummaryCard({
    super.key,
    required this.prayerSummary,
    required this.title,
    required this.gratitudeLabel,
    required this.petitionLabel,
    required this.intercessionLabel,
    this.audioUrl,
    this.audioLabel,
    this.animate = false,
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
      initiallyExpanded: animate,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (prayerSummary.gratitude.isNotEmpty)
            _buildSection(
              gratitudeLabel,
              prayerSummary.gratitude,
              AbbaColors.sage,
            ),
          if (prayerSummary.petition.isNotEmpty)
            _buildSection(
              petitionLabel,
              prayerSummary.petition,
              AbbaColors.softGold,
            ),
          if (prayerSummary.intercession.isNotEmpty)
            _buildSection(
              intercessionLabel,
              prayerSummary.intercession,
              AbbaColors.softPink,
            ),
          if (audioUrl != null) _buildAudioSection(),
        ],
      ),
    );
  }

  Widget _buildAudioSection() {
    return Padding(
      padding: const EdgeInsets.only(top: AbbaSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (audioLabel != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                audioLabel!,
                style: AbbaTypography.caption.copyWith(
                  color: AbbaColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          PrayerPlayer(audioUrl: audioUrl!),
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
                    child: TypewriterText(
                      text: item,
                      style: AbbaTypography.bodySmall,
                      animate: animate,
                    ),
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
