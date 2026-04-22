import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';

void main() {
  // Build a fixture of N consecutive prayer days ending today (inclusive).
  List<Prayer> consecutiveDayFixture(int days, {DateTime? endOn}) {
    final end = endOn ?? DateTime.now();
    return List.generate(days, (i) {
      final d = end.subtract(Duration(days: i));
      return Prayer(
        id: 'fixture-$i',
        userId: 'mock-user',
        transcript: 'Fixture prayer $i',
        mode: 'prayer',
        createdAt: d,
      );
    });
  }

  group('MockPrayerRepository', () {
    Prayer makePrayer({DateTime? createdAt}) {
      return Prayer(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'user-1',
        transcript: 'Test prayer',
        mode: 'prayer',
        createdAt: createdAt ?? DateTime.now(),
      );
    }

    test('savePrayer adds to list', () async {
      // Start empty (no asset load), then save.
      final repo = MockPrayerRepository.fromData(const []);
      final prayer = makePrayer();
      await repo.savePrayer(prayer);

      final latest = await repo.getLatestPrayer();
      expect(latest, isNotNull);
      expect(latest!.transcript, 'Test prayer');
    });

    test('getPrayersByDate returns matching prayers', () async {
      final repo = MockPrayerRepository.fromData(const []);
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      await repo.savePrayer(makePrayer(createdAt: today));
      await repo.savePrayer(makePrayer(createdAt: yesterday));

      final todayPrayers = await repo.getPrayersByDate(today);
      expect(todayPrayers.length, 1);
    });

    test('getPrayersByMonth returns matching prayers', () async {
      final repo = MockPrayerRepository.fromData(const []);
      final now = DateTime.now();
      await repo.savePrayer(makePrayer(createdAt: now));

      final monthPrayers = await repo.getPrayersByMonth(now.year, now.month);
      expect(monthPrayers.length, 1);
    });

    test('getTodayPrayerCount counts correctly', () async {
      final repo = MockPrayerRepository.fromData(const []);
      await repo.savePrayer(makePrayer());
      await repo.savePrayer(makePrayer());

      final count = await repo.getTodayPrayerCount();
      expect(count, 2);
    });

    test('updateStreak does not regress current streak', () async {
      // Seed 7 consecutive days ending today → current=7, best=7.
      // Current `updateStreak()` is a no-op (streak is derived from prayer
      // data, not a counter), so the streak stays stable across the call.
      final repo = MockPrayerRepository.fromData(consecutiveDayFixture(7));
      final before = await repo.getStreak();
      expect(before.current, 7);

      await repo.updateStreak();

      final after = await repo.getStreak();
      expect(after.current, before.current);
    });

    test('updateStreak preserves best streak', () async {
      // Seed 21 consecutive days ending today → current=21, best=21.
      final repo = MockPrayerRepository.fromData(consecutiveDayFixture(21));
      await repo.updateStreak();

      final streak = await repo.getStreak();
      expect(streak.current, 21);
      expect(streak.best, 21);
    });

    test('getLatestPrayer returns null when empty', () async {
      final repo = MockPrayerRepository.fromData(const []);
      final latest = await repo.getLatestPrayer();
      expect(latest, isNull);
    });

    test('getTotalPrayerCount returns correct count', () async {
      final repo = MockPrayerRepository.fromData(const []);
      expect(await repo.getTotalPrayerCount(), 0);

      await repo.savePrayer(makePrayer());
      expect(await repo.getTotalPrayerCount(), 1);

      await repo.savePrayer(makePrayer());
      expect(await repo.getTotalPrayerCount(), 2);
    });

    test('checkMilestones detects first prayer', () async {
      final repo = MockPrayerRepository.fromData(const []);
      await repo.savePrayer(makePrayer());
      final milestones = await repo.checkMilestones();
      expect(milestones, contains('first_prayer'));
    });

    test('checkMilestones detects 7 day streak', () async {
      // Seed exactly 7 consecutive days ending today → streak.current == 7.
      final repo = MockPrayerRepository.fromData(consecutiveDayFixture(7));
      final milestones = await repo.checkMilestones();
      expect(milestones, contains('7_day_streak'));
    });
  });

  // ---------------------------------------------------------------------------
  // Phase 5D (qt_output_redesign) — QT meditation result persistence.
  //
  // Integration-level coverage (savePrayer → getLatestPrayer with qtResult
  // preserved) cannot run here: MockPrayerRepository lazy-loads
  // `assets/mock/prayers.json` via rootBundle, and the abba test harness does
  // not wire flutter_test asset bundles. The same blocker causes all
  // pre-existing MockPrayerRepository tests above to fail, so adding more
  // rows wouldn't add signal.
  //
  // Phase 5D coverage therefore lives at the unit level:
  //   - test/models/prayer_test.dart `Phase 5D QT persistence` (fromJson
  //     dispatch on mode; QT round-trip via toJson/fromJson).
  //   - test/models/qt_meditation_result_test.dart `Phase 5D serialization`
  //     (full sub-model toJson + round-trip).
  // ---------------------------------------------------------------------------
}
