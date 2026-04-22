import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import 'active_subscription_info.dart';
import 'offering_prices.dart';
import 'subscription_service.dart';
import 'subscription_status.dart';

/// RevenueCat-backed subscription service.
///
/// The [apiKey] comes from the app's `.env` (one per platform). The
/// [entitlementId] must match the entitlement configured in the RevenueCat
/// dashboard (for abba: `'abba_pro'`).
class RevenueCatSubscriptionService implements SubscriptionService {
  RevenueCatSubscriptionService({
    required this.apiKey,
    this.entitlementId = 'abba_pro',
    Logger? logger,
  }) : _log = (logger ?? appLogger).forCategory(LogCategory.subscription);

  final String apiKey;
  final String entitlementId;
  final CategoryLogger _log;

  final _statusController = StreamController<SubscriptionStatus>.broadcast();
  SubscriptionStatus _currentStatus = SubscriptionStatus.free;
  bool _configured = false;

  @override
  Future<void> initialize(String userId) async {
    try {
      final config = PurchasesConfiguration(apiKey)..appUserID = userId;
      await Purchases.configure(config);
      _configured = true;

      Purchases.addCustomerInfoUpdateListener(_updateStatus);

      final info = await Purchases.getCustomerInfo();
      _updateStatus(info);
      _log.info('RevenueCat initialized, status=$_currentStatus');
    } catch (e, st) {
      _log.error('RevenueCat init failed', error: e, stackTrace: st);
    }
  }

  void _updateStatus(CustomerInfo info) {
    final entitlement = info.entitlements.all[entitlementId];
    _currentStatus = entitlement != null && entitlement.isActive
        ? SubscriptionStatus.premium
        : SubscriptionStatus.free;
    _statusController.add(_currentStatus);
  }

  @override
  Future<SubscriptionStatus> getSubscriptionStatus() async {
    final info = await Purchases.getCustomerInfo();
    _updateStatus(info);
    return _currentStatus;
  }

  @override
  Future<bool> purchaseMonthly() => _purchasePackage((o) => o?.monthly, 'monthly');

  @override
  Future<bool> purchaseYearly() => _purchasePackage((o) => o?.annual, 'yearly');

  @override
  Future<bool> purchaseLifetime() => _purchasePackage((o) => o?.lifetime, 'lifetime');

  Future<bool> _purchasePackage(
    Package? Function(Offering?) pick,
    String label,
  ) async {
    final offerings = await Purchases.getOfferings();
    final package = pick(offerings.current);
    if (package == null) {
      _log.warning('$label package unavailable');
      return false;
    }
    try {
      final result = await Purchases.purchase(
        PurchaseParams.package(package),
      );
      _updateStatus(result.customerInfo);
      _log.info('$label purchase completed, status=$_currentStatus');
      return _currentStatus == SubscriptionStatus.premium;
    } catch (e, st) {
      _log.error('$label purchase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> presentPaywall() async {
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded(
        entitlementId,
      );
      _log.info('Paywall closed with result=$result');
      final info = await Purchases.getCustomerInfo();
      _updateStatus(info);
      return result == PaywallResult.purchased ||
          result == PaywallResult.restored;
    } catch (e, st) {
      _log.error('presentPaywall failed', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<void> presentCustomerCenter() async {
    try {
      await RevenueCatUI.presentCustomerCenter();
      _log.info('Customer Center closed');
      final info = await Purchases.getCustomerInfo();
      _updateStatus(info);
    } catch (e, st) {
      _log.error('presentCustomerCenter failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      _updateStatus(info);
      _log.info('Purchases restored, status=$_currentStatus');
    } catch (e, st) {
      _log.error('Restore purchases failed', error: e, stackTrace: st);
    }
  }

  @override
  Future<DateTime?> getLatestExpirationDate() async {
    try {
      final info = await Purchases.getCustomerInfo();
      DateTime? latest;
      for (final dateStr in info.allExpirationDates.values) {
        if (dateStr == null) continue;
        final parsed = DateTime.tryParse(dateStr)?.toLocal();
        if (parsed == null) continue;
        if (latest == null || parsed.isAfter(latest)) latest = parsed;
      }
      return latest;
    } catch (e, st) {
      _log.error('getLatestExpirationDate failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<OfferingPrices?> getOfferingPrices() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) {
        _log.warning('getOfferingPrices: no current offering');
        return null;
      }
      final monthly = current.monthly;
      final yearly = current.annual;
      if (monthly == null || yearly == null) {
        _log.warning(
          'getOfferingPrices: missing package (monthly=${monthly != null}, '
          'yearly=${yearly != null})',
        );
        return null;
      }

      final monthlyProduct = monthly.storeProduct;
      final yearlyProduct = yearly.storeProduct;
      final monthlyPrice = monthlyProduct.price;
      final yearlyPrice = yearlyProduct.price;
      final currencyCode = monthlyProduct.currencyCode;

      // yearly / 12, formatted in the same locale-currency as yearlyPriceString.
      // RevenueCat does not expose a per-month string for an annual package,
      // so we synthesize one using intl's NumberFormat.
      final yearlyPerMonth = yearlyPrice / 12;
      String yearlyPerMonthString;
      try {
        final formatter = NumberFormat.simpleCurrency(name: currencyCode);
        yearlyPerMonthString = formatter.format(yearlyPerMonth);
      } catch (e) {
        // Fallback: raw currency code + numeric value when intl cannot
        // resolve the symbol for this ISO code.
        yearlyPerMonthString =
            '$currencyCode ${yearlyPerMonth.toStringAsFixed(2)}';
      }

      final int? savings = (monthlyPrice > 0 && yearlyPrice > 0)
          ? (100 - (yearlyPrice / (monthlyPrice * 12) * 100)).round()
          : null;

      return OfferingPrices(
        monthlyPriceString: monthlyProduct.priceString,
        yearlyPriceString: yearlyProduct.priceString,
        yearlyPriceMonthlyString: yearlyPerMonthString,
        savingsPercent: savings,
        currencyCode: currencyCode,
      );
    } catch (e, st) {
      _log.error('getOfferingPrices failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<ActiveSubscriptionInfo?> getActiveSubscription() async {
    try {
      final info = await Purchases.getCustomerInfo();
      final entitlement = info.entitlements.all[entitlementId];
      if (entitlement == null || !entitlement.isActive) return null;
      final expires = entitlement.expirationDate;
      final billingIssue = entitlement.billingIssueDetectedAt;
      return ActiveSubscriptionInfo(
        productId: entitlement.productIdentifier,
        expiresDate: expires != null ? DateTime.tryParse(expires)?.toLocal() : null,
        willRenew: entitlement.willRenew,
        periodType: entitlement.periodType,
        billingIssueDetectedAt: billingIssue != null
            ? DateTime.tryParse(billingIssue)?.toLocal()
            : null,
      );
    } catch (e, st) {
      _log.error('getActiveSubscription failed', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<bool> get isPremium async {
    if (!_configured) return false;
    final status = await getSubscriptionStatus();
    return status == SubscriptionStatus.premium ||
        status == SubscriptionStatus.trial;
  }

  @override
  Stream<SubscriptionStatus> get statusStream => _statusController.stream;

  void dispose() {
    _statusController.close();
  }
}
