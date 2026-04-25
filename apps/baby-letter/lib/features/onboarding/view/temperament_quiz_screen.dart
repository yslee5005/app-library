import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// G2. 아기 기질 퀴즈
class TemperamentQuizScreen extends StatefulWidget {
  const TemperamentQuizScreen({super.key});

  @override
  State<TemperamentQuizScreen> createState() => _TemperamentQuizScreenState();
}

class _TemperamentQuizScreenState extends State<TemperamentQuizScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showResult = false;

  // 각 질문의 선택된 답변 인덱스 (-1 = 미선택)
  final List<int> _answers = List.filled(8, -1);

  static const _questions = [
    _QuizQuestion(
      question: '아기의 활동 수준은?',
      options: ['매우 활발', '활발', '보통', '조용'],
    ),
    _QuizQuestion(
      question: '새로운 사람을 만나면?',
      options: ['호기심', '관찰 후 적응', '경계', '울음'],
    ),
    _QuizQuestion(
      question: '일과가 규칙적인가요?',
      options: ['매우 규칙적', '대체로 규칙적', '불규칙', '매우 불규칙'],
    ),
    _QuizQuestion(
      question: '새로운 음식 반응은?',
      options: ['호기심 있게 맛봄', '관찰', '강하게 거부', '무반응'],
    ),
    _QuizQuestion(
      question: '울음 강도는?',
      options: ['조용히 칭얼', '보통', '크고 강하게', '매우 다양'],
    ),
    _QuizQuestion(question: '기분 전환이?', options: ['쉬움', '보통', '어려움', '매우 어려움']),
    _QuizQuestion(
      question: '수면 패턴은?',
      options: ['잘 잠', '보통', '자주 깸', '잠들기 어려움'],
    ),
    _QuizQuestion(
      question: '자극(소리,빛)에 반응은?',
      options: ['민감', '보통', '둔감', '매우 다양'],
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
      setState(() => _showResult = true);
    }
  }

  _TemperamentResult _calculateResult() {
    // 점수 기반 기질 판단
    // 규칙성(Q3), 적응성(Q2,Q4), 반응강도(Q5,Q8), 기분(Q6)
    final regularity = _answers[2] < 0 ? 1 : _answers[2]; // 0=규칙적, 3=불규칙
    final adaptability =
        ((_answers[1] < 0 ? 1 : _answers[1]) +
            (_answers[3] < 0 ? 1 : _answers[3])) /
        2; // 0=쉬움, 3=어려움
    final intensity =
        ((_answers[4] < 0 ? 1 : _answers[4]) +
            (_answers[7] < 0 ? 1 : _answers[7])) /
        2; // 0=낮음, 3=높음
    final mood = _answers[5] < 0 ? 1 : _answers[5]; // 0=쉬움, 3=어려움
    final activity = _answers[0] < 0 ? 1 : _answers[0]; // 0=매우활발, 3=조용

    // 순한형: 규칙적 + 적응 쉬움 + 반응 낮음
    if (regularity <= 1 && adaptability <= 1.0 && mood <= 1) {
      return _TemperamentResult(
        type: '순한형',
        percentage: '40%',
        icon: '😊',
        description: '예측 가능하고 적응 잘 하는 아기',
      );
    }

    // 활발한형: 활동량 높음 + 반응 강함
    if (activity <= 1 && intensity >= 2.0) {
      return _TemperamentResult(
        type: '활발한형',
        percentage: '10%',
        icon: '⚡',
        description: '에너지 넘치고 반응이 강한 아기',
      );
    }

    // 신중한형: 적응 느림 + 경계
    if (adaptability >= 2.0) {
      return _TemperamentResult(
        type: '신중한형',
        percentage: '15%',
        icon: '🔍',
        description: '새로운 것에 천천히 적응하는 아기',
      );
    }

    // 혼합형: 나머지
    return _TemperamentResult(
      type: '혼합형',
      percentage: '35%',
      icon: '🌈',
      description: '상황에 따라 다양한 반응을 보이는 아기',
    );
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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
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
                  const Text('🧒', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 12),
                  Text(
                    '아기의 기질 알아보기',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '아기의 성격을 이해하면 육아가 편해져요',
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
                    disabledBackgroundColor: AppColors.textHint.withValues(
                      alpha: 0.3,
                    ),
                    disabledForegroundColor: AppColors.textHint,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _questions.length - 1 ? '다음 →' : '결과 보기',
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

              // Result icon
              Text(result.icon, style: const TextStyle(fontSize: 64)),
              const SizedBox(height: 24),

              // Type name
              Text(
                result.type,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Percentage badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '아기의 약 ${result.percentage}가 이 유형이에요',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Description card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      result.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textHint),
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
                    color: isSelected
                        ? AppColors.coralLight
                        : AppColors.surface,
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
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
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

class _TemperamentResult {
  final String type;
  final String percentage;
  final String icon;
  final String description;

  const _TemperamentResult({
    required this.type,
    required this.percentage,
    required this.icon,
    required this.description,
  });
}
