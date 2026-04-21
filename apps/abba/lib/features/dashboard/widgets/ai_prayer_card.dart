import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/pro_blur.dart';

class AiPrayerCard extends StatelessWidget {
  final AiPrayer aiPrayer;
  final String title;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const AiPrayerCard({
    super.key,
    required this.aiPrayer,
    required this.title,
    required this.onUnlock,
    this.isUserPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = aiPrayer.isPremium && !isUserPremium;
    final l10n = AppLocalizations.of(context)!;

    if (isLocked) {
      return ProBlur(
        title: title,
        icon: '🙏',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    return ExpandableCard(
      icon: '🙏',
      title: title,
      summary: aiPrayer.text,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aiPrayer.text,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.8,
            ),
          ),
          if (aiPrayer.citations.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.lg),
            _CitationsSection(citations: aiPrayer.citations, l10n: l10n),
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
                  _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
      case 'example':
        return ('✨', l.citationTypeExample, AbbaColors.sage);
      case 'quote':
      default:
        return ('💭', l.citationTypeQuote, AbbaColors.softGold);
    }
  }
}
