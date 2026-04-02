import 'dart:math';

import '../models/pet_profile.dart';
import '../services/breed_data_service.dart';

class LifeStats {
  final int remainingDays;
  final int remainingWalks;
  final int remainingMeals;
  final double humanAge;
  final double lifePercentage;
  final double medianLifespan;
  final double currentAgeYears;

  const LifeStats({
    required this.remainingDays,
    required this.remainingWalks,
    required this.remainingMeals,
    required this.humanAge,
    required this.lifePercentage,
    required this.medianLifespan,
    required this.currentAgeYears,
  });
}

class LifeCalculator {
  final BreedDataService _breedService;

  LifeCalculator({BreedDataService? breedService})
      : _breedService = breedService ?? BreedDataService();

  LifeStats calculate(PetProfile profile) {
    final breed = _breedService.getBreedById(profile.breedId);
    final medianLifespan = breed?.lifespanYears.median ?? 12.0;
    final ageYears = profile.ageYears;

    // Remaining days
    final remainingYears = (medianLifespan - ageYears).clamp(0.0, 100.0);
    final remainingDays = (remainingYears * 365.25).round();

    // Remaining walks: count walk routines per day
    final walksPerDay =
        profile.routines.where((r) => r.category == 'walk').length;
    final remainingWalks = remainingDays * (walksPerDay > 0 ? walksPerDay : 2);

    // Remaining meals
    final mealsPerDay =
        profile.routines.where((r) => r.category == 'meal').length;
    final remainingMeals = remainingDays * (mealsPerDay > 0 ? mealsPerDay : 2);

    // Human age: 16 × ln(dog_age) + 31
    // For puppies < 1 year, use simpler linear approximation
    final humanAge = _calculateHumanAge(ageYears);

    // Life percentage
    final lifePercentage =
        ((ageYears / medianLifespan) * 100).clamp(0.0, 100.0);

    return LifeStats(
      remainingDays: remainingDays,
      remainingWalks: remainingWalks,
      remainingMeals: remainingMeals,
      humanAge: humanAge,
      lifePercentage: lifePercentage,
      medianLifespan: medianLifespan,
      currentAgeYears: ageYears,
    );
  }

  /// Human age conversion using natural log formula
  /// Based on: Tina Wang et al. (2019) — Cell Systems
  /// Formula: 16 × ln(dog_age_in_years) + 31
  /// For very young dogs (< 0.25 years), use linear approximation
  double _calculateHumanAge(double dogAge) {
    if (dogAge <= 0) return 0;
    if (dogAge < 0.25) {
      // Linear for very young puppies: roughly 0-15 human years in first 3 months
      return dogAge * 60;
    }
    return 16 * log(dogAge) + 31;
  }

  /// Get age-appropriate health recommendations
  List<String> getHealthRecommendations(PetProfile profile) {
    final breed = _breedService.getBreedById(profile.breedId);
    if (breed == null) return [];

    final age = profile.ageYears;
    final recommendations = <String>[];

    if (age < 1) {
      recommendations.add('예방접종 스케줄을 확인하세요');
      recommendations.add('사회화 훈련이 중요한 시기입니다');
    }

    if (age >= breed.seniorAge) {
      recommendations.add('연 2회 건강검진을 권장합니다');
      recommendations.add('관절 건강에 주의하세요');
      recommendations.add('인지 기능 저하에 주의하세요');
    }

    if (breed.weightKg != null && profile.weightKg > breed.weightKg!.max) {
      recommendations.add('적정 체중 관리가 필요합니다');
    }

    for (final risk in breed.geneticHealthRisks) {
      if (risk.severity == 'critical') {
        recommendations.add('${risk.conditionKo} 정기 검사 권장');
      }
    }

    return recommendations;
  }
}
