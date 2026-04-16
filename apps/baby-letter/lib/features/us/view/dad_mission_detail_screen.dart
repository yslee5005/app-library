import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// E9. 아빠 미션 상세 화면
/// 미션 상세 설명 + 단계별 가이드 + 타이머 + 완료 사진
class DadMissionDetailScreen extends StatefulWidget {
  final String emoji;
  final String title;
  final String description;

  const DadMissionDetailScreen({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
  });

  @override
  State<DadMissionDetailScreen> createState() => _DadMissionDetailScreenState();
}

class _DadMissionDetailScreenState extends State<DadMissionDetailScreen> {
  bool _isTimerRunning = false;
  int _elapsedSeconds = 0;

  // 미션별 단계별 가이드
  Map<String, List<String>> get _stepGuides => {
        '목욕 시키기': [
          '욕조에 37-38°C 물을 준비해요',
          '아기 옷을 벗기고 부드럽게 안아요',
          '머리부터 발끝까지 천천히 씻겨요',
          '아기와 눈을 맞추며 이야기해요',
          '부드러운 수건으로 감싸 닦아줘요',
        ],
        '새벽 수유 1회': [
          '분유/모유를 적정 온도로 준비해요',
          '아기를 조심스럽게 안아올려요',
          '편안한 자세로 앉아 수유해요',
          '수유 후 트림을 시켜줘요',
          '아기를 다시 재워줘요',
        ],
        '엄마 자유시간 2시간': [
          '엄마에게 "오늘 2시간 쉬어" 말해요',
          '기저귀, 분유, 장난감 미리 준비해요',
          '아기와 놀아주며 시간을 보내요',
          '필요한 것은 스스로 해결해봐요',
          '엄마가 돌아오면 "다녀와서 좋았어?" 물어봐요',
        ],
      };

  // 미션별 아기 반응
  Map<String, String> get _babyReactions => {
        '목욕 시키기': '아빠랑 목욕하니까 더 재밌어! 물놀이 최고!',
        '새벽 수유 1회': '아빠 품도 따뜻하고 좋아~ 잘 먹었어!',
        '엄마 자유시간 2시간': '아빠랑 둘이 보내는 시간도 좋아! 아빠 최고!',
      };

  List<String> get _steps =>
      _stepGuides[widget.title] ??
      [
        '미션을 시작해요',
        '차근차근 진행해요',
        '아기와 즐거운 시간을 보내요',
        '미션 완료!',
      ];

  String get _babyReaction =>
      _babyReactions[widget.title] ?? '아빠가 미션을 해주니까 너무 좋아!';

  String get _timerDisplay {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _toggleTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
    });

    if (_isTimerRunning) {
      _startTimer();
    }
  }

  void _startTimer() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_isTimerRunning || !mounted) return false;
      setState(() {
        _elapsedSeconds++;
      });
      return true;
    });
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
        title: Text(
          widget.title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 미션 아이콘
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  AppColors.coral.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.emoji,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 미션 설명
                    Center(
                      child: Text(
                        widget.description,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                  height: 1.5,
                                ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // 단계별 가이드
                    Text(
                      '이렇게 해보세요',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(_steps.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    AppColors.coral.withValues(alpha: 0.1),
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        color: AppColors.coral,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  _steps[index],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        height: 1.4,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    // 타이머 섹션
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
                            '타이머',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _timerDisplay,
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 4,
                                ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            onPressed: _toggleTimer,
                            icon: Icon(
                              _isTimerRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              color: AppColors.coral,
                            ),
                            label: Text(
                              _isTimerRunning ? '일시정지' : '시작',
                              style:
                                  const TextStyle(color: AppColors.coral),
                            ),
                            style: OutlinedButton.styleFrom(
                              side:
                                  const BorderSide(color: AppColors.coral),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 사진 촬영 플레이스홀더
                    InkWell(
                      onTap: () {
                        // TODO: 카메라/갤러리 열기
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.surfaceVariant,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text('📸',
                                style: TextStyle(fontSize: 36)),
                            const SizedBox(height: 8),
                            Text(
                              '완료 사진 찍기',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '소중한 순간을 남겨보세요',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textHint,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 아기 반응 카드
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.amberLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text('👶',
                              style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '아기의 한마디',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.amberDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _babyReaction,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.textPrimary,
                                        fontStyle: FontStyle.italic,
                                        height: 1.4,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 완료 버튼
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: 미션 완료 처리
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('미션 완료! 대단해요 아빠! 🎉'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '완료!',
                    style: TextStyle(
                      fontSize: 18,
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
}
