import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// B9. 오늘의 발달 팁
/// 주차별 발달 정보 + 실천 체크리스트 + 출처
class DevelopmentTipScreen extends StatefulWidget {
  final int week;

  const DevelopmentTipScreen({super.key, required this.week});

  @override
  State<DevelopmentTipScreen> createState() => _DevelopmentTipScreenState();
}

class _DevelopmentTipScreenState extends State<DevelopmentTipScreen> {
  late final _TipData _tipData;
  late final List<bool> _practiceChecks;

  @override
  void initState() {
    super.initState();
    _tipData = _getTipForWeek(widget.week);
    _practiceChecks = List.filled(_tipData.practices.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('오늘의 발달 팁')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 주차 표시
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.coralLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.week}주',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.coralDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 일러스트레이션 플레이스홀더
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_tipData.emoji, style: const TextStyle(fontSize: 64)),
                    const SizedBox(height: 8),
                    Text(
                      _tipData.illustrationLabel,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 팁 제목
            Text(
              _tipData.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 12),

            // 팁 본문
            Text(
              _tipData.body,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary,
                height: 1.7,
              ),
            ),

            const SizedBox(height: 24),

            // 아기에게 해보기 섹션
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
                  Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '아기에게 해보기',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 체크 가능한 실천 항목
                  ...List.generate(_tipData.practices.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _practiceChecks[index],
                            onChanged: (value) {
                              setState(
                                () => _practiceChecks[index] = value ?? false,
                              );
                            },
                            activeColor: AppColors.coral,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _tipData.practices[index],
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: _practiceChecks[index]
                                        ? AppColors.textHint
                                        : AppColors.textPrimary,
                                    decoration: _practiceChecks[index]
                                        ? TextDecoration.lineThrough
                                        : null,
                                    height: 1.4,
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

            // 출처
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.textHint.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 16,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _tipData.source,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// 주차별 팁 데이터
class _TipData {
  final String emoji;
  final String illustrationLabel;
  final String title;
  final String body;
  final List<String> practices;
  final String source;

  const _TipData({
    required this.emoji,
    required this.illustrationLabel,
    required this.title,
    required this.body,
    required this.practices,
    required this.source,
  });
}

_TipData _getTipForWeek(int week) {
  // 주차에 따라 적절한 팁 반환
  if (week <= 16) {
    return const _TipData(
      emoji: '🎵',
      illustrationLabel: '태담 & 음악',
      title: '엄마 목소리를 들려주세요',
      body:
          '아기의 청각이 발달하기 시작했어요.\n'
          '아직 완전하지 않지만, 엄마의 목소리는\n'
          '진동으로 전달돼요.\n\n'
          '하루 5분, 아기에게 말해보세요.\n'
          '"오늘 엄마가 뭘 했는지 알려줄게"\n'
          '이런 간단한 말이면 충분해요.',
      practices: ['하루 5분 아기에게 말하기', '좋아하는 노래 한 곡 불러주기', '배에 손을 대고 인사하기'],
      source: 'DeCasper & Fifer, Science, 1980',
    );
  } else if (week <= 24) {
    return const _TipData(
      emoji: '👂',
      illustrationLabel: '청각 발달',
      title: '아기가 소리를 기억해요',
      body:
          '이 시기 아기의 달팽이관이 완성되면서\n'
          '외부 소리를 인지하기 시작해요.\n\n'
          '엄마의 목소리, 자주 듣는 음악을\n'
          '태어난 후에도 기억한다는 연구가 있어요.\n\n'
          '매일 같은 노래를 들려주면\n'
          '출생 후 안정감을 줄 수 있어요.',
      practices: ['매일 같은 노래 1곡 들려주기', '아빠도 아기에게 말하기', '시끄러운 소음 피하기'],
      source: 'DeCasper & Spence, Infant Behavior & Development, 1986',
    );
  } else if (week <= 32) {
    return const _TipData(
      emoji: '🧠',
      illustrationLabel: '뇌 발달',
      title: '아기의 뇌가 급성장해요',
      body:
          '이 시기 아기의 뇌는 매초\n'
          '수천 개의 새로운 신경 연결을 만들어요.\n\n'
          '엄마의 감정 상태가 아기에게 전달되므로\n'
          '스트레스를 줄이고 편안한 시간을 가지세요.\n\n'
          '명상이나 산책이 도움이 돼요.',
      practices: ['10분 명상 또는 심호흡', '가벼운 산책하기', '좋아하는 음악 듣기'],
      source: 'Tau & Peterson, Progress in Neurobiology, 2010',
    );
  } else {
    return const _TipData(
      emoji: '🤱',
      illustrationLabel: '피부 접촉',
      title: '만날 준비를 해요',
      body:
          '출산이 가까워졌어요!\n'
          '아기를 만나면 가장 먼저 해야 할 것은\n'
          '피부 접촉(skin-to-skin)이에요.\n\n'
          '아기의 체온을 조절하고,\n'
          '심박수를 안정시키고,\n'
          '엄마와의 유대감을 형성해요.\n\n'
          '1시간 이상의 피부 접촉이 권장돼요.',
      practices: ['출산 가방 준비하기', '피부 접촉 계획 세우기', '파트너와 역할 분담 상의하기'],
      source: 'WHO Recommendations on Newborn Health, 2018',
    );
  }
}
