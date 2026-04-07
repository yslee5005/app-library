import 'dart:async';

import 'subscription_service.dart';
import 'subscription_status.dart';

/// RevenueCat-based subscription service.
///
/// Replace stub bodies with actual RevenueCat SDK calls when integrating.
class RevenueCatSubscriptionService implements SubscriptionService {
  RevenueCatSubscriptionService({required this.apiKey});

  final String apiKey;
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  final SubscriptionStatus _status = SubscriptionStatus.free;

  @override
  Future<void> initialize() async {
    // TODO: Purchases.configure(PurchasesConfiguration(apiKey));
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    // TODO: Check CustomerInfo entitlements
    return _status;
  }

  @override
  Future<bool> purchasePlan(String planId) async {
    // TODO: Purchases.purchaseProduct(planId);
    return false;
  }

  @override
  Future<void> restorePurchases() async {
    // TODO: Purchases.restorePurchases();
  }

  @override
  Future<bool> get isPremium async => _status == SubscriptionStatus.premium;

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
