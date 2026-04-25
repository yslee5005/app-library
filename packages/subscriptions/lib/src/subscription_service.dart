import 'active_subscription_info.dart';
import 'offering_prices.dart';
import 'subscription_status.dart';

/// Abstract subscription service interface.
///
/// Implementations: [MockSubscriptionService], [RevenueCatSubscriptionService].
///
/// Flow:
///   1. [initialize] — configure the SDK with the current user id
///   2. [getSubscriptionStatus] / [statusStream] — observe entitlement state
///   3. [purchaseMonthly] / [purchaseYearly] / [purchaseLifetime] — direct purchase
///      (kept for custom UIs; new code should prefer [presentPaywall])
///   4. [presentPaywall] — show RevenueCat-hosted paywall (remote-configurable)
///   5. [presentCustomerCenter] — show subscription management UI
///   6. [restorePurchases] — recover past entitlements on device swap
abstract class SubscriptionService {
  Future<void> initialize(String userId);
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<bool> purchaseMonthly();
  Future<bool> purchaseYearly();
  Future<bool> purchaseLifetime();

  /// Present the RevenueCat-hosted paywall. Returns true when the user
  /// completed a purchase that activated the entitlement.
  Future<bool> presentPaywall();

  /// Present the Customer Center (manage subscription, cancel, restore, help).
  Future<void> presentCustomerCenter();

  Future<void> restorePurchases();

  /// Fetch current active subscription metadata (product id, next billing
  /// date, renewal flag). Returns null when the user has no active
  /// entitlement (including Grace Period window — treat `null` as free).
  Future<ActiveSubscriptionInfo?> getActiveSubscription();

  /// The latest expiration date across any prior purchase for this user.
  /// Used to show a "subscription expired" banner when the user had an
  /// active subscription that has since lapsed. Returns null when the
  /// user has no history of purchases.
  Future<DateTime?> getLatestExpirationDate();

  /// Fetch localized prices for the current offering (monthly + yearly)
  /// directly from the store (App Store / Play Store). Returns null when
  /// offerings are unavailable — UI must then fall back to ARB defaults.
  Future<OfferingPrices?> getOfferingPrices();

  Future<bool> get isPremium;
  Stream<SubscriptionStatus> get statusStream;

  /// Returns true when the current user is eligible for the yearly
  /// introductory free trial. Implementations must resolve the yearly
  /// product identifier internally (no product id leaks to UI).
  ///
  /// Safe default: return `false` on any error. A `false` result means
  /// the trial CTA is hidden and the standard yearly price is shown —
  /// never a silent upsell of a trial to someone ineligible.
  Future<bool> checkYearlyTrialEligibility();
}
