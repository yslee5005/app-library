import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_snackbar.dart';

class MembershipView extends ConsumerStatefulWidget {
  const MembershipView({super.key});

  @override
  ConsumerState<MembershipView> createState() => _MembershipViewState();
}

class _MembershipViewState extends ConsumerState<MembershipView> {
  // 0 = monthly, 1 = yearly (default yearly)
  int _selectedPlan = 1;
  bool _purchasing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final premiumAsync = ref.watch(isPremiumProvider);
    final isPremium = premiumAsync.value ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(l10n.membershipTitle, style: AbbaTypography.h2),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AbbaSpacing.md,
            vertical: AbbaSpacing.md,
          ),
          children: [
            // Header
            _buildHeader(l10n),
            const SizedBox(height: AbbaSpacing.lg),
            // Content
            if (isPremium)
              _buildActiveCard(l10n)
            else ...[
              _buildPlanToggle(l10n),
              const SizedBox(height: AbbaSpacing.lg),
              _buildPlanCard(l10n),
            ],
            const SizedBox(height: AbbaSpacing.xl),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────
  Widget _buildHeader(AppLocalizations l10n) {
    return Column(
      children: [
        const SizedBox(height: AbbaSpacing.md),
        const Text('\u{1F33F}', style: TextStyle(fontSize: 48)),
        const SizedBox(height: AbbaSpacing.md),
        Text(
          'Abba Premium',
          style: AbbaTypography.h1.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AbbaSpacing.sm),
        Text(
          l10n.membershipSubtitle,
          style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Active premium card ─────────────────────────────────────────────────
  Widget _buildActiveCard(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.lg),
      decoration: BoxDecoration(
        color: AbbaColors.white,
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AbbaColors.warmBrown.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AbbaSpacing.lg),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AbbaColors.sage.withValues(alpha: 0.12),
                  AbbaColors.softGold.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(AbbaRadius.md),
            ),
            child: Column(
              children: [
                const Text('\u2705', style: TextStyle(fontSize: 36)),
                const SizedBox(height: AbbaSpacing.sm),
                Text(
                  l10n.membershipActive,
                  style: AbbaTypography.h2.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AbbaColors.sage,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AbbaSpacing.lg),
          // Benefits list
          _buildBenefitsList(l10n),
          const SizedBox(height: AbbaSpacing.lg),
          TextButton(
            onPressed: () async {
              final service = ref.read(subscriptionServiceProvider);
              await service.restorePurchases();
            },
            child: Text(
              l10n.restorePurchase,
              style:
                  AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan toggle ─────────────────────────────────────────────────────────
  Widget _buildPlanToggle(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        color: AbbaColors.warmBrown.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.md),
                decoration: BoxDecoration(
                  color:
                      _selectedPlan == 0 ? AbbaColors.sage : Colors.transparent,
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                alignment: Alignment.center,
                child: Text(
                  l10n.monthlyPlan,
                  style: AbbaTypography.body.copyWith(
                    color: _selectedPlan == 0
                        ? AbbaColors.white
                        : AbbaColors.warmBrown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPlan = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.md),
                decoration: BoxDecoration(
                  color:
                      _selectedPlan == 1 ? AbbaColors.sage : Colors.transparent,
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.yearlyPlan,
                      style: AbbaTypography.body.copyWith(
                        color: _selectedPlan == 1
                            ? AbbaColors.white
                            : AbbaColors.warmBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.xs),
                    Text(
                      '\u2728',
                      style: TextStyle(
                        fontSize: 18,
                        color: _selectedPlan == 1
                            ? AbbaColors.white
                            : AbbaColors.warmBrown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Plan card ───────────────────────────────────────────────────────────
  Widget _buildPlanCard(AppLocalizations l10n) {
    final isYearly = _selectedPlan == 1;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.lg),
      decoration: BoxDecoration(
        color: AbbaColors.white,
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AbbaColors.warmBrown.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // BEST VALUE badge (yearly only)
          if (isYearly) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.md,
                vertical: AbbaSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AbbaColors.sage,
                borderRadius: BorderRadius.circular(AbbaRadius.full),
              ),
              child: Text(
                l10n.bestValue,
                style: AbbaTypography.caption.copyWith(
                  color: AbbaColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.md),
          ],
          // Price
          Text(
            isYearly ? l10n.yearlyPrice : l10n.monthlyPrice,
            style: AbbaTypography.hero.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (isYearly) ...[
            const SizedBox(height: AbbaSpacing.xs),
            Text(
              l10n.yearlySavings,
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.sage,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: AbbaSpacing.lg),
          // Divider
          Divider(
            color: AbbaColors.warmBrown.withValues(alpha: 0.08),
            height: 1,
          ),
          const SizedBox(height: AbbaSpacing.lg),
          // Benefits list
          _buildBenefitsList(l10n),
          const SizedBox(height: AbbaSpacing.lg),
          // CTA button
          SizedBox(
            width: double.infinity,
            height: abbaHeroButtonHeight,
            child: ElevatedButton(
              onPressed: _purchasing ? null : _purchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: AbbaColors.sageDark,
                foregroundColor: AbbaColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.xl),
                ),
                elevation: 0,
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
                      l10n.startMembership,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.lg),
          // Restore purchase
          GestureDetector(
            onTap: () async {
              final service = ref.read(subscriptionServiceProvider);
              await service.restorePurchases();
            },
            child: Text(
              l10n.restorePurchase,
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.muted,
              ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          // Cancel anytime
          Text(
            l10n.cancelAnytime,
            style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
          ),
        ],
      ),
    );
  }

  // ── Benefits list ───────────────────────────────────────────────────────
  Widget _buildBenefitsList(AppLocalizations l10n) {
    final benefits = [
      l10n.premiumBenefit1,
      l10n.premiumBenefit2,
      l10n.premiumBenefit3,
      l10n.premiumBenefit4,
      l10n.premiumBenefit5,
    ];

    return Column(
      children: benefits
          .map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: AbbaSpacing.md),
              child: Row(
                children: [
                  Icon(
                    Icons.check_rounded,
                    size: 22,
                    color: AbbaColors.sage,
                  ),
                  const SizedBox(width: AbbaSpacing.md),
                  Expanded(
                    child: Text(
                      benefit,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.warmBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  // ── Purchase ────────────────────────────────────────────────────────────
  Future<void> _purchase() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _purchasing = true);
    try {
      final service = ref.read(subscriptionServiceProvider);
      final success = _selectedPlan == 1
          ? await service.purchaseYearly()
          : await service.purchaseMonthly();
      if (success) ref.invalidate(isPremiumProvider);
    } catch (_) {
      if (mounted) {
        showAbbaSnackBar(context, message: l10n.errorPayment);
      }
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }
}
