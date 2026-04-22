import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart' show PeriodType;

import 'active_subscription_info.dart';
import 'offering_prices.dart';
import 'subscription_service.dart';
import 'subscription_status.dart';

/// In-memory mock for development and testing.
class MockSubscriptionService implements SubscriptionService {
  final _controller = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _status = SubscriptionStatus.free;

  @override
  Future<void> initialize(String userId) async {}

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async => _status;

  @override
  Future<bool> purchaseMonthly() => _grantPremium();

  @override
  Future<bool> purchaseYearly() => _grantPremium();

  @override
  Future<bool> purchaseLifetime() => _grantPremium();

  @override
  Future<bool> presentPaywall() => _grantPremium();

  @override
  Future<void> presentCustomerCenter() async {}

  Future<bool> _grantPremium() async {
    _status = SubscriptionStatus.premium;
    _controller.add(_status);
    return true;
  }

  @override
  Future<void> restorePurchases() async {}

  @override
  Future<DateTime?> getLatestExpirationDate() async => null;

  @override
  Future<OfferingPrices?> getOfferingPrices() async {
    return const OfferingPrices(
      monthlyPriceString: r'$6.99',
      yearlyPriceString: r'$49.99',
      yearlyPriceMonthlyString: r'$4.17',
      savingsPercent: 40,
      currencyCode: 'USD',
    );
  }

  @override
  Future<ActiveSubscriptionInfo?> getActiveSubscription() async {
    if (_status != SubscriptionStatus.premium) return null;
    return ActiveSubscriptionInfo(
      productId: 'com.ystech.abba.monthly',
      expiresDate: DateTime.now().add(const Duration(days: 30)),
      willRenew: true,
      periodType: PeriodType.normal,
    );
  }

  @override
  Future<bool> get isPremium async => _status == SubscriptionStatus.premium;

  @override
  Stream<SubscriptionStatus> get statusStream => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
