import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D4. 아기 프로필 상세 — 4-Layer 프로파일링
class BabyProfileDetailScreen extends StatefulWidget {
  const BabyProfileDetailScreen({super.key});

  @override
  State<BabyProfileDetailScreen> createState() =>
      _BabyProfileDetailScreenState();
}

class _BabyProfileDetailScreenState extends State<BabyProfileDetailScreen> {
  int _baselinePeriod = 0; // 0=7일, 1=14일, 2=30일

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
          '아기 프로필',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Layer 1: 연령
            _LayerCard(
              layerNumber: 1,
              title: '연령',
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.coral.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'D+45',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.coral,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '교정월령: 해당없음',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Layer 2: 환경
            _LayerCard(
              layerNumber: 2,
              title: '환경',
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _EnvironmentBadge(
                      icon: '🍼',
                      label: '혼합수유',
                      color: AppColors.feedingBlue,
                    ),
                    _EnvironmentBadge(
                      icon: '🛏️',
                      label: '아기 침대',
                      color: AppColors.sleepPurple,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Layer 3: 기질유형
            _LayerCard(
              layerNumber: 3,
              title: '기질유형',
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.coral.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '활발한 아기',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.coral,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Radar chart placeholder
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: CustomPaint(painter: _RadarChartPainter()),
                  ),
                  const SizedBox(height: 8),
                  // Legend
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: const [
                      _RadarLabel('활동성'),
                      _RadarLabel('규칙성'),
                      _RadarLabel('적응성'),
                      _RadarLabel('반응강도'),
                      _RadarLabel('기분'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Layer 4: 개인 베이스라인
            _LayerCard(
              layerNumber: 4,
              title: '개인 베이스라인',
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Period toggle
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('7일')),
                      ButtonSegment(value: 1, label: Text('14일')),
                      ButtonSegment(value: 2, label: Text('30일')),
                    ],
                    selected: {_baselinePeriod},
                    onSelectionChanged: (set) {
                      setState(() => _baselinePeriod = set.first);
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.coral;
                        }
                        return AppColors.surface;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.selected)) {
                          return Colors.white;
                        }
                        return AppColors.textSecondary;
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Trend chart placeholder
                  Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up_rounded,
                            size: 36,
                            color: AppColors.textHint.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _baselinePeriod == 0
                                ? '최근 7일 추세'
                                : _baselinePeriod == 1
                                ? '최근 14일 추세'
                                : '최근 30일 추세',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textHint),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Bottom Note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text('💛', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '이 프로필은 자동으로 업데이트됩니다',
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

class _LayerCard extends StatelessWidget {
  final int layerNumber;
  final String title;
  final Widget child;

  const _LayerCard({
    required this.layerNumber,
    required this.title,
    required this.child,
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
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.coral.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$layerNumber',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.coral,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

class _EnvironmentBadge extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;

  const _EnvironmentBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarLabel extends StatelessWidget {
  final String text;

  const _RadarLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
    );
  }
}

/// 5축 레이더 차트 (활동성, 규칙성, 적응성, 반응강도, 기분)
class _RadarChartPainter extends CustomPainter {
  // Demo values: 0.0 ~ 1.0
  static const _values = [0.8, 0.5, 0.6, 0.9, 0.7];
  static const _axisCount = 5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 16;

    // Grid paint
    final gridPaint = Paint()
      ..color = AppColors.textHint.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw concentric pentagons (grid)
    for (int level = 1; level <= 4; level++) {
      final r = radius * level / 4;
      final path = Path();
      for (int i = 0; i < _axisCount; i++) {
        final angle = (2 * math.pi * i / _axisCount) - math.pi / 2;
        final x = center.dx + r * math.cos(angle);
        final y = center.dy + r * math.sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Draw axis lines
    for (int i = 0; i < _axisCount; i++) {
      final angle = (2 * math.pi * i / _axisCount) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // Draw data polygon
    final dataPath = Path();
    final dataPaint = Paint()
      ..color = AppColors.coral.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    final dataBorderPaint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < _axisCount; i++) {
      final angle = (2 * math.pi * i / _axisCount) - math.pi / 2;
      final r = radius * _values[i];
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, dataPaint);
    canvas.drawPath(dataPath, dataBorderPaint);

    // Draw data points
    final dotPaint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.fill;
    for (int i = 0; i < _axisCount; i++) {
      final angle = (2 * math.pi * i / _axisCount) - math.pi / 2;
      final r = radius * _values[i];
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
