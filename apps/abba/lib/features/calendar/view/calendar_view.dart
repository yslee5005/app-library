import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          child: Column(
            children: [
              // --- Streak cards (two separate) ---
              streakAsync.when(
                data: (streak) => _buildStreakCards(streak, l10n),
                loading: () => const SizedBox(height: 80),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AbbaSpacing.lg),
              // --- Month navigation ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => setState(() {
                      _currentMonth = DateTime(
                        _currentMonth.year,
                        _currentMonth.month - 1,
                      );
                      prayerLog.debug('Calendar month changed: ${_currentMonth.year}-${_currentMonth.month}');
                    }),
                    child: Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: AbbaColors.warmBrown.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.md),
                  Text(
                    DateFormat.yMMMM(locale).format(_currentMonth),
                    style: AbbaTypography.h2,
                  ),
                  const SizedBox(width: AbbaSpacing.md),
                  GestureDetector(
                    onTap: () {
                      final now = DateTime.now();
                      if (_currentMonth.year > now.year ||
                          (_currentMonth.year == now.year && _currentMonth.month >= now.month)) {
                        return;
                      }
                      setState(() {
                        _currentMonth = DateTime(
                          _currentMonth.year,
                          _currentMonth.month + 1,
                        );
                        prayerLog.debug('Calendar month changed: ${_currentMonth.year}-${_currentMonth.month}');
                      });
                    },
                    child: Builder(
                      builder: (context) {
                        final now = DateTime.now();
                        final isFuture = _currentMonth.year > now.year ||
                            (_currentMonth.year == now.year && _currentMonth.month >= now.month);
                        return Icon(
                          Icons.chevron_right,
                          size: 28,
                          color: AbbaColors.warmBrown.withValues(alpha: isFuture ? 0.15 : 0.5),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AbbaSpacing.md),
              // --- Calendar grid in card ---
              AbbaCard(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Weekday headers
                    Row(
                      children: List.generate(7, (i) {
                        final date = DateTime(2024, 1, 7 + i);
                        final label =
                            DateFormat.E(locale).format(date)[0].toUpperCase();
                        return Expanded(
                          child: Center(
                            child: Text(
                              label,
                              style: AbbaTypography.caption.copyWith(
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
                      error: (_, _) => _buildCalendarGrid({}),
                    ),
                  ],
                ),
              ),
              // --- Day detail ---
              if (_selectedDate != null) ...[
                const SizedBox(height: AbbaSpacing.md),
                _buildDayDetail(l10n),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- Streak cards ---
  Widget _buildStreakCards(
    ({int current, int best}) streak,
    AppLocalizations l10n,
  ) {
    final icon = streakGardenIcon(streak.current);

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AbbaSpacing.md,
              horizontal: AbbaSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AbbaColors.sage.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AbbaRadius.lg),
            ),
            child: Column(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: AbbaSpacing.xs),
                Text(
                  l10n.currentStreak,
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
                const SizedBox(height: AbbaSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${streak.current}',
                      style: AbbaTypography.hero.copyWith(fontSize: 32),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      l10n.days,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AbbaSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AbbaSpacing.md,
              horizontal: AbbaSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AbbaColors.sage.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AbbaRadius.lg),
            ),
            child: Column(
              children: [
                const Text('🏆', style: TextStyle(fontSize: 24)),
                const SizedBox(height: AbbaSpacing.xs),
                Text(
                  l10n.bestStreak,
                  style: AbbaTypography.caption.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
                const SizedBox(height: AbbaSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${streak.best}',
                      style: AbbaTypography.hero.copyWith(fontSize: 32),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      l10n.days,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- Calendar grid ---
  Widget _buildCalendarGrid(Set<DateTime> prayerDays) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final cells = <Widget>[];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isToday = date == today;
      final hasPrayer = prayerDays.contains(date);
      final isSelected = _selectedDate == date;

      // Grace recovery check
      Color? dotColor;
      if (hasPrayer) {
        final prevDay = date.subtract(const Duration(days: 1));
        final twoDaysAgo = date.subtract(const Duration(days: 2));
        final isGrace =
            !prayerDays.contains(prevDay) && prayerDays.contains(twoDaysAgo);
        dotColor = isGrace ? AbbaColors.softGold : AbbaColors.sage;
      }

      cells.add(
        GestureDetector(
          onTap: () => setState(() {
            _selectedDate = _selectedDate == date ? null : date;
            prayerLog.debug('Calendar date tapped: $date');
          }),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AbbaColors.sage : null,
              border: isToday && !isSelected
                  ? Border.all(color: AbbaColors.softGold, width: 1.5)
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
                          isToday || isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                      color: isSelected ? AbbaColors.white : null,
                    ),
                  ),
                  if (hasPrayer)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? AbbaColors.white : dotColor,
                      ),
                    ),
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

  // --- Day detail ---
  Widget _buildDayDetail(AppLocalizations l10n) {
    final prayersAsync = ref.watch(calendarPrayersProvider(_selectedDate!));
    final locale = ref.watch(localeProvider);

    return prayersAsync.when(
      data: (prayers) {
        if (prayers.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AbbaSpacing.lg),
            child: Column(
              children: [
                const Text('🌱', style: TextStyle(fontSize: 32)),
                const SizedBox(height: AbbaSpacing.sm),
                Text(
                  l10n.noPrayersRecorded,
                  style: AbbaTypography.bodySmall.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
              ],
            ),
          );
        }

        // Find first scripture for "오늘의 한 줄"
        final firstScripture = prayers
            .where((p) => p.result?.scripture != null)
            .map((p) => p.result!.scripture)
            .firstOrNull;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: date + record count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.xs),
              child: Row(
                children: [
                  Text(
                    DateFormat.yMMMMd(locale).format(_selectedDate!),
                    style: AbbaTypography.h2.copyWith(color: AbbaColors.sage),
                  ),
                  const Spacer(),
                  Text(
                    l10n.calendarRecordCount(prayers.length),
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),
            // Prayer items as individual cards
            ...prayers.map((prayer) => _buildPrayerItem(prayer, l10n)),
            // "오늘의 한 줄" scripture card
            if (firstScripture != null) ...[
              const SizedBox(height: AbbaSpacing.sm),
              _buildVerseCard(firstScripture, l10n, locale),
            ],
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => AbbaCard(
        margin: EdgeInsets.zero,
        child: Text(l10n.errorGeneric, style: AbbaTypography.body),
      ),
    );
  }

  Widget _buildPrayerItem(Prayer prayer, AppLocalizations l10n) {
    final isQt = prayer.mode == 'qt';
    final icon = isQt ? '📖' : '🎙️';
    final label = isQt ? l10n.quietTimeLabel : l10n.morningPrayerLabel;
    final time = DateFormat('a h:mm', 'ko').format(prayer.createdAt);
    final subtitle = isQt && prayer.qtPassageRef != null
        ? '${prayer.qtPassageRef} · $time'
        : time;

    return Padding(
      padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
      child: AbbaCard(
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(AbbaSpacing.md),
        child: InkWell(
          onTap: () => _openPrayerDetail(prayer),
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
          child: Row(
            children: [
              // Icon with circular background
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AbbaColors.sage.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: AbbaSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AbbaTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AbbaTypography.caption.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              if (prayer.audioStoragePath != null)
                Padding(
                  padding: const EdgeInsets.only(right: AbbaSpacing.xs),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: AbbaColors.sage.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ),
              Icon(
                Icons.chevron_right,
                color: AbbaColors.muted.withValues(alpha: 0.4),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerseCard(
    Scripture scripture,
    AppLocalizations l10n,
    String locale,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AbbaSpacing.md),
      decoration: BoxDecoration(
        color: AbbaColors.sage.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.todayVerse,
            style: AbbaTypography.caption.copyWith(
              color: AbbaColors.sage,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            '"${scripture.verse}"',
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.warmBrown,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AbbaSpacing.xs),
          Text(
            '— ${scripture.reference}',
            style: AbbaTypography.caption.copyWith(color: AbbaColors.muted),
          ),
        ],
      ),
    );
  }

  void _openPrayerDetail(Prayer prayer) {
    if (prayer.result == null) return;

    prayerLog.debug('Prayer detail opened: ${prayer.id}');
    ref.read(prayerResultProvider.notifier).state =
        AsyncValue.data(prayer.result!);
    context.push('/home/prayer-dashboard');
  }
}
