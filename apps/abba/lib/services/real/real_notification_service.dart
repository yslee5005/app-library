import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'
    hide NotificationSettings;
import 'package:app_lib_logging/logging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../config/app_config.dart';
import '../../l10n/generated/app_localizations.dart';
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

/// English fallback copy used until [setLocalization] is called. This also
/// protects against edge cases where the service runs before the widget tree
/// injects an [AppLocalizations] instance.
class _EnFallback {
  static const morningTitles = [
    '🙏 Time to pray',
    '🌅 A new morning has come',
    "✨ Today's grace",
    '🕊️ Peaceful morning',
    '📖 With the Word',
    '🌿 Time to rest',
    '💫 Today as well',
  ];

  static const morningBodies = [
    '{name}, talk with God today as well',
    '{name}, start the day with gratitude',
    '{name}, meet the grace God has prepared',
    '{name}, fill your heart with peace through prayer',
    "{name}, listen to God's voice today",
    '{name}, pause for a moment and pray',
    '{name}, a day that begins with prayer is different',
  ];

  static const eveningTitles = [
    '✨ Thankful for today',
    '🌙 Wrapping up the day',
    '🙏 Evening prayer',
    "🌟 Counting today's blessings",
  ];

  static const eveningBodies = [
    'Look back on today and offer a prayer of thanks',
    "Express today's gratitude through prayer",
    'At the end of the day, give thanks to God',
    'If you have something to be thankful for, share it in prayer',
  ];

  static const afternoonTitle = '☀️ Have you prayed today?';
  static const afternoonBody = 'A brief prayer can change the day';

  static const channelName = 'Prayer Reminders';
  static const channelDescription =
      'Morning prayer, evening gratitude, and other prayer reminders';

  static const streakMilestones = <int, (String, String)>{
    3: ('🌱 3 days in a row!', 'Your prayer habit has begun'),
    7: ('🌿 A full week!', 'Prayer is becoming a habit'),
    14: ('🌳 2 weeks in a row!', 'Amazing growth!'),
    21: ('🌻 3 weeks in a row!', 'The flower of prayer is blooming'),
    30: ('🏆 A full month!', 'Your prayer is shining'),
    50: ('👑 50 days in a row!', 'Your walk with God is deepening'),
    100: ('🎉 100 days in a row!', "You've become a prayer warrior!"),
    365: ('✝️ A full year!', 'What an amazing journey of faith!'),
  };
}

class RealNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  NotificationSettings _cachedSettings = const NotificationSettings();

  /// Current locale strings. Null until [setLocalization] is called —
  /// services fall back to English copy in that window.
  AppLocalizations? _l10n;

  /// Whether Firebase was successfully initialized
  bool _firebaseInitialized = false;

  RealNotificationService();

  /// Get the day-of-year (1-366) for a given DateTime
  static int _dayOfYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    return date.difference(start).inDays + 1;
  }

  // ---------------------------------------------------------------------------
  // Localized message helpers
  // ---------------------------------------------------------------------------

  (String, String) _morningMessage(int index, String userName) {
    final l10n = _l10n;
    final normalizedIndex = index % 7;
    if (l10n != null) {
      final title = _morningTitleFor(l10n, normalizedIndex);
      final body = _morningBodyFor(l10n, normalizedIndex, userName);
      return (title, body);
    }

    // English fallback
    final title = _EnFallback.morningTitles[normalizedIndex];
    final template = _EnFallback.morningBodies[normalizedIndex];
    final body = userName.isNotEmpty
        ? template.replaceAll('{name}', userName)
        : template.replaceAll('{name}, ', '');
    return (title, body);
  }

  String _morningTitleFor(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.notifyMorning1Title;
      case 1:
        return l10n.notifyMorning2Title;
      case 2:
        return l10n.notifyMorning3Title;
      case 3:
        return l10n.notifyMorning4Title;
      case 4:
        return l10n.notifyMorning5Title;
      case 5:
        return l10n.notifyMorning6Title;
      case 6:
      default:
        return l10n.notifyMorning7Title;
    }
  }

  String _morningBodyFor(AppLocalizations l10n, int index, String userName) {
    // When userName is empty we still pass '' so ARB strings with a {name}
    // placeholder render without a dangling substitution.
    final name = userName;
    switch (index) {
      case 0:
        return l10n.notifyMorning1Body(name);
      case 1:
        return l10n.notifyMorning2Body(name);
      case 2:
        return l10n.notifyMorning3Body(name);
      case 3:
        return l10n.notifyMorning4Body(name);
      case 4:
        return l10n.notifyMorning5Body(name);
      case 5:
        return l10n.notifyMorning6Body(name);
      case 6:
      default:
        return l10n.notifyMorning7Body(name);
    }
  }

  (String, String) _eveningMessage(int index) {
    final l10n = _l10n;
    final normalizedIndex = index % 4;
    if (l10n != null) {
      switch (normalizedIndex) {
        case 0:
          return (l10n.notifyEvening1Title, l10n.notifyEvening1Body);
        case 1:
          return (l10n.notifyEvening2Title, l10n.notifyEvening2Body);
        case 2:
          return (l10n.notifyEvening3Title, l10n.notifyEvening3Body);
        case 3:
        default:
          return (l10n.notifyEvening4Title, l10n.notifyEvening4Body);
      }
    }
    return (
      _EnFallback.eveningTitles[normalizedIndex],
      _EnFallback.eveningBodies[normalizedIndex],
    );
  }

  (String, String)? _streakMessage(int streakCount) {
    final l10n = _l10n;
    if (l10n != null) {
      switch (streakCount) {
        case 3:
          return (l10n.notifyStreak3Title, l10n.notifyStreak3Body);
        case 7:
          return (l10n.notifyStreak7Title, l10n.notifyStreak7Body);
        case 14:
          return (l10n.notifyStreak14Title, l10n.notifyStreak14Body);
        case 21:
          return (l10n.notifyStreak21Title, l10n.notifyStreak21Body);
        case 30:
          return (l10n.notifyStreak30Title, l10n.notifyStreak30Body);
        case 50:
          return (l10n.notifyStreak50Title, l10n.notifyStreak50Body);
        case 100:
          return (l10n.notifyStreak100Title, l10n.notifyStreak100Body);
        case 365:
          return (l10n.notifyStreak365Title, l10n.notifyStreak365Body);
        default:
          return null;
      }
    }
    return _EnFallback.streakMilestones[streakCount];
  }

  String _afternoonTitle() =>
      _l10n?.notifyAfternoonNudgeTitle ?? _EnFallback.afternoonTitle;

  String _afternoonBody() =>
      _l10n?.notifyAfternoonNudgeBody ?? _EnFallback.afternoonBody;

  String _channelName() => _l10n?.notifyChannelName ?? _EnFallback.channelName;

  String _channelDescription() =>
      _l10n?.notifyChannelDescription ?? _EnFallback.channelDescription;

  NotificationDetails _buildDetails({
    Importance importance = Importance.high,
    Priority priority = Priority.high,
  }) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_reminders',
        _channelName(),
        channelDescription: _channelDescription(),
        importance: importance,
        priority: priority,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
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

    // Create Android notification channel with English fallback text.
    // When setLocalization() is called later we re-create the channel with
    // the user's current locale so the system settings show translated text.
    await _createOrUpdateChannel();

    // Load saved settings
    await getSettings();

    // Reschedule based on saved settings
    await _rescheduleFromSettings();

    // Initialize FCM (Firebase Cloud Messaging)
    // Wrapped in try/catch — app works without Firebase configured
    await _initializeFcm();
  }

  @override
  Future<void> setLocalization(AppLocalizations l10n) async {
    _l10n = l10n;
    // Android channels are immutable for name/description after creation
    // on some OS versions, but re-registering with the same ID is the
    // documented upgrade path. Safe to call repeatedly.
    await _createOrUpdateChannel();
    // Reschedule pending notifications so titles/bodies reflect the new
    // locale the next time they fire.
    await _rescheduleFromSettings();
  }

  Future<void> _createOrUpdateChannel() async {
    final androidChannel = AndroidNotificationChannel(
      'prayer_reminders',
      _channelName(),
      description: _channelDescription(),
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Initialize Firebase and FCM.
  /// Gated by `AppConfig.enableFcm` — off by default until Firebase config
  /// files are added. All Firebase calls are still wrapped in try/catch as
  /// a defense-in-depth guard.
  Future<void> _initializeFcm() async {
    if (!AppConfig.enableFcm) {
      fcmLog.info('FCM disabled by ENABLE_FCM flag');
      return;
    }

    try {
      // Dynamically import and initialize Firebase
      // This will fail if google-services.json / GoogleService-Info.plist
      // is not configured — that's expected and handled gracefully.
      final firebaseCore = await _tryInitializeFirebase();
      if (!firebaseCore) {
        fcmLog.debug('Firebase not configured — skipping FCM setup');
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

      fcmLog.info('Permission status: ${settings.authorizationStatus}');

      // Get FCM token and save it
      final token = await messaging.getToken();
      if (token != null) {
        fcmLog.info('Token obtained (${token.substring(0, 10)}...)');
        await saveToken(token);
      }

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        fcmLog.info('Token refreshed');
        saveToken(newToken);
      });
    } catch (e, st) {
      fcmLog.error(
        'Initialization failed (app continues without FCM)',
        error: e,
        stackTrace: st,
      );
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
      fcmLog.debug('Firebase Core init failed: $e');
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
      fcmLog.debug('Firebase.initializeApp() failed: $e');
      return false;
    }
  }

  /// Get FirebaseMessaging instance, or null if not available.
  FirebaseMessaging? _getFirebaseMessaging() {
    try {
      return FirebaseMessaging.instance;
    } catch (e) {
      fcmLog.debug('Could not get FirebaseMessaging instance: $e');
      return null;
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    fcmLog.debug('Notification tapped: ${response.payload}');
  }

  @override
  Future<String?> getToken() async {
    if (!_firebaseInitialized) return null;

    try {
      final messaging = _getFirebaseMessaging();
      return await messaging?.getToken();
    } catch (e) {
      fcmLog.debug('getToken() failed: $e');
      return null;
    }
  }

  @override
  Future<void> saveToken(String token) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        fcmLog.debug('No authenticated user — skipping token save');
        return;
      }

      final platform = Platform.isIOS ? 'ios' : 'android';
      final appId = AppConfig.appId;

      await supabase.from('user_devices').upsert({
        'app_id': appId,
        'user_id': user.id,
        'fcm_token': token,
        'platform': platform,
        'is_active': true,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }, onConflict: 'app_id,user_id,fcm_token');

      fcmLog.info('Token saved to user_devices for user ${user.id}');
    } catch (e) {
      // Don't crash if table doesn't exist yet or Supabase is unavailable
      fcmLog.debug('saveToken() failed (non-fatal): $e');
    }
  }

  @override
  Future<void> requestPermission() async {
    // Request iOS permissions
    await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // Request Android 13+ permissions
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
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
    final dayIndex = _dayOfYear(DateTime.now()) % 7;
    final (title, body) = _morningMessage(dayIndex, userName);

    await _plugin.zonedSchedule(
      _NotificationIds.morningReminder,
      title,
      body,
      scheduledTime,
      _buildDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'morning_prayer',
    );

    fcmLog.info(
      'Morning reminder scheduled at $hour:${minute.toString().padLeft(2, '0')} — "$title"',
    );
  }

  @override
  Future<void> scheduleEveningReminder() async {
    final scheduledTime = _nextInstanceOfTime(21, 0);

    // Pick message based on day of year (rotates daily)
    final dayIndex = _dayOfYear(DateTime.now()) % 4;
    final (title, body) = _eveningMessage(dayIndex);

    await _plugin.zonedSchedule(
      _NotificationIds.eveningReminder,
      title,
      body,
      scheduledTime,
      _buildDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'evening_gratitude',
    );

    fcmLog.info('Evening reminder scheduled at 21:00 — "$title"');
  }

  @override
  Future<void> scheduleAfternoonNudge() async {
    final scheduledTime = _nextInstanceOfTime(14, 0);

    await _plugin.zonedSchedule(
      _NotificationIds.afternoonNudge,
      _afternoonTitle(),
      _afternoonBody(),
      scheduledTime,
      _buildDetails(
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'afternoon_nudge',
    );

    fcmLog.info('Afternoon nudge scheduled at 14:00');
  }

  @override
  Future<void> showStreakCelebration(int streakCount) async {
    final milestone = _streakMessage(streakCount);
    if (milestone == null) return;

    if (!_cachedSettings.streakReminder) return;

    final (title, body) = milestone;

    await _plugin.show(
      _NotificationIds.streakCelebration + streakCount,
      title,
      body,
      _buildDetails(),
      payload: 'streak_celebration_$streakCount',
    );

    fcmLog.info('Streak celebration shown for $streakCount days');
  }

  @override
  Future<void> cancelAllReminders() async {
    await _plugin.cancelAll();
    fcmLog.info('All reminders cancelled');
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
    await prefs.setBool(
      _PrefKeys.morningReminder,
      _cachedSettings.morningReminder,
    );
    await prefs.setString(_PrefKeys.morningTime, _cachedSettings.morningTime);
    await prefs.setBool(
      _PrefKeys.eveningReminder,
      _cachedSettings.eveningReminder,
    );
    await prefs.setBool(
      _PrefKeys.afternoonNudge,
      _cachedSettings.afternoonNudge,
    );
    await prefs.setBool(
      _PrefKeys.streakReminder,
      _cachedSettings.streakReminder,
    );
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
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
