import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

/// D8. 성장 차트 — WHO 백분위 곡선 + 내 아기 데이터
class GrowthChartScreen extends StatefulWidget {
  const GrowthChartScreen({super.key});

  @override
  State<GrowthChartScreen> createState() => _GrowthChartScreenState();
}

class _GrowthChartScreenState extends State<GrowthChartScreen> {
  bool _showHeight = true; // true=키, false=몸무게
  bool _useCorrectedAge = false;

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
          '성장 차트',
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

            // Toggle: 키 / 몸무게
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('키')),
                  ButtonSegment(value: false, label: Text('몸무게')),
                ],
                selected: {_showHeight},
                onSelectionChanged: (set) {
                  setState(() => _showHeight = set.first);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return AppColors.coral;
                    }
                    return AppColors.surface;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.white;
                    }
                    return AppColors.textSecondary;
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Chart area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _showHeight ? 'WHO 신장 백분위 곡선' : 'WHO 체중 백분위 곡선',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Chart
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _WHOChartPainter(isHeight: _showHeight),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ChartLegend(
                          color: AppColors.textHint.withValues(alpha: 0.3),
                          label: '3%, 15%, 50%, 85%, 97%'),
                      const SizedBox(width: 16),
                      _ChartLegend(color: AppColors.coral, label: '내 아기'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Percentile display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '현재 ',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Text(
                    '50th',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppColors.coral,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    ' 백분위',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Corrected age toggle
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.infoLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '조산아는 교정 월령 기준으로 표시할 수 있어요',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _useCorrectedAge,
                    onChanged: (v) =>
                        setState(() => _useCorrectedAge = v),
                    activeThumbColor: AppColors.coral,
                    activeTrackColor: AppColors.coralLight,
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

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textHint,
              ),
        ),
      ],
    );
  }
}

/// WHO 백분위 차트 CustomPainter
class _WHOChartPainter extends CustomPainter {
  final bool isHeight;

  _WHOChartPainter({required this.isHeight});

  // WHO percentile reference data (simplified 0-12 months)
  // Height (cm) percentiles: 3rd, 15th, 50th, 85th, 97th
  static const _heightPercentiles = [
    // month 0
    [46.3, 48.0, 49.9, 51.8, 53.4],
    // month 1
    [50.0, 51.7, 53.7, 55.6, 57.3],
    // month 2
    [53.2, 55.0, 57.1, 59.1, 60.9],
    // month 3
    [55.8, 57.6, 59.8, 62.0, 63.9],
    // month 4
    [57.9, 59.8, 62.0, 64.3, 66.2],
    // month 5
    [59.6, 61.6, 63.9, 66.2, 68.2],
    // month 6
    [61.2, 63.2, 65.5, 67.9, 69.9],
    // month 7
    [62.5, 64.5, 67.0, 69.4, 71.5],
    // month 8
    [63.8, 65.8, 68.3, 70.8, 72.9],
    // month 9
    [65.0, 67.0, 69.6, 72.2, 74.3],
    // month 10
    [66.1, 68.2, 70.8, 73.4, 75.6],
    // month 11
    [67.2, 69.3, 72.0, 74.7, 76.9],
    // month 12
    [68.2, 70.4, 73.1, 75.9, 78.1],
  ];

  // Weight (kg) percentiles: 3rd, 15th, 50th, 85th, 97th
  static const _weightPercentiles = [
    // month 0
    [2.5, 2.9, 3.3, 3.9, 4.3],
    // month 1
    [3.2, 3.7, 4.3, 5.0, 5.6],
    // month 2
    [3.9, 4.5, 5.2, 6.0, 6.8],
    // month 3
    [4.5, 5.1, 5.9, 6.9, 7.7],
    // month 4
    [5.0, 5.6, 6.5, 7.5, 8.4],
    // month 5
    [5.3, 6.0, 7.0, 8.1, 9.0],
    // month 6
    [5.6, 6.3, 7.3, 8.5, 9.5],
    // month 7
    [5.9, 6.6, 7.6, 8.9, 9.9],
    // month 8
    [6.1, 6.8, 7.9, 9.2, 10.3],
    // month 9
    [6.3, 7.0, 8.1, 9.5, 10.6],
    // month 10
    [6.5, 7.2, 8.4, 9.7, 10.9],
    // month 11
    [6.6, 7.4, 8.6, 10.0, 11.2],
    // month 12
    [6.8, 7.6, 8.8, 10.2, 11.4],
  ];

  // My baby data points (month, value)
  static const _myHeightData = <List<double>>[
    [0, 49.5],
    [1, 53.5],
  ];

  static const _myWeightData = <List<double>>[
    [0, 3.2],
    [1, 4.8],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final data = isHeight ? _heightPercentiles : _weightPercentiles;
    final myData = isHeight ? _myHeightData : _myWeightData;

    final chartLeft = 40.0;
    final chartRight = size.width - 16.0;
    final chartTop = 16.0;
    final chartBottom = size.height - 30.0;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    // Find min/max for Y axis
    final allValues = data.expand((row) => row).toList();
    final yMin = (allValues.reduce(math.min) - 2).floorToDouble();
    final yMax = (allValues.reduce(math.max) + 2).ceilToDouble();

    // Mapping functions
    double mapX(double month) => chartLeft + (month / 12) * chartWidth;
    double mapY(double value) =>
        chartBottom - ((value - yMin) / (yMax - yMin)) * chartHeight;

    // Grid paint
    final gridPaint = Paint()
      ..color = AppColors.textHint.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    // Draw horizontal grid lines + Y labels
    const yDivisions = 5;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i <= yDivisions; i++) {
      final value = yMin + (yMax - yMin) * i / yDivisions;
      final y = mapY(value);
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );
      // Y label
      textPainter.text = TextSpan(
        text: isHeight
            ? value.toInt().toString()
            : value.toStringAsFixed(1),
        style: const TextStyle(
          color: AppColors.textHint,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(chartLeft - textPainter.width - 4, y - 6));
    }

    // Draw vertical grid lines + X labels (months)
    for (int month = 0; month <= 12; month += 2) {
      final x = mapX(month.toDouble());
      canvas.drawLine(Offset(x, chartTop), Offset(x, chartBottom), gridPaint);
      // X label
      textPainter.text = TextSpan(
        text: '${month}m',
        style: const TextStyle(
          color: AppColors.textHint,
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(x - textPainter.width / 2, chartBottom + 6));
    }

    // Draw percentile curves
    final percentileColors = [
      AppColors.textHint.withValues(alpha: 0.2),
      AppColors.textHint.withValues(alpha: 0.25),
      AppColors.textHint.withValues(alpha: 0.35),
      AppColors.textHint.withValues(alpha: 0.25),
      AppColors.textHint.withValues(alpha: 0.2),
    ];
    final percentileLabels = ['3%', '15%', '50%', '85%', '97%'];

    for (int p = 0; p < 5; p++) {
      final curvePaint = Paint()
        ..color = percentileColors[p]
        ..style = PaintingStyle.stroke
        ..strokeWidth = p == 2 ? 2 : 1; // 50th is thicker

      final path = Path();
      for (int month = 0; month < data.length; month++) {
        final x = mapX(month.toDouble());
        final y = mapY(data[month][p]);
        if (month == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, curvePaint);

      // Label at end of curve
      final lastY = mapY(data.last[p]);
      textPainter.text = TextSpan(
        text: percentileLabels[p],
        style: TextStyle(
          color: percentileColors[p],
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(chartRight + 2, lastY - 5));
    }

    // Draw my baby's data
    if (myData.length >= 2) {
      // Line
      final myLinePaint = Paint()
        ..color = AppColors.coral
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;

      final myPath = Path();
      for (int i = 0; i < myData.length; i++) {
        final x = mapX(myData[i][0]);
        final y = mapY(myData[i][1]);
        if (i == 0) {
          myPath.moveTo(x, y);
        } else {
          myPath.lineTo(x, y);
        }
      }
      canvas.drawPath(myPath, myLinePaint);
    }

    // Dots
    final dotPaint = Paint()
      ..color = AppColors.coral
      ..style = PaintingStyle.fill;
    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final point in myData) {
      final x = mapX(point[0]);
      final y = mapY(point[1]);
      canvas.drawCircle(Offset(x, y), 5, dotBorderPaint);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WHOChartPainter oldDelegate) =>
      oldDelegate.isHeight != isHeight;
}
