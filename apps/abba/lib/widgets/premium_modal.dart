import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import '../theme/abba_theme.dart';

/// Soft prompt: "이 기능은 Pro에서 사용할 수 있어요. 확인하시겠어요?"
/// Returns true if user ultimately purchased Premium.
Future<bool> showPremiumPrompt(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  final wantsToSee = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
      ),
      backgroundColor: AbbaColors.cream,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('✨', style: TextStyle(fontSize: 40)),
          const SizedBox(height: AbbaSpacing.md),
          Text(
            l10n.premiumPromptTitle,
            style: AbbaTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            l10n.premiumPromptBody,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AbbaSpacing.lg,
        0,
        AbbaSpacing.lg,
        AbbaSpacing.lg,
      ),
      actions: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx, true),
                icon: const Text('💎', style: TextStyle(fontSize: 16)),
                label: Text(
                  l10n.viewProducts,
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AbbaColors.sage,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.md),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(
                l10n.maybeLater,
                style: AbbaTypography.bodySmall.copyWith(
                  color: AbbaColors.muted,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  if (wantsToSee == true && context.mounted) {
    context.go('/settings');
  }

  return false;
}

/// Shows a soft modal when free user hits daily prayer limit.
/// Returns true if user successfully purchased Premium, false otherwise.
Future<bool> showPremiumModal(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _PremiumModalContent(),
  );

  return result ?? false;
}

class _PremiumModalContent extends ConsumerStatefulWidget {
  const _PremiumModalContent();

  @override
  ConsumerState<_PremiumModalContent> createState() =>
      _PremiumModalContentState();
}

class _PremiumModalContentState extends ConsumerState<_PremiumModalContent> {
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.xl,
        vertical: AbbaSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AbbaColors.cream,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AbbaRadius.xl),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            const Text('🌸', style: TextStyle(fontSize: 48)),
            const SizedBox(height: AbbaSpacing.md),
            Text(
              l10n.premiumLimitTitle,
              style: AbbaTypography.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              l10n.premiumLimitBody,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.xl),
            // Monthly button
            SizedBox(
              width: double.infinity,
              height: abbaHeroButtonHeight,
              child: ElevatedButton(
                onPressed: _purchasing ? null : _purchaseMonthly,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AbbaColors.premium,
                  foregroundColor: AbbaColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: _purchasing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AbbaColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        '💎 ${l10n.startPremium} — ${l10n.monthlyPrice}',
                        style: AbbaTypography.body.copyWith(
                          color: AbbaColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Yearly button
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: OutlinedButton(
                onPressed: _purchasing ? null : _purchaseYearly,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AbbaColors.premium),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  '${l10n.yearlyPrice} (${l10n.yearlySave})',
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.premium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                l10n.laterButton,
                style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _purchaseMonthly() async {
    setState(() => _purchasing = true);
    try {
      final service = ref.read(subscriptionServiceProvider);
      final success = await service.purchaseMonthly();
      if (mounted) Navigator.of(context).pop(success);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _purchaseYearly() async {
    setState(() => _purchasing = true);
    try {
      final service = ref.read(subscriptionServiceProvider);
      final success = await service.purchaseYearly();
      if (mounted) Navigator.of(context).pop(success);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }
}
