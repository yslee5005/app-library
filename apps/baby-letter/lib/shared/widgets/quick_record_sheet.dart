import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// I1. 빠른 기록 바텀 시트
void showQuickRecordSheet(
  BuildContext context, {
  VoidCallback? onFeeding,
  VoidCallback? onSleep,
  VoidCallback? onDiaper,
  VoidCallback? onMemo,
  VoidCallback? onMedicine,
  VoidCallback? onTemperature,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => _QuickRecordSheet(
      onFeeding: onFeeding,
      onSleep: onSleep,
      onDiaper: onDiaper,
      onMemo: onMemo,
      onMedicine: onMedicine,
      onTemperature: onTemperature,
    ),
  );
}

class _QuickRecordSheet extends StatelessWidget {
  final VoidCallback? onFeeding;
  final VoidCallback? onSleep;
  final VoidCallback? onDiaper;
  final VoidCallback? onMemo;
  final VoidCallback? onMedicine;
  final VoidCallback? onTemperature;

  const _QuickRecordSheet({
    this.onFeeding,
    this.onSleep,
    this.onDiaper,
    this.onMemo,
    this.onMedicine,
    this.onTemperature,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.4,
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
              '빠른 기록',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),

            // 2x3 grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _QuickButton(
                      emoji: '🍼',
                      label: '수유',
                      onTap: () {
                        Navigator.of(context).pop();
                        onFeeding?.call();
                      },
                    ),
                    _QuickButton(
                      emoji: '😴',
                      label: '수면',
                      onTap: () {
                        Navigator.of(context).pop();
                        onSleep?.call();
                      },
                    ),
                    _QuickButton(
                      emoji: '🧷',
                      label: '기저귀',
                      onTap: () {
                        Navigator.of(context).pop();
                        onDiaper?.call();
                      },
                    ),
                    _QuickButton(
                      emoji: '📝',
                      label: '메모',
                      onTap: () {
                        Navigator.of(context).pop();
                        onMemo?.call();
                      },
                    ),
                    _QuickButton(
                      emoji: '💊',
                      label: '약/비타민',
                      onTap: () {
                        Navigator.of(context).pop();
                        onMedicine?.call();
                      },
                    ),
                    _QuickButton(
                      emoji: '🌡️',
                      label: '체온',
                      onTap: () {
                        Navigator.of(context).pop();
                        onTemperature?.call();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback? onTap;

  const _QuickButton({required this.emoji, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
