import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/daily_routine.dart';

void main() {
  group('DailyRoutine', () {
    test('should create with required fields', () {
      const routine = DailyRoutine(
        id: 'walk_am',
        name: '아침 산책',
        icon: Icons.wb_sunny_outlined,
        category: 'walk',
      );

      expect(routine.id, 'walk_am');
      expect(routine.name, '아침 산책');
      expect(routine.goalPerDay, 1); // default
      expect(routine.category, 'walk');
    });

    test('toJson and fromJson roundtrip', () {
      const routine = DailyRoutine(
        id: 'teeth',
        name: '양치질',
        icon: Icons.clean_hands_outlined,
        goalPerDay: 2,
        category: 'care',
      );

      final json = routine.toJson();
      final restored = DailyRoutine.fromJson(json);

      expect(restored.id, routine.id);
      expect(restored.name, routine.name);
      expect(restored.goalPerDay, routine.goalPerDay);
      expect(restored.category, routine.category);
      expect(restored.icon.codePoint, routine.icon.codePoint);
    });

    test('defaults returns 4 routines', () {
      final defaults = DailyRoutine.defaults;
      expect(defaults.length, 4);
      expect(
        defaults.map((r) => r.id),
        containsAll(['walk_am', 'walk_pm', 'meal_am', 'meal_pm']),
      );
    });

    test('optionals returns 4 routines', () {
      final optionals = DailyRoutine.optionals;
      expect(optionals.length, 4);
      expect(
        optionals.map((r) => r.id),
        containsAll(['teeth', 'meds', 'snack', 'play']),
      );
    });

    test('copyWith creates new instance', () {
      const routine = DailyRoutine(
        id: 'walk_am',
        name: '아침 산책',
        icon: Icons.wb_sunny_outlined,
        category: 'walk',
      );

      final updated = routine.copyWith(name: '새벽 산책');
      expect(updated.name, '새벽 산책');
      expect(updated.id, 'walk_am'); // unchanged
    });
  });
}
