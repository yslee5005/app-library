import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// E1. 우리탭 메인 — 삼각형 케어 모델
class UsScreen extends StatelessWidget {
  const UsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('우리', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 20),

              // 삼각형 비주얼
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('👶', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 4),
                    Text('콩이', style: Theme.of(context).textTheme.labelMedium),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 왼쪽 선
                        Container(
                          width: 60,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.coral.withValues(alpha: 0.1),
                                AppColors.coral.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('💛', style: TextStyle(fontSize: 24)),
                        ),
                        // 오른쪽 선
                        Container(
                          width: 60,
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.coral.withValues(alpha: 0.5),
                                AppColors.coral.withValues(alpha: 0.1),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            const Text('👩', style: TextStyle(fontSize: 36)),
                            const SizedBox(height: 4),
                            Text(
                              '엄마',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                        // 하단 선
                        Container(
                          width: 80,
                          height: 2,
                          color: AppColors.coral.withValues(alpha: 0.3),
                        ),
                        Column(
                          children: [
                            const Text('👨', style: TextStyle(fontSize: 36)),
                            const SizedBox(height: 4),
                            Text(
                              '아빠',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 엄마 상태 카드
              _StatusCard(
                emoji: '👩',
                name: '엄마',
                epdsScore: 7,
                epdsStatus: '양호',
                statusColor: AppColors.success,
                message: '잘 하고 있어요 💛',
                onSurvey: () {
                  // TODO: E2 EPDS 설문
                },
              ),

              const SizedBox(height: 12),

              // 아빠 상태 카드
              Container(
                width: double.infinity,
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
                        const Text('👨', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          '아빠 상태',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '이번 주: 미완료',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: 설문 요청 보내기
                        },
                        child: const Text('설문 요청 보내기'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 파트너 메시지
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('💌', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '파트너 메시지',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '마음을 전해보세요',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: E7 파트너 메시지
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('보내기'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 아빠 미션
              Container(
                width: double.infinity,
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
                        const Text('🎯', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          '아빠 미션',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '이번 주 미션: 목욕 시키기 🛁',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '완료: 0/3',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: E8 아빠 미션 리스트
                        },
                        child: const Text('미션 보기'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 주간 회고
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // TODO: E10 주간 회고
                  },
                  icon: const Icon(Icons.auto_graph_rounded),
                  label: const Text('이번 주 돌아보기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String emoji;
  final String name;
  final int epdsScore;
  final String epdsStatus;
  final Color statusColor;
  final String message;
  final VoidCallback onSurvey;

  const _StatusCard({
    required this.emoji,
    required this.name,
    required this.epdsScore,
    required this.epdsStatus,
    required this.statusColor,
    required this.message,
    required this.onSurvey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text('$name 상태', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$epdsStatus ($epdsScore점)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSurvey,
                  child: const Text('설문하기'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    // TODO: EPDS 히스토리
                  },
                  child: const Text('히스토리'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
