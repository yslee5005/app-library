/// Tracks the user's reading progress for a single content item.
class ReadingProgress {
  ReadingProgress({
    required this.contentId,
    this.scrollPosition = 0.0,
    this.isCompleted = false,
    DateTime? lastReadAt,
    this.timeSpentSeconds = 0,
  }) : lastReadAt = lastReadAt ?? DateTime.now();

  final String contentId;

  /// Scroll position as a fraction (0.0 – 1.0).
  final double scrollPosition;

  final bool isCompleted;
  final DateTime lastReadAt;
  final int timeSpentSeconds;

  ReadingProgress copyWith({
    double? scrollPosition,
    bool? isCompleted,
    DateTime? lastReadAt,
    int? timeSpentSeconds,
  }) {
    return ReadingProgress(
      contentId: contentId,
      scrollPosition: scrollPosition ?? this.scrollPosition,
      isCompleted: isCompleted ?? this.isCompleted,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      timeSpentSeconds: timeSpentSeconds ?? this.timeSpentSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'contentId': contentId,
        'scrollPosition': scrollPosition,
        'isCompleted': isCompleted,
        'lastReadAt': lastReadAt.toIso8601String(),
        'timeSpentSeconds': timeSpentSeconds,
      };

  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      contentId: json['contentId'] as String,
      scrollPosition: (json['scrollPosition'] as num?)?.toDouble() ?? 0.0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      lastReadAt: DateTime.tryParse(json['lastReadAt'] as String? ?? ''),
      timeSpentSeconds: json['timeSpentSeconds'] as int? ?? 0,
    );
  }
}
