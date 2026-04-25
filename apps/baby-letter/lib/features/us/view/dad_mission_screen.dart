import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'dad_mission_detail_screen.dart';

/// E8. 아빠 미션 화면
/// 이번 주 미션 3개 + 완료 체크 + 월간 현황
class DadMissionScreen extends StatefulWidget {
  const DadMissionScreen({super.key});

  @override
  State<DadMissionScreen> createState() => _DadMissionScreenState();
}

class _DadMissionScreenState extends State<DadMissionScreen> {
  // 미션 완료 상태
  final List<bool> _completedMissions = [false, false, false];

  int get _completedCount => _completedMissions.where((c) => c).length;

  // 미션 데이터
  static const List<_MissionData> _missions = [
    _MissionData(
      emoji: '🛁',
      title: '목욕 시키기',
      description: '아기와 눈을 맞추며 목욕시켜 보세요. 물 온도 37-38°C',
      babyComment: '아빠 손이 크고 따뜻해서 좋아!',
    ),
    _MissionData(
      emoji: '🌙',
      title: '새벽 수유 1회',
      description: '엄마가 한 번이라도 더 잘 수 있도록',
      babyComment: '아빠도 나를 먹여줄 수 있어!',
    ),
    _MissionData(
      emoji: '📱',
      title: '엄마 자유시간 2시간',
      description: '2시간 동안 혼자 아기 돌보기',
      babyComment: '엄마도 쉬어야 나를 더 잘 돌봐줄 수 있어',
    ),
  ];

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
          '아빠 미션',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '이번 주 미션 3개',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 미션 카드들
              ...List.generate(_missions.length, (index) {
                final mission = _missions[index];
                final isCompleted = _completedMissions[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _MissionCard(
                    mission: mission,
                    isCompleted: isCompleted,
                    onToggle: () {
                      setState(() {
                        _completedMissions[index] = !_completedMissions[index];
                      });
                    },
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DadMissionDetailScreen(
                            emoji: mission.emoji,
                            title: mission.title,
                            description: mission.description,
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 8),

              // 월간 현황
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('📊', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 8),
                        Text(
                          '이번 달 미션 현황',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 프로그레스 바
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (8 + _completedCount) / 12,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.coral,
                        ),
                        minHeight: 10,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '완료 ${8 + _completedCount}/12 (${((8 + _completedCount) / 12 * 100).round()}%)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textSecondary),
                        ),
                        // 배지
                        if ((8 + _completedCount) >= 10)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.amber.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🏅',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '슈퍼 아빠',
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.amberDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 미션 데이터 모델
class _MissionData {
  final String emoji;
  final String title;
  final String description;
  final String babyComment;

  const _MissionData({
    required this.emoji,
    required this.title,
    required this.description,
    required this.babyComment,
  });
}

/// 미션 카드 위젯
class _MissionCard extends StatelessWidget {
  final _MissionData mission;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _MissionCard({
    required this.mission,
    required this.isCompleted,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isCompleted ? AppColors.successLight : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isCompleted
              ? Border.all(color: AppColors.success.withValues(alpha: 0.3))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 미션 제목 + 아이콘
            Row(
              children: [
                Text(mission.emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mission.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 설명
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                mission.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 아기 코멘트
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('💬', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        mission.babyComment,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 완료 체크
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: InkWell(
                onTap: onToggle,
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: isCompleted
                            ? AppColors.success
                            : Colors.transparent,
                        border: Border.all(
                          color: isCompleted
                              ? AppColors.success
                              : AppColors.textHint,
                          width: 2,
                        ),
                      ),
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCompleted ? '완료!' : '완료하기',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isCompleted
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: isCompleted
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
