import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  // Mock: last 7 days have prayers
  late final Set<DateTime> _prayerDays;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _prayerDays = {};
    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      _prayerDays.add(DateTime(day.year, day.month, day.day));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(
          '${l10n.calendarTitle} 📅',
          style: AbbaTypography.h1,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        child: Column(
          children: [
            // Streak card
            profileAsync.when(
              data: (profile) => AbbaCard(
                margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: AbbaSpacing.xs),
                          Text(
                            '${profile.currentStreak}',
                            style: AbbaTypography.hero,
                          ),
                          Text(
                            '${l10n.currentStreak} (${l10n.days})',
                            style: AbbaTypography.caption,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: AbbaColors.muted.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 32)),
                          const SizedBox(height: AbbaSpacing.xs),
                          Text(
                            '${profile.bestStreak}',
                            style: AbbaTypography.hero,
                          ),
                          Text(
                            '${l10n.bestStreak} (${l10n.days})',
                            style: AbbaTypography.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (e, s) => const SizedBox.shrink(),
            ),
            // Month navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month - 1,
                    );
                  }),
                  icon: const Icon(Icons.chevron_left, size: 32),
                  color: AbbaColors.warmBrown,
                ),
                Text(
                  DateFormat.yMMMM(locale).format(_currentMonth),
                  style: AbbaTypography.h2,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    _currentMonth = DateTime(
                      _currentMonth.year,
                      _currentMonth.month + 1,
                    );
                  }),
                  icon: const Icon(Icons.chevron_right, size: 32),
                  color: AbbaColors.warmBrown,
                ),
              ],
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Weekday headers
            Row(
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                  .map(
                    (d) => Expanded(
                      child: Center(
                        child: Text(
                          d,
                          style: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Calendar grid
            _buildCalendarGrid(),
            // Selected date prayers
            if (_selectedDate != null) ...[
              const SizedBox(height: AbbaSpacing.md),
              _buildDayDetail(l10n),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7; // Sunday = 0
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    // Day cells
    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday = date == today;
      final hasPrayer = _prayerDays.contains(date);
      final isSelected = _selectedDate == date;

      cells.add(
        GestureDetector(
          onTap: () => setState(() {
            _selectedDate = _selectedDate == date ? null : date;
          }),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: AbbaColors.softGold, width: 2)
                  : null,
              color: isSelected
                  ? AbbaColors.sage.withValues(alpha: 0.2)
                  : null,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$day',
                    style: AbbaTypography.bodySmall.copyWith(
                      fontWeight:
                          isToday ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  if (hasPrayer)
                    const Text('🌸', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1,
      children: cells,
    );
  }

  Widget _buildDayDetail(AppLocalizations l10n) {
    final hasPrayer = _prayerDays.contains(_selectedDate);

    return AbbaCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMMd().format(_selectedDate!),
            style: AbbaTypography.h2,
          ),
          const SizedBox(height: AbbaSpacing.sm),
          if (hasPrayer)
            Row(
              children: [
                const Text('🌸', style: TextStyle(fontSize: 20)),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Text(
                    'Morning Prayer',
                    style: AbbaTypography.body,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AbbaColors.muted,
                ),
              ],
            )
          else
            Text(
              'No prayers recorded',
              style:
                  AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
        ],
      ),
    );
  }
}
