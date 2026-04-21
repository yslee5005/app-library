import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class ScriptureCard extends StatefulWidget {
  final Scripture scripture;
  final String title;
  final bool initiallyExpanded;

  const ScriptureCard({
    super.key,
    required this.scripture,
    required this.title,
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

    return ExpandableCard(
      icon: '📜',
      title: widget.title,
      summary: scripture.reference,
      initiallyExpanded: widget.initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scripture.verse.isNotEmpty) ...[
            Text(
              scripture.verse,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.7,
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              '— ${scripture.reference}',
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.muted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else ...[
            // PD bundle not available for this locale → reference-only fallback.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AbbaSpacing.md),
              decoration: BoxDecoration(
                color: AbbaColors.muted.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AbbaRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📖', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.bibleLookupReferenceHint,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (scripture.keyWordHint.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _buildKeyWordHintBox(l10n, scripture.keyWordHint),
          ],
          if (scripture.reason.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _buildSageBox(
              icon: '❓',
              label: l10n.scriptureReasonLabel,
              body: scripture.reason,
            ),
          ],
          if (scripture.posture.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.sm),
            _buildSageBox(
              icon: '🌿',
              label: l10n.scripturePostureLabel,
              body: scripture.posture,
            ),
          ],
          if (scripture.originalWords.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _buildOriginalWordsSection(l10n),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyWordHintBox(AppLocalizations l10n, String hint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.md),
      decoration: BoxDecoration(
        color: AbbaColors.softGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                l10n.scriptureKeyWordHintTitle,
                style: AbbaTypography.label.copyWith(
                  color: AbbaColors.softGold,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: AbbaSpacing.xs),
          Text(
            hint,
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.5,
            ),
          ),
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

  Widget _buildOriginalWordsSection(AppLocalizations l10n) {
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
                _buildOriginalWord(l10n, word),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildOriginalWord(AppLocalizations l10n, ScriptureOriginalWord word) {
    // originalWords still carry _en/_ko under the hood — Phase 6 leaves this
    // as-is (Scripture scope only). Use the current app locale to pick.
    final locale = Localizations.localeOf(context).languageCode;
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
