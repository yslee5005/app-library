import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';
import '../../../widgets/streak_garden.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(localeProvider);
    final streakAsync = ref.watch(streakProvider);
    final prayerDaysAsync = ref.watch(
      monthlyPrayerDaysProvider((
        year: _currentMonth.year,
        month: _currentMonth.month,
      )),
    );

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.calendarTitle} 📅', style: AbbaTypography.h1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        child: Column(
          children: [
            // Streak card with garden growth
            streakAsync.when(
              data: (streak) {
                final icon = streakGardenIcon(streak.current);
                return AbbaCard(
                  margin: const EdgeInsets.only(bottom: AbbaSpacing.md),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  icon,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: AbbaSpacing.xs),
                                Text(
                                  '${streak.current}',
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
                                const Text(
                                  '🏆',
                                  style: TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: AbbaSpacing.xs),
                                Text(
                                  '${streak.best}',
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
                      // Encouragement for streak = 0
                      if (streak.current == 0) ...[
                        const SizedBox(height: AbbaSpacing.sm),
                        Text(
                          l10n.streakRecovery,
                          style: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.sage,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.only(bottom: AbbaSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              ),
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
            // Weekday headers (locale-aware)
            Row(
              children: List.generate(7, (i) {
                // Sunday=0 .. Saturday=6; 2024-01-07 is a Sunday
                final date = DateTime(2024, 1, 7 + i);
                final label = DateFormat.E(locale).format(date)[0].toUpperCase();
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Calendar grid
            prayerDaysAsync.when(
              data: (prayerDays) => _buildCalendarGrid(prayerDays),
              loading: () => _buildCalendarGrid({}),
              error: (e, s) => _buildCalendarGrid({}),
            ),
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

  Widget _buildCalendarGrid(Set<DateTime> prayerDays) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
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
      final hasPrayer = prayerDays.contains(date);
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
              color: isSelected ? AbbaColors.sage.withValues(alpha: 0.2) : null,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$day',
                    style: AbbaTypography.bodySmall.copyWith(
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                  if (hasPrayer) ...[
                    Builder(
                      builder: (context) {
                        // Check if previous day had prayer (grace recovery = 🌼)
                        final prevDay = date.subtract(const Duration(days: 1));
                        final prevHasPrayer = prayerDays.contains(prevDay);
                        final twoDaysAgo = date.subtract(
                          const Duration(days: 2),
                        );
                        final twoDaysHasPrayer = prayerDays.contains(
                          twoDaysAgo,
                        );
                        // Grace recovery: today has prayer, yesterday doesn't, but 2 days ago does
                        final isGraceRecovery =
                            !prevHasPrayer && twoDaysHasPrayer;
                        return Text(
                          isGraceRecovery ? '🌼' : '🌸',
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ],
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
    final prayersAsync = ref.watch(calendarPrayersProvider(_selectedDate!));

    return prayersAsync.when(
      data: (prayers) {
        if (prayers.isEmpty) {
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
                Text(
                  l10n.noPrayersRecorded,
                  style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
                ),
              ],
            ),
          );
        }

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
              ...prayers.map(
                (prayer) => Padding(
                  padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
                  child: Row(
                    children: [
                      const Text('🌸', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: AbbaSpacing.sm),
                      Expanded(
                        child: Text(
                          prayer.mode == 'qt'
                              ? l10n.quietTimeLabel
                              : l10n.morningPrayerLabel,
                          style: AbbaTypography.body,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: AbbaColors.muted),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => AbbaCard(
        margin: EdgeInsets.zero,
        child: Text(l10n.errorGeneric, style: AbbaTypography.body),
      ),
    );
  }
}
