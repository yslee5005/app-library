import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';
import 'abba_card.dart';

/// Wave C (2026-04-24) — Premium content lock UI.
///
/// When [isLocked] is true, the card NEVER triggers a real Premium AI call.
/// Instead it renders:
///   1. Title row (icon + title + Pro badge) — always visible (curiosity hook).
///   2. A blurred skeleton (BackdropFilter on top of placeholder line shapes)
///      so the user can see the SHAPE of what's behind the lock without
///      receiving any real content.
///   3. An optional [lockedHint] line — one personalized sentence built from
///      T1/T2 keywords (e.g. "당신의 기도에서 발견한 한 단어를 깊이 풀어드립니다").
///   4. A Pro CTA row that pushes `/settings/membership`.
///
/// Backwards-compatible with existing call sites: callers who still pass
/// `previewText` get the legacy single-line muted preview rendered just under
/// the title (no skeleton, no CTA row) — used by older non-feature locked
/// cards. New cards should pass [lockedHint] instead.
class ProBlur extends StatelessWidget {
  final String title;
  final String icon;
  final Widget content;
  final bool isLocked;
  final VoidCallback onUnlock;

  /// Legacy single-line preview text under the title (compact lock mode).
  /// Prefer [lockedHint] for the new skeleton + CTA preview UI.
  final String? previewText;

  /// Personalized one-liner shown below the blurred skeleton when locked.
  /// Built from T1/T2 keywords by the caller. Optional — when null, the
  /// skeleton renders without a hint line.
  final String? lockedHint;

  const ProBlur({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    required this.isLocked,
    required this.onUnlock,
    this.previewText,
    this.lockedHint,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!isLocked) {
      // Unlocked — just show content in a card
      return AbbaCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AbbaSpacing.md + 4),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: AbbaSpacing.md),
                  Expanded(child: Text(title, style: AbbaTypography.h2)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AbbaSpacing.md + 4,
                0,
                AbbaSpacing.md + 4,
                AbbaSpacing.md + 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AbbaColors.warmBrown.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  const SizedBox(height: AbbaSpacing.md),
                  content,
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Locked — preview UI (no real Premium AI call). Skeleton blur + hint + CTA.
    return Semantics(
      label: '$title - ${l10n.proUnlock}',
      child: AbbaCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/membership');
          },
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AbbaSpacing.md + 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row: icon + title + Pro badge.
                Row(
                  children: [
                    Text(icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: AbbaSpacing.md),
                    Expanded(
                      child: Text(
                        title,
                        style: AbbaTypography.h2.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _ProBadge(label: l10n.membershipTitle),
                  ],
                ),
                // Legacy compact preview (used by older callers — no skeleton).
                if (previewText != null && previewText!.isNotEmpty) ...[
                  const SizedBox(height: AbbaSpacing.xs),
                  Padding(
                    padding: const EdgeInsets.only(left: 28 + AbbaSpacing.md),
                    child: Text(
                      previewText!,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: AbbaSpacing.md),
                // Skeleton blur preview — shape only, no real content.
                const _SkeletonBlur(key: ValueKey('pro_blur_skeleton')),
                if (lockedHint != null && lockedHint!.isNotEmpty) ...[
                  const SizedBox(height: AbbaSpacing.md),
                  Text(
                    lockedHint!,
                    key: const ValueKey('pro_blur_hint'),
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.warmBrown.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: AbbaSpacing.md),
                // Pro CTA row.
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.proUnlock,
                        style: AbbaTypography.body.copyWith(
                          color: AbbaColors.sage,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: AbbaColors.sage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pro badge (sage chip) shown next to the title in locked mode.
class _ProBadge extends StatelessWidget {
  final String label;
  const _ProBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.sm,
        vertical: AbbaSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🌿', style: TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AbbaTypography.caption.copyWith(
              color: AbbaColors.sage,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// 3-line placeholder block with a BackdropFilter blur overlay. Suggests the
/// shape of premium content without containing any real text.
class _SkeletonBlur extends StatelessWidget {
  const _SkeletonBlur({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AbbaRadius.md),
      child: Stack(
        children: [
          // Placeholder lines (varying widths 90% / 75% / 60%).
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AbbaSpacing.sm,
              horizontal: AbbaSpacing.xs,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(widthFactor: 0.90),
                SizedBox(height: AbbaSpacing.sm),
                _SkeletonLine(widthFactor: 0.75),
                SizedBox(height: AbbaSpacing.sm),
                _SkeletonLine(widthFactor: 0.60),
              ],
            ),
          ),
          // Blur overlay — purely visual; content beneath is decorative.
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: AbbaColors.cream.withValues(alpha: 0.15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  const _SkeletonLine({required this.widthFactor});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 13,
        decoration: BoxDecoration(
          color: AbbaColors.warmBrown.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
