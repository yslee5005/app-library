import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/abba_theme.dart';

class PremiumBlur extends StatelessWidget {
  final String title;
  final String icon;
  final Widget content;
  final bool isLocked;
  final VoidCallback onUnlock;

  const PremiumBlur({
    super.key,
    required this.title,
    required this.icon,
    required this.content,
    required this.isLocked,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: isLocked ? '$title - Premium content locked' : title,
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
            // Content — blurred if locked
            if (isLocked)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AbbaRadius.lg),
                  bottomRight: Radius.circular(AbbaRadius.lg),
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AbbaSpacing.md,
                        0,
                        AbbaSpacing.md,
                        AbbaSpacing.md,
                      ),
                      child: content,
                    ),
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: AbbaColors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: onUnlock,
                          icon: const Text(
                            '💎',
                            style: TextStyle(fontSize: 18),
                          ),
                          label: Text(
                            'Premium',
                            style: AbbaTypography.body.copyWith(
                              color: AbbaColors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AbbaColors.premium,
                            foregroundColor: AbbaColors.white,
                            minimumSize: const Size(200, abbaButtonHeight),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AbbaRadius.xl,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
