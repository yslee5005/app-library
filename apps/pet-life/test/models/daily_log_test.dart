import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/daily_log.dart';

void main() {
  group('DailyLog', () {
    test('should create with required fields', () {
      final log = DailyLog(
        date: '2024-03-15',
        routineId: 'walk_am',
        completed: true,
        completedAt: DateTime(2024, 3, 15, 8, 30),
      );

      expect(log.date, '2024-03-15');
      expect(log.routineId, 'walk_am');
      expect(log.completed, true);
      expect(log.completedAt, isNotNull);
    });

    test('completedAt defaults to null', () {
      const log = DailyLog(
        date: '2024-03-15',
        routineId: 'walk_am',
        completed: false,
      );

      expect(log.completedAt, isNull);
    });

    test('toJson and fromJson roundtrip', () {
      final log = DailyLog(
        date: '2024-03-15',
        routineId: 'teeth',
        completed: true,
        completedAt: DateTime(2024, 3, 15, 20, 0),
      );

      final json = log.toJson();
      final restored = DailyLog.fromJson(json);

      expect(restored.date, log.date);
      expect(restored.routineId, log.routineId);
      expect(restored.completed, log.completed);
      expect(restored.completedAt, isNotNull);
    });

    test('toJson handles null completedAt', () {
      const log = DailyLog(
        date: '2024-03-15',
        routineId: 'walk_am',
        completed: false,
      );

      final json = log.toJson();
      expect(json['completedAt'], isNull);

      final restored = DailyLog.fromJson(json);
      expect(restored.completedAt, isNull);
    });

    test('copyWith creates new instance', () {
      const log = DailyLog(
        date: '2024-03-15',
        routineId: 'walk_am',
        completed: false,
      );

      final updated = log.copyWith(completed: true);
      expect(updated.completed, true);
      expect(updated.date, '2024-03-15'); // unchanged
    });
  });
}
