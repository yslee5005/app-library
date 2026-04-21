import 'package:purchases_flutter/purchases_flutter.dart' show PeriodType;

class ActiveSubscriptionInfo {
  const ActiveSubscriptionInfo({
    required this.productId,
    required this.expiresDate,
    required this.willRenew,
    required this.periodType,
  });

  final String productId;
  final DateTime? expiresDate;
  final bool willRenew;
  final PeriodType periodType;

  bool get isMonthly => productId.contains('monthly');
  bool get isYearly => productId.contains('yearly');
}
