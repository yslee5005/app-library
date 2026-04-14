import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';

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
    return Semantics(
      label: isLocked ? '$title - ${l10n.premiumUnlock}' : title,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.md,
          vertical: AbbaSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AbbaColors.white,
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AbbaColors.warmBrown.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title — always visible
            Padding(
              padding: const EdgeInsets.all(AbbaSpacing.md),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(child: Text(title, style: AbbaTypography.h2)),
                ],
              ),
            ),
            // Content — preview + fade if locked
            if (isLocked)
              Column(
                children: [
                  // 3-line preview with fade
                  if (previewText != null && previewText!.isNotEmpty)
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AbbaSpacing.md,
                          ),
                          child: Text(
                            previewText!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: AbbaTypography.bodySmall.copyWith(
                              color: AbbaColors.warmBrown,
                              height: 1.6,
                            ),
                          ),
                        ),
                        // Fade gradient overlay
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: 30,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x00FFFFFF),
                                  Color(0xFFFFFFFF),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Premium button
                  Padding(
                    padding: const EdgeInsets.all(AbbaSpacing.sm),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: onUnlock,
                        icon: const Text('💎', style: TextStyle(fontSize: 14)),
                        label: Text(
                          l10n.premiumUnlock,
                          style: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AbbaColors.premium,
                          foregroundColor: AbbaColors.white,
                          minimumSize: const Size(160, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AbbaRadius.xl),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AbbaSpacing.md,
                  0,
                  AbbaSpacing.md,
                  AbbaSpacing.md,
                ),
                child: content,
              ),
          ],
        ),
      ),
    );
  }
}
