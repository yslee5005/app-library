import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';
import 'abba_card.dart';

class PremiumBlur extends StatelessWidget {
  final String title;
  final String icon;
  final Widget content;
  final bool isLocked;
  final VoidCallback onUnlock;
  final String? previewText;

  const PremiumBlur({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    required this.isLocked,
    required this.onUnlock,
    this.previewText,
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
                AbbaSpacing.md + 4, 0, AbbaSpacing.md + 4, AbbaSpacing.md + 4,
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

    // Locked — same card style as ExpandableCard, tap to unlock
    return Semantics(
      label: '$title - ${l10n.premiumUnlock}',
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
            child: Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: AbbaSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AbbaTypography.h2),
                      if (previewText != null && previewText!.isNotEmpty) ...[
                        const SizedBox(height: AbbaSpacing.xs),
                        Text(
                          previewText!,
                          style: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.muted,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
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
                        l10n.membershipTitle,
                        style: AbbaTypography.caption.copyWith(
                          color: AbbaColors.sage,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AbbaSpacing.sm),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 32,
                  color: AbbaColors.muted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
