import 'package:flutter_test/flutter_test.dart';
import 'package:abba/models/prayer.dart';
import 'package:abba/services/mock/mock_prayer_repository.dart';

void main() {
  late MockPrayerRepository repo;

  setUp(() {
    repo = MockPrayerRepository();
  });

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
      final prayer = makePrayer();
      await repo.savePrayer(prayer);

      final latest = await repo.getLatestPrayer();
      expect(latest, isNotNull);
      expect(latest!.transcript, 'Test prayer');
    });

    test('getPrayersByDate returns matching prayers', () async {
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));

      await repo.savePrayer(makePrayer(createdAt: today));
      await repo.savePrayer(makePrayer(createdAt: yesterday));

      final todayPrayers = await repo.getPrayersByDate(today);
      expect(todayPrayers.length, 1);
    });

    test('getPrayersByMonth returns matching prayers', () async {
      final now = DateTime.now();
      await repo.savePrayer(makePrayer(createdAt: now));

      final monthPrayers = await repo.getPrayersByMonth(now.year, now.month);
      expect(monthPrayers.length, 1);
    });

    test('getTodayPrayerCount counts correctly', () async {
      await repo.savePrayer(makePrayer());
      await repo.savePrayer(makePrayer());

      final count = await repo.getTodayPrayerCount();
      expect(count, 2);
    });

    test('updateStreak increments current streak', () async {
      final before = await repo.getStreak();
      expect(before.current, 7); // initial mock value

      await repo.updateStreak();

      final after = await repo.getStreak();
      expect(after.current, 8);
    });

    test('updateStreak updates best streak when exceeded', () async {
      // Initial best is 21, current is 7
      // Need to increment 15 times to exceed
      for (var i = 0; i < 15; i++) {
        await repo.updateStreak();
      }

      final streak = await repo.getStreak();
      expect(streak.current, 22);
      expect(streak.best, 22);
    });

    test('getLatestPrayer returns null when empty', () async {
      final latest = await repo.getLatestPrayer();
      expect(latest, isNull);
    });

    test('getTotalPrayerCount returns correct count', () async {
      expect(await repo.getTotalPrayerCount(), 0);

      await repo.savePrayer(makePrayer());
      expect(await repo.getTotalPrayerCount(), 1);

      await repo.savePrayer(makePrayer());
      expect(await repo.getTotalPrayerCount(), 2);
    });

    test('checkMilestones detects first prayer', () async {
      await repo.savePrayer(makePrayer());
      final milestones = await repo.checkMilestones();
      expect(milestones, contains('first_prayer'));
    });

    test('checkMilestones detects 7 day streak', () async {
      // Mock initial streak is 7, so milestone should trigger
      final milestones = await repo.checkMilestones();
      expect(milestones, contains('7_day_streak'));
    });
  });
}
