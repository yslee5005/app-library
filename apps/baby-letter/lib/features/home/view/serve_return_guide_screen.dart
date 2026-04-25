import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// B6. Serve & Return 가이드
/// Harvard 기반 5단계 + 체크리스트
class ServeReturnGuideScreen extends StatefulWidget {
  const ServeReturnGuideScreen({super.key});

  @override
  State<ServeReturnGuideScreen> createState() => _ServeReturnGuideScreenState();
}

class _ServeReturnGuideScreenState extends State<ServeReturnGuideScreen> {
  final List<bool> _checklist = [false, false, false];

  static const _checklistItems = ['5분간 아기와 대화', '아기 신호 3개 발견', '2초 안에 응답하기'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Serve & Return')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 인트로 섹션
            Container(
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
                  const Text('🧠', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    '아기의 뇌가 자라는 대화법',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아기와 주고받는 작은 상호작용 하나하나가\n뇌의 신경 연결을 만들어요.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harvard Center on the Developing Child',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 5단계 카드
            _StepCard(
              stepNumber: 1,
              title: '아기가 신호를 보내요',
              description: '옹알이, 손 뻗기, 눈 맞춤, 울음 등\n아기의 모든 행동은 "대화의 시작"이에요.',
            ),
            const SizedBox(height: 12),

            _StepCard(
              stepNumber: 2,
              title: '신호를 알아차려요',
              description: '아기의 시선을 따라가 보세요.\n무엇을 보고 있는지, 어디에 관심이 있는지 관찰해요.',
            ),
            const SizedBox(height: 12),

            _StepCard(
              stepNumber: 3,
              title: '이름 붙여줘요',
              description: '"아~ 고양이가 보이니?"\n"배가 고프구나!"\n아기의 경험에 말로 이름을 붙여주세요.',
            ),
            const SizedBox(height: 12),

            _StepCard(
              stepNumber: 4,
              title: '차례를 주고받아요',
              description:
                  '말한 후 2-3초 기다려주세요.\n아기가 반응할 시간이 필요해요.\n기다림도 대화의 일부예요.',
            ),
            const SizedBox(height: 12),

            _StepCard(
              stepNumber: 5,
              title: '끝맺음을 알아차려요',
              description:
                  '아기가 고개를 돌리면 휴식 신호예요.\n억지로 계속하지 않아도 괜찮아요.\n아기의 속도를 존중해주세요.',
            ),

            const SizedBox(height: 24),

            // 체크리스트
            Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '오늘의 실천',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_checklistItems.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _checklist[index],
                            onChanged: (value) {
                              setState(
                                () => _checklist[index] = value ?? false,
                              );
                            },
                            activeColor: AppColors.coral,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _checklistItems[index],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _checklist[index]
                                        ? AppColors.textHint
                                        : AppColors.textPrimary,
                                    decoration: _checklist[index]
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 더 알아보기 링크
            GestureDetector(
              onTap: () {
                // TODO: Still Face 실험 정보 페이지 또는 외부 링크
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('📚', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '더 알아보기',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(color: AppColors.info),
                          ),
                          Text(
                            'Still Face 실험 — 아기에게 무반응이 어떤 영향을 미치는지',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.info,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;

  const _StepCard({
    required this.stepNumber,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 숫자 원
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.coralLight,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.coralDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // 제목 + 설명
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
