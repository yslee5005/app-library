import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class ScriptureCard extends StatefulWidget {
  final Scripture scripture;
  final String title;
  final String locale;
  final bool initiallyExpanded;

  const ScriptureCard({
    super.key,
    required this.scripture,
    required this.title,
    required this.locale,
    this.initiallyExpanded = false,
  });

  @override
  State<ScriptureCard> createState() => _ScriptureCardState();
}

class _ScriptureCardState extends State<ScriptureCard> {
  bool _originalWordsExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scripture = widget.scripture;
    final locale = widget.locale;

    return ExpandableCard(
      icon: '📜',
      title: widget.title,
      summary: scripture.reference,
      initiallyExpanded: widget.initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(scripture.verse(locale), style: AbbaTypography.body),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            '— ${scripture.reference}',
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.muted,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (scripture.reason(locale).isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _buildSageBox(
              icon: '❓',
              label: l10n.scriptureReasonLabel,
              body: scripture.reason(locale),
            ),
          ],
          if (scripture.posture(locale).isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.sm),
            _buildSageBox(
              icon: '🌿',
              label: l10n.scripturePostureLabel,
              body: scripture.posture(locale),
            ),
          ],
          if (scripture.originalWords.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _buildOriginalWordsSection(l10n, locale),
          ],
        ],
      ),
    );
  }

  Widget _buildSageBox({
    required String icon,
    required String label,
    required String body,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.sm),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(
                label,
                style: AbbaTypography.caption.copyWith(
                  color: AbbaColors.sage,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.sage,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginalWordsSection(AppLocalizations l10n, String locale) {
    final count = widget.scripture.originalWords.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () =>
              setState(() => _originalWordsExpanded = !_originalWordsExpanded),
          borderRadius: BorderRadius.circular(AbbaRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Text('🔤', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    l10n.scriptureOriginalWordsTitle,
                    style: AbbaTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AbbaColors.warmBrown,
                    ),
                  ),
                ),
                Text(
                  l10n.originalWordsCountLabel(count),
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _originalWordsExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                  size: 20,
                  color: AbbaColors.muted,
                ),
              ],
            ),
          ),
        ),
        if (_originalWordsExpanded)
          ...widget.scripture.originalWords.asMap().entries.map((entry) {
            final idx = entry.key;
            final word = entry.value;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (idx > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.sm),
                    child: Divider(
                      color: AbbaColors.muted.withValues(alpha: 0.2),
                      height: 1,
                    ),
                  ),
                _buildOriginalWord(l10n, locale, word),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildOriginalWord(AppLocalizations l10n, String locale, ScriptureOriginalWord word) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Directionality(
            textDirection: word.isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Text(
              word.word,
              style: AbbaTypography.hero.copyWith(fontSize: 32),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            '${word.transliteration} · ${word.language}',
            style: AbbaTypography.caption.copyWith(
              fontStyle: FontStyle.italic,
              color: AbbaColors.muted,
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.sm),
        _buildLabeledLine(l10n.originalWordMeaningLabel, word.meaning(locale)),
        if (word.nuance(locale).isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildLabeledLine(l10n.originalWordNuanceLabel, word.nuance(locale)),
        ],
      ],
    );
  }

  Widget _buildLabeledLine(String label, String body) {
    return RichText(
      text: TextSpan(
        style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.warmBrown),
        children: [
          TextSpan(
            text: '$label: ',
            style: AbbaTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: AbbaColors.warmBrown,
            ),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}
