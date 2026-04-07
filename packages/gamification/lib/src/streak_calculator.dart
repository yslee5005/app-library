import 'streak.dart';

/// Pure utility for calculating streak updates based on date differences.
class StreakCalculator {
  /// Returns an updated [Streak] after recording activity for [today].
  ///
  /// - diff == 0: already recorded today → no change
  /// - diff == 1: consecutive day → increment
  /// - diff == 2 && [graceRecovery]: grace recovery → keep streak + 1
  /// - diff > 2 (or diff == 2 without grace): reset to 1
  static Streak recordActivity(
    Streak current, {
    bool graceRecovery = false,
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    if (current.lastActivityDate == null) {
      // First ever activity
      return Streak(
        current: 1,
        best: current.best > 1 ? current.best : 1,
        lastActivityDate: todayDate,
      );
    }

    final lastDate = current.lastActivityDate!;
    final lastDateNormalized = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final diff = todayDate.difference(lastDateNormalized).inDays;

    if (diff == 0) {
      // Already recorded today
      return current;
    }

    if (diff == 1) {
      // Consecutive day
      final newCurrent = current.current + 1;
      return Streak(
        current: newCurrent,
        best: newCurrent > current.best ? newCurrent : current.best,
        lastActivityDate: todayDate,
      );
    }

    if (diff == 2 && graceRecovery) {
      // Grace recovery — missed one day but allowed
      final newCurrent = current.current + 1;
      return Streak(
        current: newCurrent,
        best: newCurrent > current.best ? newCurrent : current.best,
        lastActivityDate: todayDate,
      );
    }

    // Streak broken — reset
    return Streak(
      current: 1,
      best: current.best,
      lastActivityDate: todayDate,
    );
  }
}
