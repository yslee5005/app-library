import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C1. 기록탭 메인 — 임신 중 버전
/// 태동 카운터 CTA + 오늘의 일지 + 주간 태동 패턴
class RecordPregnantView extends StatefulWidget {
  const RecordPregnantView({super.key});

  @override
  State<RecordPregnantView> createState() => _RecordPregnantViewState();
}

class _RecordPregnantViewState extends State<RecordPregnantView> {
  // 기분 이모지 목록
  static const _moods = ['😊', '😐', '😢', '😡', '😴'];
  int? _selectedMoodIndex;

  final _weightController = TextEditingController();
  final _bpSystolicController = TextEditingController();
  final _bpDiastolicController = TextEditingController();
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _bpSystolicController.dispose();
    _bpDiastolicController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 헤더
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      '기록',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.coralLight,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '📅 25주 3일',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.coralDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 태동 카운터 CTA 카드
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.coral.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text('👶', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text(
                        '태동 카운터',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '아기의 움직임을 기록해보세요',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const _KickCounterPlaceholder(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.coral,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            '태동 세기 시작',
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
            ),

            // 오늘의 일지
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '오늘의 일지',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),

                      // 체중
                      Row(
                        children: [
                          const Text('체중', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _weightController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: InputDecoration(
                                hintText: '__',
                                suffixText: 'kg',
                                hintStyle: const TextStyle(
                                  color: AppColors.textHint,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: AppColors.textHint,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textHint.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 혈압
                      Row(
                        children: [
                          const Text('혈압', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: _bpSystolicController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '___',
                                hintStyle: const TextStyle(
                                  color: AppColors.textHint,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textHint.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              '/',
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: TextField(
                              controller: _bpDiastolicController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: '___',
                                hintStyle: const TextStyle(
                                  color: AppColors.textHint,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: AppColors.textHint.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 기분 이모지 셀렉터
                      Text('기분', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(_moods.length, (index) {
                          final isSelected = _selectedMoodIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedMoodIndex = index;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.amberLight
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: isSelected
                                    ? Border.all(color: AppColors.amber)
                                    : null,
                              ),
                              child: Text(
                                _moods[index],
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),

                      // 메모
                      TextField(
                        controller: _memoController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: '오늘의 메모를 적어보세요...',
                          hintStyle: const TextStyle(color: AppColors.textHint),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.textHint.withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 이번 주 태동 패턴 미니 차트
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '이번 주 태동 패턴',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _WeekdayBar(label: '월', value: 0.6),
                            _WeekdayBar(label: '화', value: 0.8),
                            _WeekdayBar(label: '수', value: 0.5),
                            _WeekdayBar(label: '목', value: 0.7),
                            _WeekdayBar(label: '금', value: 0.9),
                            _WeekdayBar(label: '토', value: 0.4),
                            _WeekdayBar(label: '일', value: 0.0, isToday: true),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 지난 기록 링크
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: TextButton(
                  onPressed: () {
                    // TODO: 지난 기록 화면으로 이동
                  },
                  child: const Text(
                    '📋 지난 기록 →',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
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

/// 주간 막대 그래프 아이템
class _WeekdayBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 ~ 1.0
  final bool isToday;

  const _WeekdayBar({
    required this.label,
    required this.value,
    this.isToday = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: 80 * value,
          decoration: BoxDecoration(
            color: isToday
                ? AppColors.coral.withValues(alpha: 0.3)
                : AppColors.coral,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isToday ? AppColors.coral : AppColors.textSecondary,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

/// 태동 카운터 placeholder (실제 KickCounterScreen으로 교체 예정)
class _KickCounterPlaceholder extends StatelessWidget {
  const _KickCounterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('태동 카운터'),
        backgroundColor: AppColors.cream,
      ),
      body: const Center(child: Text('태동 카운터 화면 (C3)')),
    );
  }
}
