import '../models/prayer.dart';

/// Abstract prayer repository — mock returns JSON, real calls Supabase
abstract class PrayerRepository {
  Future<void> savePrayer(Prayer prayer);
  Future<List<Prayer>> getPrayersByDate(DateTime date);
  Future<List<Prayer>> getPrayersByMonth(int year, int month);
  Future<Prayer?> getLatestPrayer();
  Future<int> getTodayPrayerCount();
  Future<void> updateStreak();
  Future<({int current, int best})> getStreak();
  Future<int> getTotalPrayerCount();

  /// Check and record milestones, returns list of newly achieved milestones
  Future<List<String>> checkMilestones();
}
