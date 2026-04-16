import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C2. 기록탭 메인 — 출산 후 버전 (기본)
/// 퀵기록 4버튼 + 오늘 요약 + 타임라인
class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 상단
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      '기록',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // TODO: C9 캘린더 뷰
                      },
                      icon: const Icon(Icons.calendar_month_rounded),
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            // 빠른 기록 버튼 그리드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '빠른 기록',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickRecordButton(
                            emoji: '🍼',
                            label: '수유',
                            color: AppColors.feedingBlue,
                            onTap: () {
                              // TODO: C4 수유 기록
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickRecordButton(
                            emoji: '😴',
                            label: '수면',
                            color: AppColors.sleepPurple,
                            onTap: () {
                              // TODO: C5 수면 기록
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _QuickRecordButton(
                            emoji: '🧷',
                            label: '기저귀',
                            color: AppColors.diaperGreen,
                            onTap: () {
                              // TODO: C6 기저귀 기록
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _QuickRecordButton(
                            emoji: '📝',
                            label: '메모',
                            color: AppColors.amber,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 오늘 요약
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘 요약',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(
                        icon: Icons.local_drink_rounded,
                        label: '수유',
                        value: '아직 기록 없음',
                        color: AppColors.feedingBlue,
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        icon: Icons.nightlight_round,
                        label: '수면',
                        value: '아직 기록 없음',
                        color: AppColors.sleepPurple,
                      ),
                      const SizedBox(height: 12),
                      _SummaryRow(
                        icon: Icons.baby_changing_station,
                        label: '기저귀',
                        value: '아직 기록 없음',
                        color: AppColors.diaperGreen,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 오늘 타임라인
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '오늘 타임라인',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // TODO: C7 패턴 시각화
                            },
                            child: const Text('주간 패턴 보기'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.timeline_rounded,
                              size: 48,
                              color: AppColors.textHint.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '기록을 시작하면\n타임라인이 만들어져요',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: AppColors.textHint),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _QuickRecordButton extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickRecordButton({
    required this.emoji,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
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
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
