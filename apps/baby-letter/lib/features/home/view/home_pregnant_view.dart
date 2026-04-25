import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../shared/data/baby_letters.dart';
import '../../../shared/widgets/letter_card.dart';
import 'letter_detail_screen.dart';

/// B1. 홈탭 — 임신 중 버전
/// 태아 영상 카드 + 아기편지 + 오늘의 발달 팁 + Serve & Return + 4th Trimester
class HomePregnantView extends StatelessWidget {
  final int currentWeek;

  const HomePregnantView({super.key, required this.currentWeek});

  @override
  Widget build(BuildContext context) {
    final letter = findLetterForWeek(currentWeek);
    final day = DateTime.now().weekday; // 간단한 일수 대용

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
                      decoration: BoxDecoration(
                        color: AppColors.coralLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🤰', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$currentWeek주 $day일',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '콩순이가 편지를 보냈어요',
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

            // 태아 영상 카드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    // TODO: B4 풀스크린 영상으로 이동
                  },
                  child: Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFFE0B2),
                          Color(0xFFFFCC80),
                          Color(0xFFFFB74D),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 영상 플레이스홀더
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('👶', style: TextStyle(fontSize: 64)),
                              const SizedBox(height: 12),
                              Text(
                                'Week $currentWeek',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '약 30cm · 600g',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        // 재생 버튼 오버레이
                        Positioned(
                          right: 16,
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
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

            // 오늘의 발달 팁
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _TipCard(
                  icon: Icons.lightbulb_rounded,
                  iconColor: AppColors.info,
                  title: '오늘의 발달 팁',
                  subtitle: '$currentWeek주: 청각 발달 완성기',
                  body: '아기에게 노래를 불러주세요.\n엄마의 목소리를 가장 좋아해요 🎵',
                  source: 'DeCasper & Fifer, Science, 1980',
                ),
              ),
            ),

            // Serve & Return 실천
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _ActionCard(
                  icon: '🧠',
                  title: 'Serve & Return',
                  subtitle: '오늘의 실천: 태담하기',
                  body: '5분간 아기에게 말해보세요.\n"오늘 엄마가 뭘 했는지 알려줄게"',
                  actionText: '하러가기',
                  onAction: () {
                    // TODO: B6 Serve & Return 가이드
                  },
                ),
              ),
            ),

            // 4th Trimester 준비 (30주+ 표시)
            if (currentWeek >= 30)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _ActionCard(
                    icon: '⚡',
                    title: '4th Trimester 준비',
                    subtitle: '출산 후 첫 3개월 미리 알아두세요',
                    body: '자궁 밖으로 나온 아기가\n적응하는 데 필요한 것들',
                    actionText: '알아보기',
                    onAction: () {
                      // TODO: B7 4th Trimester 가이드
                    },
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

/// 팁 카드 위젯
class _TipCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String body;
  final String? source;

  const _TipCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.body,
    this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (source != null) ...[
            const SizedBox(height: 8),
            Text(
              source!,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
            ),
          ],
        ],
      ),
    );
  }
}

/// 액션 카드 위젯
class _ActionCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String body;
  final String actionText;
  final VoidCallback? onAction;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: onAction, child: Text(actionText)),
          ),
        ],
      ),
    );
  }
}
