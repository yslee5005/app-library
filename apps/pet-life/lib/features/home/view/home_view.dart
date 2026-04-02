import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/app_config.dart';
import '../../../models/daily_log.dart';
import '../../../models/daily_routine.dart';
import '../../../models/favorite_activity.dart';
import '../../../models/pet_profile.dart';
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
  DogMessage? _dogMessage;
  LifeStats? _lifeStats;
  Map<String, int> _streaks = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = PetStorageService();
    final profile = await storage.loadProfile();
    if (profile == null) return;

    final today = PetStorageService.dateString(DateTime.now());
    final todayLogs = await storage.getLogsForDate(today);
    final allLogs = await storage.loadLogs();
    final lifeStats = LifeCalculator().calculate(profile);
    final dogMessage = await DogStateService().getDogState(
      profile: profile,
      todayLogs: todayLogs,
      recentLogs: allLogs,
    );

    final streaks = <String, int>{};
    for (final routine in profile.routines) {
      streaks[routine.id] = await storage.getStreak(routine.id);
    }

    if (mounted) {
      setState(() {
        _profile = profile;
        _todayLogs = todayLogs;
        _dogMessage = dogMessage;
        _lifeStats = lifeStats;
        _streaks = streaks;
      });
    }
  }

  Future<void> _completeRoutine(DailyRoutine routine) async {
    HapticFeedback.mediumImpact();
    final today = PetStorageService.dateString(DateTime.now());
    await PetStorageService().addLog(DailyLog(
      date: today,
      routineId: routine.id,
      completed: true,
      completedAt: DateTime.now(),
    ));
    await _loadData();
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              _buildTopBar(),
              const SizedBox(height: 16),

              // Dog + speech bubble
              _buildDogSection(),
              const SizedBox(height: 24),

              // Favorite activities — THE CORE
              _buildFavoriteActivities(),
              const SizedBox(height: 24),

              // Daily routine (compact)
              _buildDailyRoutine(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final totalStreak = _streaks.values.fold(0, (a, b) => a > b ? a : b);
    return Row(
      children: [
        Text(
          '🐾 ${_profile!.name}',
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        if (totalStreak > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppConfig.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🔥 $totalStreak',
              style: TextStyle(color: AppConfig.accentColor, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _buildDogSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const DogPlaceholder(size: 70),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _dogMessage?.message ?? '안녕하세요! 🐾',
                  style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_profile!.ageDisplay} · ${_lifeStats != null ? "${_lifeStats!.remainingDays}일 남음" : ""}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── THE CORE: Favorite Activities with Remaining Counts ───
  Widget _buildFavoriteActivities() {
    final activities = _profile!.favoriteActivities;

    if (activities.isEmpty) {
      return GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '좋아하는 활동을 등록해주세요',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {}, // TODO: navigate to settings
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConfig.accentColor,
                side: BorderSide(color: AppConfig.accentColor.withOpacity(0.3)),
              ),
              child: const Text('활동 등록하기'),
            ),
          ],
        ),
      );
    }

    // Sort by urgency (most urgent first)
    final sorted = [...activities];
    sorted.sort((a, b) {
      final aYears = a.yearsRemaining(_profile!.ageYears);
      final bYears = b.yearsRemaining(_profile!.ageYears);
      return aYears.compareTo(bYears);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '초코가 좋아하는 것들',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          '남은 가능 횟수를 확인하세요',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ...sorted.map((activity) => _buildActivityCard(activity)),
      ],
    );
  }

  Widget _buildActivityCard(FavoriteActivity activity) {
    final age = _profile!.ageYears;
    final remaining = activity.remainingCount(age);
    final urgency = activity.urgencyLevel(age);
    final lastDate = _profile!.lastActivityDates[activity.id];
    final humanUnit = activity.remainingHumanUnit(age);
    final freq = activity.frequencyDisplay;
    final missed = activity.missedCount(lastDate);
    final remainingIfMore = activity.remainingIfMore(age);

    int daysSinceLast = -1;
    bool isOverdue = false;
    if (lastDate != null) {
      daysSinceLast = DateTime.now().difference(lastDate).inDays;
      isOverdue = daysSinceLast > 14;
    } else {
      isOverdue = true;
    }

    final overdueMsg = daysSinceLast > 0
        ? activity.overdueMessage(_profile!.name, daysSinceLast)
        : '';

    final accentColor = urgency == 'critical'
        ? Colors.redAccent
        : urgency == 'warning'
            ? const Color(0xFFE8A838) // brighter amber for readability
            : AppConfig.accentColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF252540), // slightly lighter than background for contrast
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: accentColor.withOpacity(urgency == 'normal' ? 0.1 : 0.35),
            width: urgency == 'normal' ? 1 : 1.5,
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji + name + remaining count
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (freq.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          '현재 패턴: $freq',
                          style: const TextStyle(color: Color(0xFF9090A0), fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$remaining번',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '남음',
                      style: TextStyle(color: Color(0xFF8080A0), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Human-friendly remaining time
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                humanUnit,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Overdue warning
            if (isOverdue && overdueMsg.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('⚠️', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            overdueMsg,
                            style: const TextStyle(color: Color(0xFFFF8A80), fontSize: 13, height: 1.3),
                          ),
                          if (missed > 0) ...[
                            const SizedBox(height: 2),
                            Text(
                              '이미 $missed번의 기회를 놓쳤어요',
                              style: const TextStyle(color: Color(0xFFFF8A80), fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Motivational: if you do 1 more per unit...
            if (remaining > 0 && remainingIfMore > remaining)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '💡 ${_frequencyUnitLabel(activity.frequencyUnit)} 1번 더 하면 → ${remainingIfMore}번으로 늘어나요!',
                  style: const TextStyle(color: Color(0xFF80D0A0), fontSize: 12),
                ),
              ),

            // Loss message
            Text(
              activity.lossMessage(age),
              style: const TextStyle(color: Color(0xFF707088), fontSize: 11),
            ),
            const SizedBox(height: 12),

            // CTA button
            if (isOverdue)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor.withOpacity(0.15),
                    foregroundColor: accentColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    '이번 주에 ${activity.name} 하기 ${activity.emoji}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _frequencyUnitLabel(String unit) {
    return switch (unit) {
      'weekly' => '매주',
      'yearly' => '매년',
      _ => '매달',
    };
  }

  // ─── Daily Routine (compact) ───
  Widget _buildDailyRoutine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '오늘의 루틴',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _profile!.routines.map((routine) {
            final isCompleted = _todayLogs.any(
              (l) => l.routineId == routine.id && l.completed,
            );
            final streak = _streaks[routine.id] ?? 0;

            return GestureDetector(
              onTap: isCompleted ? null : () => _completeRoutine(routine),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppConfig.accentColor.withOpacity(0.15)
                      : Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isCompleted
                        ? AppConfig.accentColor.withOpacity(0.3)
                        : Colors.white.withOpacity(0.05),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      routine.icon,
                      size: 16,
                      color: isCompleted ? AppConfig.accentColor : Colors.white38,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      routine.name,
                      style: TextStyle(
                        color: isCompleted ? AppConfig.accentColor : Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                    if (streak > 0 && isCompleted) ...[
                      const SizedBox(width: 4),
                      Text(
                        '🔥$streak',
                        style: TextStyle(color: AppConfig.accentColor, fontSize: 11),
                      ),
                    ],
                    if (isCompleted)
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.check, size: 14, color: Colors.green),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
