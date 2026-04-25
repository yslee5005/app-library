import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../shared/data/baby_letters.dart';
import 'letter_detail_screen.dart';

/// B5. 아기의 편지 모음
/// 필터 + 주차 그룹별 편지 프리뷰 리스트
class LetterHistoryScreen extends StatefulWidget {
  const LetterHistoryScreen({super.key});

  @override
  State<LetterHistoryScreen> createState() => _LetterHistoryScreenState();
}

class _LetterHistoryScreenState extends State<LetterHistoryScreen> {
  _LetterFilter _currentFilter = _LetterFilter.all;

  List<BabyLetter> get _filteredLetters {
    switch (_currentFilter) {
      case _LetterFilter.all:
        return [...pregnancyLetters, ...postnatalLetters];
      case _LetterFilter.pregnancy:
        return pregnancyLetters;
      case _LetterFilter.postnatal:
        return postnatalLetters;
    }
  }

  /// 편지를 그룹으로 묶기 (이번 주 / 지난 주 / 이전)
  Map<String, List<BabyLetter>> get _groupedLetters {
    final letters = _filteredLetters;
    final groups = <String, List<BabyLetter>>{};

    // 간단한 그룹 분류: 처음 3개 = 이번 주, 다음 3개 = 지난 주, 나머지 = 이전
    for (var i = 0; i < letters.length; i++) {
      final String group;
      if (i < 3) {
        group = '이번 주';
      } else if (i < 6) {
        group = '지난 주';
      } else {
        group = '이전 편지';
      }
      groups.putIfAbsent(group, () => []).add(letters[i]);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedLetters;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('아기의 편지 모음')),
      body: Column(
        children: [
          // 필터 칩
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(
                    label: '전체',
                    selected: _currentFilter == _LetterFilter.all,
                    onSelected: () =>
                        setState(() => _currentFilter = _LetterFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '임신',
                    selected: _currentFilter == _LetterFilter.pregnancy,
                    onSelected: () => setState(
                      () => _currentFilter = _LetterFilter.pregnancy,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '출산후',
                    selected: _currentFilter == _LetterFilter.postnatal,
                    onSelected: () => setState(
                      () => _currentFilter = _LetterFilter.postnatal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '감정별 ▼',
                    selected: false,
                    onSelected: () {
                      // TODO: 감정별 필터 팝업
                    },
                  ),
                ],
              ),
            ),
          ),

          // 편지 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              itemCount: grouped.length,
              itemBuilder: (context, groupIndex) {
                final groupName = grouped.keys.elementAt(groupIndex);
                final letters = grouped[groupName]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 그룹 헤더
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        '📅 $groupName',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),

                    // 편지 카드들
                    ...letters.map(
                      (letter) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _LetterPreviewCard(
                          letter: letter,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    LetterDetailScreen(letter: letter),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum _LetterFilter { all, pregnancy, postnatal }

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.coralLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.coral
                : AppColors.textHint.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: selected ? AppColors.coralDark : AppColors.textSecondary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _LetterPreviewCard extends StatelessWidget {
  final BabyLetter letter;
  final VoidCallback? onTap;

  const _LetterPreviewCard({required this.letter, this.onTap});

  String get _weekLabel {
    if (letter.weekKey.startsWith('week_')) {
      return '임신 ${letter.weekKey.substring(5)}주';
    }
    return 'D+${letter.weekKey.substring(2)}';
  }

  String get _preview {
    final msg = letter.message.replaceAll('\n', ' ');
    return msg.length > 60 ? '${msg.substring(0, 60)}...' : msg;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 이모지
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.letterCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(letter.emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // 내용
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _weekLabel,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.coralDark,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        letter.title,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
