import 'package:abba/services/prayer_quota_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('PrayerQuotaService', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('canStart(limit: null) is always true (pro tier)', () async {
      final prefs = await SharedPreferences.getInstance();
      final svc = PrayerQuotaService(prefs: prefs);

      for (var i = 0; i < 5; i++) {
        expect(await svc.canStart(limit: null), isTrue);
        await svc.increment();
      }
    });

    test(
      'canStart(limit: 3) becomes false after 3 increments same day',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final now = DateTime(2026, 4, 24, 10);
        final svc = PrayerQuotaService(prefs: prefs, now: () => now);

        expect(await svc.canStart(limit: 3), isTrue);
        await svc.increment();
        expect(await svc.canStart(limit: 3), isTrue);
        await svc.increment();
        expect(await svc.canStart(limit: 3), isTrue);
        await svc.increment();
        expect(await svc.canStart(limit: 3), isFalse);
        expect(await svc.getTodayCount(), 3);
      },
    );

    test(
      'canStart(limit: 1) becomes false after 1 increment (free tier)',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final svc = PrayerQuotaService(prefs: prefs);

        expect(await svc.canStart(limit: 1), isTrue);
        await svc.increment();
        expect(await svc.canStart(limit: 1), isFalse);
      },
    );

    test('counter resets at local-day boundary', () async {
      final prefs = await SharedPreferences.getInstance();
      var currentNow = DateTime(2026, 4, 24, 23, 50);
      DateTime nowFn() => currentNow;
      final svc = PrayerQuotaService(prefs: prefs, now: nowFn);

      await svc.increment();
      await svc.increment();
      await svc.increment();
      expect(await svc.getTodayCount(), 3);
      expect(await svc.canStart(limit: 3), isFalse);

      // Advance to the next local day.
      currentNow = DateTime(2026, 4, 25, 0, 1);
      expect(await svc.getTodayCount(), 0);
      expect(await svc.canStart(limit: 3), isTrue);

      await svc.increment();
      expect(await svc.getTodayCount(), 1);
      expect(await svc.canStart(limit: 3), isTrue);
    });

    test(
      'increment persists across service instances with same prefs',
      () async {
        final prefs = await SharedPreferences.getInstance();
        final now = DateTime(2026, 4, 24, 10);

        final svc1 = PrayerQuotaService(prefs: prefs, now: () => now);
        await svc1.increment();
        await svc1.increment();
        expect(await svc1.getTodayCount(), 2);

        final svc2 = PrayerQuotaService(prefs: prefs, now: () => now);
        expect(await svc2.getTodayCount(), 2);
      },
    );
  });
}
