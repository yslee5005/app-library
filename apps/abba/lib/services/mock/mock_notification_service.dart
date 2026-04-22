import 'package:app_lib_logging/logging.dart';

import '../../l10n/generated/app_localizations.dart';
import '../notification_service.dart';

class MockNotificationService implements NotificationService {
  NotificationSettings _settings = const NotificationSettings();

  @override
  Future<void> initialize() async {
    fcmLog.debug('[MockNotification] initialized');
  }

  @override
  Future<String?> getToken() async => 'mock-fcm-token';

  @override
  Future<void> saveToken(String token) async {
    fcmLog.debug('[MockNotification] saveToken: $token');
  }

  @override
  Future<void> requestPermission() async {
    fcmLog.debug('[MockNotification] requestPermission');
  }

  @override
  Future<void> setLocalization(AppLocalizations l10n) async {
    fcmLog.debug('[MockNotification] setLocalization: ${l10n.localeName}');
  }

  @override
  Future<void> scheduleMorningReminder({
    required String time,
    required String userName,
  }) async {
    fcmLog.debug('[MockNotification] scheduleMorningReminder: $time for $userName');
  }

  @override
  Future<void> scheduleEveningReminder() async {
    fcmLog.debug('[MockNotification] scheduleEveningReminder at 21:00');
  }

  @override
  Future<void> scheduleAfternoonNudge() async {
    fcmLog.debug('[MockNotification] scheduleAfternoonNudge at 14:00');
  }

  @override
  Future<void> showStreakCelebration(int streakCount) async {
    fcmLog.debug('[MockNotification] showStreakCelebration: $streakCount days');
  }

  @override
  Future<void> cancelAllReminders() async {
    fcmLog.debug('[MockNotification] cancelAllReminders');
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
    fcmLog.debug('[MockNotification] updateSettings: $_settings');
  }

  @override
  Future<NotificationSettings> getSettings() async => _settings;
}
