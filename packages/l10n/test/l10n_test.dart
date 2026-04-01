import 'package:test/test.dart';

import 'package:app_lib_l10n/l10n.dart';

void main() {
  group('RelativeTimeFormatter (en)', () {
    const formatter = RelativeTimeFormatter();
    final now = DateTime(2026, 4, 1, 12, 0, 0);

    test('seconds ago', () {
      final past = now.subtract(const Duration(seconds: 30));
      expect(formatter.format(past, now: now), '30 seconds ago');
    });

    test('1 minute ago', () {
      final past = now.subtract(const Duration(minutes: 1));
      expect(formatter.format(past, now: now), '1 minute ago');
    });

    test('minutes ago', () {
      final past = now.subtract(const Duration(minutes: 5));
      expect(formatter.format(past, now: now), '5 minutes ago');
    });

    test('hours ago', () {
      final past = now.subtract(const Duration(hours: 3));
      expect(formatter.format(past, now: now), '3 hours ago');
    });

    test('days ago', () {
      final past = now.subtract(const Duration(days: 2));
      expect(formatter.format(past, now: now), '2 days ago');
    });

    test('weeks ago', () {
      final past = now.subtract(const Duration(days: 14));
      expect(formatter.format(past, now: now), '2 weeks ago');
    });

    test('months ago', () {
      final past = now.subtract(const Duration(days: 60));
      expect(formatter.format(past, now: now), '2 months ago');
    });

    test('years ago', () {
      final past = now.subtract(const Duration(days: 400));
      expect(formatter.format(past, now: now), '1 year ago');
    });

    test('future time', () {
      final future = now.add(const Duration(hours: 2));
      expect(formatter.format(future, now: now), 'in 2 hours');
    });
  });

  group('RelativeTimeFormatter (ko)', () {
    const formatter = RelativeTimeFormatter(locale: 'ko');
    final now = DateTime(2026, 4, 1, 12, 0, 0);

    test('분 전', () {
      final past = now.subtract(const Duration(minutes: 3));
      expect(formatter.format(past, now: now), '3분 전');
    });

    test('시간 전', () {
      final past = now.subtract(const Duration(hours: 1));
      expect(formatter.format(past, now: now), '1시간 전');
    });

    test('future', () {
      final future = now.add(const Duration(days: 5));
      expect(formatter.format(future, now: now), '5일 후');
    });
  });

  group('NumberFormatter', () {
    const formatter = NumberFormatter();

    test('small numbers', () {
      expect(formatter.compact(0), '0');
      expect(formatter.compact(999), '999');
      expect(formatter.compact(42), '42');
    });

    test('thousands', () {
      expect(formatter.compact(1000), '1K');
      expect(formatter.compact(1200), '1.2K');
      expect(formatter.compact(15000), '15K');
      expect(formatter.compact(999999), '1000K');
    });

    test('millions', () {
      expect(formatter.compact(1000000), '1M');
      expect(formatter.compact(3400000), '3.4M');
      expect(formatter.compact(12500000), '12.5M');
    });

    test('billions', () {
      expect(formatter.compact(1000000000), '1B');
      expect(formatter.compact(2500000000), '2.5B');
    });

    test('negative numbers', () {
      expect(formatter.compact(-1500), '-1.5K');
      expect(formatter.compact(-42), '-42');
    });
  });

  group('LanguageService', () {
    const service = LanguageService();

    test('resolves exact match', () {
      expect(service.resolve('en'), 'en');
      expect(service.resolve('ko'), 'ko');
    });

    test('resolves with region suffix', () {
      expect(service.resolve('en_US'), 'en');
      expect(service.resolve('ko_KR'), 'ko');
      expect(service.resolve('ko-KR'), 'ko');
    });

    test('falls back for unsupported locale', () {
      expect(service.resolve('ja'), 'en');
      expect(service.resolve('fr_FR'), 'en');
    });

    test('isSupported checks correctly', () {
      expect(service.isSupported('en'), isTrue);
      expect(service.isSupported('ko'), isTrue);
      expect(service.isSupported('ja'), isFalse);
    });

    test('custom supported locales', () {
      const custom = LanguageService(
        supportedLocales: ['en', 'ko', 'ja'],
        fallbackLocale: 'ko',
      );

      expect(custom.resolve('ja_JP'), 'ja');
      expect(custom.resolve('zh'), 'ko'); // falls back to custom fallback
    });
  });
}
