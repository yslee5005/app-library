import 'notification_message.dart';

/// Abstract interface for notification operations.
///
/// Implementations may use local notifications, push (FCM), or both.
abstract interface class NotificationRepository {
  /// Shows a notification immediately.
  Future<void> show(NotificationMessage message);

  /// Schedules a notification for [message.scheduledAt].
  ///
  /// Throws if [message.scheduledAt] is null.
  Future<void> schedule(NotificationMessage message);

  /// Cancels a notification by its [id].
  Future<void> cancel(int id);

  /// Cancels all pending and shown notifications.
  Future<void> cancelAll();

  /// Requests notification permission from the user.
  ///
  /// Returns `true` if permission was granted.
  Future<bool> requestPermission();
}
