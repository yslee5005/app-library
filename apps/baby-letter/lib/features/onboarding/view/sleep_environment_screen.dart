import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// G3. 수면 환경 선택
class SleepEnvironmentScreen extends StatefulWidget {
  const SleepEnvironmentScreen({super.key});

  @override
  State<SleepEnvironmentScreen> createState() => _SleepEnvironmentScreenState();
}

class _SleepEnvironmentScreenState extends State<SleepEnvironmentScreen> {
  int _selectedIndex = -1;

  static const _options = [
    _SleepOption(
      emoji: '🛏️',
      title: '독립 수면 (아기 침대)',
      description: '아기만의 수면 공간에서 잠을 자요',
    ),
    _SleepOption(
      emoji: '🤱',
      title: '동침 (같은 침대)',
      description: '부모와 같은 침대에서 잠을 자요',
    ),
    _SleepOption(
      emoji: '🔄',
      title: '혼합 (상황에 따라)',
      description: '상황에 따라 달라져요',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '수면 환경',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '어느 것이 좋다/나쁘다가 아닙니다.\n패턴 분석을 위한 정보예요',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
              ),

              const SizedBox(height: 32),

              // Selection cards
              ...List.generate(_options.length, (i) {
                final option = _options[i];
                final isSelected = _selectedIndex == i;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = i),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.coral
                              : AppColors.textHint.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            option.emoji,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: isSelected
                                            ? AppColors.coralDark
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  option.description,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.coral,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Non-judgmental note
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.amberLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '모든 수면 환경은 각 가정의 상황에 맞는 선택이에요.\n'
                  '판단하지 않고, 아기의 수면 패턴을 이해하는 데 활용할게요.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedIndex >= 0
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
                    '확인',
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
    );
  }
}

class _SleepOption {
  final String emoji;
  final String title;
  final String description;

  const _SleepOption({
    required this.emoji,
    required this.title,
    required this.description,
  });
}
