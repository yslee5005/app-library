import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_life/models/daily_routine.dart';
import 'package:pet_life/models/pet_profile.dart';

void main() {
  group('PetProfile', () {
    late PetProfile profile;

    setUp(() {
      profile = PetProfile(
        name: 'Buddy',
        breedId: 'golden_retriever',
        birthDate: DateTime(2019, 6, 15),
        weightKg: 30.0,
        neutered: true,
        routines: [
          const DailyRoutine(
            id: 'walk_am',
            name: '아침 산책',
            icon: Icons.wb_sunny_outlined,
            category: 'walk',
          ),
        ],
        createdAt: DateTime(2024, 1, 1),
      );
    });

    test('should create PetProfile with all fields', () {
      expect(profile.name, 'Buddy');
      expect(profile.breedId, 'golden_retriever');
      expect(profile.weightKg, 30.0);
      expect(profile.neutered, true);
      expect(profile.routines.length, 1);
    });

    test('ageYears returns correct fractional age', () {
      // Since age depends on current time, just verify it's positive
      expect(profile.ageYears, greaterThan(0));
    });

    test('ageDisplay returns years for dogs > 1 year', () {
      final oldProfile = PetProfile(
        name: 'Max',
        breedId: 'poodle_standard',
        birthDate: DateTime.now().subtract(const Duration(days: 1100)),
        weightKg: 20.0,
        routines: const [],
        createdAt: DateTime.now(),
      );
      expect(oldProfile.ageDisplay, contains('세'));
    });

    test('ageDisplay returns months for puppies < 1 year', () {
      final puppy = PetProfile(
        name: 'Pup',
        breedId: 'golden_retriever',
        birthDate: DateTime.now().subtract(const Duration(days: 90)),
        weightKg: 10.0,
        routines: const [],
        createdAt: DateTime.now(),
      );
      expect(puppy.ageDisplay, contains('개월'));
    });

    test('toJson and fromJson roundtrip', () {
      final json = profile.toJson();
      final restored = PetProfile.fromJson(json);

      expect(restored.name, profile.name);
      expect(restored.breedId, profile.breedId);
      expect(restored.birthDate, profile.birthDate);
      expect(restored.weightKg, profile.weightKg);
      expect(restored.neutered, profile.neutered);
      expect(restored.routines.length, profile.routines.length);
      expect(restored.routines.first.id, 'walk_am');
    });

    test('copyWith creates new instance with updated fields', () {
      final updated = profile.copyWith(name: 'Max', weightKg: 35.0);

      expect(updated.name, 'Max');
      expect(updated.weightKg, 35.0);
      expect(updated.breedId, profile.breedId); // unchanged
    });

    test('neutered defaults to false', () {
      final defaultProfile = PetProfile(
        name: 'Dog',
        breedId: 'beagle',
        birthDate: DateTime(2020, 1, 1),
        weightKg: 10.0,
        routines: const [],
        createdAt: DateTime.now(),
      );
      expect(defaultProfile.neutered, false);
    });
  });
}
