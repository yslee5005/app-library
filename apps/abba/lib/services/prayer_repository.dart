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

  /// Phase 4.1: Atomic per-tier UPDATE via `abba.update_prayer_tier` RPC.
  /// Safely merges [sectionData] into `result JSONB` and flips the tier
  /// flag in `section_status`. Server uses `||` operator so concurrent
  /// T1/T2 updates never lose each other's data.
  ///
  /// [tier] must be 't1', 't2', or 't3'.
  /// [sectionData] is a JSON map containing only the fields for that tier,
  /// e.g. `{"summary": {...}, "scripture": {...}}` for T1.
  Future<void> updateTierResult({
    required String prayerId,
    required String tier,
    required Map<String, dynamic> sectionData,
  });

  /// Phase A1 — record per-tier partial failure (T2/T3) in
  /// `abba.prayers.section_status` JSONB without flipping `ai_status`.
  /// Called from the notifier stream listener when a `TierFailed` event
  /// arrives. The dashboard reads section_status to render an inline
  /// "분석 일부를 불러오지 못했어요" indicator on revisit.
  ///
  /// Recovery: a subsequent successful [updateTierResult] for the same
  /// tier overwrites the 'failed' value via the JSONB `||` operator —
  /// no extra reset call needed.
  ///
  /// [tier] must be 't1', 't2', or 't3'.
  /// [errorKind] is an opaque tag (e.g., AiAnalysisFailureKind.name) used
  /// only for logging; the DB just records 'failed' state.
  ///
  /// Best-effort: implementations log on failure but never throw.
  Future<void> markTierFailed({
    required String prayerId,
    required String tier,
    required String errorKind,
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
