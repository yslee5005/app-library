import 'package:app_lib_logging/logging.dart';
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
  bool _verseExpanded = false;

  /// v7 — fold long verse passages so the rest of the card remains scannable.
  /// Triggers when (a) reference is a range (`Romans 8:31-39`), or (b) the
  /// verse text exceeds ~140 chars. Truncated preview is ~110 chars.
  static const int _verseFoldThresholdChars = 140;
  static const int _versePreviewChars = 110;

  bool _shouldFoldVerse(Scripture s) {
    if (s.verse.length <= _verseFoldThresholdChars) {
      return s.reference.contains('-') &&
          s.verse.length > _versePreviewChars;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scripture = widget.scripture;

    // Render-time diagnostic: clear signal on which UI path is taken.
    if (scripture.verse.isEmpty && scripture.reference.isNotEmpty) {
      prayerLog.info(
        '[ScriptureCard] reference-only UI: ref="${scripture.reference}" '
        '(no bundle text — check locale support and Supabase upload)',
      );
    }

    return ExpandableCard(
      icon: '📜',
      title: widget.title,
      summary: scripture.reference,
      initiallyExpanded: widget.initiallyExpanded,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (scripture.verse.isNotEmpty) ...[
            _buildVerseText(l10n, scripture),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              '— ${scripture.reference}',
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.muted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ] else ...[
            // Verse empty. Two sub-cases:
            //   (a) Phase 4.2 Phase C mid-stream — we only have the
            //       reference from SSE regex; reason/posture still arriving.
            //       Show "finding the right scripture..." placeholder.
            //   (b) Stream finished but PD bundle missing the translation →
            //       reference-only fallback (pre-Phase-C behaviour).
            // Heuristic: if reason/posture are also empty we're still in
            // the streaming window.
            if (scripture.reason.isEmpty && scripture.posture.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AbbaSpacing.md),
                decoration: BoxDecoration(
                  color: AbbaColors.sage.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AbbaColors.sage.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.sm),
                    Expanded(
                      child: Text(
                        l10n.aiScriptureValidating,
                        style: AbbaTypography.bodySmall.copyWith(
                          color: AbbaColors.muted,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
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

  Widget _buildVerseText(AppLocalizations l10n, Scripture scripture) {
    final fold = _shouldFoldVerse(scripture);
    final showFull = !fold || _verseExpanded;
    final body = showFull
        ? scripture.verse
        : '${scripture.verse.substring(0, _versePreviewChars).trimRight()}…';
    final textStyle = AbbaTypography.body.copyWith(
      color: AbbaColors.warmBrown,
      height: 1.7,
    );
    if (!fold) {
      return Text(scripture.verse, style: textStyle);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(body, style: textStyle),
        const SizedBox(height: AbbaSpacing.xs),
        InkWell(
          onTap: () => setState(() => _verseExpanded = !_verseExpanded),
          borderRadius: BorderRadius.circular(AbbaRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _verseExpanded ? l10n.seeLess : l10n.seeMore,
                  style: AbbaTypography.bodySmall.copyWith(
                    color: AbbaColors.sage,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  _verseExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: AbbaColors.sage,
                ),
              ],
            ),
          ),
        ),
      ],
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
                    padding: const EdgeInsets.symmetric(
                      vertical: AbbaSpacing.sm,
                    ),
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
    // Phase 5A — single-field (generated by Gemini in user's locale).
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
        _buildLabeledLine(l10n.originalWordMeaningLabel, word.meaning),
        if (word.nuance.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildLabeledLine(l10n.originalWordNuanceLabel, word.nuance),
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
