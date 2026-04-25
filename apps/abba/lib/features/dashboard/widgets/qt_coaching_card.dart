import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/pro_blur.dart';

/// QT Coaching card — Pro-only, evaluates the user's meditation against
/// `assets/docs/qt_guide.md`. Mirrors [PrayerCoachingCard] exactly.
/// Phase 2 of qt_output_redesign (INT-119 / INT-121).
class QtCoachingCard extends ConsumerWidget {
  final String locale;
  final bool isUserPremium;
  final VoidCallback onUnlock;

  const QtCoachingCard({
    super.key,
    required this.locale,
    required this.isUserPremium,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Free user: locked preview (no network call triggered).
    if (!isUserPremium) {
      return ProBlur(
        title: l10n.qtCoachingTitle,
        icon: '🎯',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    final coachingAsync = ref.watch(qtCoachingProvider);

    return coachingAsync.when(
      loading: () => _LoadingCard(
        title: l10n.qtCoachingTitle,
        message: l10n.qtCoachingLoadingText,
      ),
      error: (_, __) => _ErrorCard(
        title: l10n.qtCoachingTitle,
        message: l10n.qtCoachingErrorText,
        retryLabel: l10n.qtCoachingRetryButton,
        onRetry: () => ref.invalidate(qtCoachingProvider),
      ),
      data: (coaching) =>
          _DataCard(coaching: coaching, locale: locale, l10n: l10n),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  final String title;
  final String message;
  const _LoadingCard({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '🎯',
      title: title,
      summary: message,
      initiallyExpanded: true,
      expandedContent: Padding(
        padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.md),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: AbbaSpacing.md),
            Expanded(
              child: Text(
                message,
                style: AbbaTypography.bodySmall.copyWith(
                  color: AbbaColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String title;
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;
  const _ErrorCard({
    required this.title,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandableCard(
      icon: '🎯',
      title: title,
      summary: message,
      initiallyExpanded: true,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          ),
          const SizedBox(height: AbbaSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(retryLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final QtCoaching coaching;
  final String locale;
  final AppLocalizations l10n;

  const _DataCard({
    required this.coaching,
    required this.locale,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final feedback = coaching.overallFeedback(locale);
    final summary = feedback.isNotEmpty ? feedback : l10n.qtCoachingTitle;

    return ExpandableCard(
      icon: '🎯',
      title:
          '${l10n.qtCoachingTitle}  ${_levelBadgeText(coaching.expertLevel, l10n)}',
      summary: summary,
      initiallyExpanded: true,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScoresSection(scores: coaching.scores, l10n: l10n),
          if (coaching.strengths.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _BulletsSection(
              title: l10n.qtCoachingStrengthsTitle,
              bullets: coaching.strengths,
              accent: AbbaColors.sage,
            ),
          ],
          if (coaching.improvements.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            _BulletsSection(
              title: l10n.qtCoachingImprovementsTitle,
              bullets: coaching.improvements,
              accent: AbbaColors.softGold,
            ),
          ],
          if (feedback.isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Divider(color: AbbaColors.warmBrown.withValues(alpha: 0.1)),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              feedback,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _levelBadgeText(String level, AppLocalizations l) {
    switch (level) {
      case 'beginner':
        return l.qtCoachingLevelBeginner;
      case 'expert':
        return l.qtCoachingLevelExpert;
      case 'growing':
      default:
        return l.qtCoachingLevelGrowing;
    }
  }
}

class _ScoresSection extends StatelessWidget {
  final QtScores scores;
  final AppLocalizations l10n;

  const _ScoresSection({required this.scores, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final rows = <_ScoreRow>[
      _ScoreRow(
        label: l10n.qtCoachingScoreComprehension,
        score: scores.comprehension,
      ),
      _ScoreRow(
        label: l10n.qtCoachingScoreApplication,
        score: scores.application,
      ),
      _ScoreRow(label: l10n.qtCoachingScoreDepth, score: scores.depth),
      _ScoreRow(
        label: l10n.qtCoachingScoreAuthenticity,
        score: scores.authenticity,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: AbbaSpacing.xs),
          rows[i],
        ],
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final int score;

  const _ScoreRow({required this.label, required this.score});

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0, 5);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
          Expanded(
            child: Row(
              children: [
                for (int i = 1; i <= 5; i++) ...[
                  if (i > 1) const SizedBox(width: 4),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: i <= clamped
                          ? AbbaColors.sage
                          : AbbaColors.muted.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
                const SizedBox(width: AbbaSpacing.sm),
                Text(
                  '$clamped/5',
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletsSection extends StatelessWidget {
  final String title;
  final List<String> bullets;
  final Color accent;

  const _BulletsSection({
    required this.title,
    required this.bullets,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AbbaTypography.label.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AbbaSpacing.xs),
        for (final bullet in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: AbbaSpacing.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Icon(Icons.circle, size: 6, color: accent),
                ),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Text(
                    bullet,
                    style: AbbaTypography.bodySmall.copyWith(
                      color: AbbaColors.warmBrown,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
