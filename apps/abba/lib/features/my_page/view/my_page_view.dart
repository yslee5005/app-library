import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/post.dart';
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
    final profileAsync = ref.watch(userProfileProvider);
    final streakAsync = ref.watch(streakProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(l10n.myPageTitle, style: AbbaTypography.h1),
      ),
      body: Column(
        children: [
          // Profile section
          profileAsync.when(
            data: (profile) {
              final streak = streakAsync.value;
              return Padding(
                padding: const EdgeInsets.all(AbbaSpacing.md),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          AbbaColors.sage.withValues(alpha: 0.2),
                      child: Text(
                        profile.name.isNotEmpty
                            ? profile.name[0].toUpperCase()
                            : '?',
                        style: AbbaTypography.hero.copyWith(
                          color: AbbaColors.sage,
                        ),
                      ),
                    ),
                    const SizedBox(height: AbbaSpacing.sm),
                    // Name
                    Text(profile.name, style: AbbaTypography.h1),
                    Text(
                      profile.email,
                      style: AbbaTypography.bodySmall.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                    const SizedBox(height: AbbaSpacing.md),
                    // 3-column stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _StatColumn(
                          value: '${profile.totalPrayers}',
                          label: l10n.totalPrayersCount,
                        ),
                        _StatColumn(
                          value: '${streak?.current ?? profile.currentStreak}',
                          label: l10n.streakCount,
                        ),
                        _StatColumn(
                          value: '0', // Testimony count placeholder
                          label: l10n.testimoniesCount,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox(
              height: 200,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, st) => const SizedBox.shrink(),
          ),

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
                Tab(text: '\u270d\ufe0f ${l10n.myTestimonies}'),
                Tab(text: '\ud83d\udd16 ${l10n.savedPosts}'),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _MyPrayersTab(),
                _MyTestimoniesTab(),
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
// Stat column for profile
// ---------------------------------------------------------------------------
class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AbbaTypography.h1.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AbbaSpacing.xs),
        Text(
          label,
          style: AbbaTypography.caption,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// My Prayers tab
// ---------------------------------------------------------------------------
class _MyPrayersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    // Use current month prayers
    final now = DateTime.now();
    final prayersAsync = ref.watch(
      monthlyPrayerDaysProvider((year: now.year, month: now.month)),
    );

    return prayersAsync.when(
      data: (prayerDays) {
        if (prayerDays.isEmpty) {
          return Center(
            child: Text(
              l10n.noPrayersRecorded,
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
          );
        }
        final sortedDays = prayerDays.toList()
          ..sort((a, b) => b.compareTo(a));
        return ListView.builder(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          itemCount: sortedDays.length,
          itemBuilder: (context, index) {
            final day = sortedDays[index];
            return _PrayerDayTile(date: day);
          },
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

class _PrayerDayTile extends ConsumerWidget {
  final DateTime date;

  const _PrayerDayTile({required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayersAsync = ref.watch(calendarPrayersProvider(date));

    return prayersAsync.when(
      data: (prayers) {
        if (prayers.isEmpty) return const SizedBox.shrink();
        return Padding(
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
                Text(
                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                  style: AbbaTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AbbaSpacing.xs),
                ...prayers.map(
                  (p) => GestureDetector(
                    onTap: () {
                      if (p.result != null) {
                        ref.read(prayerResultProvider.notifier).state =
                            AsyncValue.data(p.result!);
                        context.push('/home/prayer-dashboard');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AbbaSpacing.xs),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.transcript.length > 80
                                  ? '${p.transcript.substring(0, 80)}...'
                                  : p.transcript,
                              style: AbbaTypography.bodySmall.copyWith(
                                color: AbbaColors.muted,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (p.result != null)
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AbbaColors.muted.withValues(alpha: 0.4),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, st) => const SizedBox.shrink(),
    );
  }
}

// ---------------------------------------------------------------------------
// My Testimonies tab
// ---------------------------------------------------------------------------
class _MyTestimoniesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(myPostsProvider);

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
          itemBuilder: (context, index) =>
              _PostTile(post: posts[index]),
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
          itemBuilder: (context, index) =>
              _PostTile(post: posts[index]),
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

  const _PostTile({required this.post});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }
}
