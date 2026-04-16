import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../shared/data/baby_letters.dart';

/// B3. 아기 편지 상세
/// 1인칭 메시지 풀스크린 + 과학적 근거 접기/펼치기
class LetterDetailScreen extends StatefulWidget {
  final BabyLetter letter;

  const LetterDetailScreen({super.key, required this.letter});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  bool _showScience = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('아기의 편지'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 날짜/주차
            Text(
              widget.letter.weekKey.startsWith('week_')
                  ? '임신 ${widget.letter.weekKey.substring(5)}주'
                  : 'D+${widget.letter.weekKey.substring(2)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // 편지 카드
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColors.letterCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.amber.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 이모지 + 제목
                  Center(
                    child: Text(
                      widget.letter.emoji,
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      widget.letter.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 편지 본문
                  Text(
                    widget.letter.message,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 과학적 근거 접기/펼치기
            GestureDetector(
              onTap: () => setState(() => _showScience = !_showScience),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.textHint.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.science_rounded,
                          size: 18,
                          color: AppColors.info,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '과학적 근거',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppColors.info,
                              ),
                        ),
                        const Spacer(),
                        Icon(
                          _showScience
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.textHint,
                        ),
                      ],
                    ),
                    if (_showScience) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.letter.scientificBasis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '출처: ${widget.letter.source}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 액션 버튼
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 파트너에게 공유
                    },
                    icon: const Icon(Icons.favorite_border_rounded, size: 18),
                    label: const Text('파트너에게 공유'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: 편지 모아보기 (B5)
                    },
                    icon: const Icon(Icons.list_rounded, size: 18),
                    label: const Text('편지 모아보기'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
