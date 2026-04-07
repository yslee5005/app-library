/// Represents a user's activity streak.
class Streak {
  const Streak({
    required this.current,
    required this.best,
    this.lastActivityDate,
  });

  final int current;
  final int best;
  final DateTime? lastActivityDate;

  Streak copyWith({
    int? current,
    int? best,
    DateTime? lastActivityDate,
  }) {
    return Streak(
      current: current ?? this.current,
      best: best ?? this.best,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
    );
  }
}
