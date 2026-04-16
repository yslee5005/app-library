import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';

/// Provider that loads prayers for a given month, filtered to mode == 'prayer'
final _prayerHistoryProvider =
    FutureProvider.autoDispose.family<List<Prayer>, ({int year, int month})>((
  ref,
  params,
) async {
  final repo = ref.watch(prayerRepositoryProvider);
  final all = await repo.getPrayersByMonth(params.year, params.month);
  return all.where((p) => p.mode == 'prayer').toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
});

class PrayerHistoryView extends ConsumerStatefulWidget {
  const PrayerHistoryView({super.key});

  @override
  ConsumerState<PrayerHistoryView> createState() => _PrayerHistoryViewState();
}

class _PrayerHistoryViewState extends ConsumerState<PrayerHistoryView> {
  late int _year;
  late int _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
  }

  void _previousMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    // Don't go beyond current month
    if (_year == now.year && _month >= now.month) return;
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final params = (year: _year, month: _month);
    final prayersAsync = ref.watch(_prayerHistoryProvider(params));

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          '기도 히스토리',
          style: AbbaTypography.h2,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Month navigator
          _buildMonthNavigator(),
          const SizedBox(height: AbbaSpacing.sm),
          // Prayer list
          Expanded(
            child: prayersAsync.when(
              data: (prayers) => prayers.isEmpty
                  ? _buildEmptyState()
                  : _buildPrayerList(prayers),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(
                child: Text(
                  '데이터를 불러올 수 없습니다',
                  style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthNavigator() {
    final now = DateTime.now();
    final isCurrentMonth = _year == now.year && _month == now.month;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(Icons.chevron_left, size: 28),
            color: AbbaColors.warmBrown,
          ),
          Text(
            '$_year년 $_month월',
            style: AbbaTypography.h2.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: isCurrentMonth ? null : _nextMonth,
            icon: Icon(
              Icons.chevron_right,
              size: 28,
              color: isCurrentMonth
                  ? AbbaColors.muted.withValues(alpha: 0.3)
                  : AbbaColors.warmBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🙏',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(
            '아직 기도 기록이 없습니다',
            style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerList(List<Prayer> prayers) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.sm,
      ),
      itemCount: prayers.length,
      separatorBuilder: (_, _) => const SizedBox(height: AbbaSpacing.sm),
      itemBuilder: (context, index) {
        final prayer = prayers[index];
        return _PrayerHistoryCard(prayer: prayer);
      },
    );
  }
}

class _PrayerHistoryCard extends ConsumerWidget {
  final Prayer prayer;

  const _PrayerHistoryCard({required this.prayer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = prayer.createdAt;
    final dateStr = _formatKoreanDate(date);
    final summary = _buildSummary(prayer);

    return GestureDetector(
      onTap: () {
        // Load this prayer's result into the provider, then navigate
        if (prayer.result != null) {
          ref.read(prayerResultProvider.notifier).state =
              AsyncValue.data(prayer.result!);
          context.push('/home/prayer-dashboard');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        decoration: BoxDecoration(
          color: AbbaColors.white,
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AbbaColors.warmBrown.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Date circle
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: AbbaTypography.h2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AbbaColors.sage,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AbbaSpacing.md),
            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateStr,
                    style: AbbaTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AbbaColors.warmBrown,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AbbaSpacing.xs),
                  Text(
                    summary,
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AbbaSpacing.sm),
            Icon(
              Icons.chevron_right,
              color: AbbaColors.muted.withValues(alpha: 0.5),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  String _formatKoreanDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    // DateTime.weekday: 1=Monday, 7=Sunday
    final weekday = weekdays[date.weekday - 1];
    return '${date.month}월 ${date.day}일 $weekday요일';
  }

  String _buildSummary(Prayer prayer) {
    if (prayer.result?.scripture != null) {
      final ref = prayer.result!.scripture.reference;
      return '말씀: $ref';
    }
    if (prayer.transcript.isNotEmpty) {
      final preview = prayer.transcript.length > 30
          ? '${prayer.transcript.substring(0, 30)}...'
          : prayer.transcript;
      return preview;
    }
    return '기도';
  }
}
