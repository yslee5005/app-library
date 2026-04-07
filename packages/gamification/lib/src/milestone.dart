/// Represents an achievement milestone.
class Milestone {
  const Milestone({
    required this.type,
    required this.achievedAt,
  });

  /// e.g. 'first_activity', '7_day_streak', '30_day_streak'
  final String type;
  final DateTime achievedAt;
}
