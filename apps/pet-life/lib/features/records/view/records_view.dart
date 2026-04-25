import 'package:flutter/material.dart';

import '../../../config/app_config.dart';
import '../../../models/daily_log.dart';
import '../../../models/pet_profile.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/glass_card.dart';

class RecordsView extends StatefulWidget {
  const RecordsView({super.key});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  PetProfile? _profile;
  List<DailyLog> _logs = [];
  Map<String, int> _streaks = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = PetStorageService();
    final profile = await storage.loadProfile();
    final logs = await storage.loadLogs();

    final streaks = <String, int>{};
    if (profile != null) {
      for (final routine in profile.routines) {
        streaks[routine.id] = await storage.getStreak(routine.id);
      }
    }

    if (mounted) {
      setState(() {
        _profile = profile;
        _logs = logs;
        _streaks = streaks;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                '📝 기록',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_profile!.name}와 함께한 시간',
                style: const TextStyle(color: Colors.white54, fontSize: 15),
              ),
              const SizedBox(height: 24),

              // Heatmap Calendar
              _buildHeatmapSection(),
              const SizedBox(height: 24),

              // Streak Section
              _buildStreakSection(),
              const SizedBox(height: 24),

              // Monthly Stats
              _buildMonthlyStats(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapSection() {
    final now = DateTime.now();
    final completedDates = <String>{};
    for (final log in _logs) {
      if (log.completed) {
        completedDates.add(log.date);
      }
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '이번 달 활동',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Simple calendar grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: _daysInMonth(now.year, now.month),
            itemBuilder: (context, index) {
              final day = index + 1;
              final dateStr = PetStorageService.dateString(
                DateTime(now.year, now.month, day),
              );
              final isCompleted = completedDates.contains(dateStr);
              final isToday = day == now.day;
              final isFuture = day > now.day;

              return Container(
                decoration: BoxDecoration(
                  color:
                      isFuture
                          ? Colors.white.withOpacity(0.03)
                          : isCompleted
                          ? AppConfig.accentColor.withOpacity(0.7)
                          : Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border:
                      isToday
                          ? Border.all(color: AppConfig.accentColor, width: 2)
                          : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$day',
                  style: TextStyle(
                    color:
                        isFuture
                            ? Colors.white24
                            : isCompleted
                            ? Colors.white
                            : Colors.white54,
                    fontSize: 12,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendDot(Colors.white.withOpacity(0.08), '미완'),
              const SizedBox(width: 16),
              _legendDot(AppConfig.accentColor.withOpacity(0.7), '완료'),
              const SizedBox(width: 16),
              _legendDot(Colors.white.withOpacity(0.03), '미래'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔥 스트릭 현황',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._profile!.routines.map((routine) {
            final streak = _streaks[routine.id] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(routine.icon, color: AppConfig.accentColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      routine.name,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          streak > 0
                              ? AppConfig.accentColor.withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      streak > 0 ? '🔥 $streak일' : '0일',
                      style: TextStyle(
                        color:
                            streak > 0 ? AppConfig.accentColor : Colors.white38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMonthlyStats() {
    final now = DateTime.now();
    final thisMonthLogs =
        _logs.where((l) {
          final date = DateTime.tryParse(l.date);
          return date != null &&
              date.year == now.year &&
              date.month == now.month &&
              l.completed;
        }).toList();

    final totalRoutines = _profile!.routines.length * now.day;
    final completedCount = thisMonthLogs.length;
    final percentage =
        totalRoutines > 0 ? (completedCount / totalRoutines * 100).round() : 0;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 이번 달 통계',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Overall progress
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: AppConfig.accentColor,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '전체 달성률',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$completedCount회',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '완료한 루틴',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(AppConfig.accentColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedCount / $totalRoutines 루틴 (${now.day}일 기준)',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
