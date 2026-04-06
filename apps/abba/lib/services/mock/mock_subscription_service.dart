import 'dart:async';

import '../../models/user_profile.dart';
import '../subscription_service.dart';

class MockSubscriptionService implements SubscriptionService {
  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _currentStatus = SubscriptionStatus.free;

  @override
  Future<void> initialize(String userId) async {
    // Mock: no-op
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    return _currentStatus;
  }

  @override
  Future<bool> purchaseMonthly() async {
    // Mock: simulate successful purchase
    _currentStatus = SubscriptionStatus.premium;
    _statusController.add(_currentStatus);
    return true;
  }

  @override
  Future<bool> purchaseYearly() async {
    _currentStatus = SubscriptionStatus.premium;
    _statusController.add(_currentStatus);
    return true;
  }

  @override
  Future<void> restorePurchases() async {
    // Mock: no-op
  }

  @override
  Future<bool> get isPremium async {
    return _currentStatus == SubscriptionStatus.premium ||
        _currentStatus == SubscriptionStatus.trial;
  }

  @override
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;
}
