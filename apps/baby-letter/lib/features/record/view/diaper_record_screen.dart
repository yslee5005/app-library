import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// C6. 기저귀 기록
/// 소변/대변/둘 다 + 대변 색상 팔레트 + 위험 색상 경고 + 양
class DiaperRecordScreen extends StatefulWidget {
  const DiaperRecordScreen({super.key});

  @override
  State<DiaperRecordScreen> createState() => _DiaperRecordScreenState();
}

class _DiaperRecordScreenState extends State<DiaperRecordScreen> {
  // 타입: 0=소변, 1=대변, 2=둘 다
  int _type = 0;
  static const _typeLabels = ['소변', '대변', '둘 다'];

  // 대변 색상
  int? _selectedColorIndex;

  // 색상 팔레트 정의
  static const _stoolColors = [
    _StoolColorInfo(
      color: Color(0xFFDAA520),
      label: '겨자노랑',
      emoji: '🟡',
      isDanger: false,
    ),
    _StoolColorInfo(
      color: Color(0xFFA0522D),
      label: '황갈색',
      emoji: '🟤',
      isDanger: false,
    ),
    _StoolColorInfo(
      color: Color(0xFF228B22),
      label: '녹색',
      emoji: '🟢',
      isDanger: false,
    ),
    _StoolColorInfo(
      color: Color(0xFFCD853F),
      label: '연갈색',
      emoji: '🟠',
      isDanger: false,
    ),
    _StoolColorInfo(
      color: Color(0xFFD3D3D3),
      label: '회백색',
      emoji: '⚪',
      isDanger: true,
      dangerMessage: '담도폐쇄증 의심 — 즉시 소아과 방문이 필요합니다',
    ),
    _StoolColorInfo(
      color: Color(0xFFF5F5F5),
      label: '흰색',
      emoji: '⬜',
      isDanger: true,
      dangerMessage: '담도폐쇄증 의심 — 즉시 소아과 방문이 필요합니다',
    ),
    _StoolColorInfo(
      color: Color(0xFFDC143C),
      label: '혈변',
      emoji: '🔴',
      isDanger: true,
      dangerMessage: '혈변이 관찰되었습니다 — 즉시 소아과 방문이 필요합니다',
    ),
  ];

  // 양: 0=적음, 1=보통, 2=많음
  int? _amount;
  static const _amountLabels = ['적음', '보통', '많음'];

  // 메모
  final _memoController = TextEditingController();

  @override
  void dispose() {
    _memoController.dispose();
    super.dispose();
  }

  void _onColorSelected(int index) {
    setState(() {
      _selectedColorIndex = index;
    });

    final colorInfo = _stoolColors[index];
    if (colorInfo.isDanger) {
      _showDangerDialog(colorInfo);
    }
  }

  void _showDangerDialog(_StoolColorInfo colorInfo) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: AppColors.danger),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '주의가 필요해요',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.dangerLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                colorInfo.dangerMessage ?? '',
                style: const TextStyle(
                  color: AppColors.danger,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('확인'),
            ),
          ),
        ],
      ),
    );
  }

  void _save() {
    // TODO: 저장 로직
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final showStoolSection = _type == 1 || _type == 2;

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
          '기저귀 기록',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타입 선택
            Text(
              '종류',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_typeLabels.length, (index) {
                final isSelected = _type == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _typeLabels.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _type = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.diaperGreen
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.diaperGreen
                                : AppColors.textHint.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _typeLabels[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // 대변 색상 (대변 또는 둘 다 선택 시)
            if (showStoolSection) ...[
              Text(
                '대변 색상',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                '아기의 대변 색상을 선택해주세요',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 정상 색상
                    Text(
                      '정상',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(4, (index) {
                        return _StoolColorCircle(
                          colorInfo: _stoolColors[index],
                          isSelected: _selectedColorIndex == index,
                          onTap: () => _onColorSelected(index),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    // 위험 색상
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          size: 16,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '주의 필요',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.danger,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (i) {
                        final index = i + 4;
                        return _StoolColorCircle(
                          colorInfo: _stoolColors[index],
                          isSelected: _selectedColorIndex == index,
                          onTap: () => _onColorSelected(index),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // 위험 색상 선택 시 경고 텍스트
              if (_selectedColorIndex != null &&
                  _stoolColors[_selectedColorIndex!].isDanger)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.dangerLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.danger),
                    ),
                    child: Row(
                      children: [
                        const Text('⚠️', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            '즉시 소아과 방문을 권장합니다',
                            style: TextStyle(
                              color: AppColors.danger,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],

            // 양
            Text(
              '양',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_amountLabels.length, (index) {
                final isSelected = _amount == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _amountLabels.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _amount = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.diaperGreen.withValues(alpha: 0.2)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.diaperGreen
                                : AppColors.textHint.withValues(alpha: 0.3),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _amountLabels[index],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.diaperGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // 사진 추가 (placeholder)
            OutlinedButton.icon(
              onPressed: () {
                // TODO: 사진 추가 기능
              },
              icon: const Text('📸', style: TextStyle(fontSize: 16)),
              label: const Text('사진 추가 (선택)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(
                  color: AppColors.textHint.withValues(alpha: 0.3),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 32),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.diaperGreen,
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

class _StoolColorInfo {
  final Color color;
  final String label;
  final String emoji;
  final bool isDanger;
  final String? dangerMessage;

  const _StoolColorInfo({
    required this.color,
    required this.label,
    required this.emoji,
    required this.isDanger,
    this.dangerMessage,
  });
}

class _StoolColorCircle extends StatelessWidget {
  final _StoolColorInfo colorInfo;
  final bool isSelected;
  final VoidCallback onTap;

  const _StoolColorCircle({
    required this.colorInfo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorInfo.color,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorInfo.isDanger
                    ? AppColors.danger
                    : isSelected
                        ? AppColors.diaperGreen
                        : AppColors.textHint.withValues(alpha: 0.3),
                width: isSelected ? 3 : colorInfo.isDanger ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: (colorInfo.isDanger
                                ? AppColors.danger
                                : AppColors.diaperGreen)
                            .withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            colorInfo.label,
            style: TextStyle(
              fontSize: 10,
              color: colorInfo.isDanger
                  ? AppColors.danger
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
