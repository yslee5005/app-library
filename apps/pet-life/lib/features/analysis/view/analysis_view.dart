import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/app_config.dart';
import '../../../models/breed_info.dart';
import '../../../models/daily_log.dart';
import '../../../models/pet_profile.dart';
import '../../../services/breed_data_service.dart';
import '../../../services/care_standards.dart';
import '../../../services/life_calculator.dart';
import '../../../services/pet_storage_service.dart';
import '../../../widgets/glass_card.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  PetProfile? _profile;
  LifeStats? _lifeStats;
  BreedInfo? _breedInfo;
  List<DailyLog> _allLogs = [];
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

    final lifeStats = LifeCalculator().calculate(profile);
    final breedInfo = BreedDataService().getBreedById(profile.breedId);
    final allLogs = await storage.loadLogs();

    final streaks = <String, int>{};
    for (final routine in profile.routines) {
      streaks[routine.id] = await storage.getStreak(routine.id);
    }

    if (mounted) {
      setState(() {
        _profile = profile;
        _lifeStats = lifeStats;
        _breedInfo = breedInfo;
        _allLogs = allLogs;
        _streaks = streaks;
      });
    }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                '${_profile!.name} 분석',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Journey Timeline
              _buildJourneySection(),
              const SizedBox(height: 28),

              // 2. Care Score
              _buildCareScore(),
              const SizedBox(height: 28),

              // 3. Category Comparisons
              _buildComparisonSection(),
              const SizedBox(height: 28),

              // 4. Health Risks
              _buildHealthRisks(),
              const SizedBox(height: 28),

              // 5. Bottom CTA
              _buildBottomCTA(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ─── 1. Journey Timeline ───
  Widget _buildJourneySection() {
    final percentage = _lifeStats!.lifePercentage.round();

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🐾 여정',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          // Mini timeline bar
          Row(
            children: [
              const Text('탄생', style: TextStyle(color: Colors.white38, fontSize: 11)),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    // Background
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    // Progress
                    FractionallySizedBox(
                      widthFactor: percentage / 100,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppConfig.accentColor.withOpacity(0.5), AppConfig.accentColor],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    // Dog position
                    Positioned(
                      left: (MediaQuery.of(context).size.width - 80) * (percentage / 100) - 8,
                      top: -5,
                      child: const Text('🐕', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text('🌈', style: TextStyle(fontSize: 11)),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '$percentage% 경과 · 남은 시간 ${_formatNumber(_lifeStats!.remainingDays)}일',
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 2. Care Score ───
  Widget _buildCareScore() {
    final score = _calculateCareScore();

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            '🏆 돌봄 점수',
            style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          // Circular score
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      score >= 70
                          ? Colors.green
                          : score >= 40
                              ? AppConfig.accentColor
                              : Colors.redAccent,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: TextStyle(
                        color: AppConfig.accentColor,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text('/ 100', style: TextStyle(color: Colors.white38, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getCareScoreMessage(score),
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─── 3. Category Comparisons (15 items) ───
  Widget _buildComparisonSection() {
    final standards = CareStandards(profile: _profile!, breed: _breedInfo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📊 항목별 비교',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          '건강하게 오래 사는 강아지 기준과 비교',
          style: TextStyle(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 16),
        ...standards.categories.map((category) => _buildCategoryGroup(category)),
      ],
    );
  }

  Widget _buildCategoryGroup(CareCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(
            '${category.icon} ${category.name}',
            style: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        ...category.items.map((item) {
          if (item.isWeightItem) return _buildWeightCard();
          final current = _getCurrentValue(item);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildComparisonCard(
              icon: item.icon,
              title: item.name,
              current: current,
              recommended: item.recommended,
              unit: item.unit,
              tip: item.tip,
              source: item.source,
              isCritical: current == 0 && item.recommended > 0,
              hasNoRecord: current == -1,
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  int _getCurrentValue(CareItem item) {
    // If linked to a routine category, auto-count from logs
    if (item.routineCategory != null) {
      return _getWeeklyCount(item.routineCategory!);
    }
    // Items without routine tracking return -1 (no record)
    return -1;
  }

  Widget _buildComparisonCard({
    required String icon,
    required String title,
    required int current,
    required int recommended,
    required String unit,
    required String tip,
    required String source,
    bool isCritical = false,
    bool hasNoRecord = false,
  }) {
    if (hasNoRecord) {
      return GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('기록 없음 · 권장 $recommended$unit', style: const TextStyle(color: Colors.white30, fontSize: 11)),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppConfig.accentColor,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('루틴 추가 →', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      );
    }

    final percentage = recommended > 0 ? (current / recommended * 100).clamp(0, 100).round() : 0;
    final deficit = recommended - current;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: percentage >= 80
                      ? Colors.green.withOpacity(0.2)
                      : percentage >= 50
                          ? AppConfig.accentColor.withOpacity(0.2)
                          : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    color: percentage >= 80 ? Colors.green : percentage >= 50 ? AppConfig.accentColor : Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comparison bars
          Row(
            children: [
              SizedBox(
                width: 30,
                child: Text('나', style: TextStyle(color: Colors.white54, fontSize: 11)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(AppConfig.accentColor),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$current$unit', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 30,
                child: Text('권장', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: 1.0,
                    backgroundColor: Colors.white.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.15)),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('$recommended$unit', style: const TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          // Tip
          if (deficit > 0)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isCritical ? Colors.redAccent.withOpacity(0.1) : AppConfig.accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(isCritical ? '🔴' : '💡', style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        color: isCritical ? Colors.redAccent.shade100 : Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (deficit <= 0)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text('✅', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Text('잘하고 있어요!', style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ),
          // Source
          const SizedBox(height: 6),
          Text(source, style: const TextStyle(color: Colors.white24, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildWeightCard() {
    final weight = _profile!.weightKg;
    final minWeight = _breedInfo?.weightKg?.min.toDouble() ?? 10;
    final maxWeight = _breedInfo?.weightKg?.max.toDouble() ?? 40;
    final isInRange = weight >= minWeight && weight <= maxWeight;
    final isOver = weight > maxWeight;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('⚖️', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              const Text('체중', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isInRange ? Colors.green.withOpacity(0.2) : Colors.redAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInRange ? '적정' : isOver ? '과체중' : '저체중',
                  style: TextStyle(
                    color: isInRange ? Colors.green : Colors.redAccent,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weight range bar
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${minWeight.round()}kg', style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Text(
                '${weight}kg (현재)',
                style: TextStyle(color: AppConfig.accentColor, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text('${maxWeight.round()}kg', style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
          if (isOver) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Text('⚠️', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '과체중은 수명을 최대 2.5년 단축시켜요 — AVMA',
                      style: TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ─── 4. Health Risks ───
  Widget _buildHealthRisks() {
    if (_breedInfo == null || _breedInfo!.geneticHealthRisks.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '⚠️ 건강 위험',
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ..._breedInfo!.geneticHealthRisks.take(4).map(_buildHealthRiskCard),
      ],
    );
  }

  Widget _buildHealthRiskCard(HealthRisk risk) {
    final color = risk.severity == 'critical'
        ? Colors.redAccent
        : risk.severity == 'high'
            ? Colors.orange
            : Colors.amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    risk.conditionKo,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${risk.prevalencePercent}% 발생률 · ${risk.source}',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${risk.prevalencePercent}%',
                style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 5. Bottom CTA ───
  Widget _buildBottomCTA() {
    final score = _calculateCareScore();
    final pointsToTop = (80 - score).clamp(0, 100);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            pointsToTop > 0
                ? '${_profile!.name}의 돌봄 점수를 올리면\n더 건강하고 오래 함께할 수 있어요'
                : '${_profile!.name}를 정말 잘 돌보고 계시네요! 💛',
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
            textAlign: TextAlign.center,
          ),
          if (pointsToTop > 0) ...[
            const SizedBox(height: 4),
            Text(
              '오늘 +${(pointsToTop * 0.3).round()}점 가능해요!',
              style: TextStyle(color: AppConfig.accentColor, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Share.share(
                  '${_profile!.name} 돌봄 점수: $score/100\n'
                  '남은 시간: ${_formatNumber(_lifeStats!.remainingDays)}일\n'
                  '오늘도 함께 걸어요 🐾\n\n'
                  '#PetLife #반려견사랑',
                );
              },
              icon: const Icon(Icons.share_outlined, size: 18),
              label: const Text('분석 결과 공유하기'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConfig.accentColor,
                side: BorderSide(color: AppConfig.accentColor.withOpacity(0.3)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ───

  int _calculateCareScore() {
    int score = 0;

    // Walk score (max 30)
    final weeklyWalks = _getWeeklyCount('walk');
    final recWalks = _getRecommendedWeeklyWalks();
    score += ((weeklyWalks / recWalks) * 30).clamp(0, 30).round();

    // Teeth score (max 20)
    final weeklyTeeth = _getWeeklyCount('care');
    score += ((weeklyTeeth / 7) * 20).clamp(0, 20).round();

    // Weight score (max 20)
    final weight = _profile!.weightKg;
    final minW = _breedInfo?.weightKg?.min.toDouble() ?? 10;
    final maxW = _breedInfo?.weightKg?.max.toDouble() ?? 40;
    if (weight >= minW && weight <= maxW) score += 20;

    // Streak bonus (max 15)
    final maxStreak = _streaks.values.fold(0, (a, b) => a > b ? a : b);
    score += (maxStreak / 30 * 15).clamp(0, 15).round();

    // Meal score (max 15)
    final weeklyMeals = _getWeeklyCount('meal');
    score += ((weeklyMeals / 14) * 15).clamp(0, 15).round();

    return score.clamp(0, 100);
  }

  String _getCareScoreMessage(int score) {
    if (score >= 80) return '훌륭해요! 상위 20% 보호자예요 🏆';
    if (score >= 60) return '잘하고 있어요! 상위 40% 🌟';
    if (score >= 40) return '조금만 더 노력하면 상위 40%! 💪';
    return '${_profile!.name}가 더 많은 관심이 필요해요 🐾';
  }

  int _getWeeklyCount(String category) {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _allLogs.where((l) {
      final date = DateTime.tryParse(l.date);
      if (date == null) return false;
      final routine = _profile!.routines.where((r) => r.id == l.routineId).firstOrNull;
      return l.completed && date.isAfter(weekAgo) && routine?.category == category;
    }).length;
  }

  int _getRecommendedWeeklyWalks() {
    final exerciseMin = _breedInfo?.exerciseMinutesPerDay?.min ?? 60;
    if (exerciseMin >= 90) return 14;
    if (exerciseMin >= 60) return 14;
    return 10;
  }

  String _getWalkTip() {
    final current = _getWeeklyCount('walk');
    final rec = _getRecommendedWeeklyWalks();
    final deficit = rec - current;
    if (deficit <= 0) return '충분히 산책하고 있어요!';
    if (deficit <= 4) return '하루 ${(deficit / 7).ceil()}번 더 가면 권장량 달성!';
    return '산책이 부족해요. 매일 산책이 치매 위험 6.47배 낮춰줘요';
  }

  String _getTeethTip() {
    final current = _getWeeklyCount('care');
    if (current >= 7) return '매일 양치 완벽!';
    if (current >= 3) return '주 ${7 - current}회 더 하면 치주질환 예방에 효과적!';
    return '3세 이상 80-90%가 치주질환. 양치를 시작해보세요';
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
