import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D5. 같은유형 비교 — 시각적 비교만, 판단 없음
class TypeComparisonScreen extends StatelessWidget {
  const TypeComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '같은유형 비교',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Chart legend
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LegendDot(
                    color: AppColors.coral,
                    label: '내 아기',
                  ),
                  const SizedBox(width: 24),
                  _LegendDot(
                    color: AppColors.amber.withValues(alpha: 0.4),
                    label: '활발한 아기 1,234명 평균',
                    isBand: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Comparison cards
            _ComparisonCard(
              label: '수면시간',
              icon: '😴',
              myValue: 14.2,
              avgMin: 13.0,
              avgMax: 15.5,
              unit: 'h/일',
              maxScale: 20,
            ),

            const SizedBox(height: 12),

            _ComparisonCard(
              label: '수유횟수',
              icon: '🍼',
              myValue: 8,
              avgMin: 7,
              avgMax: 10,
              unit: '회/일',
              maxScale: 14,
            ),

            const SizedBox(height: 12),

            _ComparisonCard(
              label: '낮잠 길이',
              icon: '🌤️',
              myValue: 3.5,
              avgMin: 3.0,
              avgMax: 5.0,
              unit: 'h',
              maxScale: 8,
            ),

            const SizedBox(height: 12),

            _ComparisonCard(
              label: '밤잠 길이',
              icon: '🌙',
              myValue: 10.7,
              avgMin: 9.0,
              avgMax: 12.0,
              unit: 'h',
              maxScale: 14,
            ),

            const SizedBox(height: 24),

            // Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.amberLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💛', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '모든 아기는 다릅니다. 이 비교는 참고용입니다.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  final bool isBand;

  const _LegendDot({
    required this.color,
    required this.label,
    this.isBand = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isBand)
          Container(
            width: 16,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          )
        else
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String label;
  final String icon;
  final double myValue;
  final double avgMin;
  final double avgMax;
  final String unit;
  final double maxScale;

  const _ComparisonCard({
    required this.label,
    required this.icon,
    required this.myValue,
    required this.avgMin,
    required this.avgMax,
    required this.unit,
    required this.maxScale,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual bar comparison
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final myRatio = myValue / maxScale;
              final avgMinRatio = avgMin / maxScale;
              final avgMaxRatio = avgMax / maxScale;

              return Column(
                children: [
                  // My baby bar
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '내 아기',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            // Background
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // My value bar
                            FractionallySizedBox(
                              widthFactor: myRatio.clamp(0, 1),
                              child: Container(
                                height: 24,
                                decoration: BoxDecoration(
                                  color: AppColors.coral,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${myValue % 1 == 0 ? myValue.toInt() : myValue}$unit',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.coral,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Average band
                  Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '평균',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            // Background
                            Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: AppColors.cream,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            // Average band
                            Positioned(
                              left: (barWidth - 60 - 58) * avgMinRatio,
                              child: Container(
                                width: (barWidth - 60 - 58) *
                                    (avgMaxRatio - avgMinRatio),
                                height: 24,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.amber.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 50,
                        child: Text(
                          '${avgMin % 1 == 0 ? avgMin.toInt() : avgMin}-${avgMax % 1 == 0 ? avgMax.toInt() : avgMax}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textHint,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
