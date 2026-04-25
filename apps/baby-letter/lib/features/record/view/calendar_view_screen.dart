import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C9. 캘린더 뷰
/// 월 네비게이션 + 날짜 그리드 (컬러 닷) + 날짜 탭 시 요약 바텀시트
class CalendarViewScreen extends StatefulWidget {
  const CalendarViewScreen({super.key});

  @override
  State<CalendarViewScreen> createState() => _CalendarViewScreenState();
}

class _CalendarViewScreenState extends State<CalendarViewScreen> {
  late DateTime _currentMonth;
  int? _selectedDay;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(2026, 4); // 2026년 4월
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _selectedDay = null;
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _selectedDay = null;
    });
  }

  /// 해당 월의 첫째 날의 요일 (0=일요일)
  int _firstDayOfWeek() {
    final first = DateTime(_currentMonth.year, _currentMonth.month, 1);
    return first.weekday % 7; // DateTime.weekday: 1=월, 7=일 → % 7 으로 0=일
  }

  /// 해당 월의 총 일수
  int _daysInMonth() {
    final next = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    return next.day;
  }

  String _monthTitle() {
    return '${_currentMonth.year}년 ${_currentMonth.month}월';
  }

  /// 데모 데이터: 특정 날짜에 기록된 활동 유형
  Set<_RecordType> _getRecordsForDay(int day) {
    // 데모용 - 실제로는 DB 조회
    final records = <int, Set<_RecordType>>{
      1: {_RecordType.feeding, _RecordType.sleep},
      2: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
      3: {_RecordType.feeding},
      5: {_RecordType.sleep, _RecordType.diaper},
      6: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
      7: {_RecordType.feeding, _RecordType.sleep},
      8: {_RecordType.diaper},
      9: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
      10: {_RecordType.feeding, _RecordType.sleep},
      11: {_RecordType.feeding, _RecordType.diaper},
      12: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
      13: {_RecordType.sleep},
      14: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
      15: {_RecordType.feeding, _RecordType.sleep},
      16: {_RecordType.feeding, _RecordType.sleep, _RecordType.diaper},
    };
    return records[day] ?? {};
  }

  void _onDayTapped(int day) {
    setState(() {
      _selectedDay = day;
    });

    final records = _getRecordsForDay(day);
    if (records.isEmpty) return;

    _showDaySummary(day, records);
  }

  void _showDaySummary(int day, Set<_RecordType> records) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 핸들 바
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textHint.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 날짜
              Text(
                '${_currentMonth.month}월 $day일',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // 기록 요약
              if (records.contains(_RecordType.feeding))
                _SummaryItem(
                  icon: Icons.local_drink_rounded,
                  color: AppColors.feedingBlue,
                  label: '수유',
                  value: '8회 (모유 5회, 분유 3회)',
                ),
              if (records.contains(_RecordType.sleep)) ...[
                const SizedBox(height: 12),
                _SummaryItem(
                  icon: Icons.nightlight_round,
                  color: AppColors.sleepPurple,
                  label: '수면',
                  value: '총 14시간 30분',
                ),
              ],
              if (records.contains(_RecordType.diaper)) ...[
                const SizedBox(height: 12),
                _SummaryItem(
                  icon: Icons.baby_changing_station,
                  color: AppColors.diaperGreen,
                  label: '기저귀',
                  value: '6회 (소변 4, 대변 2)',
                ),
              ],
              const SizedBox(height: 16),

              // 상세보기 버튼
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // TODO: 일간 패턴 화면으로 이동
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.coral,
                    side: const BorderSide(color: AppColors.coral),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('일간 패턴 보기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstDayOffset = _firstDayOfWeek();
    final totalDays = _daysInMonth();
    final totalCells = firstDayOffset + totalDays;
    final rowCount = (totalCells / 7).ceil();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
        ),
        title: Text('캘린더', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: Column(
        children: [
          // 월 네비게이션
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left),
                  color: AppColors.textSecondary,
                ),
                Text(
                  _monthTitle(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),

          // 요일 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['일', '월', '화', '수', '목', '금', '토'].map((day) {
                final isSunday = day == '일';
                final isSaturday = day == '토';
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSunday
                            ? AppColors.danger
                            : isSaturday
                            ? AppColors.feedingBlue
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // 캘린더 그리드
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: List.generate(rowCount, (row) {
                return Row(
                  children: List.generate(7, (col) {
                    final cellIndex = row * 7 + col;
                    final day = cellIndex - firstDayOffset + 1;

                    if (day < 1 || day > totalDays) {
                      return const Expanded(child: SizedBox(height: 64));
                    }

                    final records = _getRecordsForDay(day);
                    final isSelected = _selectedDay == day;
                    final isToday =
                        day == 16 &&
                        _currentMonth.month == 4 &&
                        _currentMonth.year == 2026;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onDayTapped(day),
                        child: Container(
                          height: 64,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.coral.withValues(alpha: 0.1)
                                : isToday
                                ? AppColors.amberLight
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isToday
                                ? Border.all(color: AppColors.amber, width: 1.5)
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$day',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: col == 0
                                      ? AppColors.danger
                                      : col == 6
                                      ? AppColors.feedingBlue
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // 컬러 닷
                              if (records.isNotEmpty)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (records.contains(_RecordType.feeding))
                                      _Dot(color: AppColors.feedingBlue),
                                    if (records.contains(_RecordType.sleep))
                                      _Dot(color: AppColors.sleepPurple),
                                    if (records.contains(_RecordType.diaper))
                                      _Dot(color: AppColors.diaperGreen),
                                  ],
                                )
                              else
                                const SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          // 범례
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LegendItem(color: AppColors.feedingBlue, label: '수유'),
                  _LegendItem(color: AppColors.sleepPurple, label: '수면'),
                  _LegendItem(color: AppColors.diaperGreen, label: '기저귀'),
                ],
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

enum _RecordType { feeding, sleep, diaper }

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;

  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
