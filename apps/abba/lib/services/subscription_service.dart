import '../models/user_profile.dart';

/// Abstract subscription service — mock returns static state, real uses RevenueCat
abstract class SubscriptionService {
  Future<void> initialize(String userId);

  Future<SubscriptionStatus> getSubscriptionStatus();

  Future<bool> purchaseMonthly();

  Future<bool> purchaseYearly();

  Future<void> restorePurchases();

  Future<bool> get isPremium;

  Stream<SubscriptionStatus> get statusStream;
}
