import 'package:flutter_test/flutter_test.dart';

import 'package:app_lib_notifications/notifications.dart';

void main() {
  group('NotificationMessage', () {
    test('creates immediate notification when scheduledAt is null', () {
      const msg = NotificationMessage(id: 1, title: 'Test', body: 'Hello');

      expect(msg.id, 1);
      expect(msg.title, 'Test');
      expect(msg.body, 'Hello');
      expect(msg.payload, isNull);
      expect(msg.scheduledAt, isNull);
      expect(msg.isScheduled, isFalse);
    });

    test('creates scheduled notification with scheduledAt', () {
      final scheduled = DateTime(2026, 4, 1, 9, 0);
      final msg = NotificationMessage(
        id: 2,
        title: 'Reminder',
        body: 'Don\'t forget',
        scheduledAt: scheduled,
      );

      expect(msg.isScheduled, isTrue);
      expect(msg.scheduledAt, scheduled);
    });

    test('supports payload', () {
      const msg = NotificationMessage(
        id: 3,
        title: 'Nav',
        body: 'Tap to open',
        payload: '/settings',
      );

      expect(msg.payload, '/settings');
    });

    test('equality works correctly', () {
      const a = NotificationMessage(id: 1, title: 'T', body: 'B');
      const b = NotificationMessage(id: 1, title: 'T', body: 'B');
      const c = NotificationMessage(id: 2, title: 'T', body: 'B');

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, b.hashCode);
    });

    test('toString includes key info', () {
      const msg = NotificationMessage(id: 42, title: 'Hello', body: 'World');

      expect(msg.toString(), contains('42'));
      expect(msg.toString(), contains('Hello'));
    });
  });
}
