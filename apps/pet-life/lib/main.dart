import 'package:flutter/material.dart';

import 'models/daily_log.dart';
import 'models/daily_routine.dart';
import 'models/favorite_activity.dart';
import 'models/pet_profile.dart';
import 'router/app_router.dart';
import 'services/breed_data_service.dart';
import 'services/pet_storage_service.dart';
import 'theme/pet_life_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load breed data
  await BreedDataService().loadBreeds();

  // === TEST MODE: Skip onboarding, inject sample data ===
  await _injectSampleData();

  runApp(const PetLifeApp(isOnboarded: true));
}

/// Injects hardcoded sample data for testing
Future<void> _injectSampleData() async {
  final storage = PetStorageService();

  // Sample pet: 초코, 골든 리트리버, 7세
  final profile = PetProfile(
    name: '초코',
    breedId: 'golden_retriever',
    birthDate: DateTime(2019, 3, 15),
    weightKg: 28.0,
    neutered: true,
    routines: [
      ...DailyRoutine.defaults,
      DailyRoutine.optionals[0], // 양치질
    ],
    favoriteActivities: [
      FavoriteActivity.allActivities[0], // 수영
      FavoriteActivity.allActivities[1], // 공놀이
      FavoriteActivity.allActivities[2], // 등산
      FavoriteActivity.allActivities[4], // 친구 만남
      FavoriteActivity.allActivities[5], // 드라이브
    ],
    lastActivityDates: {
      'swimming': DateTime.now().subtract(const Duration(days: 60)),
      'ball_play': DateTime.now().subtract(const Duration(days: 3)),
      'hiking': DateTime.now().subtract(const Duration(days: 180)),
      'dog_friends': DateTime.now().subtract(const Duration(days: 21)),
      'car_ride': DateTime.now().subtract(const Duration(days: 7)),
    },
    createdAt: DateTime(2024, 1, 1),
  );

  await storage.saveProfile(profile);
  await storage.setOnboardingComplete(true);

  // Sample daily logs — 오늘 일부 완료 + 과거 14일 스트릭
  final today = PetStorageService.dateString(DateTime.now());
  final logs = <DailyLog>[];

  // 오늘: 아침 산책 + 아침 식사 완료
  logs.add(DailyLog(
    date: today,
    routineId: 'walk_am',
    completed: true,
    completedAt: DateTime.now().subtract(const Duration(hours: 3)),
  ));
  logs.add(DailyLog(
    date: today,
    routineId: 'meal_am',
    completed: true,
    completedAt: DateTime.now().subtract(const Duration(hours: 4)),
  ));

  // 과거 14일 — 전부 완료 (스트릭 14일)
  for (int i = 1; i <= 14; i++) {
    final date = PetStorageService.dateString(
      DateTime.now().subtract(Duration(days: i)),
    );
    for (final routineId in ['walk_am', 'walk_pm', 'meal_am', 'meal_pm']) {
      logs.add(DailyLog(
        date: date,
        routineId: routineId,
        completed: true,
        completedAt: DateTime.now().subtract(Duration(days: i)),
      ));
    }
  }

  await storage.saveLogs(logs);
}

class PetLifeApp extends StatelessWidget {
  final bool isOnboarded;

  const PetLifeApp({super.key, required this.isOnboarded});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(isOnboarded: isOnboarded);

    return MaterialApp.router(
      title: 'Pet Life',
      debugShowCheckedModeBanner: false,
      theme: PetLifeTheme.darkTheme,
      routerConfig: appRouter.router,
    );
  }
}
