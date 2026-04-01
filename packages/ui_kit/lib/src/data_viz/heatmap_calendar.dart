import 'package:flutter/material.dart';

/// A GitHub-style contribution heatmap calendar.
///
/// Takes a [data] map of dates to intensity values and renders a grid of
/// coloured cells.
class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({
    required this.data,
    this.weeks = 17,
    this.cellSize = 14,
    this.cellSpacing = 3,
    this.startDay = DateTime.monday,
    this.baseColor,
    this.emptyColor,
    this.dayLabels = const ['M', '', 'W', '', 'F', '', ''],
    this.onDayTap,
    super.key,
  });

  /// Map of dates (year-month-day only) to intensity (0 = empty, higher = more
  /// intense). The maximum value in the map determines the scale.
  final Map<DateTime, int> data;

  /// Number of weeks (columns) to display.
  final int weeks;

  /// Size of each cell.
  final double cellSize;

  /// Spacing between cells.
  final double cellSpacing;

  /// First day of the week (1 = Monday, 7 = Sunday).
  final int startDay;

  /// High-intensity colour. Defaults to [ColorScheme.primary].
  final Color? baseColor;

  /// Colour for days with no data. Defaults to surface container.
  final Color? emptyColor;

  /// Short labels for each row (7 items, Mon–Sun starting from [startDay]).
  final List<String> dayLabels;

  /// Called when a cell is tapped.
  final void Function(DateTime date, int value)? onDayTap;

  /// Normalize a DateTime to midnight.
  static DateTime _normalize(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = baseColor ?? theme.colorScheme.primary;
    final empty = emptyColor ?? theme.colorScheme.surfaceContainerHighest;

    // Find max value for scaling.
    final maxVal = data.values.fold<int>(0, (a, b) => a > b ? a : b);

    // Compute the end date (today) and the start date.
    final today = _normalize(DateTime.now());
    final totalDays = weeks * 7;
    // Align the end to the last day of the current week row.
    final endWeekday = today.weekday; // 1=Mon..7=Sun
    final daysUntilEnd = (7 - ((endWeekday - startDay) % 7)) % 7;
    final endDate = today.add(Duration(days: daysUntilEnd));
    final startDate = endDate.subtract(Duration(days: totalDays - 1));

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day labels column
        Column(
          children: List.generate(7, (i) {
            return SizedBox(
              width: 20,
              height: cellSize + cellSpacing,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dayLabels.length > i ? dayLabels[i] : '',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            );
          }),
        ),

        // Grid
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(weeks, (weekIndex) {
                return Column(
                  children: List.generate(7, (dayIndex) {
                    final dayOffset = weekIndex * 7 + dayIndex;
                    final date = startDate.add(Duration(days: dayOffset));
                    final normalised = _normalize(date);
                    final value = data[normalised] ?? 0;

                    Color cellColor;
                    if (value <= 0 || maxVal <= 0) {
                      cellColor = empty;
                    } else {
                      final intensity = (value / maxVal).clamp(0.0, 1.0);
                      // 4 levels
                      final level = (intensity * 4).ceil().clamp(1, 4);
                      final alpha = (level * 60).clamp(60, 240);
                      cellColor = color.withAlpha(alpha);
                    }

                    return GestureDetector(
                      onTap: onDayTap != null
                          ? () => onDayTap!(normalised, value)
                          : null,
                      child: Container(
                        width: cellSize,
                        height: cellSize,
                        margin: EdgeInsets.all(cellSpacing / 2),
                        decoration: BoxDecoration(
                          color: cellColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
