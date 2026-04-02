import '../models/daily_log.dart';
import '../models/pet_profile.dart';
import '../services/breed_data_service.dart';

enum DogState {
  happy,
  veryHappy,
  wantsWalk,
  hungry,
  sad,
  sleeping,
  bored,
  healthWarning,
}

class DogMessage {
  final DogState state;
  final String message;
  final String? source;

  const DogMessage({
    required this.state,
    required this.message,
    this.source,
  });
}

class DogStateService {
  final BreedDataService _breedService;

  DogStateService({BreedDataService? breedService})
      : _breedService = breedService ?? BreedDataService();

  /// Determine dog's current state based on logs and time
  Future<DogMessage> getDogState({
    required PetProfile profile,
    required List<DailyLog> todayLogs,
    required List<DailyLog> recentLogs,
    DateTime? now,
  }) async {
    now ??= DateTime.now();
    final hour = now.hour;

    // Sleeping: 22:00 - 06:00
    if (hour >= 22 || hour < 6) {
      return const DogMessage(
        state: DogState.sleeping,
        message: '지금은 꿈나라에 있어요... 💤',
      );
    }

    final completedToday = todayLogs.where((l) => l.completed).toList();
    final routineIds = profile.routines.map((r) => r.id).toSet();
    final completedIds = completedToday.map((l) => l.routineId).toSet();

    // All routines completed today → very happy
    if (routineIds.isNotEmpty &&
        routineIds.every((id) => completedIds.contains(id))) {
      return const DogMessage(
        state: DogState.veryHappy,
        message: '완벽한 하루! 오늘도 최고예요! 🎉',
      );
    }

    // Check recent days for missing routines
    final walkRoutines = profile.routines
        .where((r) => r.category == 'walk')
        .map((r) => r.id)
        .toSet();
    final mealRoutines = profile.routines
        .where((r) => r.category == 'meal')
        .map((r) => r.id)
        .toSet();
    final careRoutines = profile.routines
        .where((r) => r.category == 'care')
        .map((r) => r.id)
        .toSet();

    final daysMissingWalk = _daysSinceLastCompletion(
        recentLogs, walkRoutines, now);
    final daysMissingCare = _daysSinceLastCompletion(
        recentLogs, careRoutines, now);

    // 7+ days no walk → very sad
    if (walkRoutines.isNotEmpty && daysMissingWalk >= 7) {
      return const DogMessage(
        state: DogState.sad,
        message: '많이 답답해해요. 산책이 필요해요 😢',
      );
    }

    // 3+ days no walk → bored + dementia warning
    if (walkRoutines.isNotEmpty && daysMissingWalk >= 3) {
      return DogMessage(
        state: DogState.bored,
        message: '${daysMissingWalk}일째 산책을 못 갔어요. 지루해해요 😔\n산책은 치매 예방에 도움이 돼요.',
        source: 'Journal of Veterinary Internal Medicine',
      );
    }

    // Walk not done today and it's past 10am
    if (walkRoutines.isNotEmpty &&
        !walkRoutines.any((id) => completedIds.contains(id)) &&
        hour >= 10) {
      return const DogMessage(
        state: DogState.wantsWalk,
        message: '산책 가고 싶어요... 🥺',
      );
    }

    // Teeth care missing 5+ days
    final teethRoutine = careRoutines.contains('teeth');
    if (teethRoutine && daysMissingCare >= 5) {
      return const DogMessage(
        state: DogState.healthWarning,
        message: '이가 걱정돼요. 3세 이상 반려견의 80-90%가 치주질환이 있어요.',
        source: 'American Veterinary Dental College',
      );
    }

    // Hungry: meal not done and it's meal time
    if (mealRoutines.isNotEmpty &&
        !mealRoutines.any((id) => completedIds.contains(id)) &&
        (hour >= 7 && hour <= 9 || hour >= 17 && hour <= 19)) {
      return const DogMessage(
        state: DogState.hungry,
        message: '배가 고파요... 밥 주세요! 🍖',
      );
    }

    // No routines done for 3+ days → sad
    final allDaysMissing = _daysSinceAnyCompletion(recentLogs, routineIds, now);
    if (allDaysMissing >= 3) {
      return const DogMessage(
        state: DogState.sad,
        message: '요즘 많이 외로워요... 😔',
      );
    }

    // Health-based warnings (breed + age)
    final healthMessage = _getHealthWarning(profile);
    if (healthMessage != null) {
      return healthMessage;
    }

    // Default: happy
    final happyMessages = [
      '오늘도 좋은 하루! 😊',
      '같이 있어서 행복해요! 🐕',
      '오늘도 건강하게 보내요! 💪',
    ];
    return DogMessage(
      state: DogState.happy,
      message: happyMessages[now.day % happyMessages.length],
    );
  }

  int _daysSinceLastCompletion(
      List<DailyLog> recentLogs, Set<String> routineIds, DateTime now) {
    if (routineIds.isEmpty) return 0;

    final completedDates = recentLogs
        .where((l) => routineIds.contains(l.routineId) && l.completed)
        .map((l) => l.date)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (completedDates.isEmpty) return 30; // Assume long time

    final lastDate = DateTime.parse(completedDates.first);
    return now.difference(lastDate).inDays;
  }

  int _daysSinceAnyCompletion(
      List<DailyLog> recentLogs, Set<String> routineIds, DateTime now) {
    if (routineIds.isEmpty) return 0;

    final completedDates = recentLogs
        .where((l) => routineIds.contains(l.routineId) && l.completed)
        .map((l) => l.date)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (completedDates.isEmpty) return 30;

    final lastDate = DateTime.parse(completedDates.first);
    return now.difference(lastDate).inDays;
  }

  DogMessage? _getHealthWarning(PetProfile profile) {
    final breed = _breedService.getBreedById(profile.breedId);
    if (breed == null) return null;

    final age = profile.ageYears;

    // Senior warning
    if (age >= breed.seniorAge && age < breed.seniorAge + 1) {
      return DogMessage(
        state: DogState.healthWarning,
        message:
            '시니어에 진입했어요. 연 2회 건강검진을 추천해요.',
        source: 'American Animal Hospital Association',
      );
    }

    // High-risk breed warning for critical conditions
    for (final risk in breed.geneticHealthRisks) {
      if (risk.severity == 'critical' && risk.prevalencePercent >= 30) {
        if (age >= breed.seniorAge) {
          return DogMessage(
            state: DogState.healthWarning,
            message:
                '정기 검진이 중요해요. ${breed.nameKo}의 ${risk.prevalencePercent}%가 ${risk.conditionKo}으로...',
            source: risk.source,
          );
        }
      }
    }

    // Overweight warning
    if (breed.weightKg != null && profile.weightKg > breed.weightKg!.max) {
      return const DogMessage(
        state: DogState.healthWarning,
        message: '체중이 적정보다 높아요. 과체중은 수명을 평균 2.5년 줄일 수 있어요.',
        source: 'AVMA: 50,000+ dogs study',
      );
    }

    return null;
  }
}
