import '../notification_service.dart';

class MockNotificationService implements NotificationService {
  NotificationSettings _settings = const NotificationSettings();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> getToken() async => 'mock-fcm-token';

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> scheduleMorningReminder({
    required String time,
    required String userName,
  }) async {}

  @override
  Future<void> scheduleEveningReminder() async {}

  @override
  Future<void> cancelAllReminders() async {}

  @override
  Future<void> updateSettings({
    bool? morningReminder,
    String? morningTime,
    bool? eveningReminder,
    bool? streakReminder,
    bool? weeklySummary,
  }) async {
    _settings = _settings.copyWith(
      morningReminder: morningReminder,
      morningTime: morningTime,
      eveningReminder: eveningReminder,
      streakReminder: streakReminder,
      weeklySummary: weeklySummary,
    );
  }

  @override
  Future<NotificationSettings> getSettings() async => _settings;
}
