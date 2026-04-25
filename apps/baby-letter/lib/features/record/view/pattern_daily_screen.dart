import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C7. 일간 패턴
/// 24시간 타임라인 + 활동별 컬러 바 + 평균 밴드 placeholder
class PatternDailyScreen extends StatelessWidget {
  const PatternDailyScreen({super.key});

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
        title: Text('일간 패턴', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // 날짜 표시
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '2026년 4월 16일 (수)',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          // 평균 밴드 설명
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.textHint.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: AppColors.textHint.withValues(alpha: 0.3),
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '같은 유형 평균 밴드 (데이터 수집 중)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 24시간 타임라인
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              itemCount: 24,
              itemBuilder: (context, index) {
                final activities = _getDemoActivities(index);
                return _HourBlock(hour: index, activities: activities);
              },
            ),
          ),

          // 범례
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.cream, width: 1)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LegendItem(color: AppColors.feedingBlue, label: '수유'),
                  _LegendItem(color: AppColors.sleepPurple, label: '수면'),
                  _LegendItem(color: AppColors.diaperGreen, label: '기저귀'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 데모 데이터: 특정 시간에 활동이 있었는지
  List<_ActivityData> _getDemoActivities(int hour) {
    switch (hour) {
      case 0:
        return [_ActivityData.sleep()];
      case 1:
        return [_ActivityData.sleep()];
      case 2:
        return [_ActivityData.sleep(), _ActivityData.feeding()];
      case 3:
        return [_ActivityData.sleep()];
      case 4:
        return [_ActivityData.sleep()];
      case 5:
        return [_ActivityData.sleep(), _ActivityData.diaper()];
      case 6:
        return [_ActivityData.feeding()];
      case 7:
        return [_ActivityData.diaper()];
      case 9:
        return [_ActivityData.feeding()];
      case 10:
        return [_ActivityData.sleep()];
      case 11:
        return [_ActivityData.sleep()];
      case 12:
        return [_ActivityData.feeding(), _ActivityData.diaper()];
      case 14:
        return [_ActivityData.sleep()];
      case 15:
        return [_ActivityData.feeding()];
      case 16:
        return [_ActivityData.diaper()];
      case 18:
        return [_ActivityData.feeding()];
      case 19:
        return [_ActivityData.diaper()];
      case 20:
        return [_ActivityData.sleep()];
      case 21:
        return [_ActivityData.sleep()];
      case 22:
        return [_ActivityData.sleep(), _ActivityData.feeding()];
      case 23:
        return [_ActivityData.sleep()];
      default:
        return [];
    }
  }
}

enum _ActivityType { feeding, sleep, diaper }

class _ActivityData {
  final _ActivityType type;
  final Color color;

  const _ActivityData({required this.type, required this.color});

  factory _ActivityData.feeding() => const _ActivityData(
    type: _ActivityType.feeding,
    color: AppColors.feedingBlue,
  );
  factory _ActivityData.sleep() => const _ActivityData(
    type: _ActivityType.sleep,
    color: AppColors.sleepPurple,
  );
  factory _ActivityData.diaper() => const _ActivityData(
    type: _ActivityType.diaper,
    color: AppColors.diaperGreen,
  );
}

class _HourBlock extends StatelessWidget {
  final int hour;
  final List<_ActivityData> activities;

  const _HourBlock({required this.hour, required this.activities});

  @override
  Widget build(BuildContext context) {
    final hourLabel = hour.toString().padLeft(2, '0');
    final hasActivity = activities.isNotEmpty;

    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          // 시간 라벨
          SizedBox(
            width: 40,
            child: Text(
              '$hourLabel시',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
                fontWeight: hasActivity ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // 활동 바
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: hasActivity ? Colors.transparent : AppColors.surface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: hasActivity
                  ? Row(
                      children: activities.map((activity) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: activity.color.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: activity.color.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : null,
            ),
          ),
          // 평균 밴드 (placeholder - 반투명 밴드)
          const SizedBox(width: 8),
          Container(
            width: 20,
            decoration: BoxDecoration(
              color: AppColors.textHint.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: color, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
