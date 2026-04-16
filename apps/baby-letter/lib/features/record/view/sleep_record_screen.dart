import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C5. 수면 기록
/// 시작/종료 시간 + 낮잠/밤잠 자동 감지 + 수면 환경 태그 + 난이도
class SleepRecordScreen extends StatefulWidget {
  const SleepRecordScreen({super.key});

  @override
  State<SleepRecordScreen> createState() => _SleepRecordScreenState();
}

class _SleepRecordScreenState extends State<SleepRecordScreen> {
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();

  // 수면 환경 태그
  static const _environmentTags = ['동침', '독립', '카시트', '유모차', '안아서'];
  final Set<int> _selectedEnvironments = {};

  // 난이도: 0=쉬움, 1=보통, 2=어려움
  int? _difficulty;
  static const _difficultyOptions = [
    ('쉬움', '😊'),
    ('보통', '😐'),
    ('어려움', '😫'),
  ];

  /// 6am~8pm -> 낮잠, 그 외 -> 밤잠
  bool get _isNap {
    final hour = _startTime.hour;
    return hour >= 6 && hour < 20;
  }

  String get _sleepTypeLabel => _isNap ? '낮잠' : '밤잠';

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime,
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _calculateDuration() {
    final startMinutes = _startTime.hour * 60 + _startTime.minute;
    var endMinutes = _endTime.hour * 60 + _endTime.minute;

    // 밤잠: 종료가 시작보다 이르면 다음날
    if (endMinutes <= startMinutes) {
      endMinutes += 24 * 60;
    }

    final diff = endMinutes - startMinutes;
    final hours = diff ~/ 60;
    final minutes = diff % 60;

    if (hours > 0 && minutes > 0) {
      return '$hours시간 $minutes분';
    } else if (hours > 0) {
      return '$hours시간';
    } else {
      return '$minutes분';
    }
  }

  void _save() {
    // TODO: 저장 로직
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          '수면 기록',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 수면 유형 자동 감지 표시
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.sleepPurple.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isNap ? '🌤️' : '🌙',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$_sleepTypeLabel으로 감지됨',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.sleepPurple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 시작/종료 시간
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // 시작 시간
                  GestureDetector(
                    onTap: _pickStartTime,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.bedtime_outlined,
                          color: AppColors.sleepPurple,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '시작',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatTime(_startTime),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: AppColors.sleepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                  // 종료 시간
                  GestureDetector(
                    onTap: _pickEndTime,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wb_sunny_outlined,
                          color: AppColors.amber,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '종료',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _formatTime(_endTime),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: AppColors.amber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 수면 시간 표시
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.sleepPurple.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '수면 시간: ${_calculateDuration()}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.sleepPurple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 수면 환경
            Text(
              '수면 환경',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_environmentTags.length, (index) {
                final isSelected = _selectedEnvironments.contains(index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedEnvironments.remove(index);
                      } else {
                        _selectedEnvironments.add(index);
                      }
                    });
                  },
                  child: Chip(
                    label: Text(_environmentTags[index]),
                    backgroundColor: isSelected
                        ? AppColors.sleepPurple.withValues(alpha: 0.2)
                        : AppColors.surface,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.sleepPurple
                          : AppColors.textHint.withValues(alpha: 0.3),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.sleepPurple
                          : AppColors.textSecondary,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // 재우기 난이도
            Text(
              '재우기 난이도',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_difficultyOptions.length, (index) {
                final (label, emoji) = _difficultyOptions[index];
                final isSelected = _difficulty == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _difficultyOptions.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _difficulty = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.sleepPurple.withValues(alpha: 0.15)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.sleepPurple
                                : AppColors.textHint.withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              emoji,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                color: isSelected
                                    ? AppColors.sleepPurple
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sleepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '저장',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
