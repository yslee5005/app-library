class DailyLog {
  final String date; // 'yyyy-MM-dd'
  final String routineId;
  final bool completed;
  final DateTime? completedAt;

  const DailyLog({
    required this.date,
    required this.routineId,
    required this.completed,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'routineId': routineId,
      'completed': completed,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      date: json['date'] as String,
      routineId: json['routineId'] as String,
      completed: json['completed'] as bool,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  DailyLog copyWith({
    String? date,
    String? routineId,
    bool? completed,
    DateTime? completedAt,
  }) {
    return DailyLog(
      date: date ?? this.date,
      routineId: routineId ?? this.routineId,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
