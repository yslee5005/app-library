import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart' show Citation;
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
    final l10n = AppLocalizations.of(context)!;
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
          // Citations (Phase 3, qt_output_redesign — mirrors AiPrayer citations)
          if (knowledge.citations.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _CitationsSection(citations: knowledge.citations, l10n: l10n),
          ],
        ],
      ),
    );
  }
}

class _CitationsSection extends StatefulWidget {
  final List<Citation> citations;
  final AppLocalizations l10n;

  const _CitationsSection({required this.citations, required this.l10n});

  @override
  State<_CitationsSection> createState() => _CitationsSectionState();
}

class _CitationsSectionState extends State<_CitationsSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(AbbaRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.xs),
            child: Row(
              children: [
                const Text('📚', style: TextStyle(fontSize: 18)),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Text(
                    '${widget.l10n.aiPrayerCitationsTitle} (${widget.citations.length})',
                    style: AbbaTypography.label.copyWith(
                      color: AbbaColors.warmBrown,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AbbaColors.muted,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: AbbaSpacing.sm),
          for (int i = 0; i < widget.citations.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.sm),
                child: Divider(
                  height: 1,
                  color: AbbaColors.warmBrown.withValues(alpha: 0.08),
                ),
              ),
            _CitationRow(citation: widget.citations[i], l10n: widget.l10n),
          ],
        ],
      ],
    );
  }
}

class _CitationRow extends StatelessWidget {
  final Citation citation;
  final AppLocalizations l10n;

  const _CitationRow({required this.citation, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final (icon, label, accent) = _typeMeta(citation.type, l10n);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: AbbaSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: AbbaTypography.caption.copyWith(
                      color: accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (citation.source.isNotEmpty) ...[
                    Text(
                      ' · ',
                      style: AbbaTypography.caption.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        citation.source,
                        style: AbbaTypography.caption.copyWith(
                          color: AbbaColors.muted,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '"${citation.content}"',
                style: AbbaTypography.bodySmall.copyWith(
                  color: AbbaColors.warmBrown,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  (String, String, Color) _typeMeta(String type, AppLocalizations l) {
    switch (type) {
      case 'science':
        return ('🔬', l.citationTypeScience, AbbaColors.softSky);
      case 'history':
        return ('📜', l.citationTypeHistory, AbbaColors.softLavender);
      case 'example':
        return ('✨', l.citationTypeExample, AbbaColors.sage);
      case 'quote':
      default:
        return ('💭', l.citationTypeQuote, AbbaColors.softGold);
    }
  }
}
