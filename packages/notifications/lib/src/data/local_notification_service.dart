import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../domain/notification_message.dart';
import '../domain/notification_repository.dart';

/// [NotificationRepository] implementation using flutter_local_notifications.
class LocalNotificationService implements NotificationRepository {
  LocalNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this.channelId = 'default',
    this.channelName = 'Default',
    this.channelDescription = 'Default notification channel',
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  /// Android notification channel ID.
  final String channelId;

  /// Android notification channel name.
  final String channelName;

  /// Android notification channel description.
  final String channelDescription;

  /// Initializes the plugin. Call once at app startup.
  Future<void> initialize({void Function(NotificationResponse)? onTap}) async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(settings, onDidReceiveNotificationResponse: onTap);
  }

  NotificationDetails get _defaultDetails => NotificationDetails(
    android: AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(),
  );

  @override
  Future<void> show(NotificationMessage message) async {
    await _plugin.show(
      message.id,
      message.title,
      message.body,
      _defaultDetails,
      payload: message.payload,
    );
  }

  @override
  Future<void> schedule(NotificationMessage message) async {
    final scheduledAt = message.scheduledAt;
    if (scheduledAt == null) {
      throw ArgumentError(
        'scheduledAt must not be null for scheduled notifications',
      );
    }

    await _plugin.zonedSchedule(
      message.id,
      message.title,
      message.body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      _defaultDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: message.payload,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }

  @override
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  @override
  Future<bool> requestPermission() async {
    // iOS permission request
    final ios =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    if (ios != null) {
      final result = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result ?? false;
    }

    // Android 13+ permission request
    final android =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (android != null) {
      final result = await android.requestNotificationsPermission();
      return result ?? false;
    }

    return true;
  }
}
