import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    hide NotificationSettings;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../config/app_config.dart';
import '../notification_service.dart';

/// Notification IDs for scheduled reminders
class _NotificationIds {
  static const morningReminder = 1;
  static const eveningReminder = 2;
  static const afternoonNudge = 3;
  static const streakCelebration = 100;
}

/// SharedPreferences keys for notification settings
class _PrefKeys {
  static const morningReminder = 'notif_morning_reminder';
  static const morningTime = 'notif_morning_time';
  static const eveningReminder = 'notif_evening_reminder';
  static const afternoonNudge = 'notif_afternoon_nudge';
  static const streakReminder = 'notif_streak_reminder';
  static const weeklySummary = 'notif_weekly_summary';
}

class RealNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationSettings _cachedSettings = const NotificationSettings();

  /// Whether Firebase was successfully initialized
  bool _firebaseInitialized = false;

  RealNotificationService();

  // ---------------------------------------------------------------------------
  // Morning messages — rotated daily by day-of-year
  // ---------------------------------------------------------------------------
  static const _morningMessages = [
    ('🙏 기도할 시간이에요', '{name}님, 오늘도 하나님과 대화해보세요'),
    ('🌅 새 아침이 밝았어요', '{name}님, 감사로 하루를 시작해보세요'),
    ('✨ 오늘의 은혜', '{name}님, 하나님이 준비하신 은혜를 만나보세요'),
    ('🕊️ 평안한 아침', '{name}님, 기도로 마음에 평안을 채워보세요'),
    ('📖 말씀과 함께', '{name}님, 오늘 하나님의 음성을 들어보세요'),
    ('🌿 쉼의 시간', '{name}님, 잠시 멈추고 기도해보세요'),
    ('💫 오늘 하루도', '{name}님, 기도로 시작하는 하루가 달라요'),
  ];

  // ---------------------------------------------------------------------------
  // Evening messages — rotated daily by day-of-year
  // ---------------------------------------------------------------------------
  static const _eveningMessages = [
    ('✨ 오늘 하루 감사', '오늘 하루를 돌아보며 감사 기도를 드려보세요'),
    ('🌙 하루를 마무리하며', '오늘의 감사를 기도로 표현해보세요'),
    ('🙏 저녁 기도', '하루의 끝, 하나님께 감사를 올려드려요'),
    ('🌟 오늘의 은혜를 세며', '감사할 것이 있다면 기도로 나눠보세요'),
  ];

  // ---------------------------------------------------------------------------
  // Streak milestone messages
  // ---------------------------------------------------------------------------
  static const _streakMilestones = <int, (String, String)>{
    3: ('🌱 3일 연속!', '기도 습관이 시작됐어요'),
    7: ('🌿 일주일 연속!', '기도가 습관이 되고 있어요'),
    14: ('🌳 2주 연속!', '놀라운 성장이에요'),
    21: ('🌻 3주 연속!', '기도의 꽃이 피고 있어요'),
    30: ('🏆 한 달 연속!', '당신의 기도가 빛나고 있어요'),
    50: ('👑 50일 연속!', '하나님과의 동행이 깊어지고 있어요'),
    100: ('🎉 100일 연속!', '기도의 전사가 되었어요!'),
    365: ('✝️ 1년 연속!', '놀라운 믿음의 여정이에요!'),
  };

  /// Get the day-of-year (1-366) for a given DateTime
  static int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }

  @override
  Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS/macOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'prayer_reminders',
      '기도 알림',
      description: '아침 기도, 저녁 감사 등 기도 알림',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Load saved settings
    await getSettings();

    // Reschedule based on saved settings
    await _rescheduleFromSettings();

    // Initialize FCM (Firebase Cloud Messaging)
    // Wrapped in try/catch — app works without Firebase configured
    await _initializeFcm();
  }

  /// Initialize Firebase and FCM.
  /// All Firebase calls are wrapped in try/catch so the app still works
  /// without Firebase configured (e.g., in development).
  Future<void> _initializeFcm() async {
    try {
      // Dynamically import and initialize Firebase
      // This will fail if google-services.json / GoogleService-Info.plist
      // is not configured — that's expected and handled gracefully.
      final firebaseCore = await _tryInitializeFirebase();
      if (!firebaseCore) {
        debugPrint('FCM: Firebase not configured — skipping FCM setup');
        return;
      }

      _firebaseInitialized = true;

      // Import firebase_messaging dynamically
      final messaging = _getFirebaseMessaging();
      if (messaging == null) return;

      // Request FCM permission (iOS requires explicit permission)
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        'FCM: Permission status: ${settings.authorizationStatus}',
      );

      // Get FCM token and save it
      final token = await messaging.getToken();
      if (token != null) {
        debugPrint('FCM: Token obtained (${token.substring(0, 10)}...)');
        await saveToken(token);
      }

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM: Token refreshed');
        saveToken(newToken);
      });
    } catch (e, st) {
      debugPrint('FCM: Initialization failed (app continues without FCM): $e');
      debugPrint('FCM: Stack trace: $st');
      _firebaseInitialized = false;
    }
  }

  /// Try to initialize Firebase. Returns true if successful.
  Future<bool> _tryInitializeFirebase() async {
    try {
      // ignore: depend_on_referenced_packages
      final firebase = await _importFirebaseCore();
      return firebase;
    } catch (e) {
      debugPrint('FCM: Firebase Core init failed: $e');
      return false;
    }
  }

  /// Attempt to initialize Firebase Core.
  /// Returns true if Firebase was initialized successfully.
  Future<bool> _importFirebaseCore() async {
    try {
      await Firebase.initializeApp();
      return true;
    } catch (e) {
      debugPrint('FCM: Firebase.initializeApp() failed: $e');
      return false;
    }
  }

  /// Get FirebaseMessaging instance, or null if not available.
  FirebaseMessaging? _getFirebaseMessaging() {
    try {
      return FirebaseMessaging.instance;
    } catch (e) {
      debugPrint('FCM: Could not get FirebaseMessaging instance: $e');
      return null;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  @override
  Future<String?> getToken() async {
    if (!_firebaseInitialized) return null;

    try {
      final messaging = _getFirebaseMessaging();
      return await messaging?.getToken();
    } catch (e) {
      debugPrint('FCM: getToken() failed: $e');
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        debugPrint('FCM: No authenticated user — skipping token save');
        return;
      }

      final platform = Platform.isIOS ? 'ios' : 'android';
      final appId = AppConfig.appId;

      await supabase.from('user_devices').upsert(
        {
          'app_id': appId,
          'user_id': user.id,
          'fcm_token': token,
          'platform': platform,
          'is_active': true,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
        onConflict: 'app_id,user_id,fcm_token',
      );

      debugPrint('FCM: Token saved to user_devices for user ${user.id}');
    } catch (e) {
      // Don't crash if table doesn't exist yet or Supabase is unavailable
      debugPrint('FCM: saveToken() failed (non-fatal): $e');
    }
  }

  @override
  Future<void> requestPermission() async {
    // Request iOS permissions
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request Android 13+ permissions
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  @override
  Future<void> scheduleMorningReminder({
    required String time,
    required String userName,
  }) async {
    final parts = time.split(':');
    final hour = int.tryParse(parts[0]) ?? 6;
    final minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    // Pick message based on day of year (rotates daily)
    final dayIndex = _dayOfYear(DateTime.now()) % _morningMessages.length;
    final (title, bodyTemplate) = _morningMessages[dayIndex];

    final body = userName.isNotEmpty
        ? bodyTemplate.replaceAll('{name}', userName)
        : bodyTemplate.replaceAll('{name}님, ', '');

    await _plugin.zonedSchedule(
      _NotificationIds.morningReminder,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminders',
          '기도 알림',
          channelDescription: '아침 기도, 저녁 감사 등 기도 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning_prayer',
    );

    debugPrint(
      'Morning reminder scheduled at $hour:${minute.toString().padLeft(2, '0')} — "$title"',
    );
  }

  @override
  Future<void> scheduleEveningReminder() async {
    final scheduledTime = _nextInstanceOfTime(21, 0);

    // Pick message based on day of year (rotates daily)
    final dayIndex = _dayOfYear(DateTime.now()) % _eveningMessages.length;
    final (title, body) = _eveningMessages[dayIndex];

    await _plugin.zonedSchedule(
      _NotificationIds.eveningReminder,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminders',
          '기도 알림',
          channelDescription: '아침 기도, 저녁 감사 등 기도 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_gratitude',
    );

    debugPrint('Evening reminder scheduled at 21:00 — "$title"');
  }

  @override
  Future<void> scheduleAfternoonNudge() async {
    final scheduledTime = _nextInstanceOfTime(14, 0);

    await _plugin.zonedSchedule(
      _NotificationIds.afternoonNudge,
      '☀️ 오늘 기도는 하셨나요?',
      '잠깐의 기도가 하루를 바꿔요',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminders',
          '기도 알림',
          channelDescription: '아침 기도, 저녁 감사 등 기도 알림',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'afternoon_nudge',
    );

    debugPrint('Afternoon nudge scheduled at 14:00');
  }

  @override
  Future<void> showStreakCelebration(int streakCount) async {
    final milestone = _streakMilestones[streakCount];
    if (milestone == null) return;

    if (!_cachedSettings.streakReminder) return;

    final (title, body) = milestone;

    await _plugin.show(
      _NotificationIds.streakCelebration + streakCount,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_reminders',
          '기도 알림',
          channelDescription: '아침 기도, 저녁 감사 등 기도 알림',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'streak_celebration_$streakCount',
    );

    debugPrint('Streak celebration shown for $streakCount days');
  }

  @override
  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
    debugPrint('All reminders cancelled');
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
    _cachedSettings = _cachedSettings.copyWith(
      morningReminder: morningReminder,
      morningTime: morningTime,
      eveningReminder: eveningReminder,
      afternoonNudge: afternoonNudge,
      streakReminder: streakReminder,
      weeklySummary: weeklySummary,
    );

    // Save to SharedPreferences (Phase 1: local-only)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_PrefKeys.morningReminder, _cachedSettings.morningReminder);
    await prefs.setString(_PrefKeys.morningTime, _cachedSettings.morningTime);
    await prefs.setBool(_PrefKeys.eveningReminder, _cachedSettings.eveningReminder);
    await prefs.setBool(_PrefKeys.afternoonNudge, _cachedSettings.afternoonNudge);
    await prefs.setBool(_PrefKeys.streakReminder, _cachedSettings.streakReminder);
    await prefs.setBool(_PrefKeys.weeklySummary, _cachedSettings.weeklySummary);

    // Reschedule notifications based on new settings
    await _rescheduleFromSettings();
  }

  @override
  Future<NotificationSettings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    _cachedSettings = NotificationSettings(
      morningReminder: prefs.getBool(_PrefKeys.morningReminder) ?? true,
      morningTime: prefs.getString(_PrefKeys.morningTime) ?? '06:00',
      eveningReminder: prefs.getBool(_PrefKeys.eveningReminder) ?? false,
      afternoonNudge: prefs.getBool(_PrefKeys.afternoonNudge) ?? true,
      streakReminder: prefs.getBool(_PrefKeys.streakReminder) ?? true,
      weeklySummary: prefs.getBool(_PrefKeys.weeklySummary) ?? true,
    );

    return _cachedSettings;
  }

  /// Reschedule all notifications based on current settings
  Future<void> _rescheduleFromSettings() async {
    await cancelAllReminders();

    if (_cachedSettings.morningReminder) {
      await scheduleMorningReminder(
        time: _cachedSettings.morningTime,
        userName: '', // Generic — userName is passed at schedule time
      );
    }

    if (_cachedSettings.eveningReminder) {
      await scheduleEveningReminder();
    }

    if (_cachedSettings.afternoonNudge) {
      await scheduleAfternoonNudge();
    }
  }

  /// Calculate the next instance of a specific time today or tomorrow
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
