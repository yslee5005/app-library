import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/daily_routine.dart';
import 'package:pet_life/models/pet_profile.dart';
import 'package:pet_life/services/life_calculator.dart';

void main() {
  group('LifeCalculator', () {
    late LifeCalculator calculator;

    setUp(() {
      calculator = LifeCalculator();
    });

    PetProfile _makeProfile({
      DateTime? birthDate,
      String breedId = 'golden_retriever',
      double weightKg = 30.0,
      List<DailyRoutine>? routines,
    }) {
      return PetProfile(
        name: 'Test Dog',
        breedId: breedId,
        birthDate:
            birthDate ??
            DateTime.now().subtract(const Duration(days: 2555)), // ~7 years
        weightKg: weightKg,
        routines:
            routines ??
            [
              const DailyRoutine(
                id: 'walk_am',
                name: '아침 산책',
                icon: Icons.wb_sunny_outlined,
                category: 'walk',
              ),
              const DailyRoutine(
                id: 'walk_pm',
                name: '저녁 산책',
                icon: Icons.nightlight_outlined,
                category: 'walk',
              ),
              const DailyRoutine(
                id: 'meal_am',
                name: '아침 식사',
                icon: Icons.restaurant_outlined,
                category: 'meal',
              ),
              const DailyRoutine(
                id: 'meal_pm',
                name: '저녁 식사',
                icon: Icons.dinner_dining_outlined,
                category: 'meal',
              ),
            ],
        createdAt: DateTime.now(),
      );
    }

    test('remaining days: breed median lifespan - current age', () {
      // golden_retriever median = 11.0 years
      // Dog is ~7 years old, so ~4 years remaining ≈ 1461 days
      final profile = _makeProfile();
      final stats = calculator.calculate(profile);

      // Remaining days should be roughly 4 years (±30 days tolerance)
      expect(stats.remainingDays, greaterThan(1300));
      expect(stats.remainingDays, lessThan(1600));
    });

    test('remaining walks: remaining days × walks per day', () {
      final profile = _makeProfile();
      final stats = calculator.calculate(profile);

      // 2 walk routines, so remaining walks = remainingDays * 2
      expect(stats.remainingWalks, stats.remainingDays * 2);
    });

    test('remaining meals: remaining days × meals per day', () {
      final profile = _makeProfile();
      final stats = calculator.calculate(profile);

      // 2 meal routines, so remaining meals = remainingDays * 2
      expect(stats.remainingMeals, stats.remainingDays * 2);
    });

    test('human age conversion: 16 × ln(dog_age) + 31', () {
      final profile = _makeProfile();
      final stats = calculator.calculate(profile);
      final expectedHumanAge = 16 * log(profile.ageYears) + 31;

      expect(stats.humanAge, closeTo(expectedHumanAge, 1.0));
    });

    test('life percentage: current age / median lifespan × 100', () {
      final profile = _makeProfile();
      final stats = calculator.calculate(profile);

      // ~7 / 11 * 100 ≈ 63.6%
      expect(stats.lifePercentage, greaterThan(60.0));
      expect(stats.lifePercentage, lessThan(70.0));
    });

    test('edge case: newborn puppy (0 days)', () {
      final profile = _makeProfile(birthDate: DateTime.now());
      final stats = calculator.calculate(profile);

      expect(stats.remainingDays, greaterThan(3500)); // ~11 years
      expect(stats.humanAge, closeTo(0, 1.0));
      expect(stats.lifePercentage, closeTo(0, 1.0));
    });

    test('edge case: very old dog past median lifespan', () {
      final profile = _makeProfile(
        birthDate: DateTime.now().subtract(
          const Duration(days: 5475),
        ), // ~15 years
      );
      final stats = calculator.calculate(profile);

      expect(stats.remainingDays, 0); // past median, clamped to 0
      expect(stats.lifePercentage, 100.0); // clamped to 100
    });

    test('defaults to 2 walks when no walk routines defined', () {
      final profile = _makeProfile(routines: const []);
      final stats = calculator.calculate(profile);

      // Defaults to 2 walks per day
      expect(stats.remainingWalks, stats.remainingDays * 2);
    });
  });
}
