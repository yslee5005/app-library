/// A notification that can be shown immediately or scheduled.
class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.scheduledAt,
  });

  /// Unique identifier for this notification.
  final int id;

  /// Notification title.
  final String title;

  /// Notification body text.
  final String body;

  /// Optional payload string delivered when the notification is tapped.
  final String? payload;

  /// When set, the notification is scheduled for this time.
  /// When `null`, the notification is shown immediately.
  final DateTime? scheduledAt;

  /// Whether this notification is scheduled (vs. immediate).
  bool get isScheduled => scheduledAt != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          payload == other.payload &&
          scheduledAt == other.scheduledAt;

  @override
  int get hashCode => Object.hash(id, title, body, payload, scheduledAt);

  @override
  String toString() =>
      'NotificationMessage(id: $id, title: $title, scheduled: $isScheduled)';
}
