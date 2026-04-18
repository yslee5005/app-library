import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/post.dart';
import '../../../models/prayer.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';

class MyPageView extends ConsumerStatefulWidget {
  const MyPageView({super.key});

  @override
  ConsumerState<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends ConsumerState<MyPageView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(l10n.myPageTitle, style: AbbaTypography.h1),
      ),
      body: Column(
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AbbaColors.muted.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AbbaColors.warmBrown,
              unselectedLabelColor: AbbaColors.muted,
              indicatorColor: AbbaColors.sage,
              labelStyle: AbbaTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: [
                Tab(text: '\ud83d\ude4f ${l10n.myPrayers}'),
                Tab(text: '\ud83d\udcd6 QT'),
                Tab(text: '\ud83d\udd16 ${l10n.savedPosts}'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _PrayerListTab(mode: 'prayer'),
                _PrayerListTab(mode: 'qt'),
                _SavedPostsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Prayer / QT list tab (filtered by mode)
// ---------------------------------------------------------------------------

/// Provider: monthly prayers filtered by mode, sorted newest first.
final _monthlyPrayersByModeProvider = FutureProvider.autoDispose
    .family<List<Prayer>, ({int year, int month, String mode})>((ref, params) async {
  try {
    final repo = ref.watch(prayerRepositoryProvider);
    final all = await repo.getPrayersByMonth(params.year, params.month);
    prayerLog.debug('getPrayersByMonth returned ${all.length} items');
    final filtered = all.where((p) => p.mode == params.mode).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  } catch (e, st) {
    prayerLog.error('_monthlyPrayersByModeProvider failed: $e\n$st');
    rethrow;
  }
});

class _PrayerListTab extends ConsumerWidget {
  final String mode; // 'prayer' or 'qt'

  const _PrayerListTab({required this.mode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final prayersAsync = ref.watch(
      _monthlyPrayersByModeProvider((year: now.year, month: now.month, mode: mode)),
    );

    return prayersAsync.when(
      data: (prayers) {
        prayerLog.debug('History $mode tab: ${prayers.length} items found');
        if (prayers.isEmpty) {
          return Center(
            child: Text(
              l10n.noPrayersRecorded,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          itemCount: prayers.length,
          itemBuilder: (context, index) =>
              _PrayerItemCard(prayer: prayers[index], locale: locale),
        );
      },
      loading: () {
        prayerLog.debug('History $mode tab: loading...');
        return const Center(child: CircularProgressIndicator());
      },
      error: (e, st) {
        prayerLog.error('History $mode tab error: $e');
        return Center(
          child: Text(l10n.errorGeneric,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted)),
        );
      },
    );
  }
}

class _PrayerItemCard extends ConsumerWidget {
  final Prayer prayer;
  final String locale;

  const _PrayerItemCard({required this.prayer, required this.locale});

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormat = DateFormat.yMMMd(locale);
    final timeFormat = DateFormat.jm(locale);
    final isQt = prayer.mode == 'qt';

    return GestureDetector(
      onTap: () {
        if (prayer.result != null) {
          ref.read(prayerResultProvider.notifier).state =
              AsyncValue.data(prayer.result!);
          prayerLog.info('History item tapped: ${prayer.id}, navigating to dashboard');
          context.push('/home/prayer-dashboard');
        } else {
          prayerLog.warning('History item tapped: ${prayer.id}, but no result available');
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          decoration: BoxDecoration(
            color: AbbaColors.white,
            borderRadius: BorderRadius.circular(AbbaRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date + time row
              Row(
                children: [
                  Text(
                    dateFormat.format(prayer.createdAt),
                    style: AbbaTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  Text(
                    timeFormat.format(prayer.createdAt),
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.muted,
                    ),
                  ),
                  const Spacer(),
                  // Duration badge
                  if (prayer.durationSeconds > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AbbaSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isQt ? AbbaColors.softGold : AbbaColors.sage)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AbbaRadius.sm),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer_outlined,
                            size: 14,
                            color: isQt ? AbbaColors.softGold : AbbaColors.sage,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _formatDuration(prayer.durationSeconds),
                            style: AbbaTypography.caption.copyWith(
                              color: isQt
                                  ? AbbaColors.softGold
                                  : AbbaColors.sage,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              // QT passage reference
              if (isQt && prayer.qtPassageRef != null) ...[
                const SizedBox(height: AbbaSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.menu_book_outlined,
                        size: 14, color: AbbaColors.softGold),
                    const SizedBox(width: AbbaSpacing.xs),
                    Expanded(
                      child: Text(
                        prayer.qtPassageRef!,
                        style: AbbaTypography.bodySmall.copyWith(
                          color: AbbaColors.softGold,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AbbaSpacing.xs),
              // Transcript preview
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prayer.transcript,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (prayer.audioStoragePath != null)
                    Padding(
                      padding: const EdgeInsets.only(right: AbbaSpacing.xs),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: 16,
                        color: AbbaColors.sage.withValues(alpha: 0.6),
                      ),
                    ),
                  if (prayer.result != null)
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AbbaColors.muted.withValues(alpha: 0.4),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Saved Posts tab
// ---------------------------------------------------------------------------
class _SavedPostsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(savedPostsProvider);

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text(
              l10n.noPrayersRecorded,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          itemCount: posts.length,
          itemBuilder: (context, index) => _PostTile(
            post: posts[index],
            onTap: () => context.push(
              '/home/my-records/testimony',
              extra: posts[index],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, st) => Center(
        child: Text(l10n.errorGeneric,
            style: AbbaTypography.body.copyWith(color: AbbaColors.muted)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Post tile (used in My Testimonies and Saved)
// ---------------------------------------------------------------------------
class _PostTile extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback? onTap;

  const _PostTile({required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AbbaSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          decoration: BoxDecoration(
            color: AbbaColors.white,
            borderRadius: BorderRadius.circular(AbbaRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AbbaSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: post.category == 'testimony'
                          ? AbbaColors.softPink.withValues(alpha: 0.3)
                          : AbbaColors.softSky.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AbbaRadius.sm),
                    ),
                    child: Text(
                      post.category == 'testimony'
                          ? l10n.filterTestimony
                          : l10n.filterPrayerRequest,
                      style: AbbaTypography.caption,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(post.createdAt),
                    style: AbbaTypography.caption,
                  ),
                ],
              ),
              const SizedBox(height: AbbaSpacing.sm),
              Text(
                post.content,
                style: AbbaTypography.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AbbaSpacing.sm),
              Row(
                children: [
                  Icon(Icons.favorite, size: 14, color: AbbaColors.error),
                  const SizedBox(width: AbbaSpacing.xs),
                  Text('${post.likeCount}', style: AbbaTypography.caption),
                  const SizedBox(width: AbbaSpacing.md),
                  Icon(Icons.chat_bubble_outline,
                      size: 14, color: AbbaColors.muted),
                  const SizedBox(width: AbbaSpacing.xs),
                  Text('${post.commentCount}', style: AbbaTypography.caption),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: AbbaColors.muted.withValues(alpha: 0.4),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }
}
