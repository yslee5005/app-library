import '../../models/prayer.dart';
import '../prayer_repository.dart';

class MockPrayerRepository implements PrayerRepository {
  final List<Prayer> _prayers = [];
  int _currentStreak = 7;
  int _bestStreak = 21;

  MockPrayerRepository();

  @override
  Future<void> savePrayer(Prayer prayer) async {
    _prayers.insert(0, prayer);
  }

  @override
  Future<List<Prayer>> getPrayersByDate(DateTime date) async {
    return _prayers
        .where(
          (p) =>
              p.createdAt.year == date.year &&
              p.createdAt.month == date.month &&
              p.createdAt.day == date.day,
        )
        .toList();
  }

  @override
  Future<List<Prayer>> getPrayersByMonth(int year, int month) async {
    return _prayers
        .where((p) => p.createdAt.year == year && p.createdAt.month == month)
        .toList();
  }

  @override
  Future<Prayer?> getLatestPrayer() async {
    if (_prayers.isEmpty) return null;
    return _prayers.first;
  }

  @override
  Future<int> getTodayPrayerCount() async {
    final now = DateTime.now();
    return _prayers
        .where(
          (p) =>
              p.createdAt.year == now.year &&
              p.createdAt.month == now.month &&
              p.createdAt.day == now.day,
        )
        .length;
  }

  @override
  Future<void> updateStreak() async {
    _currentStreak++;
    if (_currentStreak > _bestStreak) {
      _bestStreak = _currentStreak;
    }
  }

  @override
  Future<({int current, int best})> getStreak() async {
    return (current: _currentStreak, best: _bestStreak);
  }

  @override
  Future<int> getTotalPrayerCount() async => _prayers.length;

  @override
  Future<List<String>> checkMilestones() async {
    final milestones = <String>[];
    if (_prayers.length == 1) milestones.add('first_prayer');
    if (_currentStreak == 7) milestones.add('7_day_streak');
    if (_currentStreak == 30) milestones.add('30_day_streak');
    if (_prayers.length == 100) milestones.add('100_prayers');
    return milestones;
  }
}
