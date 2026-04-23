import 'package:flutter_test/flutter_test.dart';

import 'package:app_lib_logging/logging.dart';

import 'package:abba/services/mock/mock_notification_service.dart';
import 'package:abba/services/notification_service.dart';

/// Tests for [NotificationSettings] (model) + [MockNotificationService]
/// (in-memory impl). The real implementation ([RealNotificationService]) is
/// out of scope here because it depends on firebase_messaging and
/// flutter_local_notifications platform channels that cannot be mocked
/// without an integration harness.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // MockNotificationService logs via fcmLog → requires appLogger.
    appLogger = Logger(
      config: LogConfig.development,
      outputs: const [NoopOutput()],
    );
  });

  group('NotificationSettings', () {
    test('defaults match product spec', () {
      const settings = NotificationSettings();
      expect(settings.morningReminder, isTrue);
      expect(settings.morningTime, '06:00');
      expect(settings.eveningReminder, isFalse);
      expect(settings.afternoonNudge, isTrue);
      expect(settings.streakReminder, isTrue);
      expect(settings.weeklySummary, isTrue);
    });

    test('copyWith overrides only provided fields', () {
      const base = NotificationSettings();
      final updated = base.copyWith(
        morningTime: '07:30',
        eveningReminder: true,
      );
      expect(updated.morningTime, '07:30');
      expect(updated.eveningReminder, isTrue);
      // Untouched
      expect(updated.morningReminder, base.morningReminder);
      expect(updated.afternoonNudge, base.afternoonNudge);
    });

    test('fromJson reads all fields with correct defaults', () {
      final settings = NotificationSettings.fromJson(const {
        'morning_reminder': false,
        'morning_time': '05:30',
        'evening_reminder': true,
        'afternoon_nudge': false,
        'streak_reminder': false,
        'weekly_summary': false,
      });
      expect(settings.morningReminder, isFalse);
      expect(settings.morningTime, '05:30');
      expect(settings.eveningReminder, isTrue);
      expect(settings.afternoonNudge, isFalse);
      expect(settings.streakReminder, isFalse);
      expect(settings.weeklySummary, isFalse);
    });

    test('fromJson falls back to defaults for missing keys', () {
      final settings = NotificationSettings.fromJson(const {});
      expect(settings.morningReminder, isTrue);
      expect(settings.morningTime, '06:00');
      expect(settings.eveningReminder, isFalse);
    });
  });

  group('MockNotificationService', () {
    late MockNotificationService service;

    setUp(() {
      service = MockNotificationService();
    });

    test('getToken returns the stub FCM token', () async {
      expect(await service.getToken(), 'mock-fcm-token');
    });

    test('getSettings returns defaults before any update', () async {
      final settings = await service.getSettings();
      expect(settings.morningReminder, isTrue);
      expect(settings.morningTime, '06:00');
    });

    test('updateSettings persists changes in-memory', () async {
      await service.updateSettings(
        morningReminder: false,
        morningTime: '07:30',
        eveningReminder: true,
      );
      final settings = await service.getSettings();
      expect(settings.morningReminder, isFalse);
      expect(settings.morningTime, '07:30');
      expect(settings.eveningReminder, isTrue);
      // Untouched fields keep their defaults.
      expect(settings.afternoonNudge, isTrue);
      expect(settings.weeklySummary, isTrue);
    });

    test('updateSettings with no args is a no-op', () async {
      final before = await service.getSettings();
      await service.updateSettings();
      final after = await service.getSettings();
      expect(after.morningReminder, before.morningReminder);
      expect(after.morningTime, before.morningTime);
    });

    test('schedule + cancel are no-op but do not throw', () async {
      await service.initialize();
      await service.requestPermission();
      await service.scheduleMorningReminder(
        time: '06:00',
        userName: 'Grace',
      );
      await service.scheduleEveningReminder();
      await service.scheduleAfternoonNudge();
      await service.showStreakCelebration(7);
      await service.cancelAllReminders();
      // Reaching this line without exception is the assertion.
    });
  });
}
