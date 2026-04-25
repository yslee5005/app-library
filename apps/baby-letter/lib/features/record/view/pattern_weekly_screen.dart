import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C8. 주간 패턴
/// 7일 비교 스택 바 차트 + 베이스라인 + 인사이트 카드 + 월간 트렌드 placeholder
class PatternWeeklyScreen extends StatelessWidget {
  const PatternWeeklyScreen({super.key});

  // 데모 데이터
  static const _weekData = [
    _DayData(label: '월', sleepHours: 14, feedingCount: 8, diaperCount: 6),
    _DayData(label: '화', sleepHours: 13, feedingCount: 7, diaperCount: 5),
    _DayData(label: '수', sleepHours: 15, feedingCount: 9, diaperCount: 7),
    _DayData(label: '목', sleepHours: 14, feedingCount: 8, diaperCount: 6),
    _DayData(label: '금', sleepHours: 15, feedingCount: 8, diaperCount: 5),
    _DayData(label: '토', sleepHours: 16, feedingCount: 7, diaperCount: 6),
    _DayData(label: '일', sleepHours: 15, feedingCount: 8, diaperCount: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
        ),
        title: Text('주간 패턴', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜 범위
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '4월 10일 (목) - 4월 16일 (수)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 7일 비교 차트
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '일별 기록 비교',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),

                  // 스택 바 차트
                  SizedBox(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _weekData.map((day) {
                        return _DayColumn(data: day);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 베이스라인 표시 (점선 placeholder)
                  Row(
                    children: [
                      // 점선 표시
                      ...List.generate(20, (i) {
                        return Expanded(
                          child: Container(
                            height: 1,
                            color: i.isEven
                                ? AppColors.textHint.withValues(alpha: 0.4)
                                : Colors.transparent,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '--- 개인 베이스라인 (형성 중)',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 범례
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ChartLegend(
                        color: AppColors.sleepPurple,
                        label: '수면(시간)',
                      ),
                      _ChartLegend(
                        color: AppColors.feedingBlue,
                        label: '수유(회)',
                      ),
                      _ChartLegend(
                        color: AppColors.diaperGreen,
                        label: '기저귀(회)',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 긍정 인사이트 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Text('🌱', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '4일차부터 패턴이 안정되기 시작했어요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 주간 통계 요약
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('주간 평균', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 16),
                  _StatRow(
                    icon: Icons.nightlight_round,
                    color: AppColors.sleepPurple,
                    label: '수면',
                    value: '14.6시간/일',
                  ),
                  const SizedBox(height: 12),
                  _StatRow(
                    icon: Icons.local_drink_rounded,
                    color: AppColors.feedingBlue,
                    label: '수유',
                    value: '7.9회/일',
                  ),
                  const SizedBox(height: 12),
                  _StatRow(
                    icon: Icons.baby_changing_station,
                    color: AppColors.diaperGreen,
                    label: '기저귀',
                    value: '5.9회/일',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 월간 트렌드 placeholder
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '월간 트렌드',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Icon(
                    Icons.show_chart_rounded,
                    size: 48,
                    color: AppColors.textHint.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2주 이상 데이터가 쌓이면\n월간 트렌드를 보여드려요',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DayData {
  final String label;
  final double sleepHours;
  final int feedingCount;
  final int diaperCount;

  const _DayData({
    required this.label,
    required this.sleepHours,
    required this.feedingCount,
    required this.diaperCount,
  });

  double get total => sleepHours + feedingCount + diaperCount;
}

class _DayColumn extends StatelessWidget {
  final _DayData data;

  const _DayColumn({required this.data});

  @override
  Widget build(BuildContext context) {
    // 최대 높이 180에 대해 스케일링
    const maxHeight = 180.0;
    const maxTotal = 30.0; // 최대 예상 합

    final scale = maxHeight / maxTotal;
    final sleepHeight = data.sleepHours * scale;
    final feedingHeight = data.feedingCount * scale;
    final diaperHeight = data.diaperCount * scale;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // 수면 (위)
        Container(
          width: 28,
          height: sleepHeight,
          decoration: BoxDecoration(
            color: AppColors.sleepPurple.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        // 수유 (중간)
        Container(
          width: 28,
          height: feedingHeight,
          color: AppColors.feedingBlue.withValues(alpha: 0.7),
        ),
        // 기저귀 (아래)
        Container(
          width: 28,
          height: diaperHeight,
          decoration: BoxDecoration(
            color: AppColors.diaperGreen.withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(4),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          data.label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
