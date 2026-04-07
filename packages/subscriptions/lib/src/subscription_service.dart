import 'subscription_status.dart';

/// Abstract subscription service interface.
///
/// Implementations: [MockSubscriptionService], RevenueCat-based, etc.
abstract class SubscriptionService {
  Future<void> initialize();
  Future<SubscriptionStatus> getSubscriptionStatus();
  Future<bool> purchasePlan(String planId);
  Future<void> restorePurchases();
  Future<bool> get isPremium;
  Stream<SubscriptionStatus> get statusStream;
}
