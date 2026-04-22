import 'package:app_lib_subscriptions/subscriptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OfferingPrices', () {
    test('stores all provided price strings verbatim', () {
      const prices = OfferingPrices(
        monthlyPriceString: r'$6.99',
        yearlyPriceString: r'$49.99',
        yearlyPriceMonthlyString: r'$4.17',
        savingsPercent: 40,
        currencyCode: 'USD',
      );

      expect(prices.monthlyPriceString, r'$6.99');
      expect(prices.yearlyPriceString, r'$49.99');
      expect(prices.yearlyPriceMonthlyString, r'$4.17');
      expect(prices.savingsPercent, 40);
      expect(prices.currencyCode, 'USD');
    });

    test('savingsPercent may be null when unknown', () {
      const prices = OfferingPrices(
        monthlyPriceString: '₩9,900',
        yearlyPriceString: '₩69,000',
        yearlyPriceMonthlyString: '₩5,750',
        currencyCode: 'KRW',
      );

      expect(prices.savingsPercent, isNull);
      expect(prices.currencyCode, 'KRW');
    });
  });

  group('MockSubscriptionService.getOfferingPrices', () {
    test('returns a non-null USD OfferingPrices', () async {
      final service = MockSubscriptionService();

      final prices = await service.getOfferingPrices();

      expect(prices, isNotNull);
      expect(prices!.currencyCode, 'USD');
      expect(prices.monthlyPriceString, r'$6.99');
      expect(prices.yearlyPriceString, r'$49.99');
      expect(prices.yearlyPriceMonthlyString, r'$4.17');
      expect(prices.savingsPercent, 40);
    });
  });
}
