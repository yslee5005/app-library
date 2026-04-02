import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/app_config.dart';
import '../../../models/breed_info.dart';
import '../../../models/daily_log.dart';
import '../../../models/daily_routine.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/dog_state_service.dart';
import '../../../services/life_calculator.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/dog_placeholder.dart';
import '../../../widgets/glass_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PetProfile? _profile;
  List<DailyLog> _todayLogs = [];
  List<DailyLog> _recentLogs = [];
  DogMessage? _dogMessage;
  LifeStats? _lifeStats;
  BreedInfo? _breedInfo;
  Map<String, int> _streaks = {};

  final _dogStateService = DogStateService();
  final _lifeCalculator = LifeCalculator();
  final _storageService = PetStorageService();
  final _breedService = BreedDataService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _storageService.loadProfile();
    if (profile == null) return;

    final today = PetStorageService.dateString(DateTime.now());
    final allLogs = await _storageService.loadLogs();
    final todayLogs = allLogs.where((l) => l.date == today).toList();

    // Recent logs: last 30 days
    final thirtyDaysAgo =
        DateTime.now().subtract(const Duration(days: 30));
    final recentLogs = allLogs
        .where((l) =>
            DateTime.tryParse(l.date)?.isAfter(thirtyDaysAgo) ?? false)
        .toList();

    final dogMessage = await _dogStateService.getDogState(
      profile: profile,
      todayLogs: todayLogs,
      recentLogs: recentLogs,
    );

    final lifeStats = _lifeCalculator.calculate(profile);
    final breedInfo = _breedService.getBreedById(profile.breedId);

    // Load streaks for each routine
    final streaks = <String, int>{};
    for (final routine in profile.routines) {
      streaks[routine.id] = await _storageService.getStreak(routine.id);
    }

    setState(() {
      _profile = profile;
      _todayLogs = todayLogs;
      _recentLogs = recentLogs;
      _dogMessage = dogMessage;
      _lifeStats = lifeStats;
      _breedInfo = breedInfo;
      _streaks = streaks;
    });
  }

  Future<void> _completeRoutine(DailyRoutine routine) async {
    final today = PetStorageService.dateString(DateTime.now());
    final log = DailyLog(
      date: today,
      routineId: routine.id,
      completed: true,
      completedAt: DateTime.now(),
    );

    await _storageService.addLog(log);
    await _loadData();
  }

  bool _isRoutineCompleted(String routineId) {
    return _todayLogs.any(
        (l) => l.routineId == routineId && l.completed);
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildTopBar(),
              const SizedBox(height: 20),
              _buildHeroSection(),
              const SizedBox(height: 20),
              _buildLifeJourneyMiniTimeline(),
              const SizedBox(height: 20),
              _buildRoutineSection(),
              const SizedBox(height: 20),
              _buildDailyInsight(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Top Bar ───
  Widget _buildTopBar() {
    final perfectDayStreak = _calculatePerfectDayStreak();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _profile!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _profile!.ageDisplay,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (perfectDayStreak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppConfig.accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '$perfectDayStreak일',
                  style: TextStyle(
                    color: AppConfig.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  int _calculatePerfectDayStreak() {
    if (_profile == null || _profile!.routines.isEmpty) return 0;
    // Simple: check if all routines were completed today
    final allCompleted = _profile!.routines.every(
        (r) => _isRoutineCompleted(r.id));
    if (!allCompleted) return 0;
    // Count consecutive days from today backwards
    return _streaks.values.isEmpty
        ? 0
        : _streaks.values.reduce((a, b) => a < b ? a : b);
  }

  // ─── Hero Section ───
  Widget _buildHeroSection() {
    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              const DogPlaceholder(size: 100),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSpeechBubble(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechBubble() {
    final message = _dogMessage?.message ?? '안녕하세요!';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          if (_dogMessage?.source != null) ...[
            const SizedBox(height: 6),
            Text(
              '출처: ${_dogMessage!.source}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Life Journey Mini Timeline ───
  Widget _buildLifeJourneyMiniTimeline() {
    if (_lifeStats == null || _breedInfo == null) return const SizedBox.shrink();

    final percentage = _lifeStats!.lifePercentage;
    final milestones = _breedService.getAgeMilestones(_profile!.breedId);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('인생 여정',
                  style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${percentage.toStringAsFixed(0)}% 경과',
                style: TextStyle(
                  color: AppConfig.accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTimelineBar(percentage, milestones),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('탄생',
                  style: TextStyle(color: Colors.white38, fontSize: 11)),
              Text('~${_lifeStats!.medianLifespan.toStringAsFixed(0)}세',
                  style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineBar(double percentage, List<AgeMilestone> milestones) {
    return SizedBox(
      height: 32,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final currentPos = (percentage / 100) * width;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background bar
              Positioned(
                top: 14,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Progress bar
              Positioned(
                top: 14,
                left: 0,
                width: currentPos.clamp(0, width),
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [
                        AppConfig.accentColor.withValues(alpha: 0.4),
                        AppConfig.accentColor,
                      ],
                    ),
                  ),
                ),
              ),
              // Milestone dots
              ...milestones.map((m) {
                final pos = (m.age / _lifeStats!.medianLifespan) * width;
                final isPast = m.age <= _lifeStats!.currentAgeYears;
                return Positioned(
                  top: 11,
                  left: pos.clamp(4, width - 4) - 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPast
                          ? AppConfig.accentColor
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                );
              }),
              // Current position: paw icon
              Positioned(
                top: 2,
                left: (currentPos - 14).clamp(0, width - 28),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConfig.accentColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppConfig.accentColor.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.pets, size: 14, color: Colors.black),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Routine Section ───
  Widget _buildRoutineSection() {
    if (_profile == null || _profile!.routines.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('오늘의 루틴',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: _profile!.routines.length,
            itemBuilder: (context, index) {
              final routine = _profile!.routines[index];
              final completed = _isRoutineCompleted(routine.id);
              final streak = _streaks[routine.id] ?? 0;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildRoutineCard(routine, completed, streak),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineCard(
      DailyRoutine routine, bool completed, int streak) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                routine.icon,
                color: completed
                    ? AppConfig.accentColor
                    : Colors.white54,
                size: 28,
              ),
              if (streak > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🔥 $streak',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.orange),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            routine.name,
            style: TextStyle(
              color: completed ? AppConfig.accentColor : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: completed
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: AppConfig.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '완료 ✓',
                        style: TextStyle(
                            color: AppConfig.accentColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )
                : ElevatedButton(
                    onPressed: () => _completeRoutine(routine),
                    child: const Text('완료하기'),
                  ),
          ),
        ],
      ),
    );
  }

  // ─── Daily Insight ───
  Widget _buildDailyInsight() {
    final insights = _getInsights();
    if (insights.isEmpty) return const SizedBox.shrink();

    final today = DateTime.now().day;
    final insight = insights[today % insights.length];

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline,
              color: AppConfig.accentColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '오늘의 건강 정보',
                  style: TextStyle(
                    color: AppConfig.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getInsights() {
    final breed = _breedInfo;
    final insights = <String>[
      '반려견의 치아 건강을 위해 매일 양치질을 해주세요. 3세 이상 반려견의 80%가 치주질환이 있습니다.',
      '산책은 신체 건강뿐 아니라 정신 건강에도 중요합니다. 인지 기능 저하를 예방해요.',
      '적정 체중을 유지하면 수명이 평균 2.5년 늘어납니다. (AVMA 50,000+ dogs study)',
      '시니어 반려견은 연 2회 건강검진을 권장합니다.',
      '사람 음식 중 초콜릿, 포도, 양파, 자일리톨은 반려견에게 독성이 있습니다.',
    ];

    if (breed != null) {
      for (final risk in breed.geneticHealthRisks) {
        if (risk.description != null) {
          insights.add('${risk.conditionKo}: ${risk.description} (${risk.source})');
        }
      }
    }

    return insights;
  }
}
