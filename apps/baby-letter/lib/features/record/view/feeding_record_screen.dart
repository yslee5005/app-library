import 'dart:async';
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C4. 수유 기록
/// 모유/분유/혼합 세그먼트 + 타이머 + ml 입력
class FeedingRecordScreen extends StatefulWidget {
  const FeedingRecordScreen({super.key});

  @override
  State<FeedingRecordScreen> createState() => _FeedingRecordScreenState();
}

enum _FeedingType { breast, formula, mixed }

class _FeedingRecordScreenState extends State<FeedingRecordScreen> {
  _FeedingType _feedingType = _FeedingType.breast;

  // 모유 관련
  bool _leftActive = false;
  bool _rightActive = false;
  final Stopwatch _leftStopwatch = Stopwatch();
  final Stopwatch _rightStopwatch = Stopwatch();
  Timer? _leftTimer;
  Timer? _rightTimer;

  // 분유 관련
  double _formulaMl = 60;

  // 환경 태그
  final List<String> _tags = ['졸린 상태', '잘 먹음', '거부'];
  final Set<int> _selectedTags = {};

  // 메모
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _leftTimer?.cancel();
    _rightTimer?.cancel();
    _memoController.dispose();
    super.dispose();
  }

  void _toggleLeft() {
    setState(() {
      if (_leftActive) {
        _leftStopwatch.stop();
        _leftTimer?.cancel();
        _leftActive = false;
      } else {
        _leftStopwatch.start();
        _leftTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) setState(() {});
        });
        _leftActive = true;
      }
    });
  }

  void _toggleRight() {
    setState(() {
      if (_rightActive) {
        _rightStopwatch.stop();
        _rightTimer?.cancel();
        _rightActive = false;
      } else {
        _rightStopwatch.start();
        _rightTimer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (mounted) setState(() {});
        });
        _rightActive = true;
      }
    });
  }

  String _formatStopwatch(Stopwatch sw) {
    final minutes = sw.elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (sw.elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
          '수유 기록',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 세그먼트 컨트롤
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _SegmentButton(
                    label: '모유',
                    isSelected: _feedingType == _FeedingType.breast,
                    onTap: () =>
                        setState(() => _feedingType = _FeedingType.breast),
                  ),
                  _SegmentButton(
                    label: '분유',
                    isSelected: _feedingType == _FeedingType.formula,
                    onTap: () =>
                        setState(() => _feedingType = _FeedingType.formula),
                  ),
                  _SegmentButton(
                    label: '혼합',
                    isSelected: _feedingType == _FeedingType.mixed,
                    onTap: () =>
                        setState(() => _feedingType = _FeedingType.mixed),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 모유 섹션
            if (_feedingType == _FeedingType.breast ||
                _feedingType == _FeedingType.mixed) ...[
              _buildBreastSection(),
              const SizedBox(height: 24),
            ],

            // 분유 섹션
            if (_feedingType == _FeedingType.formula ||
                _feedingType == _FeedingType.mixed) ...[
              _buildFormulaSection(),
              const SizedBox(height: 24),
            ],

            // 메모
            Text(
              '메모',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '메모를 입력하세요...',
                hintStyle: const TextStyle(color: AppColors.textHint),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 환경 태그
            Text(
              '태그',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_tags.length, (index) {
                final isSelected = _selectedTags.contains(index);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedTags.remove(index);
                      } else {
                        _selectedTags.add(index);
                      }
                    });
                  },
                  child: Chip(
                    label: Text(_tags[index]),
                    backgroundColor: isSelected
                        ? AppColors.feedingBlue.withValues(alpha: 0.2)
                        : AppColors.surface,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.feedingBlue
                          : AppColors.textHint.withValues(alpha: 0.3),
                    ),
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.feedingBlue
                          : AppColors.textSecondary,
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
                  backgroundColor: AppColors.feedingBlue,
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

  Widget _buildBreastSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '모유 수유',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // 왼쪽 가슴
              Expanded(
                child: _BreastButton(
                  label: '왼쪽',
                  isActive: _leftActive,
                  time: _formatStopwatch(_leftStopwatch),
                  onTap: _toggleLeft,
                ),
              ),
              const SizedBox(width: 12),
              // 오른쪽 가슴
              Expanded(
                child: _BreastButton(
                  label: '오른쪽',
                  isActive: _rightActive,
                  time: _formatStopwatch(_rightStopwatch),
                  onTap: _toggleRight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 동시 수유 옵션
          Row(
            children: [
              const Text(
                '동시 수유',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (!_leftActive && !_rightActive) {
                    _toggleLeft();
                    _toggleRight();
                  } else if (_leftActive && _rightActive) {
                    _toggleLeft();
                    _toggleRight();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (_leftActive && _rightActive)
                        ? AppColors.feedingBlue.withValues(alpha: 0.2)
                        : AppColors.cream,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: (_leftActive && _rightActive)
                          ? AppColors.feedingBlue
                          : AppColors.textHint.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    (_leftActive && _rightActive) ? '중지' : '시작',
                    style: TextStyle(
                      fontSize: 12,
                      color: (_leftActive && _rightActive)
                          ? AppColors.feedingBlue
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormulaSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '분유',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '${_formulaMl.round()} ml',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.feedingBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Slider(
            value: _formulaMl,
            min: 0,
            max: 300,
            divisions: 30,
            activeColor: AppColors.feedingBlue,
            inactiveColor: AppColors.feedingBlue.withValues(alpha: 0.2),
            label: '${_formulaMl.round()} ml',
            onChanged: (value) {
              setState(() {
                _formulaMl = value;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0 ml',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              Text(
                '300 ml',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 빠른 선택 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [30, 60, 90, 120, 150, 180].map((ml) {
              final isSelected = _formulaMl.round() == ml;
              return GestureDetector(
                onTap: () => setState(() => _formulaMl = ml.toDouble()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.feedingBlue
                        : AppColors.cream,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$ml',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.feedingBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _BreastButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final String time;
  final VoidCallback onTap;

  const _BreastButton({
    required this.label,
    required this.isActive,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.feedingBlue.withValues(alpha: 0.15)
              : AppColors.cream,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive
                ? AppColors.feedingBlue
                : AppColors.textHint.withValues(alpha: 0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isActive
                    ? AppColors.feedingBlue
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? AppColors.feedingBlue
                    : AppColors.textHint,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive ? '⏸ 정지' : '▶ 시작',
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? AppColors.feedingBlue
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
