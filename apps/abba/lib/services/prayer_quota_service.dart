import 'package:shared_preferences/shared_preferences.dart';

/// Tracks the user's daily prayer count in local storage for the purpose
/// of enforcing tier-based soft caps (free = 1/day, trial = 3/day,
/// pro = unlimited). Uses the device's **local** date — the day boundary
/// is the device's midnight, not UTC.
///
/// Not multi-user aware — anonymous-first means one device = one quota.
/// If an account is linked and used on a second device, quota is tracked
/// independently per device, which is acceptable for a soft cap.
class PrayerQuotaService {
  PrayerQuotaService({
    required SharedPreferences prefs,
    DateTime Function() now = DateTime.now,
  }) : _prefs = prefs,
       _now = now;

  final SharedPreferences _prefs;
  final DateTime Function() _now;

  static const _dateKey = 'abba_quota_date';
  static const _countKey = 'abba_quota_count';

  /// Format a [DateTime] to its local-date `YYYY-MM-DD` string.
  String _todayKey() {
    final local = _now().toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Current count for today. Returns 0 when the stored date is not
  /// today's local date (i.e. the counter has rolled over overnight).
  Future<int> getTodayCount() async {
    final stored = _prefs.getString(_dateKey);
    if (stored != _todayKey()) return 0;
    return _prefs.getInt(_countKey) ?? 0;
  }

  /// Returns true when the user may start a prayer given [limit].
  /// A null [limit] means unlimited (pro tier) — always true.
  Future<bool> canStart({required int? limit}) async {
    if (limit == null) return true;
    final count = await getTodayCount();
    return count < limit;
  }

  /// Records one prayer for the current local date. If the stored date
  /// is stale (yesterday or older), the counter resets to 1.
  Future<void> increment() async {
    final today = _todayKey();
    final stored = _prefs.getString(_dateKey);
    final int next = (stored == today)
        ? (_prefs.getInt(_countKey) ?? 0) + 1
        : 1;
    await _prefs.setString(_dateKey, today);
    await _prefs.setInt(_countKey, next);
  }
}
