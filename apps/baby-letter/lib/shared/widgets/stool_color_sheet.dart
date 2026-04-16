import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// I2. 대변 색상 선택 바텀 시트
/// 선택된 색상의 인덱스를 반환 (0~6), null이면 취소
Future<int?> showStoolColorSheet(BuildContext context) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const _StoolColorSheet(),
  );
}

class _StoolColorSheet extends StatefulWidget {
  const _StoolColorSheet();

  @override
  State<_StoolColorSheet> createState() => _StoolColorSheetState();
}

class _StoolColorSheetState extends State<_StoolColorSheet> {
  int? _selectedIndex;
  bool _showDangerWarning = false;

  static const _colors = [
    _StoolColor(
      name: '겨자노랑',
      color: Color(0xFFD4A017),
      isDanger: false,
    ),
    _StoolColor(
      name: '황갈색',
      color: Color(0xFF8B6914),
      isDanger: false,
    ),
    _StoolColor(
      name: '녹색',
      color: Color(0xFF4CAF50),
      isDanger: false,
    ),
    _StoolColor(
      name: '연갈색',
      color: Color(0xFFA0522D),
      isDanger: false,
    ),
    _StoolColor(
      name: '회백색',
      color: Color(0xFFE0E0E0),
      isDanger: true,
    ),
    _StoolColor(
      name: '흰색',
      color: Colors.white,
      isDanger: true,
    ),
    _StoolColor(
      name: '빨간색',
      color: Colors.red,
      isDanger: true,
    ),
  ];

  void _selectColor(int index) {
    setState(() {
      _selectedIndex = index;
      _showDangerWarning = _colors[index].isDanger;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // Title
            Text(
              '대변 색상',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),

            const SizedBox(height: 24),

            // Color circles in wrap
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Wrap(
                spacing: 16,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: List.generate(_colors.length, (i) {
                  final stoolColor = _colors[i];
                  final isSelected = _selectedIndex == i;

                  return GestureDetector(
                    onTap: () => _selectColor(i),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: stoolColor.color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: stoolColor.isDanger
                                  ? AppColors.danger
                                  : isSelected
                                      ? AppColors.coral
                                      : AppColors.textHint
                                          .withValues(alpha: 0.3),
                              width: stoolColor.isDanger ? 3 : (isSelected ? 3 : 1),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          AppColors.coral.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: stoolColor.color == Colors.white
                                      ? AppColors.textPrimary
                                      : Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          stoolColor.name,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // Danger warning
            if (_showDangerWarning)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dangerLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.danger.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('⚠️', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '즉시 소아과 방문이 필요합니다',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.danger,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Confirm button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedIndex != null
                      ? () => Navigator.of(context).pop(_selectedIndex)
                      : null,
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
                  child: const Text(
                    '선택',
                    style: TextStyle(
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
}

class _StoolColor {
  final String name;
  final Color color;
  final bool isDanger;

  const _StoolColor({
    required this.name,
    required this.color,
    required this.isDanger,
  });
}
