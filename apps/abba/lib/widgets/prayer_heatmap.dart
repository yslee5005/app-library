import 'package:flutter/material.dart';
import 'package:app_lib_logging/logging.dart';
import 'package:intl/intl.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import '../theme/abba_theme.dart';

/// Color scheme for heatmap cells.
enum HeatmapColorScheme {
  /// Sage green gradient (prayer)
  sage,

  /// Soft gold gradient (QT)
  gold,
}

/// GitHub-style contribution heatmap showing prayer activity.
/// Tap a cell to see date + count + total minutes.
class PrayerHeatmap extends StatefulWidget {
  const PrayerHeatmap({
    super.key,
    required this.data,
    required this.streakDays,
    this.weeks = 8,
    this.cellSize = 18.0,
    this.cellSpacing = 3.0,
    this.colorScheme = HeatmapColorScheme.sage,
  });

  final Map<DateTime, HeatmapDay> data;
  final int streakDays;
  final int weeks;
  final double cellSize;
  final double cellSpacing;
  final HeatmapColorScheme colorScheme;

  @override
  State<PrayerHeatmap> createState() => _PrayerHeatmapState();
}

class _PrayerHeatmapState extends State<PrayerHeatmap> {
  DateTime? _selectedDate;
  HeatmapDay? _selectedDay;

  // Sage color gradient (prayer)
  static const _sageEmpty = Color(0xFFEDE8DF);
  static const _sageLevel1 = Color(0xFFC8DCC8);
  static const _sageLevel2 = Color(0xFFA4CCA4);
  static const _sageLevel3 = Color(0xFF8FBC8F);
  static const _sageLevel4 = Color(0xFF5B8C5A);

  // Gold color gradient (QT)
  static const _goldEmpty = Color(0xFFEDE8DF);
  static const _goldLevel1 = Color(0xFFF0E4D4);
  static const _goldLevel2 = Color(0xFFE8D4B8);
  static const _goldLevel3 = Color(0xFFD4A574);
  static const _goldLevel4 = Color(0xFFB8864A);

  Color get _emptyColor =>
      widget.colorScheme == HeatmapColorScheme.gold ? _goldEmpty : _sageEmpty;
  Color get _level1 =>
      widget.colorScheme == HeatmapColorScheme.gold ? _goldLevel1 : _sageLevel1;
  Color get _level2 =>
      widget.colorScheme == HeatmapColorScheme.gold ? _goldLevel2 : _sageLevel2;
  Color get _level3 =>
      widget.colorScheme == HeatmapColorScheme.gold ? _goldLevel3 : _sageLevel3;
  Color get _level4 =>
      widget.colorScheme == HeatmapColorScheme.gold ? _goldLevel4 : _sageLevel4;

  Color _colorForCount(int count) {
    if (count <= 0) return _emptyColor;
    if (count == 1) return _level1;
    if (count == 2) return _level2;
    if (count == 3) return _level3;
    return _level4;
  }

  late DateTime _today;
  late DateTime _gridStart;
  late int _cols;
  late double _step;

  void _calcGrid() {
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    final totalDays = widget.weeks * 7;
    final rawStart = _today.subtract(Duration(days: totalDays - 1));
    final startOffset = (rawStart.weekday - 1) % 7;
    _gridStart = rawStart.subtract(Duration(days: startOffset));
    final daysBetween = _today.difference(_gridStart).inDays;
    _cols = (daysBetween ~/ 7) + 1;
    _step = widget.cellSize + widget.cellSpacing;
  }

  void _onTapDown(TapDownDetails details) {
    final labelWidth = 24.0;
    final dx = details.localPosition.dx - labelWidth;
    final dy = details.localPosition.dy - 22; // month label height + gap

    if (dx < 0 || dy < 0) {
      setState(() {
        _selectedDate = null;
        _selectedDay = null;
      });
      return;
    }

    final col = (dx / _step).floor();
    final row = (dy / _step).floor();

    if (col < 0 || col >= _cols || row < 0 || row >= 7) {
      setState(() {
        _selectedDate = null;
        _selectedDay = null;
      });
      return;
    }

    final dayOffset = col * 7 + row;
    final date = _gridStart.add(Duration(days: dayOffset));
    final dateKey = DateTime(date.year, date.month, date.day);

    if (dateKey.isAfter(_today)) {
      setState(() {
        _selectedDate = null;
        _selectedDay = null;
      });
      return;
    }

    setState(() {
      if (_selectedDate == dateKey) {
        _selectedDate = null;
        _selectedDay = null;
      } else {
        _selectedDate = dateKey;
        _selectedDay = widget.data[dateKey] ?? const HeatmapDay();
        final count = _selectedDay?.count ?? 0;
        prayerLog.debug('Heatmap cell tapped: $dateKey, count=$count');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _calcGrid();

    final gridWidth = _cols * _step - widget.cellSpacing;
    final gridHeight = 7 * _step - widget.cellSpacing;

    final locale = Localizations.localeOf(context).toString();
    // ISO weekday: Mon=1..Sun=7. Generate short names via intl (locale-aware).
    final weekdayLabels = List.generate(7, (i) {
      final d = DateTime(2024, 1, i + 1); // Jan 1 2024 = Mon
      return DateFormat.E(locale).format(d);
    });
    const labelWidth = 24.0;

    // Month labels (locale-aware short month name)
    final monthLabels = <(int col, String label)>[];
    int lastMonth = -1;
    for (int col = 0; col < _cols; col++) {
      final firstDayOfCol = _gridStart.add(Duration(days: col * 7));
      if (firstDayOfCol.month != lastMonth) {
        lastMonth = firstDayOfCol.month;
        monthLabels.add((col, DateFormat.MMM(locale).format(firstDayOfCol)));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tappable heatmap
        GestureDetector(
          onTapDown: _onTapDown,
          child: SizedBox(
            height: 22 + gridHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: SizedBox(
                width: labelWidth + gridWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month labels
                    SizedBox(
                      height: 14,
                      child: Padding(
                        padding: EdgeInsets.only(left: labelWidth),
                        child: Stack(
                          children: monthLabels.map((entry) {
                            final (col, label) = entry;
                            return Positioned(
                              left: col * _step,
                              child: Text(
                                label,
                                style: AbbaTypography.caption.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AbbaColors.warmBrown,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Weekday labels + grid
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Weekday labels
                        SizedBox(
                          width: labelWidth,
                          height: gridHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(7, (row) {
                              return SizedBox(
                                height: widget.cellSize,
                                child: Center(
                                  child: Text(
                                    weekdayLabels[row],
                                    style: AbbaTypography.caption.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AbbaColors.warmBrown,
                                      height: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        // Grid
                        SizedBox(
                          width: gridWidth,
                          height: gridHeight,
                          child: CustomPaint(
                            size: Size(gridWidth, gridHeight),
                            painter: _HeatmapPainter(
                              data: widget.data,
                              gridStart: _gridStart,
                              today: _today,
                              cols: _cols,
                              cellSize: widget.cellSize,
                              cellSpacing: widget.cellSpacing,
                              colorForCount: _colorForCount,
                              borderRadius: 3.0,
                              selectedDate: _selectedDate,
                              selectionBorderColor: _level4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AbbaSpacing.sm),
        // Selected date info or streak + legend
        if (_selectedDate != null && _selectedDay != null)
          _buildSelectedInfo()
        else
          _buildStreakAndLegend(context),
      ],
    );
  }

  Widget _buildSelectedInfo() {
    final d = _selectedDate!;
    final day = _selectedDay!;
    final locale = Localizations.localeOf(context).toString();
    // Full localized date: "Apr 22 (Tue)" / "4월 22일 (화)" 등
    final dateStr =
        '${DateFormat.MMMd(locale).format(d)} '
        '(${DateFormat.E(locale).format(d)})';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AbbaRadius.md),
      ),
      child: Row(
        children: [
          Text(
            '📅 $dateStr',
            style: AbbaTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AbbaColors.warmBrown,
            ),
          ),
          const Spacer(),
          if (day.count > 0)
            Text(
              '🙏 ${day.count}회 · ${day.minutes}분',
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.sageDark,
                fontWeight: FontWeight.w600,
              ),
            )
          else
            Text(
              AppLocalizations.of(context)!.heatmapNoPrayer,
              style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
            ),
        ],
      ),
    );
  }

  Widget _buildStreakAndLegend(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        if (widget.streakDays > 0)
          Text(
            '\u{1F525} ${widget.streakDays}',
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.warmBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
        const Spacer(),
        Text(
          l10n.heatmapLegendLess,
          style: AbbaTypography.caption.copyWith(fontSize: 10),
        ),
        const SizedBox(width: 3),
        ...[_emptyColor, _level1, _level2, _level3, _level4].map(
          (color) => Padding(
            padding: const EdgeInsets.only(right: 2),
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        const SizedBox(width: 2),
        Text(
          l10n.heatmapLegendMore,
          style: AbbaTypography.caption.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.data,
    required this.gridStart,
    required this.today,
    required this.cols,
    required this.cellSize,
    required this.cellSpacing,
    required this.colorForCount,
    required this.borderRadius,
    this.selectedDate,
    this.selectionBorderColor = const Color(0xFF5B8C5A),
  });

  final Map<DateTime, HeatmapDay> data;
  final DateTime gridStart;
  final DateTime today;
  final int cols;
  final double cellSize;
  final double cellSpacing;
  final Color Function(int) colorForCount;
  final double borderRadius;
  final DateTime? selectedDate;
  final Color selectionBorderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = selectionBorderColor;
    final step = cellSize + cellSpacing;

    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < 7; row++) {
        final dayOffset = col * 7 + row;
        final date = gridStart.add(Duration(days: dayOffset));

        if (date.isAfter(today)) continue;

        final dateKey = DateTime(date.year, date.month, date.day);
        final count = data[dateKey]?.count ?? 0;
        paint.color = colorForCount(count);

        final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(col * step, row * step, cellSize, cellSize),
          Radius.circular(borderRadius),
        );
        canvas.drawRRect(rect, paint);

        // Selected cell border
        if (selectedDate == dateKey) {
          canvas.drawRRect(rect, borderPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.today != today ||
        oldDelegate.selectedDate != selectedDate;
  }
}
