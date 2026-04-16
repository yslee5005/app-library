import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// G1. 수면 유형 퀴즈
class ChronotypeQuizScreen extends StatefulWidget {
  const ChronotypeQuizScreen({super.key});

  @override
  State<ChronotypeQuizScreen> createState() => _ChronotypeQuizScreenState();
}

class _ChronotypeQuizScreenState extends State<ChronotypeQuizScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showResult = false;

  // 각 질문의 선택된 답변 인덱스 (-1 = 미선택)
  final List<int> _answers = List.filled(5, -1);

  static const _questions = [
    _QuizQuestion(
      question: '자연스럽게 잠드는 시간은?',
      options: ['밤 9-10시', '밤 10-11시', '밤 11시-자정', '자정 이후'],
    ),
    _QuizQuestion(
      question: '아침에 가장 컨디션이 좋은 시간은?',
      options: ['6-8시', '8-10시', '10시-정오', '정오 이후'],
    ),
    _QuizQuestion(
      question: '낮에 졸린 시간대는?',
      options: ['오후 1-2시', '오후 2-4시', '오후 4시 이후', '별로 안 졸림'],
    ),
    _QuizQuestion(
      question: '주말에 자연스럽게 일어나는 시간은?',
      options: ['7시 전', '7-9시', '9-11시', '11시 이후'],
    ),
    _QuizQuestion(
      question: '저녁에 집중력이 가장 좋은 시간은?',
      options: ['저녁 7시 전', '7-9시', '9-11시', '11시 이후'],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _answers[_currentPage] = answerIndex;
    });
  }

  void _nextPage() {
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 마지막 질문 후 결과 보여주기
      setState(() => _showResult = true);
    }
  }

  _ChronotypeResult _calculateResult() {
    // 점수 계산: 0=아침형, 3=저녁형
    final totalScore =
        _answers.fold<int>(0, (sum, a) => sum + (a < 0 ? 1 : a));
    final avgScore = totalScore / _questions.length;

    if (avgScore <= 1.0) {
      return _ChronotypeResult(
        type: '아침형',
        icon: '🌅',
        description: '이른 아침에 활력이 넘치고, 밤에는 일찍 잠드는 타입이에요.\n'
            '아기의 이른 기상 패턴과 잘 맞을 수 있어요.',
      );
    } else if (avgScore <= 2.0) {
      return _ChronotypeResult(
        type: '중간형',
        icon: '☀️',
        description: '균형 잡힌 수면 패턴을 가지고 있어요.\n'
            '아기 리듬에 유연하게 적응할 수 있는 타입이에요.',
      );
    } else {
      return _ChronotypeResult(
        type: '저녁형',
        icon: '🌙',
        description: '밤에 더 활동적이고, 아침에는 천천히 깨어나는 타입이에요.\n'
            '야간 수유 시간에 상대적으로 적응이 편할 수 있어요.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen(context);
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              '✕ 나중에 할게요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Text('🌙', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    '나의 수면 유형',
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '엄마의 수면 패턴이 아기 수면에도 영향을 줘요',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ProgressBar(
                current: _currentPage + 1,
                total: _questions.length,
              ),
            ),

            const SizedBox(height: 24),

            // Questions PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final q = _questions[index];
                  return _QuestionPage(
                    question: q.question,
                    options: q.options,
                    selectedIndex: _answers[index],
                    onSelect: _selectAnswer,
                  );
                },
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _answers[_currentPage] >= 0 ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppColors.textHint.withValues(alpha: 0.3),
                    disabledForegroundColor: AppColors.textHint,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _questions.length - 1
                        ? '다음 →'
                        : '결과 보기',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  Widget _buildResultScreen(BuildContext context) {
    final result = _calculateResult();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Text(result.icon, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 24),

              Text(
                result.type,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 20),

              // Description card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  result.description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                ),
              ),

              const SizedBox(height: 16),

              // Helpful note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '이 정보가 아기 수면 예측에 도움이 돼요',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),

              const Spacer(flex: 3),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 진행 바
class _ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(total, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: i < total - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < current ? AppColors.coral : AppColors.coralLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '$current/$total',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textHint,
              ),
        ),
      ],
    );
  }
}

/// 질문 페이지
class _QuestionPage extends StatelessWidget {
  final String question;
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _QuestionPage({
    required this.question,
    required this.options,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 20),
          ...List.generate(options.length, (i) {
            final isSelected = selectedIndex == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => onSelect(i),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.coralLight : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.coral
                          : AppColors.textHint.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    options[i],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isSelected
                              ? AppColors.coralDark
                              : AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
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

class _QuizQuestion {
  final String question;
  final List<String> options;

  const _QuizQuestion({required this.question, required this.options});
}

class _ChronotypeResult {
  final String type;
  final String icon;
  final String description;

  const _ChronotypeResult({
    required this.type,
    required this.icon,
    required this.description,
  });
}
