import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../data/baby_letters.dart';

/// 아기 편지 카드 위젯
/// 편지봉투 디자인 + 1인칭 메시지 프리뷰
class LetterCard extends StatelessWidget {
  final BabyLetter letter;
  final VoidCallback? onTap;

  const LetterCard({super.key, required this.letter, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.letterCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.amber.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(letter.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '아기의 편지',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.coralDark,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textHint,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              letter.message.length > 80
                  ? '${letter.message.substring(0, 80)}...'
                  : letter.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
