import 'package:purchases_flutter/purchases_flutter.dart' show PeriodType;

/// RevenueCat's documented Billing Grace Period window. Apple/Google keep
/// retrying the renewal transparently during this window; the entitlement
/// stays active but [billingIssueDetectedAt] is set so we can warn the user.
///
/// Matches the `Grace Period Duration = 16 days` configured in App Store
/// Connect (see `apps/abba/specs/SUBSCRIPTION.md` §2.1).
const int billingGracePeriodDays = 16;

class ActiveSubscriptionInfo {
  const ActiveSubscriptionInfo({
    required this.productId,
    required this.expiresDate,
    required this.willRenew,
    required this.periodType,
    this.billingIssueDetectedAt,
  });

  final String productId;
  final DateTime? expiresDate;
  final bool willRenew;
  final PeriodType periodType;

  /// Timestamp at which the store first reported a billing issue (card
  /// declined, expired, etc.). RevenueCat clears this as soon as the issue
  /// resolves. While set, the subscription is inside the
  /// [billingGracePeriodDays] window and will auto-downgrade if unresolved.
  final DateTime? billingIssueDetectedAt;

  bool get isMonthly => productId.contains('monthly');
  bool get isYearly => productId.contains('yearly');

  /// True when RevenueCat has flagged a billing issue **and** the user still
  /// intends to renew. `willRenew == false` means the user already opted
  /// out, so the expired-banner flow handles it instead.
  bool get isInGracePeriod =>
      billingIssueDetectedAt != null && willRenew;

  /// Days remaining in the [billingGracePeriodDays] window. Returns `null`
  /// when the subscription is not in a grace state, and `0` once the
  /// window has elapsed (Apple's retries are done; downgrade imminent).
  int? get gracePeriodDaysRemaining {
    final detectedAt = billingIssueDetectedAt;
    if (!isInGracePeriod || detectedAt == null) return null;
    final elapsed = DateTime.now().difference(detectedAt).inDays;
    final remaining = billingGracePeriodDays - elapsed;
    return remaining < 0 ? 0 : remaining;
  }
}
