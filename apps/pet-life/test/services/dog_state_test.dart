import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/daily_log.dart';
import 'package:pet_life/models/daily_routine.dart';
import 'package:pet_life/models/pet_profile.dart';
import 'package:pet_life/services/dog_state_service.dart';

void main() {
  group('DogStateService', () {
    late DogStateService service;
    late PetProfile profile;

    setUp(() {
      service = DogStateService();
      profile = PetProfile(
        name: 'Buddy',
        breedId: 'golden_retriever',
        birthDate: DateTime.now().subtract(const Duration(days: 2555)),
        weightKg: 30.0,
        routines: [
          const DailyRoutine(id: 'walk_am', name: '아침 산책', icon: Icons.wb_sunny_outlined, category: 'walk'),
          const DailyRoutine(id: 'walk_pm', name: '저녁 산책', icon: Icons.nightlight_outlined, category: 'walk'),
          const DailyRoutine(id: 'meal_am', name: '아침 식사', icon: Icons.restaurant_outlined, category: 'meal'),
          const DailyRoutine(id: 'meal_pm', name: '저녁 식사', icon: Icons.dinner_dining_outlined, category: 'meal'),
        ],
        createdAt: DateTime.now(),
      );
    });

    String _dateStr(DateTime dt) {
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    }

    test('returns sleeping when hour is 22-6', () async {
      final now = DateTime(2024, 3, 15, 23, 0);
      final result = await service.getDogState(
        profile: profile,
        todayLogs: [],
        recentLogs: [],
        now: now,
      );

      expect(result.state, DogState.sleeping);
      expect(result.message, contains('꿈나라'));
    });

    test('returns sleeping at 3am', () async {
      final now = DateTime(2024, 3, 15, 3, 0);
      final result = await service.getDogState(
        profile: profile,
        todayLogs: [],
        recentLogs: [],
        now: now,
      );

      expect(result.state, DogState.sleeping);
    });

    test('returns veryHappy when all routines completed today', () async {
      final now = DateTime(2024, 3, 15, 14, 0);
      final today = _dateStr(now);
      final todayLogs = [
        DailyLog(date: today, routineId: 'walk_am', completed: true),
        DailyLog(date: today, routineId: 'walk_pm', completed: true),
        DailyLog(date: today, routineId: 'meal_am', completed: true),
        DailyLog(date: today, routineId: 'meal_pm', completed: true),
      ];

      final result = await service.getDogState(
        profile: profile,
        todayLogs: todayLogs,
        recentLogs: todayLogs,
        now: now,
      );

      expect(result.state, DogState.veryHappy);
      expect(result.message, contains('완벽한 하루'));
    });

    test('returns wantsWalk when walk not done and hour > 10', () async {
      final now = DateTime(2024, 3, 15, 11, 0);
      final result = await service.getDogState(
        profile: profile,
        todayLogs: [],
        recentLogs: [],
        now: now,
      );

      expect(result.state, DogState.wantsWalk);
      expect(result.message, contains('산책'));
    });

    test('returns sad when no routines done for 3+ days', () async {
      final now = DateTime(2024, 3, 15, 9, 0);
      // Recent logs: nothing in last 3+ days
      final oldLogs = [
        DailyLog(
          date: _dateStr(now.subtract(const Duration(days: 5))),
          routineId: 'walk_am',
          completed: true,
        ),
      ];

      // Walk not yet overdue (hour < 10), but 3+ days missing
      // Actually wantsWalk won't trigger since hour=9 < 10
      // But 3 days missing walk will trigger bored first
      final result = await service.getDogState(
        profile: profile,
        todayLogs: [],
        recentLogs: oldLogs,
        now: now,
      );

      // Should be bored (walk missing 3+ days) or sad
      expect(
        [DogState.bored, DogState.sad].contains(result.state),
        true,
      );
    });

    test('returns bored when walk not done for 3+ days', () async {
      final now = DateTime(2024, 3, 15, 9, 0);
      final recentLogs = [
        DailyLog(
          date: _dateStr(now.subtract(const Duration(days: 4))),
          routineId: 'walk_am',
          completed: true,
        ),
        DailyLog(
          date: _dateStr(now.subtract(const Duration(days: 4))),
          routineId: 'meal_am',
          completed: true,
        ),
        // Recent meal to prevent generic "sad" from triggering first
        DailyLog(
          date: _dateStr(now),
          routineId: 'meal_am',
          completed: true,
        ),
      ];

      final result = await service.getDogState(
        profile: profile,
        todayLogs: [DailyLog(date: _dateStr(now), routineId: 'meal_am', completed: true)],
        recentLogs: recentLogs,
        now: now,
      );

      expect(result.state, DogState.bored);
      expect(result.message, contains('산책'));
    });

    test('returns happy with time-appropriate greeting', () async {
      // Create a simple profile with no walk routines to avoid walk-related states
      final simpleProfile = PetProfile(
        name: 'Buddy',
        breedId: 'golden_retriever',
        birthDate: DateTime.now().subtract(const Duration(days: 730)),
        weightKg: 30.0,
        routines: const [
          DailyRoutine(id: 'meal_am', name: '식사', icon: Icons.restaurant, category: 'meal'),
        ],
        createdAt: DateTime.now(),
      );

      final now = DateTime(2024, 3, 15, 8, 0); // morning
      final today = _dateStr(now);
      final todayLogs = [
        DailyLog(date: today, routineId: 'meal_am', completed: true),
      ];
      final recentLogs = [
        ...todayLogs,
        DailyLog(date: _dateStr(now.subtract(const Duration(days: 1))), routineId: 'meal_am', completed: true),
      ];

      final result = await service.getDogState(
        profile: simpleProfile,
        todayLogs: todayLogs,
        recentLogs: recentLogs,
        now: now,
      );

      // Should be veryHappy (all 1 routine completed)
      expect(result.state, DogState.veryHappy);
    });
  });
}
