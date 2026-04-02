import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_config.dart';
import '../../../models/breed_info.dart';
import '../../../models/daily_log.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/life_calculator.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/glass_card.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  PetProfile? _profile;
  LifeStats? _lifeStats;
  BreedInfo? _breedInfo;
  List<DailyLog> _allLogs = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final profile = await PetStorageService().loadProfile();
    if (profile == null) return;

    final lifeStats = LifeCalculator().calculate(profile);
    final breedInfo = BreedDataService().getBreedById(profile.breedId);
    final allLogs = await PetStorageService().loadLogs();

    setState(() {
      _profile = profile;
      _lifeStats = lifeStats;
      _breedInfo = breedInfo;
      _allLogs = allLogs;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null || _lifeStats == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('분석',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ),
            const SizedBox(height: 16),
            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppConfig.accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: AppConfig.accentColor,
                unselectedLabelColor: Colors.white54,
                dividerHeight: 0,
                tabs: const [
                  Tab(text: '시간'),
                  Tab(text: '건강'),
                  Tab(text: '기록'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTimeTab(),
                  _buildHealthTab(),
                  _buildRecordTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Time Tab ───
  Widget _buildTimeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Life Journey Timeline (vertical)
          _buildLifeJourneyTimeline(),
          const SizedBox(height: 20),
          // Remaining days
          _buildRemainingCard(),
          const SizedBox(height: 16),
          // Human age + walks + meals
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '사람 나이',
                  '${_lifeStats!.humanAge.toStringAsFixed(0)}세',
                  Icons.person_outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '남은 산책',
                  _formatNumber(_lifeStats!.remainingWalks),
                  Icons.directions_walk,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '남은 식사',
                  _formatNumber(_lifeStats!.remainingMeals),
                  Icons.restaurant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  '수명 진행',
                  '${_lifeStats!.lifePercentage.toStringAsFixed(1)}%',
                  Icons.timeline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Emotional message + share
          GlassCard(
            child: Column(
              children: [
                Text(
                  '남은 ${_formatNumber(_lifeStats!.remainingWalks)}번의 산책 중\n오늘이 그 중 하나예요 🐾',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    SharePlus.instance.share(
                      ShareParams(
                        text:
                            '${_profile!.name}와 함께하는 시간\n'
                            '남은 산책: ${_formatNumber(_lifeStats!.remainingWalks)}번\n'
                            '남은 식사: ${_formatNumber(_lifeStats!.remainingMeals)}번\n'
                            '오늘도 소중한 하루를 보내요 🐾\n\n'
                            '#PetLife #반려견사랑',
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text('공유하기'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLifeJourneyTimeline() {
    final milestones = BreedDataService().getAgeMilestones(_profile!.breedId);
    final currentAge = _lifeStats!.currentAgeYears;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('인생 여정 타임라인',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          ...milestones.map((m) {
            final isPast = m.age <= currentAge;
            final isCurrent =
                (m.age - currentAge).abs() < 1.0 && isPast;

            return _buildTimelineNode(
              label: m.event,
              description: m.description,
              ageLabel: '${m.age.toStringAsFixed(m.age == m.age.roundToDouble() ? 0 : 1)}세',
              isPast: isPast,
              isCurrent: isCurrent,
              isLast: m == milestones.last,
            );
          }),
          // Current position node
          if (!milestones.any((m) =>
              (m.age - currentAge).abs() < 1.0 && m.age <= currentAge))
            _buildTimelineNode(
              label: '현재',
              description:
                  '${currentAge.toStringAsFixed(1)}세 · 사람 나이 ${_lifeStats!.humanAge.toStringAsFixed(0)}세 · 남은 시간 ${_formatNumber(_lifeStats!.remainingDays)}일',
              ageLabel: '${currentAge.toStringAsFixed(1)}세',
              isPast: true,
              isCurrent: true,
              isLast: false,
            ),
          // Future milestones
          ...(_breedInfo?.geneticHealthRisks ?? [])
              .where((r) => r.severity == 'critical')
              .take(2)
              .map((risk) {
            return _buildTimelineNode(
              label: '주의: ${risk.conditionKo}',
              description:
                  '발생률 ${risk.prevalencePercent}% · ${risk.source}',
              ageLabel: '',
              isPast: false,
              isCurrent: false,
              isLast: false,
              isWarning: true,
            );
          }),
          _buildTimelineNode(
            label: '평균 수명',
            description:
                '~${_lifeStats!.medianLifespan.toStringAsFixed(0)}세',
            ageLabel:
                '${_lifeStats!.medianLifespan.toStringAsFixed(0)}세',
            isPast: false,
            isCurrent: false,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode({
    required String label,
    required String description,
    required String ageLabel,
    required bool isPast,
    required bool isCurrent,
    required bool isLast,
    bool isWarning = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line + dot
        SizedBox(
          width: 30,
          child: Column(
            children: [
              Container(
                width: isCurrent ? 18 : 12,
                height: isCurrent ? 18 : 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isWarning
                      ? Colors.orange.withValues(alpha: 0.8)
                      : isPast
                          ? AppConfig.accentColor
                          : Colors.white.withValues(alpha: 0.2),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppConfig.accentColor
                                .withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isCurrent
                    ? const Icon(Icons.pets, size: 10, color: Colors.black)
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: isPast
                      ? AppConfig.accentColor.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.1),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: isWarning
                        ? Colors.orange
                        : isPast
                            ? Colors.white
                            : Colors.white54,
                    fontWeight:
                        isCurrent ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: isPast
                        ? Colors.white54
                        : Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemainingCard() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            '남은 시간',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          // Circular progress
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _lifeStats!.lifePercentage / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        AppConfig.accentColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatNumber(_lifeStats!.remainingDays),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('일',
                        style: TextStyle(
                            color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '약 ${(_lifeStats!.remainingDays / 365.25).toStringAsFixed(1)}년',
            style: TextStyle(
                color: AppConfig.accentColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: AppConfig.accentColor, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  // ─── Health Tab ───
  Widget _buildHealthTab() {
    final risks = _breedInfo?.geneticHealthRisks ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_breedInfo != null) ...[
            Text(
              '${_breedInfo!.nameKo} 유전 건강 위험',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '견종별 유전적 건강 위험입니다. 수의사와 상담을 권장합니다.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
          ],
          if (risks.isEmpty)
            GlassCard(
              child: Column(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    '이 견종에 대한 주요 유전병 데이터가 없습니다.',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ...risks.map(_buildHealthRiskCard),
          const SizedBox(height: 16),
          // Disclaimer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.orange.withValues(alpha: 0.7), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '이 정보는 참고용이며 수의학적 진단을 대체하지 않습니다. '
                    '반드시 수의사와 상담하세요.',
                    style: TextStyle(
                      color: Colors.orange.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildHealthRiskCard(HealthRisk risk) {
    final severityColor = _getSeverityColor(risk.severity);

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: severityColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  risk.conditionKo,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: severityColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${risk.prevalencePercent}%',
                  style: TextStyle(
                    color: severityColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (risk.description != null) ...[
            const SizedBox(height: 8),
            Text(
              risk.description!,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
          if (risk.prevention != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.shield_outlined,
                    color: Colors.green.withValues(alpha: 0.7), size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    risk.prevention!,
                    style: TextStyle(
                      color: Colors.green.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Text(
            '출처: ${risk.source}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'moderate':
        return Colors.amber;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ─── Record Tab ───
  Widget _buildRecordTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('월간 루틴 달성률',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          _buildMonthlyChart(),
          const SizedBox(height: 24),
          Text('루틴별 통계',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          if (_profile != null)
            ..._profile!.routines.map(_buildRoutineStatCard),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    // Get last 30 days completion data
    final now = DateTime.now();
    final routineCount =
        _profile?.routines.length ?? 1;
    final last7Days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final dateStr = PetStorageService.dateString(date);
      final completedCount = _allLogs
          .where((l) => l.date == dateStr && l.completed)
          .length;
      final rate = routineCount > 0
          ? (completedCount / routineCount).clamp(0.0, 1.0)
          : 0.0;
      return (date, rate);
    });

    return GlassCard(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: last7Days.map((entry) {
                final (date, rate) = entry;
                final dayName = _getDayName(date.weekday);
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(rate * 100).toInt()}%',
                          style: TextStyle(
                            color: rate > 0
                                ? AppConfig.accentColor
                                : Colors.white30,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: (rate * 100).clamp(4, 100),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(4),
                            color: rate > 0
                                ? AppConfig.accentColor
                                    .withValues(alpha: 0.3 + rate * 0.7)
                                : Colors.white
                                    .withValues(alpha: 0.05),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayName,
                          style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    const names = ['', '월', '화', '수', '목', '금', '토', '일'];
    return names[weekday];
  }

  Widget _buildRoutineStatCard(routine) {
    final completedCount = _allLogs
        .where((l) => l.routineId == routine.id && l.completed)
        .length;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(routine.icon, color: AppConfig.accentColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(routine.name,
                style: const TextStyle(color: Colors.white)),
          ),
          Text(
            '$completedCount회 완료',
            style:
                const TextStyle(color: Colors.white54, fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)},${(number % 1000).toString().padLeft(3, '0')}';
    }
    return number.toString();
  }
}
