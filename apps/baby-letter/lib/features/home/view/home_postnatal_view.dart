import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../shared/data/baby_letters.dart';
import '../../../shared/widgets/letter_card.dart';
import 'letter_detail_screen.dart';

/// B2. 홈탭 — 출산 후 버전
/// 성장 요약 + 아기편지 + Serve & Return + 회고 + 위험신호
class HomePostnatalView extends StatelessWidget {
  final int daysSinceBirth;
  final String babyName;

  const HomePostnatalView({
    super.key,
    required this.daysSinceBirth,
    this.babyName = '콩이',
  });

  @override
  Widget build(BuildContext context) {
    final letter = findLetterForDay(daysSinceBirth);
    final months = daysSinceBirth ~/ 30;
    final remainDays = daysSinceBirth % 30;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 상단 바
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.coralLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('👶', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'D+$daysSinceBirth ($months개월 $remainDays일)',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '$babyName가 편지를 보냈어요',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            // 오늘의 성장 요약 카드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '👶 오늘의 성장',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amberLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '활발한 아기',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColors.amberDark,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 주요 지표 3개
                      Row(
                        children: [
                          _StatItem(
                            icon: Icons.nightlight_round,
                            label: '수면',
                            value: '14.2h/일',
                            color: AppColors.sleepPurple,
                          ),
                          const SizedBox(width: 16),
                          _StatItem(
                            icon: Icons.local_drink_rounded,
                            label: '수유',
                            value: '8회/일',
                            color: AppColors.feedingBlue,
                          ),
                          const SizedBox(width: 16),
                          _StatItem(
                            icon: Icons.baby_changing_station,
                            label: '기저귀',
                            value: '6회',
                            color: AppColors.diaperGreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 16,
                              color: AppColors.success,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '정상 범위 안에 있어요',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 아기 편지 카드
            if (letter != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: LetterCard(
                    letter: letter,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LetterDetailScreen(letter: letter),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Serve & Return 실천
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('🧠', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            'Serve & Return',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '오늘의 응답 연습',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '아기가 "아~" 하면\n"응, 엄마 여기 있어" 라고 대답해보세요',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '2초 안에 응답하면 아기 뇌에 신경 연결이 만들어져요',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 어제의 회고 (Technoference 방지)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_graph_rounded,
                            color: AppColors.info,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '어제의 회고',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // TODO: 패턴 시각화로 이동
                            },
                            child: const Text('상세보기'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '어제 기록 요약',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // 미니 요약
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _MiniStat(label: '수면', value: '13.5h'),
                          _MiniStat(label: '수유', value: '7회'),
                          _MiniStat(label: '기저귀', value: '5회'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Technoference 방지 메시지
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Center(
                  child: Text(
                    '지금은 아기와 함께하는 시간이에요 💛',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(label, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
