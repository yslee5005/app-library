import 'package:flutter/foundation.dart';

import '../notification_service.dart';

class MockNotificationService implements NotificationService {
  NotificationSettings _settings = const NotificationSettings();

  @override
  Future<void> initialize() async {
    debugPrint('[MockNotification] initialized');
  }

  @override
  Future<String?> getToken() async => 'mock-fcm-token';

  @override
  Future<void> saveToken(String token) async {
    debugPrint('[MockNotification] saveToken: $token');
  }

  @override
  Future<void> requestPermission() async {
    debugPrint('[MockNotification] requestPermission');
  }

  @override
  Future<void> scheduleMorningReminder({
    required String time,
    required String userName,
  }) async {
    debugPrint('[MockNotification] scheduleMorningReminder: $time for $userName');
  }

  @override
  Future<void> scheduleEveningReminder() async {
    debugPrint('[MockNotification] scheduleEveningReminder at 21:00');
  }

  @override
  Future<void> scheduleAfternoonNudge() async {
    debugPrint('[MockNotification] scheduleAfternoonNudge at 14:00');
  }

  @override
  Future<void> showStreakCelebration(int streakCount) async {
    debugPrint('[MockNotification] showStreakCelebration: $streakCount days');
  }

  @override
  Future<void> cancelAllReminders() async {
    debugPrint('[MockNotification] cancelAllReminders');
  }

  @override
  Future<void> updateSettings({
    bool? morningReminder,
    String? morningTime,
    bool? eveningReminder,
    bool? afternoonNudge,
    bool? streakReminder,
    bool? weeklySummary,
  }) async {
    _settings = _settings.copyWith(
      morningReminder: morningReminder,
      morningTime: morningTime,
      eveningReminder: eveningReminder,
      afternoonNudge: afternoonNudge,
      streakReminder: streakReminder,
      weeklySummary: weeklySummary,
    );
    debugPrint('[MockNotification] updateSettings: $_settings');
  }

  @override
  Future<NotificationSettings> getSettings() async => _settings;
}
