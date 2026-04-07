import 'dart:async';

import 'subscription_service.dart';
import 'subscription_status.dart';

/// In-memory mock for development and testing.
class MockSubscriptionService implements SubscriptionService {
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = SubscriptionStatus.free;

  @override
  Future<void> initialize() async {}

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async => _status;

  @override
  Future<bool> purchasePlan(String planId) async {
    _status = SubscriptionStatus.premium;
    _controller.add(_status);
    return true;
  }

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<bool> get isPremium async => _status == SubscriptionStatus.premium;

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
