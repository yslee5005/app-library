import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';

import '../../config/app_config.dart';
import '../../models/user_profile.dart';
import '../subscription_service.dart';

class RevenueCatSubscriptionService implements SubscriptionService {
  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _currentStatus = SubscriptionStatus.free;

  @override
  Future<void> initialize(String userId) async {
    final config = PurchasesConfiguration(AppConfig.revenueCatApiKey)
      ..appUserID = userId;
    await Purchases.configure(config);

    // Listen for customer info updates
    Purchases.addCustomerInfoUpdateListener((info) {
      _updateStatus(info);
    });

    // Initial status check
    final info = await Purchases.getCustomerInfo();
    _updateStatus(info);
  }

  void _updateStatus(CustomerInfo info) {
    final entitlement = info.entitlements.all['premium'];
    if (entitlement != null && entitlement.isActive) {
      _currentStatus = SubscriptionStatus.premium;
    } else {
      _currentStatus = SubscriptionStatus.free;
    }
    _statusController.add(_currentStatus);
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final info = await Purchases.getCustomerInfo();
    _updateStatus(info);
    return _currentStatus;
  }

  @override
  Future<bool> purchaseMonthly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final monthly = offerings.current?.monthly;
      if (monthly == null) return false;

      await Purchases.purchasePackage(monthly);
      final info = await Purchases.getCustomerInfo();
      _updateStatus(info);
      return _currentStatus == SubscriptionStatus.premium;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> purchaseYearly() async {
    try {
      final offerings = await Purchases.getOfferings();
      final annual = offerings.current?.annual;
      if (annual == null) return false;

      await Purchases.purchasePackage(annual);
      final info = await Purchases.getCustomerInfo();
      _updateStatus(info);
      return _currentStatus == SubscriptionStatus.premium;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> restorePurchases() async {
    final info = await Purchases.restorePurchases();
    _updateStatus(info);
  }

  @override
  Future<bool> get isPremium async {
    final status = await getSubscriptionStatus();
    return status == SubscriptionStatus.premium ||
        status == SubscriptionStatus.trial;
  }

  @override
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;
}
