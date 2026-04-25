import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActiveSubscriptionInfo.isInGracePeriod', () {
    test('is false when billingIssueDetectedAt is null', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().add(const Duration(days: 15)),
        willRenew: true,
        periodType: PeriodType.normal,
      );

      expect(info.isInGracePeriod, isFalse);
      expect(info.gracePeriodDaysRemaining, isNull);
    });

    test('is true when billing issue is set and willRenew is true', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().add(const Duration(days: 15)),
        willRenew: true,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now(),
      );

      expect(info.isInGracePeriod, isTrue);
    });

    test('is false when willRenew is false (user already cancelled)', () {
      // Cancelled user flows through the "cancellation notice" UI, not the
      // billing-issue banner, even if the store happened to report an issue.
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().add(const Duration(days: 15)),
        willRenew: false,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now(),
      );

      expect(info.isInGracePeriod, isFalse);
      expect(info.gracePeriodDaysRemaining, isNull);
    });
  });

  group('ActiveSubscriptionInfo.gracePeriodDaysRemaining', () {
    test('returns full window when issue was just detected', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().add(const Duration(days: 15)),
        willRenew: true,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now(),
      );

      // elapsed = 0 → 16 remaining.
      expect(info.gracePeriodDaysRemaining, billingGracePeriodDays);
    });

    test('returns half the window after 8 days', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().add(const Duration(days: 7)),
        willRenew: true,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now().subtract(
          const Duration(days: 8),
        ),
      );

      expect(info.gracePeriodDaysRemaining, 8);
    });

    test('clamps to 0 when window has elapsed', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now().subtract(const Duration(days: 1)),
        willRenew: true,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now().subtract(
          const Duration(days: 40),
        ),
      );

      expect(info.gracePeriodDaysRemaining, 0);
    });

    test('clamps to 0 exactly at the 16-day boundary', () {
      final info = ActiveSubscriptionInfo(
        productId: 'com.ystech.abba.monthly',
        expiresDate: DateTime.now(),
        willRenew: true,
        periodType: PeriodType.normal,
        billingIssueDetectedAt: DateTime.now().subtract(
          const Duration(days: 16, hours: 1),
        ),
      );

      expect(info.gracePeriodDaysRemaining, 0);
    });
  });
}
