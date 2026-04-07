import 'streak.dart';

/// Abstract gamification service interface.
abstract class GamificationService {
  Future<Streak> getStreak();
  Future<void> recordActivity();
  Future<List<String>> checkMilestones();
}
