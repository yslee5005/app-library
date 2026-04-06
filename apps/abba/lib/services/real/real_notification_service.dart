import 'package:supabase_flutter/supabase_flutter.dart';

import '../notification_service.dart';

class RealNotificationService implements NotificationService {
  final SupabaseClient _client;
  NotificationSettings _cachedSettings = const NotificationSettings();

  RealNotificationService(this._client);

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<void> initialize() async {
    // Load settings from Supabase
    await getSettings();
  }

  @override
  Future<String?> getToken() async {
    // FCM token is obtained from firebase_messaging
    // Will be implemented when Firebase is configured
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await _client.from('user_devices').upsert({
      'app_id': 'abba',
      'user_id': _userId,
      'fcm_token': token,
      'platform': 'ios', // Detect at runtime
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<void> requestPermission() async {
    // Firebase messaging permission request
    // Will be implemented when Firebase is configured
  }

  @override
  Future<void> scheduleMorningReminder({
    required String time,
    required String userName,
  }) async {
    // Local notification scheduling via flutter_local_notifications
    // Will be implemented with Firebase integration
  }

  @override
  Future<void> scheduleEveningReminder() async {
    // Evening reminder at 21:00
  }

  @override
  Future<void> cancelAllReminders() async {
    // Cancel all local notifications
  }

  @override
  Future<void> updateSettings({
    bool? morningReminder,
    String? morningTime,
    bool? eveningReminder,
    bool? streakReminder,
    bool? weeklySummary,
  }) async {
    _cachedSettings = _cachedSettings.copyWith(
      morningReminder: morningReminder,
      morningTime: morningTime,
      eveningReminder: eveningReminder,
      streakReminder: streakReminder,
      weeklySummary: weeklySummary,
    );

    await _client.from('notification_settings').upsert({
      'app_id': 'abba',
      'user_id': _userId,
      'morning_reminder': _cachedSettings.morningReminder,
      'morning_time': _cachedSettings.morningTime,
      'evening_reminder': _cachedSettings.eveningReminder,
      'streak_reminder': _cachedSettings.streakReminder,
      'weekly_summary': _cachedSettings.weeklySummary,
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Reschedule notifications based on new settings
    await cancelAllReminders();
    if (_cachedSettings.morningReminder) {
      await scheduleMorningReminder(
        time: _cachedSettings.morningTime,
        userName: '', // Will be passed from profile
      );
    }
    if (_cachedSettings.eveningReminder) {
      await scheduleEveningReminder();
    }
  }

  @override
  Future<NotificationSettings> getSettings() async {
    final data = await _client
        .from('notification_settings')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .maybeSingle();

    if (data != null) {
      _cachedSettings = NotificationSettings.fromJson(data);
    }
    return _cachedSettings;
  }
}
