import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';

/// Abstract prayer repository — mock returns JSON, real calls Supabase
abstract class PrayerRepository {
  Future<void> savePrayer(Prayer prayer);

  /// 2026-04-23 Pending/Retry: INSERT a prayer with `ai_status='pending'`
  /// BEFORE calling AI. Returns the assigned prayer id so the caller can
  /// later UPDATE it via [completePrayer] / [markPrayerFailedRetry].
  ///
  /// The raw prayer (transcript for text mode, audio_storage_path for voice
  /// mode) is persisted immediately — if AI subsequently fails, the user's
  /// content is never lost.
  Future<String> savePendingPrayer(Prayer prayer);

  /// 2026-04-23 Pending/Retry: after successful AI analysis, UPDATE the
  /// pending record with result + final transcript (audio mode) and flip
  /// `ai_status='completed'`.
  Future<void> completePrayer({
    required String prayerId,
    required String transcript,
    PrayerResult? result,
    QtMeditationResult? qtResult,
  });

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
