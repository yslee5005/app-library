import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';

/// Shows a soft modal when free user hits daily prayer limit.
/// Returns true if user wants to proceed with Premium, false otherwise.
Future<bool> showPremiumModal(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final isKo = Localizations.localeOf(context).languageCode == 'ko';

  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => Container(
      padding: const EdgeInsets.all(AbbaSpacing.xl),
      decoration: const BoxDecoration(
        color: AbbaColors.cream,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AbbaRadius.xl)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌸', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AbbaSpacing.md),
            Text(
              isKo ? '오늘의 기도를 마쳤습니다' : "Today's prayer is complete",
              style: AbbaTypography.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              isKo
                  ? '내일 다시 만나요!\nPremium으로 무제한 기도하기'
                  : 'See you tomorrow!\nPray unlimited with Premium',
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.xl),
            SizedBox(
              width: double.infinity,
              height: abbaHeroButtonHeight,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AbbaColors.premium,
                  foregroundColor: AbbaColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  '💎 ${l10n.startPremium} — ${l10n.monthlyPrice}',
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                isKo ? '다음에 하기' : 'Maybe later',
                style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return result ?? false;
}
