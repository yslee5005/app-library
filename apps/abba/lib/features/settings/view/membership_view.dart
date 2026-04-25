import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_lib_subscriptions/subscriptions.dart'
    show PurchasesErrorCode, PurchasesErrorHelper;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/app_config.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_snackbar.dart';

class MembershipView extends ConsumerStatefulWidget {
  const MembershipView({super.key});

  @override
  ConsumerState<MembershipView> createState() => _MembershipViewState();
}

class _MembershipViewState extends ConsumerState<MembershipView>
    with WidgetsBindingObserver {
  // 0 = monthly, 1 = yearly (default yearly)
  int _selectedPlan = 1;
  bool _purchasing = false;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // learned-pitfalls §2.4 — refresh subscription state when the app
    // comes back to foreground (user may have cancelled / resubscribed
    // via App Store while we were suspended).
    if (state == AppLifecycleState.resumed && mounted) {
      ref.invalidate(isPremiumProvider);
      ref.invalidate(activeSubscriptionProvider);
      ref.invalidate(lastExpirationDateProvider);
      ref.invalidate(offeringPricesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final premiumAsync = ref.watch(isPremiumProvider);
    final isPremium = premiumAsync.value ?? false;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(title: Text('Abba Pro', style: AbbaTypography.h2)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AbbaSpacing.md,
            vertical: AbbaSpacing.sm,
          ),
          children: [
            if (isPremium)
              _buildActiveCard(l10n)
            else ...[
              _buildExpiredBannerIfAny(l10n),
              _buildPlanToggle(l10n),
              const SizedBox(height: AbbaSpacing.md),
              _buildPlanCard(l10n),
            ],
            const SizedBox(height: AbbaSpacing.md),
          ],
        ),
      ),
    );
  }

  /// Expired-subscription banner shown only when the user has a past
  /// expiration within the last 30 days. Silent otherwise.
  Widget _buildExpiredBannerIfAny(AppLocalizations l10n) {
    final expiryAsync = ref.watch(lastExpirationDateProvider);
    final expiry = expiryAsync.value;
    if (expiry == null) return const SizedBox.shrink();
    final daysSince = DateTime.now().difference(expiry).inDays;
    if (daysSince < 0 || daysSince > 30) return const SizedBox.shrink();
    final locale = Localizations.localeOf(context).languageCode;
    final dateLabel = DateFormat.yMMMd(locale).format(expiry);
    return Padding(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.md),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AbbaSpacing.md),
        decoration: BoxDecoration(
          color: AbbaColors.softPeach.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AbbaRadius.md),
          border: Border.all(
            color: AbbaColors.softGold.withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\u23F0', style: TextStyle(fontSize: 22)),
            const SizedBox(width: AbbaSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.subscriptionExpiredTitle,
                    style: AbbaTypography.body.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AbbaColors.warmBrown,
                    ),
                  ),
                  const SizedBox(height: AbbaSpacing.xs),
                  Text(
                    l10n.subscriptionExpiredBody(dateLabel),
                    style: AbbaTypography.bodySmall.copyWith(
                      color: AbbaColors.warmBrown,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Active premium card ─────────────────────────────────────────────────
  Widget _buildActiveCard(AppLocalizations l10n) {
    final activeAsync = ref.watch(activeSubscriptionProvider);

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
          _buildActiveBadge(l10n),
          const SizedBox(height: AbbaSpacing.md),
          activeAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(AbbaSpacing.md),
              child: CircularProgressIndicator(),
            ),
            error: (_, _) => _buildActiveFallback(l10n),
            data: (info) => info == null
                ? _buildActiveFallback(l10n)
                : _buildActiveDetails(l10n, info),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveBadge(AppLocalizations l10n) {
    return Container(
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
    );
  }

  /// Fallback when we can't resolve the active subscription (e.g. listener
  /// race or transient fetch error). Keeps the user on the active layout
  /// instead of crashing back to the plan picker.
  Widget _buildActiveFallback(AppLocalizations l10n) {
    return Column(
      children: [
        _buildBenefitsList(l10n),
        const SizedBox(height: AbbaSpacing.md),
        TextButton(
          onPressed: _restoring ? null : _restore,
          child: Text(
            l10n.restorePurchase,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveDetails(
    AppLocalizations l10n,
    ActiveSubscriptionInfo info,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final expires = info.expiresDate;
    final dateLabel = expires != null
        ? DateFormat.yMMMd(locale).format(expires)
        : '—';
    final billingLabel = info.willRenew
        ? l10n.nextBillingDate(dateLabel)
        : l10n.accessUntil(dateLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDetailRow(label: l10n.currentPlan(_planDisplayName(l10n, info))),
        const SizedBox(height: AbbaSpacing.xs),
        _buildDetailRow(label: billingLabel),
        if (info.isInGracePeriod) ...[
          const SizedBox(height: AbbaSpacing.sm),
          _buildGraceBanner(l10n, info),
        ],
        if (!info.willRenew) ...[
          const SizedBox(height: AbbaSpacing.sm),
          _buildCancellationNotice(l10n, dateLabel),
        ],
        const SizedBox(height: AbbaSpacing.md),
        Divider(color: AbbaColors.warmBrown.withValues(alpha: 0.08), height: 1),
        const SizedBox(height: AbbaSpacing.md),
        _buildBenefitsList(l10n),
        if (info.isMonthly) ...[
          const SizedBox(height: AbbaSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: ElevatedButton(
              onPressed: _purchasing ? null : _upgradeToYearly,
              style: ElevatedButton.styleFrom(
                backgroundColor: AbbaColors.sageDark,
                foregroundColor: AbbaColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.lg),
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
                      l10n.upgradeToYearly,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
        const SizedBox(height: AbbaSpacing.sm),
        TextButton(
          onPressed: _manageSubscription,
          child: Text(
            l10n.manageSubscription,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.sage),
          ),
        ),
        TextButton(
          onPressed: _restoring ? null : _restore,
          child: Text(
            l10n.restorePurchase,
            style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
          ),
        ),
        const SizedBox(height: AbbaSpacing.xs),
        Text(
          l10n.cancelAnytime,
          textAlign: TextAlign.center,
          style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
        ),
      ],
    );
  }

  Widget _buildDetailRow({required String label}) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: AbbaTypography.body.copyWith(color: AbbaColors.warmBrown),
    );
  }

  /// Grace Period banner — shown inline inside the Active card when
  /// RevenueCat reports `billingIssueDetectedAt`. The entitlement is still
  /// active, so we don't block the user; we surface the warning + a CTA
  /// into the App Store subscription management sheet (`_manageSubscription`).
  Widget _buildGraceBanner(AppLocalizations l10n, ActiveSubscriptionInfo info) {
    final days = info.gracePeriodDaysRemaining ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.md),
      decoration: BoxDecoration(
        color: AbbaColors.softPeach.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
        border: Border.all(color: AbbaColors.softGold.withValues(alpha: 0.7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚠️', style: TextStyle(fontSize: 22)),
              const SizedBox(width: AbbaSpacing.sm),
              Expanded(
                child: Text(
                  l10n.billingIssueTitle,
                  style: AbbaTypography.body.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AbbaColors.warmBrown,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AbbaSpacing.xs),
          Text(
            l10n.billingIssueBody(days),
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.warmBrown,
            ),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          SizedBox(
            width: double.infinity,
            height: abbaButtonHeight,
            child: ElevatedButton(
              onPressed: _manageSubscription,
              style: ElevatedButton.styleFrom(
                backgroundColor: AbbaColors.sageDark,
                foregroundColor: AbbaColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AbbaRadius.md),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.billingIssueAction,
                style: AbbaTypography.body.copyWith(
                  color: AbbaColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationNotice(AppLocalizations l10n, String dateLabel) {
    return Container(
      padding: const EdgeInsets.all(AbbaSpacing.sm),
      decoration: BoxDecoration(
        color: AbbaColors.softPeach.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(AbbaRadius.sm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🌱', style: TextStyle(fontSize: 16)),
          const SizedBox(width: AbbaSpacing.xs),
          Expanded(
            child: Text(
              l10n.subscriptionCancelledNotice(dateLabel),
              style: AbbaTypography.caption.copyWith(
                color: AbbaColors.warmBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _planDisplayName(AppLocalizations l10n, ActiveSubscriptionInfo info) {
    if (info.isYearly) return 'Abba Pro ${l10n.yearlyPlan}';
    if (info.isMonthly) return 'Abba Pro ${l10n.monthlyPlan}';
    return 'Abba Pro';
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
              onTap: () {
                setState(() => _selectedPlan = 0);
                appLogger.info(
                  'Membership plan selected: monthly',
                  category: LogCategory.subscription,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.md),
                decoration: BoxDecoration(
                  color: _selectedPlan == 0
                      ? AbbaColors.sage
                      : Colors.transparent,
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
              onTap: () {
                setState(() => _selectedPlan = 1);
                appLogger.info(
                  'Membership plan selected: yearly',
                  category: LogCategory.subscription,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.md),
                decoration: BoxDecoration(
                  color: _selectedPlan == 1
                      ? AbbaColors.sage
                      : Colors.transparent,
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
    // Store-localized prices. Null → fall back to hardcoded ARB values.
    final prices = ref.watch(offeringPricesProvider).value;
    final priceLabel = isYearly
        ? (prices?.yearlyPriceString ?? l10n.yearlyPrice)
        : (prices?.monthlyPriceString ?? l10n.monthlyPrice);

    // Yearly free trial eligibility. `trialEligibleYearlyProvider` defaults
    // to `false` on any error, and we only surface the trial CTA on the
    // Yearly tab — Monthly has no intro offer.
    final trialEligibleAsync = ref.watch(trialEligibleYearlyProvider);
    final showTrial = isYearly && (trialEligibleAsync.value ?? false);
    final ctaLabel = showTrial ? l10n.trialStartCta : l10n.startMembership;

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
            priceLabel,
            style: AbbaTypography.hero.copyWith(fontWeight: FontWeight.w700),
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
          const SizedBox(height: AbbaSpacing.md),
          Divider(
            color: AbbaColors.warmBrown.withValues(alpha: 0.08),
            height: 1,
          ),
          const SizedBox(height: AbbaSpacing.md),
          _buildBenefitsList(l10n),
          const SizedBox(height: AbbaSpacing.sm),
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
                      ctaLabel,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
          if (showTrial) ...[
            const SizedBox(height: AbbaSpacing.sm),
            // Apple GL 3.1.2 — auto-renew disclosure immediately under CTA.
            Text(
              l10n.trialAutoRenewDisclosure(priceLabel),
              style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AbbaSpacing.sm),
          // Apple Guideline 3.1.2 — Terms / Privacy links immediately under CTA
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              TextButton(
                onPressed: () => launchUrl(Uri.parse(AppConfig.termsUrl)),
                child: Text(
                  l10n.termsOfService,
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
              ),
              Text(
                ' · ',
                style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
              ),
              TextButton(
                onPressed: () => launchUrl(Uri.parse(AppConfig.privacyUrl)),
                child: Text(
                  l10n.privacyPolicy,
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AbbaSpacing.sm),
          // Restore purchase
          TextButton(
            onPressed: _restoring ? null : _restore,
            child: Text(
              l10n.restorePurchase,
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
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
      l10n.proBenefit1,
      l10n.proBenefit2,
      l10n.proBenefit3,
      l10n.proBenefit5,
    ];

    return Column(
      children: benefits
          .map(
            (benefit) => Padding(
              padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, size: 20, color: AbbaColors.sage),
                  const SizedBox(width: AbbaSpacing.sm),
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
    final productId = _selectedPlan == 1 ? 'yearly' : 'monthly';
    appLogger.info(
      'Purchase initiated: $productId',
      category: LogCategory.subscription,
    );
    setState(() => _purchasing = true);
    try {
      final service = ref.read(subscriptionServiceProvider);
      final success = _selectedPlan == 1
          ? await service.purchaseYearly()
          : await service.purchaseMonthly();
      if (!mounted) return;
      if (success) {
        appLogger.info(
          'Purchase successful',
          category: LogCategory.subscription,
        );
        ref.invalidate(isPremiumProvider);
        ref.invalidate(activeSubscriptionProvider);
        showAbbaSnackBar(context, message: l10n.purchaseSuccess);
      }
    } on PlatformException catch (e) {
      appLogger.error(
        'Purchase failed',
        category: LogCategory.subscription,
        error: e,
      );
      if (!mounted) return;
      final code = PurchasesErrorHelper.getErrorCode(e);
      _handlePurchaseError(code, l10n);
    } catch (e) {
      appLogger.error(
        'Purchase failed',
        category: LogCategory.subscription,
        error: e,
      );
      if (!mounted) return;
      showAbbaSnackBar(context, message: l10n.purchaseFailedGeneric);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  Future<void> _upgradeToYearly() async {
    final l10n = AppLocalizations.of(context)!;
    appLogger.info(
      'Upgrade to yearly initiated',
      category: LogCategory.subscription,
    );
    setState(() => _purchasing = true);
    try {
      final service = ref.read(subscriptionServiceProvider);
      final success = await service.purchaseYearly();
      if (!mounted) return;
      if (success) {
        ref.invalidate(isPremiumProvider);
        ref.invalidate(activeSubscriptionProvider);
        showAbbaSnackBar(context, message: l10n.upgradeSuccess);
      }
    } on PlatformException catch (e) {
      appLogger.error(
        'Upgrade failed',
        category: LogCategory.subscription,
        error: e,
      );
      if (!mounted) return;
      final code = PurchasesErrorHelper.getErrorCode(e);
      _handlePurchaseError(code, l10n);
    } catch (e) {
      appLogger.error(
        'Upgrade failed',
        category: LogCategory.subscription,
        error: e,
      );
      if (!mounted) return;
      showAbbaSnackBar(context, message: l10n.purchaseFailedGeneric);
    } finally {
      if (mounted) setState(() => _purchasing = false);
    }
  }

  void _handlePurchaseError(PurchasesErrorCode code, AppLocalizations l10n) {
    switch (code) {
      case PurchasesErrorCode.purchaseCancelledError:
        // User cancelled deliberately — stay silent.
        break;
      case PurchasesErrorCode.networkError:
        showAbbaSnackBar(context, message: l10n.purchaseFailedNetwork);
      default:
        showAbbaSnackBar(context, message: l10n.purchaseFailedGeneric);
    }
  }

  Future<void> _restore() async {
    final l10n = AppLocalizations.of(context)!;
    appLogger.info(
      'Restore purchase initiated',
      category: LogCategory.subscription,
    );
    setState(() => _restoring = true);
    showAbbaSnackBar(context, message: l10n.restoreInProgress);
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.restorePurchases().timeout(const Duration(seconds: 30));
      final active = await service.getActiveSubscription();
      if (!mounted) return;
      if (active != null) {
        ref.invalidate(isPremiumProvider);
        ref.invalidate(activeSubscriptionProvider);
        showAbbaSnackBar(context, message: l10n.restoreSuccess);
      } else {
        showAbbaSnackBar(context, message: l10n.restoreNothing);
      }
    } on TimeoutException {
      if (mounted) showAbbaSnackBar(context, message: l10n.restoreTimeout);
    } catch (e) {
      appLogger.error(
        'Restore failed',
        category: LogCategory.subscription,
        error: e,
      );
      if (mounted) showAbbaSnackBar(context, message: l10n.restoreFailed);
    } finally {
      if (mounted) setState(() => _restoring = false);
    }
  }

  Future<void> _manageSubscription() async {
    appLogger.info(
      'Manage subscription initiated',
      category: LogCategory.subscription,
    );
    try {
      final service = ref.read(subscriptionServiceProvider);
      await service.presentCustomerCenter();
      if (mounted) {
        ref.invalidate(isPremiumProvider);
        ref.invalidate(activeSubscriptionProvider);
      }
    } catch (e) {
      appLogger.warning(
        'Customer center failed, falling back to App Store URL',
        category: LogCategory.subscription,
        error: e,
      );
      await launchUrl(
        Uri.parse('https://apps.apple.com/account/subscriptions'),
      );
    }
  }
}
