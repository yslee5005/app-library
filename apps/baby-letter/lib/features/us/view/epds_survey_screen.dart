import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import 'epds_result_screen.dart';

/// E2/E3. EPDS 설문 화면
/// Edinburgh Postnatal Depression Scale — 엄마/아빠 모두 지원
class EpdsSurveyScreen extends StatefulWidget {
  final bool isMom;

  const EpdsSurveyScreen({super.key, required this.isMom});

  @override
  State<EpdsSurveyScreen> createState() => _EpdsSurveyScreenState();
}

class _EpdsSurveyScreenState extends State<EpdsSurveyScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  // 각 문항별 선택한 답변 (null = 미선택)
  final List<int?> _answers = List.filled(10, null);

  // EPDS 10문항
  static const List<String> _questions = [
    '웃을 수 있었고, 일이 재미있었다',
    '즐거운 기대감을 가지고 일을 기대할 수 있었다',
    '일이 잘못될 때 불필요하게 자신을 탓했다',
    '특별한 이유 없이 불안하거나 걱정되었다',
    '특별한 이유 없이 무섭거나 공포를 느꼈다',
    '일이 너무 많다고 느꼈다',
    '너무 불행해서 잠을 잘 수 없었다',
    '슬프거나 비참한 느낌이 들었다',
    '너무 불행해서 울었다',
    '자해에 대한 생각이 들었다',
  ];

  // 각 문항별 선택지 텍스트
  static const List<String> _optionLabels = [
    '전혀 없었다',
    '거의 없었다',
    '가끔 그랬다',
    '자주 그랬다',
  ];

  // 역채점 문항 (1번, 2번 — index 0, 1)
  static const Set<int> _reverseScored = {0, 1};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _getScore(int questionIndex, int optionIndex) {
    if (_reverseScored.contains(questionIndex)) {
      // 역채점: 전혀 없었다=3, 거의 없었다=2, 가끔=1, 자주=0
      return 3 - optionIndex;
    }
    return optionIndex;
  }

  int _calculateTotalScore() {
    int total = 0;
    for (int i = 0; i < _answers.length; i++) {
      if (_answers[i] != null) {
        total += _getScore(i, _answers[i]!);
      }
    }
    return total;
  }

  void _goToNext() {
    if (_currentPage < 9) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 완료 — 결과 화면으로
      final score = _calculateTotalScore();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EpdsResultScreen(score: score, isMom: widget.isMom),
        ),
      );
    }
  }

  void _goToPrevious() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
          '마음 체크',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 아빠 전용 인트로 메시지
            if (!widget.isMom && _currentPage == 0)
              Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.infoLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('💙', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '아빠도 힘들 수 있어요.\n육아는 둘 다 처음이니까요.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // 진행 바
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_currentPage + 1}/10',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        '솔직하게 답해주세요. 정답은 없어요 💛',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (_currentPage + 1) / 10,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.coral,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 문항 PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: 10,
                itemBuilder: (context, index) {
                  return _buildQuestionPage(index);
                },
              ),
            ),

            // 하단 네비게이션 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      // 이전 버튼
                      if (_currentPage > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _goToPrevious,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.coral),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '이전',
                              style: TextStyle(color: AppColors.coral),
                            ),
                          ),
                        )
                      else
                        const Expanded(child: SizedBox()),
                      const SizedBox(width: 12),
                      // 다음/완료 버튼
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _answers[_currentPage] != null
                              ? _goToNext
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
                            disabledBackgroundColor: AppColors.coralLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(_currentPage == 9 ? '완료' : '다음'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '이 설문은 선별 도구이며 진단이 아닙니다',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.textHint),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPage(int index) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 문항 번호 + 질문
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
                Text(
                  'Q${index + 1}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '지난 7일 동안...',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
                ),
                const SizedBox(height: 4),
                Text(
                  _questions[index],
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 4개 선택지
          ...List.generate(4, (optionIndex) {
            final isSelected = _answers[index] == optionIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _answers[index] = optionIndex;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.coral.withValues(alpha: 0.1)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.coral
                          : AppColors.surfaceVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppColors.coral
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.coral
                                : AppColors.textHint,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _optionLabels[optionIndex],
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: isSelected
                                    ? AppColors.coral
                                    : AppColors.textPrimary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
