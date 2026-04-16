import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// E10. 주간 회고 화면
/// 이번 주 하이라이트 + 감정 변화 + 잘한 것 + 다음 주 기대
class WeeklyReviewScreen extends StatelessWidget {
  const WeeklyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '이번 주 돌아보기',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 하이라이트 섹션
                    _SectionTitle(title: '이번 주 하이라이트', emoji: '🌟'),
                    const SizedBox(height: 12),

                    _HighlightCard(
                      emoji: '😴',
                      title: '가장 긴 수면',
                      value: '5시간 30분',
                      subtitle: '화요일 밤',
                      color: AppColors.sleepPurple,
                    ),
                    const SizedBox(height: 10),
                    _HighlightCard(
                      emoji: '🍼',
                      title: '수유 안정화',
                      value: '일평균 8회로 안정',
                      subtitle: '지난주 대비 -1회',
                      color: AppColors.feedingBlue,
                    ),
                    const SizedBox(height: 10),
                    _HighlightCard(
                      emoji: '😊',
                      title: '새로운 마일스톤',
                      value: '사회적 미소!',
                      subtitle: '아기가 처음으로 웃었어요',
                      color: AppColors.coral,
                    ),

                    const SizedBox(height: 28),

                    // 감정 변화 그래프
                    _SectionTitle(title: '감정 변화', emoji: '📊'),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          // 범례
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _LegendDot(
                                color: AppColors.coral,
                                label: '엄마',
                              ),
                              const SizedBox(width: 20),
                              _LegendDot(
                                color: AppColors.info,
                                label: '아빠',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // 간단한 라인 차트 플레이스홀더
                          SizedBox(
                            height: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _WeekColumn(
                                  label: '1주차',
                                  momScore: 8,
                                  dadScore: 6,
                                ),
                                _WeekColumn(
                                  label: '2주차',
                                  momScore: 10,
                                  dadScore: 7,
                                ),
                                _WeekColumn(
                                  label: '3주차',
                                  momScore: 7,
                                  dadScore: 5,
                                ),
                                _WeekColumn(
                                  label: '이번주',
                                  momScore: 6,
                                  dadScore: 4,
                                  isCurrent: true,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            'EPDS 점수 추이 (낮을수록 양호)',
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppColors.textHint,
                                    ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 잘한 것
                    _SectionTitle(title: '잘한 것', emoji: '👏'),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '매일 기록을 빠짐없이 했어요!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '7일 연속 기록 달성! 꾸준함이 대단해요.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 다음 주 기대할 것
                    _SectionTitle(title: '다음 주 기대할 것', emoji: '🔮'),
                    const SizedBox(height: 12),

                    _UpcomingCard(
                      emoji: '🏥',
                      title: '영유아 검진',
                      subtitle: '수요일 오후 2시',
                      color: AppColors.info,
                    ),
                    const SizedBox(height: 10),
                    _UpcomingCard(
                      emoji: '📏',
                      title: '성장 마일스톤',
                      subtitle: '목 가누기가 더 안정될 시기예요',
                      color: AppColors.coral,
                    ),
                    const SizedBox(height: 10),
                    _UpcomingCard(
                      emoji: '💉',
                      title: '예방접종',
                      subtitle: 'BCG 접종 예정 (금요일)',
                      color: AppColors.warning,
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 파트너 함께 보기 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: 파트너 공유
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('파트너에게 공유했어요 💛'),
                        backgroundColor: AppColors.coral,
                      ),
                    );
                  },
                  icon: const Text('👫', style: TextStyle(fontSize: 18)),
                  label: const Text('파트너 함께 보기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 섹션 제목 위젯
class _SectionTitle extends StatelessWidget {
  final String title;
  final String emoji;

  const _SectionTitle({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

/// 하이라이트 카드
class _HighlightCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _HighlightCard({
    required this.emoji,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textHint,
                ),
          ),
        ],
      ),
    );
  }
}

/// 범례 점 위젯
class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

/// 주간 컬럼 (감정 차트)
class _WeekColumn extends StatelessWidget {
  final String label;
  final int momScore;
  final int dadScore;
  final bool isCurrent;

  const _WeekColumn({
    required this.label,
    required this.momScore,
    required this.dadScore,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    // 최대 점수 30 기준으로 높이 계산 (최대 80px)
    final momHeight = (momScore / 30 * 80).clamp(8.0, 80.0);
    final dadHeight = (dadScore / 30 * 80).clamp(8.0, 80.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 엄마 바
            Container(
              width: 14,
              height: momHeight,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.coral
                    : AppColors.coral.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 3),
            // 아빠 바
            Container(
              width: 14,
              height: dadHeight,
              decoration: BoxDecoration(
                color: isCurrent
                    ? AppColors.info
                    : AppColors.info.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color:
                    isCurrent ? AppColors.textPrimary : AppColors.textHint,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                fontSize: 10,
              ),
        ),
      ],
    );
  }
}

/// 다음 주 예정 카드
class _UpcomingCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _UpcomingCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
            size: 20,
          ),
        ],
      ),
    );
  }
}
