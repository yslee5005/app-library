import 'package:flutter/material.dart';

import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class RelatedKnowledgeCard extends StatelessWidget {
  final RelatedKnowledge knowledge;
  final String title;
  final String originalWordLabel;
  final String historicalContextLabel;
  final String crossReferencesLabel;
  final String locale;

  const RelatedKnowledgeCard({
    super.key,
    required this.knowledge,
    required this.title,
    required this.originalWordLabel,
    required this.historicalContextLabel,
    required this.crossReferencesLabel,
    required this.locale,
  });

  String get _summary {
    final parts = <String>[];
    if (knowledge.originalWord != null) parts.add('원어');
    parts.add('역사');
    if (knowledge.crossReferences.isNotEmpty) parts.add('교차참조');
    return parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '🔤',
      title: title,
      summary: _summary,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original Word
          if (knowledge.originalWord != null) ...[
            Text(
              originalWordLabel,
              style: AbbaTypography.caption.copyWith(
                color: AbbaColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AbbaSpacing.sm),
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AbbaRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${knowledge.originalWord!.word}  (${knowledge.originalWord!.transliteration})',
                    style: AbbaTypography.h2,
                  ),
                  Text(
                    knowledge.originalWord!.language,
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    knowledge.originalWord!.meaning(locale),
                    style: AbbaTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
          ],
          // Historical Context
          Text(
            historicalContextLabel,
            style: AbbaTypography.caption.copyWith(
              color: AbbaColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            knowledge.historicalContext(locale),
            style: AbbaTypography.bodySmall,
          ),
          // Cross References
          if (knowledge.crossReferences.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Text(
              crossReferencesLabel,
              style: AbbaTypography.caption.copyWith(
                color: AbbaColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            for (final ref in knowledge.crossReferences)
              Padding(
                padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ref.reference,
                      style: AbbaTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AbbaColors.sage,
                      ),
                    ),
                    if (ref.text.isNotEmpty)
                      Text(
                        ref.text,
                        style: AbbaTypography.bodySmall.copyWith(
                          fontStyle: FontStyle.italic,
                          height: 1.5,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
