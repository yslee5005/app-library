/// Abstract notification service for push notifications and reminders
abstract class NotificationService {
  Future<void> initialize();

  Future<String?> getToken();

  Future<void> saveToken(String token);

  Future<void> requestPermission();

  /// Schedule morning prayer reminder
  Future<void> scheduleMorningReminder({
    required String time, // "HH:mm" format
    required String userName,
  });

  /// Schedule evening gratitude reminder
  Future<void> scheduleEveningReminder();

  /// Cancel all scheduled reminders
  Future<void> cancelAllReminders();

  /// Update notification settings
  Future<void> updateSettings({
    bool? morningReminder,
    String? morningTime,
    bool? eveningReminder,
    bool? streakReminder,
    bool? weeklySummary,
  });

  /// Get current notification settings
  Future<NotificationSettings> getSettings();
}

class NotificationSettings {
  final bool morningReminder;
  final String morningTime;
  final bool eveningReminder;
  final bool streakReminder;
  final bool weeklySummary;

  const NotificationSettings({
    this.morningReminder = true,
    this.morningTime = '06:00',
    this.eveningReminder = false,
    this.streakReminder = true,
    this.weeklySummary = true,
  });

  NotificationSettings copyWith({
    bool? morningReminder,
    String? morningTime,
    bool? eveningReminder,
    bool? streakReminder,
    bool? weeklySummary,
  }) {
    return NotificationSettings(
      morningReminder: morningReminder ?? this.morningReminder,
      morningTime: morningTime ?? this.morningTime,
      eveningReminder: eveningReminder ?? this.eveningReminder,
      streakReminder: streakReminder ?? this.streakReminder,
      weeklySummary: weeklySummary ?? this.weeklySummary,
    );
  }

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      morningReminder: json['morning_reminder'] as bool? ?? true,
      morningTime: json['morning_time'] as String? ?? '06:00',
      eveningReminder: json['evening_reminder'] as bool? ?? false,
      streakReminder: json['streak_reminder'] as bool? ?? true,
      weeklySummary: json['weekly_summary'] as bool? ?? true,
    );
  }
}
