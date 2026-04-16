import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// B7. 4th Trimester 가이드
/// 자궁 vs 세상 비교 + 4단계 탭 + 아기 시점 메시지
class FourthTrimesterGuideScreen extends StatelessWidget {
  const FourthTrimesterGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          title: const Text('4th Trimester'),
          bottom: TabBar(
            isScrollable: false,
            labelColor: AppColors.coralDark,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.coral,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: '0-2주'),
              Tab(text: '2-6주'),
              Tab(text: '6-12주'),
              Tab(text: '3-6개월'),
            ],
          ),
        ),
        body: Column(
          children: [
            // 자궁 vs 세상 비교 (고정)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Container(
                width: double.infinity,
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
                  children: [
                    Text(
                      '출산 후 첫 3개월',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '아기에게는 "네 번째 삼분기"예요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    // 비교 테이블
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '자궁 안',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppColors.coralDark,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              _ComparisonItem(text: '어두움 🌙'),
                              _ComparisonItem(text: '23°C 일정 🌡️'),
                              _ComparisonItem(text: '심장소리 💓'),
                              _ComparisonItem(text: '감싸짐 🤱'),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 120,
                          color: AppColors.textHint.withValues(alpha: 0.2),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                '세상 밖',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: AppColors.info,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              _ComparisonItem(text: '밝음 ☀️'),
                              _ComparisonItem(text: '온도 변동 🌡️'),
                              _ComparisonItem(text: '소음 🔊'),
                              _ComparisonItem(text: '공간 🌌'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 탭 콘텐츠
            Expanded(
              child: TabBarView(
                children: [
                  _TabContent(
                    title: '0-2주: 적응기',
                    tips: const [
                      '피부 접촉(Skin-to-skin)을 자주 해주세요',
                      '자궁처럼 어둡고 조용한 환경을 만들어요',
                      '속싸개로 감싸주면 안정감을 느껴요',
                      '아기가 울면 2초 안에 반응해주세요',
                      '신생아는 하루 16-17시간 자는 게 정상이에요',
                      '수유는 아기가 원할 때 (demand feeding)',
                    ],
                  ),
                  _TabContent(
                    title: '2-6주: 각성기',
                    tips: const [
                      '깨어있는 시간이 조금씩 늘어나요',
                      '아기의 시선을 따라 대화해보세요',
                      '백색소음은 자궁 환경을 떠올리게 해요',
                      '영아 산통이 시작될 수 있어요 (저녁 6-10시)',
                      '목욕은 매일 안 해도 괜찮아요 (2-3일에 한 번)',
                      '부모의 수면 교대를 계획하세요',
                    ],
                  ),
                  _TabContent(
                    title: '6-12주: 소통기',
                    tips: const [
                      '사회적 미소가 시작돼요 — 진짜 웃음이에요!',
                      '옹알이에 대답해주면 언어 발달이 빨라져요',
                      '수면 패턴이 조금씩 잡히기 시작해요',
                      '엎드려 놀기(tummy time) 매일 조금씩',
                      '아기의 리듬에 맞춰 일과를 만들어보세요',
                      '이 시기 산통은 점점 줄어들어요',
                    ],
                  ),
                  _TabContent(
                    title: '3-6개월: 탐색기',
                    tips: const [
                      '손으로 물건을 잡으려고 해요',
                      '까꿍 놀이를 시작해보세요',
                      '뒤집기를 시도해요 — 안전한 바닥에서!',
                      '밤잠이 길어지기 시작해요',
                      '이유식 준비 시기 (만 6개월부터)',
                      '부모의 감정도 중요해요 — 쉬어가세요',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonItem extends StatelessWidget {
  final String text;

  const _ComparisonItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final String title;
  final List<String> tips;

  const _TabContent({required this.title, required this.tips});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 16),

          // 팁 리스트
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: const BoxDecoration(
                      color: AppColors.coral,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // 아기 시점 메시지
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.letterCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.amber.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                const Text('💌', style: TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text(
                  '아기의 마음',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.coralDark,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '나는 아직 자궁이 그리워요...\n'
                  '엄마 심장소리, 따뜻한 온도, 감싸는 느낌.\n'
                  '조금만 더 그렇게 해주면\n'
                  '세상에 익숙해질 수 있을 거야.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
