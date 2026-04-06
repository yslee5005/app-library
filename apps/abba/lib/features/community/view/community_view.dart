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
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(communityFilterProvider);
    final postsAsync = ref.watch(filteredCommunityPostsProvider);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.communityTitle} 🌻', style: AbbaTypography.h1),
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
                  isSelected: filter == 'all',
                  onTap: () =>
                      ref.read(communityFilterProvider.notifier).state = 'all',
                ),
                const SizedBox(width: AbbaSpacing.sm),
                _FilterChip(
                  label: l10n.filterTestimony,
                  isSelected: filter == 'testimony',
                  onTap: () =>
                      ref.read(communityFilterProvider.notifier).state =
                          'testimony',
                ),
                const SizedBox(width: AbbaSpacing.sm),
                _FilterChip(
                  label: l10n.filterPrayerRequest,
                  isSelected: filter == 'prayer_request',
                  onTap: () =>
                      ref.read(communityFilterProvider.notifier).state =
                          'prayer_request',
                ),
              ],
            ),
          ),
          // Posts list
          Expanded(
            child: postsAsync.when(
              data: (posts) {
                if (posts.isEmpty) {
                  return Center(
                    child: Text(
                      l10n.noPrayersRecorded,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredCommunityPostsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: posts.length,
                    itemBuilder: (context, index) =>
                        _PostCard(post: posts[index]),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
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

class _PostCard extends ConsumerStatefulWidget {
  final CommunityPost post;

  const _PostCard({required this.post});

  @override
  ConsumerState<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<_PostCard> {
  bool _expanded = false;
  late bool _isLiked;
  late bool _isSaved;
  late int _likeCount;
  final _commentController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToName;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isSaved = widget.post.isSaved;
    _likeCount = widget.post.likeCount;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
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
              // Header: avatar + name + time + overflow menu
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
                          style: AbbaTypography.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
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
                  // Overflow menu (report / delete)
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AbbaColors.muted,
                      size: 20,
                    ),
                    onSelected: (value) => _handleMenuAction(value, post, l10n),
                    itemBuilder: (context) {
                      final authState = ref.read(authStateProvider);
                      final isOwner = authState.user?.id == post.userId;
                      return [
                        if (isOwner)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                  color: AbbaColors.error,
                                ),
                                const SizedBox(width: AbbaSpacing.sm),
                                Text(l10n.deletePost),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'report',
                          child: Row(
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 18,
                                color: AbbaColors.muted,
                              ),
                              const SizedBox(width: AbbaSpacing.sm),
                              Text(l10n.reportPost),
                            ],
                          ),
                        ),
                      ];
                    },
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
                    onTap: _handleLike,
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
                    icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    label: '',
                    color: _isSaved ? AbbaColors.softGold : AbbaColors.muted,
                    onTap: _handleSave,
                  ),
                ],
              ),
              // Expanded: comments + input
              if (_expanded) ...[
                const Divider(height: AbbaSpacing.lg),
                // Comment list
                if (post.comments.isNotEmpty)
                  ...post.comments.map((comment) {
                    final isReply = comment.parentCommentId != null;
                    return _CommentWidget(
                      comment: comment,
                      isReply: isReply,
                      anonymousLabel: l10n.anonymous,
                      onReply: isReply
                          ? null
                          : () => setState(() {
                              _replyToCommentId = comment.id;
                              _replyToName =
                                  comment.displayName ?? l10n.anonymous;
                            }),
                      onDelete: () => _handleDeleteComment(comment.id),
                      isOwner:
                          ref.read(authStateProvider).user?.id ==
                          comment.userId,
                    );
                  }),
                const SizedBox(height: AbbaSpacing.sm),
                // Reply indicator
                if (_replyToCommentId != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AbbaSpacing.md,
                      vertical: AbbaSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AbbaColors.sage.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AbbaRadius.sm),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '↩️ $_replyToName',
                            style: AbbaTypography.caption.copyWith(
                              color: AbbaColors.sage,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            _replyToCommentId = null;
                            _replyToName = null;
                          }),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: AbbaColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Comment input
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: AbbaTypography.bodySmall,
                        decoration: InputDecoration(
                          hintText: l10n.commentButton,
                          hintStyle: AbbaTypography.bodySmall.copyWith(
                            color: AbbaColors.muted,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AbbaRadius.xl),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AbbaColors.cream,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AbbaSpacing.md,
                            vertical: AbbaSpacing.sm,
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: AbbaSpacing.sm),
                    GestureDetector(
                      onTap: () => _submitComment(post.id),
                      child: Container(
                        padding: const EdgeInsets.all(AbbaSpacing.sm),
                        decoration: BoxDecoration(
                          color: AbbaColors.sage,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.send,
                          size: 18,
                          color: AbbaColors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLike() async {
    final repo = ref.read(communityRepositoryProvider);
    final liked = await repo.toggleLike(widget.post.id);
    setState(() {
      _isLiked = liked;
      _likeCount += liked ? 1 : -1;
    });
  }

  Future<void> _handleSave() async {
    final repo = ref.read(communityRepositoryProvider);
    final saved = await repo.toggleSave(widget.post.id);
    setState(() {
      _isSaved = saved;
    });
  }

  Future<void> _submitComment(String postId) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final repo = ref.read(communityRepositoryProvider);
    final profile = ref.read(userProfileProvider).valueOrNull;

    await repo.createComment(
      postId: postId,
      content: text,
      displayName: profile?.name,
      parentCommentId: _replyToCommentId,
    );

    _commentController.clear();
    setState(() {
      _replyToCommentId = null;
      _replyToName = null;
    });

    // Refresh posts
    ref.invalidate(filteredCommunityPostsProvider);
  }

  Future<void> _handleDeleteComment(String commentId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.deleteComment(commentId);
    ref.invalidate(filteredCommunityPostsProvider);
  }

  void _handleMenuAction(
    String action,
    CommunityPost post,
    AppLocalizations l10n,
  ) {
    if (action == 'delete') {
      _showDeleteConfirm(post.id, l10n);
    } else if (action == 'report') {
      _showReportDialog(post.id, l10n);
    }
  }

  Future<void> _showDeleteConfirm(String postId, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle, style: AbbaTypography.h2),
        content: Text(l10n.deleteConfirmMessage, style: AbbaTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.deletePost,
              style: TextStyle(color: AbbaColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(communityRepositoryProvider);
      await repo.deletePost(postId);
      ref.invalidate(filteredCommunityPostsProvider);
    }
  }

  Future<void> _showReportDialog(String postId, AppLocalizations l10n) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('🚫', style: AbbaTypography.h2),
          content: TextField(
            controller: controller,
            style: AbbaTypography.body,
            decoration: InputDecoration(
              hintText: l10n.writePostHint,
              hintStyle: AbbaTypography.body.copyWith(color: AbbaColors.muted),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: Text(l10n.sharePostButton),
            ),
          ],
        );
      },
    );

    if (reason != null && reason.isNotEmpty) {
      final repo = ref.read(communityRepositoryProvider);
      await repo.reportPost(postId, reason);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.reportSubmitted)));
      }
    }
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
  final String anonymousLabel;
  final VoidCallback? onReply;
  final VoidCallback onDelete;
  final bool isOwner;

  const _CommentWidget({
    required this.comment,
    required this.isReply,
    required this.anonymousLabel,
    this.onReply,
    required this.onDelete,
    required this.isOwner,
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
                Row(
                  children: [
                    Text(
                      comment.displayName ?? anonymousLabel,
                      style: AbbaTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (isOwner)
                      GestureDetector(
                        onTap: onDelete,
                        child: Icon(
                          Icons.close,
                          size: 14,
                          color: AbbaColors.muted,
                        ),
                      ),
                  ],
                ),
                Text(comment.content, style: AbbaTypography.bodySmall),
                if (onReply != null)
                  GestureDetector(
                    onTap: onReply,
                    child: Padding(
                      padding: const EdgeInsets.only(top: AbbaSpacing.xs),
                      child: Text(
                        '↩️ ${AppLocalizations.of(context)!.replyButton}',
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
