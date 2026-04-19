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
  Future<bool> get isPremium;
  Stream<SubscriptionStatus> get statusStream;
}
