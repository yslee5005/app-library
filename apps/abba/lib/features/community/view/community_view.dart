import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/post.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';

class CommunityView extends ConsumerStatefulWidget {
  const CommunityView({super.key});

  @override
  ConsumerState<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends ConsumerState<CommunityView> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final postsAsync = ref.watch(communityPostsProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text(
          '${l10n.communityTitle} 🌻',
          style: AbbaTypography.h1,
        ),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AbbaSpacing.md,
              vertical: AbbaSpacing.sm,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: l10n.filterAll,
                  isSelected: _selectedFilter == 'all',
                  onTap: () => setState(() => _selectedFilter = 'all'),
                ),
                const SizedBox(width: AbbaSpacing.sm),
                _FilterChip(
                  label: l10n.filterTestimony,
                  isSelected: _selectedFilter == 'testimony',
                  onTap: () => setState(() => _selectedFilter = 'testimony'),
                ),
                const SizedBox(width: AbbaSpacing.sm),
                _FilterChip(
                  label: l10n.filterPrayerRequest,
                  isSelected: _selectedFilter == 'prayer_request',
                  onTap: () =>
                      setState(() => _selectedFilter = 'prayer_request'),
                ),
              ],
            ),
          ),
          // Posts list
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                final filtered = _selectedFilter == 'all'
                    ? posts
                    : posts
                        .where((p) => p.category == _selectedFilter)
                        .toList();
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _PostCard(post: filtered[index]),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/community/write'),
        backgroundColor: AbbaColors.sage,
        child: const Text('✏️', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.md,
          vertical: AbbaSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AbbaColors.sage : AbbaColors.white,
          borderRadius: BorderRadius.circular(AbbaRadius.xl),
          border: Border.all(
            color: isSelected ? AbbaColors.sage : AbbaColors.muted,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AbbaTypography.bodySmall.copyWith(
            color: isSelected ? AbbaColors.white : AbbaColors.warmBrown,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  final CommunityPost post;

  const _PostCard({required this.post});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _expanded = false;
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _likeCount = widget.post.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AbbaSpacing.md,
        vertical: AbbaSpacing.sm,
      ),
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
      child: InkWell(
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: avatar + name + time
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AbbaColors.sage.withValues(alpha: 0.2),
                    child: Text(
                      post.displayName != null
                          ? post.displayName![0].toUpperCase()
                          : '🌿',
                      style: AbbaTypography.body,
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.displayName ?? l10n.anonymous,
                          style: AbbaTypography.body
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _formatTime(post.createdAt),
                          style: AbbaTypography.caption,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AbbaSpacing.sm,
                      vertical: AbbaSpacing.xs,
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
                      style: AbbaTypography.caption.copyWith(
                        color: AbbaColors.warmBrown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AbbaSpacing.md),
              // Content
              Text(
                post.content,
                style: AbbaTypography.body,
                maxLines: _expanded ? null : 3,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),
              const SizedBox(height: AbbaSpacing.md),
              // Action buttons
              Row(
                children: [
                  _ActionButton(
                    icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                    label: '$_likeCount',
                    color: _isLiked ? AbbaColors.error : AbbaColors.muted,
                    onTap: () {
                      setState(() {
                        _isLiked = !_isLiked;
                        _likeCount += _isLiked ? 1 : -1;
                      });
                    },
                  ),
                  const SizedBox(width: AbbaSpacing.lg),
                  _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: '${post.commentCount}',
                    color: AbbaColors.muted,
                    onTap: () => setState(() => _expanded = !_expanded),
                  ),
                  const SizedBox(width: AbbaSpacing.lg),
                  _ActionButton(
                    icon: post.isSaved
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    label: '',
                    color:
                        post.isSaved ? AbbaColors.softGold : AbbaColors.muted,
                    onTap: () {},
                  ),
                ],
              ),
              // Comments (expanded)
              if (_expanded && post.comments.isNotEmpty) ...[
                const Divider(height: AbbaSpacing.lg),
                ...post.comments.map((comment) => _CommentWidget(
                      comment: comment,
                      isReply: comment.parentCommentId != null,
                      replyLabel: l10n.replyButton,
                      anonymousLabel: l10n.anonymous,
                    )),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: color),
          if (label.isNotEmpty) ...[
            const SizedBox(width: AbbaSpacing.xs),
            Text(label, style: AbbaTypography.bodySmall.copyWith(color: color)),
          ],
        ],
      ),
    );
  }
}

class _CommentWidget extends StatelessWidget {
  final Comment comment;
  final bool isReply;
  final String replyLabel;
  final String anonymousLabel;

  const _CommentWidget({
    required this.comment,
    required this.isReply,
    required this.replyLabel,
    required this.anonymousLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? AbbaSpacing.xl : 0,
        bottom: AbbaSpacing.sm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AbbaColors.sage.withValues(alpha: 0.15),
            child: Text(
              comment.displayName != null
                  ? comment.displayName![0].toUpperCase()
                  : '🌿',
              style: AbbaTypography.caption,
            ),
          ),
          const SizedBox(width: AbbaSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.displayName ?? anonymousLabel,
                  style: AbbaTypography.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(comment.content, style: AbbaTypography.bodySmall),
                if (!isReply)
                  GestureDetector(
                    onTap: () {},
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: AbbaSpacing.xs),
                      child: Text(
                        '↩️ $replyLabel',
                        style: AbbaTypography.caption.copyWith(
                          color: AbbaColors.sage,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
