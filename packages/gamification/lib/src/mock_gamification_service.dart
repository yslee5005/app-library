import 'gamification_service.dart';
import 'milestone.dart';
import 'streak.dart';
import 'streak_calculator.dart';

/// In-memory mock for development and testing.
class MockGamificationService implements GamificationService {
  Streak _streak = const Streak(current: 0, best: 0);
  final List<Milestone> _milestones = [];

  static const _milestoneThresholds = {
    'first_activity': 1,
    '7_day_streak': 7,
    '14_day_streak': 14,
    '30_day_streak': 30,
    '60_day_streak': 60,
    '100_day_streak': 100,
  };

  @override
  Future<Streak> getStreak() async => _streak;

  @override
  Future<void> recordActivity() async {
    _streak = StreakCalculator.recordActivity(_streak);
  }

  @override
  Future<List<String>> checkMilestones() async {
    final newMilestones = <String>[];
    final achieved = _milestones.map((m) => m.type).toSet();

    for (final entry in _milestoneThresholds.entries) {
      if (!achieved.contains(entry.key) && _streak.current >= entry.value) {
        final milestone = Milestone(type: entry.key, achievedAt: DateTime.now());
        _milestones.add(milestone);
        newMilestones.add(entry.key);
      }
    }

    return newMilestones;
  }
}
