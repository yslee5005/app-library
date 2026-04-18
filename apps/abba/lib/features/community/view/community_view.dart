import 'dart:async';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final _scrollController = ScrollController();
  final List<CommunityPost> _posts = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _cursor;
  bool _initialLoaded = false;

  bool _isLoadingInitial = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final repo = ref.read(communityRepositoryProvider);
    final filter = ref.read(communityFilterProvider);
    final newPosts = await repo.getPosts(
      category: filter == 'all' ? null : filter,
      cursor: _cursor,
      limit: 20,
    );

    if (!mounted) return;
    setState(() {
      _posts.addAll(newPosts);
      _cursor = newPosts.isNotEmpty
          ? newPosts.last.createdAt.toIso8601String()
          : null;
      _hasMore = newPosts.length >= 20;
      _isLoadingMore = false;
    });
    communityLog.debug('Loaded ${newPosts.length} more posts, cursor=$_cursor');
  }

  Future<void> _loadInitial() async {
    if (_isLoadingInitial) return;
    _isLoadingInitial = true;

    final repo = ref.read(communityRepositoryProvider);
    final filter = ref.read(communityFilterProvider);
    final posts = await repo.getPosts(
      category: filter == 'all' ? null : filter,
      limit: 20,
    );
    if (!mounted) return;
    setState(() {
      _posts.clear();
      _posts.addAll(posts);
      _cursor =
          posts.isNotEmpty ? posts.last.createdAt.toIso8601String() : null;
      _hasMore = posts.length >= 20;
      _initialLoaded = true;
      _isLoadingInitial = false;
    });
    communityLog.info('Loaded ${posts.length} posts, filter=$filter');
  }

  Future<void> _refresh() async {
    setState(() {
      _posts.clear();
      _cursor = null;
      _hasMore = true;
      _initialLoaded = false;
      _isLoadingInitial = false;
    });
    await _loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filter = ref.watch(communityFilterProvider);

    // Reload when filter changes
    ref.listen(communityFilterProvider, (prev, next) {
      if (prev != next) _refresh();
    });

    // Show loading state until initial load completes
    if (!_initialLoaded) {
      return Scaffold(
        backgroundColor: AbbaColors.cream,
        appBar: AppBar(
          title: Text('${l10n.communityTitle} \ud83c\udf3b', style: AbbaTypography.h1),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        title: Text('${l10n.communityTitle} \ud83c\udf3b', style: AbbaTypography.h1),
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
          // Posts list — Instagram style full-width feed
          Expanded(
            child: _posts.isEmpty
                ? Center(
                    child: Text(
                      l10n.noPrayersRecorded,
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.muted,
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 80),
                      itemCount: _posts.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _posts.length) {
                          return const Padding(
                            padding: EdgeInsets.all(AbbaSpacing.md),
                            child:
                                Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _PostItem(
                          post: _posts[index],
                          onRefresh: _refresh,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push<bool>('/community/write');
          if (result == true) _refresh();
        },
        backgroundColor: AbbaColors.sageDark,
        child: const Text('\u270f\ufe0f', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter chip
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
// Facebook-style post card (rounded card with shadow)
// ---------------------------------------------------------------------------
class _PostItem extends ConsumerStatefulWidget {
  final CommunityPost post;
  final VoidCallback onRefresh;

  const _PostItem({required this.post, required this.onRefresh});

  @override
  ConsumerState<_PostItem> createState() => _PostItemState();
}

class _PostItemState extends ConsumerState<_PostItem> {
  late bool _isLiked;
  late bool _isSaved;
  late int _likeCount;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post.isLiked;
    _isSaved = widget.post.isSaved;
    _likeCount = widget.post.likeCount;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final post = widget.post;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Facebook-style card ──
        Container(
          margin: const EdgeInsets.symmetric(horizontal: AbbaSpacing.md, vertical: 6),
          decoration: BoxDecoration(
            color: AbbaColors.white,
            borderRadius: BorderRadius.circular(AbbaRadius.lg), // 16px
            boxShadow: [
              BoxShadow(
                color: AbbaColors.warmBrown.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GestureDetector(
            onDoubleTap: () {
              if (!_isLiked) _handleLike();
              setState(() => _showHeartAnimation = true);
              Future.delayed(const Duration(milliseconds: 800), () {
                if (mounted) setState(() => _showHeartAnimation = false);
              });
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AbbaSpacing.md), // 16px
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header row ──
                      Row(
                        children: [
                          // Avatar circle 40px
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AbbaColors.sage.withValues(alpha: 0.2),
                            child: Text(
                              (post.displayName != null && post.displayName!.isNotEmpty)
                                  ? post.displayName![0].toUpperCase()
                                  : '\ud83c\udf3f',
                              style: AbbaTypography.bodySmall,
                            ),
                          ),
                          const SizedBox(width: AbbaSpacing.sm),
                          // Name + category + time column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name row with category pill
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        post.displayName ?? l10n.anonymous,
                                        style: AbbaTypography.body.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: AbbaSpacing.sm),
                                    // Category badge pill
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: post.category == 'testimony'
                                            ? AbbaColors.sage.withValues(alpha: 0.15)
                                            : AbbaColors.softGold.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        post.category == 'testimony'
                                            ? l10n.filterTestimony
                                            : l10n.filterPrayerRequest,
                                        style: AbbaTypography.caption.copyWith(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: post.category == 'testimony'
                                              ? AbbaColors.sage
                                              : AbbaColors.softGold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                // Time
                                Text(
                                  _formatTime(post.createdAt),
                                  style: AbbaTypography.caption.copyWith(
                                    color: AbbaColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Overflow menu (keep existing)
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_horiz, color: AbbaColors.muted, size: 20),
                            padding: EdgeInsets.zero,
                            onSelected: (value) => _handleMenuAction(value, post, l10n),
                            itemBuilder: (context) {
                              final currentUser = ref.read(currentUserProvider);
                              final isOwner = currentUser?.id == post.userId;
                              return [
                                if (isOwner)
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline,
                                            size: 18, color: AbbaColors.error),
                                        const SizedBox(width: AbbaSpacing.sm),
                                        Text(l10n.deletePost),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem(
                                  value: 'report',
                                  child: Row(
                                    children: [
                                      Icon(Icons.flag_outlined,
                                          size: 18, color: AbbaColors.muted),
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

                      // ── Content ──
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _ExpandableText(
                          text: post.content,
                          maxLines: 4,
                          seeMoreLabel: l10n.seeMore,
                        ),
                      ),

                      // ── Like summary line (only if likeCount > 0) ──
                      if (_likeCount > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            l10n.likedByCount(_likeCount),
                            style: AbbaTypography.bodySmall.copyWith(
                              color: AbbaColors.muted,
                            ),
                          ),
                        ),

                      // ── Thin divider ──
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: AbbaColors.warmBrown.withValues(alpha: 0.1),
                        ),
                      ),

                      // ── Action buttons row (3 equal buttons) ──
                      Row(
                        children: [
                          // Like button
                          Expanded(
                            child: _CardActionButton(
                              icon: _isLiked ? Icons.favorite : Icons.favorite_border,
                              label: l10n.actionLike,
                              color: _isLiked ? AbbaColors.error : AbbaColors.muted,
                              onTap: _handleLike,
                            ),
                          ),
                          // Comment button
                          Expanded(
                            child: _CardActionButton(
                              icon: Icons.chat_bubble_outline,
                              label: l10n.actionComment,
                              color: AbbaColors.muted,
                              onTap: () => _showCommentsSheet(context, post, l10n),
                            ),
                          ),
                          // Save button
                          Expanded(
                            child: _CardActionButton(
                              icon: _isSaved ? Icons.bookmark : Icons.bookmark_border,
                              label: l10n.actionSave,
                              color: _isSaved ? AbbaColors.softGold : AbbaColors.muted,
                              onTap: _handleSave,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Heart animation overlay (double-tap)
                if (_showHeartAnimation)
                  Positioned.fill(
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) => Opacity(
                          opacity: value > 0.5 ? 2 - value * 2 : value * 2,
                          child: Transform.scale(
                            scale: 0.5 + value * 0.5,
                            child: Icon(Icons.favorite,
                                size: 80, color: AbbaColors.error),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Comments only via bottom sheet (tap 💬 댓글 button)
      ],
    );
  }

  Future<void> _handleLike() async {
    final repo = ref.read(communityRepositoryProvider);
    final liked = await repo.toggleLike(widget.post.id);
    if (!mounted) return;
    setState(() {
      _isLiked = liked;
      _likeCount += liked ? 1 : -1;
    });
    communityLog.info('Post ${widget.post.id} ${liked ? "liked" : "unliked"}');
  }

  Future<void> _handleSave() async {
    final repo = ref.read(communityRepositoryProvider);
    final saved = await repo.toggleSave(widget.post.id);
    if (!mounted) return;
    setState(() => _isSaved = saved);
    communityLog.info('Post ${widget.post.id} ${saved ? "saved" : "unsaved"}');
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

  Future<void> _showDeleteConfirm(
      String postId, AppLocalizations l10n) async {
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
      communityLog.info('Post $postId deleted');
      widget.onRefresh();
    }
  }

  Future<void> _showReportDialog(
      String postId, AppLocalizations l10n) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
          ),
          title: Row(
            children: [
              const Text('🚨', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(l10n.reportPost, style: AbbaTypography.h2),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.reportReasonHint,
                style: AbbaTypography.bodySmall.copyWith(color: AbbaColors.muted),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              TextField(
                controller: controller,
                style: AbbaTypography.body,
                decoration: InputDecoration(
                  hintText: l10n.reportReasonPlaceholder,
                  hintStyle:
                      AbbaTypography.body.copyWith(color: AbbaColors.muted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.md),
                  ),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: Text(
                l10n.reportSubmitButton,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (reason != null && reason.isNotEmpty) {
      // Send report via email
      final uri = Uri(
        scheme: 'mailto',
        path: 'ystech5005@gmail.com',
        queryParameters: {
          'subject': '[Abba] Post Report: $postId',
          'body': 'Post ID: $postId\nReason: $reason',
        },
      );
      await launchUrl(uri);
      communityLog.info('Post $postId reported');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.reportSubmitted)),
        );
      }
    }
  }

  void _showCommentsSheet(
    BuildContext context,
    CommunityPost post,
    AppLocalizations l10n,
  ) {
    communityLog.debug('Comments sheet opened for post ${post.id}');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AbbaColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AbbaRadius.lg)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (ctx, scrollController) => _CommentsSheet(
          post: post,
          scrollController: scrollController,
          onRefresh: widget.onRefresh,
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

// ---------------------------------------------------------------------------
// Expandable text with "See more"
// ---------------------------------------------------------------------------
class _ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final String seeMoreLabel;

  const _ExpandableText({
    required this.text,
    required this.maxLines,
    required this.seeMoreLabel,
  });

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(
          text: widget.text,
          style: AbbaTypography.body,
        );
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final isOverflow = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: AbbaTypography.body,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (isOverflow && !_expanded)
              GestureDetector(
                onTap: () => setState(() => _expanded = true),
                child: Padding(
                  padding: const EdgeInsets.only(top: AbbaSpacing.xs),
                  child: Text(
                    widget.seeMoreLabel,
                    style: AbbaTypography.bodySmall.copyWith(
                      color: AbbaColors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Comments bottom sheet — Instagram-style threaded view
// ---------------------------------------------------------------------------
class _CommentsSheet extends ConsumerStatefulWidget {
  final CommunityPost post;
  final ScrollController scrollController;
  final VoidCallback onRefresh;

  const _CommentsSheet({
    required this.post,
    required this.scrollController,
    required this.onRefresh,
  });

  @override
  ConsumerState<_CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<_CommentsSheet> {
  final _commentController = TextEditingController();
  String? _replyToCommentId;
  String? _replyToName;

  // Pagination state
  final List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _cursor;
  static const _pageSize = 20;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
    _loadComments();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _commentController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _loadComments() async {
    final repo = ref.read(communityRepositoryProvider);
    final comments = await repo.getComments(
      widget.post.id,
      limit: _pageSize,
    );
    if (!mounted) return;
    setState(() {
      _comments.clear();
      _comments.addAll(comments);
      _cursor = comments.isNotEmpty
          ? comments.last.createdAt.toIso8601String()
          : null;
      _hasMore = comments.length >= _pageSize;
      _isLoading = false;
    });
    communityLog.debug('Loaded ${comments.length} comments for post ${widget.post.id}');
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;
    setState(() => _isLoadingMore = true);

    final repo = ref.read(communityRepositoryProvider);
    final newComments = await repo.getComments(
      widget.post.id,
      cursor: _cursor,
      limit: _pageSize,
    );
    if (!mounted) return;
    setState(() {
      _comments.addAll(newComments);
      _cursor = newComments.isNotEmpty
          ? newComments.last.createdAt.toIso8601String()
          : null;
      _hasMore = newComments.length >= _pageSize;
      _isLoadingMore = false;
    });
    communityLog.debug('Loaded ${newComments.length} more comments');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final post = widget.post;

    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: AbbaSpacing.sm),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AbbaColors.muted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Title
        Padding(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          child: Text(l10n.commentsTitle, style: AbbaTypography.h2),
        ),
        const Divider(height: 1),
        // Threaded comment list
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _comments.isEmpty
                  ? Center(
                      child: Text(
                        l10n.commentButton,
                        style: AbbaTypography.body.copyWith(
                          color: AbbaColors.muted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: widget.scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AbbaSpacing.md,
                        vertical: AbbaSpacing.sm,
                      ),
                      itemCount:
                          _comments.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _comments.length) {
                          return const Padding(
                            padding: EdgeInsets.all(AbbaSpacing.md),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }
                        final comment = _comments[index];
                        return _ThreadedCommentTile(
                          comment: comment,
                          isReply: false,
                          anonymousLabel: l10n.anonymous,
                          onReply: () => setState(() {
                            _replyToCommentId = comment.id;
                            _replyToName =
                                comment.displayName ?? l10n.anonymous;
                          }),
                          onDelete: () =>
                              _handleDeleteComment(comment.id),
                          isOwner: ref.read(currentUserProvider)?.id ==
                              comment.userId,
                          onCommentLike: (id) =>
                              _handleCommentLike(id),
                        );
                      },
                    ),
        ),
        // Reply indicator
        if (_replyToCommentId != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AbbaSpacing.md,
              vertical: AbbaSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AbbaColors.sage.withValues(alpha: 0.1),
              border: Border(
                top: BorderSide(
                  color: AbbaColors.sage.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.reply, size: 16, color: AbbaColors.sage),
                const SizedBox(width: AbbaSpacing.xs),
                Expanded(
                  child: Text(
                    l10n.replyingTo(_replyToName ?? ''),
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.sage,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _replyToCommentId = null;
                    _replyToName = null;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(AbbaSpacing.xs),
                    child:
                        Icon(Icons.close, size: 18, color: AbbaColors.muted),
                  ),
                ),
              ],
            ),
          ),
        // Comment input (fixed at bottom)
        Container(
          padding: const EdgeInsets.all(AbbaSpacing.md),
          decoration: BoxDecoration(
            color: AbbaColors.white,
            border: Border(
              top: BorderSide(
                color: AbbaColors.muted.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
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
                    decoration: const BoxDecoration(
                      color: AbbaColors.sage,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 18,
                      color: AbbaColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitComment(String postId) async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final repo = ref.read(communityRepositoryProvider);
    final profile = ref.read(userProfileProvider).value;

    final newComment = await repo.createComment(
      postId: postId,
      content: text,
      displayName: profile?.name,
      parentCommentId: _replyToCommentId,
    );

    _commentController.clear();

    if (_replyToCommentId != null) {
      // Optimistic: append reply under the parent comment
      final parentIndex =
          _comments.indexWhere((c) => c.id == _replyToCommentId);
      if (parentIndex != -1) {
        final parent = _comments[parentIndex];
        _comments[parentIndex] = parent.copyWith(
          replies: [...parent.replies, newComment],
        );
      }
    } else {
      // Optimistic: prepend top-level comment
      _comments.insert(0, newComment);
    }

    communityLog.info('Comment added to post $postId${_replyToCommentId != null ? " (reply to $_replyToCommentId)" : ""}');

    setState(() {
      _replyToCommentId = null;
      _replyToName = null;
    });
    widget.onRefresh();
  }

  Future<void> _handleDeleteComment(String commentId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.deleteComment(commentId);
    communityLog.info('Comment $commentId deleted');
    setState(() {
      _comments.removeWhere((c) => c.id == commentId);
    });
    widget.onRefresh();
  }

  Future<void> _handleCommentLike(String commentId) async {
    final repo = ref.read(communityRepositoryProvider);
    await repo.toggleCommentLike(commentId);
    communityLog.debug('Comment $commentId like toggled');

    // Optimistic toggle in local state
    setState(() {
      for (int i = 0; i < _comments.length; i++) {
        if (_comments[i].id == commentId) {
          final c = _comments[i];
          final nowLiked = !c.isLiked;
          _comments[i] = c.copyWith(
            isLiked: nowLiked,
            likeCount: c.likeCount + (nowLiked ? 1 : -1),
          );
          return;
        }
        // Check replies
        final replies = _comments[i].replies;
        for (int j = 0; j < replies.length; j++) {
          if (replies[j].id == commentId) {
            final r = replies[j];
            final nowLiked = !r.isLiked;
            final updatedReplies = List<Comment>.from(replies);
            updatedReplies[j] = r.copyWith(
              isLiked: nowLiked,
              likeCount: r.likeCount + (nowLiked ? 1 : -1),
            );
            _comments[i] = _comments[i].copyWith(replies: updatedReplies);
            return;
          }
        }
      }
    });
  }
}

// ---------------------------------------------------------------------------
// Threaded comment tile — supports top-level + nested replies
// ---------------------------------------------------------------------------
class _ThreadedCommentTile extends StatefulWidget {
  final Comment comment;
  final bool isReply;
  final String anonymousLabel;
  final VoidCallback? onReply;
  final VoidCallback onDelete;
  final bool isOwner;
  final ValueChanged<String> onCommentLike;

  const _ThreadedCommentTile({
    required this.comment,
    required this.isReply,
    required this.anonymousLabel,
    this.onReply,
    required this.onDelete,
    required this.isOwner,
    required this.onCommentLike,
  });

  @override
  State<_ThreadedCommentTile> createState() => _ThreadedCommentTileState();
}

class _ThreadedCommentTileState extends State<_ThreadedCommentTile> {
  bool _showReplies = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final comment = widget.comment;
    final avatarRadius = widget.isReply ? 12.0 : 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The comment itself
        Padding(
          padding: EdgeInsets.only(
            left: widget.isReply ? 40.0 : 0,
            bottom: AbbaSpacing.sm,
          ),
          child: Container(
            decoration: widget.isReply
                ? BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AbbaColors.sage.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                  )
                : null,
            padding: widget.isReply
                ? const EdgeInsets.only(left: AbbaSpacing.sm)
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: AbbaColors.sage.withValues(alpha: 0.15),
                  child: Text(
                    (comment.displayName != null &&
                            comment.displayName!.isNotEmpty)
                        ? comment.displayName![0].toUpperCase()
                        : '\ud83c\udf3f',
                    style: AbbaTypography.caption.copyWith(
                      fontSize: widget.isReply ? 10 : 12,
                    ),
                  ),
                ),
                const SizedBox(width: AbbaSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row: name · time · (heart like) · (delete)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              comment.displayName ?? widget.anonymousLabel,
                              style: AbbaTypography.bodySmall.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: widget.isReply ? 15 : 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AbbaSpacing.xs),
                          Text(
                            _formatTime(comment.createdAt),
                            style: AbbaTypography.caption,
                          ),
                          const Spacer(),
                          // Comment like button
                          GestureDetector(
                            onTap: () =>
                                widget.onCommentLike(comment.id),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    comment.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 14,
                                    color: comment.isLiked
                                        ? AbbaColors.error
                                        : AbbaColors.muted,
                                  ),
                                  if (comment.likeCount > 0) ...[
                                    const SizedBox(width: 2),
                                    Text(
                                      '${comment.likeCount}',
                                      style: AbbaTypography.caption.copyWith(
                                        fontSize: 12,
                                        color: comment.isLiked
                                            ? AbbaColors.error
                                            : AbbaColors.muted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          if (widget.isOwner)
                            GestureDetector(
                              onTap: widget.onDelete,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AbbaSpacing.xs),
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: AbbaColors.muted,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      // Comment content
                      Text(
                        comment.content,
                        style: AbbaTypography.bodySmall.copyWith(
                          fontSize: widget.isReply ? 15 : 16,
                        ),
                      ),
                      // Reply button (only for top-level comments)
                      if (widget.onReply != null)
                        GestureDetector(
                          onTap: widget.onReply,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: AbbaSpacing.xs),
                            child: Text(
                              l10n.replyButton,
                              style: AbbaTypography.caption.copyWith(
                                color: AbbaColors.sage,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Nested replies toggle and list
        if (!widget.isReply && comment.replies.isNotEmpty) ...[
          // Show/hide replies toggle
          GestureDetector(
            onTap: () => setState(() => _showReplies = !_showReplies),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40.0 + AbbaSpacing.sm,
                bottom: AbbaSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 1,
                    color: AbbaColors.muted.withValues(alpha: 0.3),
                  ),
                  const SizedBox(width: AbbaSpacing.xs),
                  Text(
                    _showReplies
                        ? l10n.hideReplies
                        : l10n.showReplies(comment.replies.length),
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.sage,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show replies (max 2 initially when expanded, all when fully expanded)
          if (_showReplies)
            ...comment.replies.map(
              (reply) => _ThreadedCommentTile(
                comment: reply,
                isReply: true,
                anonymousLabel: widget.anonymousLabel,
                onReply: null, // No nested reply on replies
                onDelete: () {}, // Simplified for replies
                isOwner: false,
                onCommentLike: widget.onCommentLike,
              ),
            ),
        ],
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }
}

// ---------------------------------------------------------------------------
// Card action button (Facebook-style: icon + text label, centered, min 44px)
// ---------------------------------------------------------------------------
class _CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CardActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: AbbaSpacing.xs),
            Text(
              label,
              style: AbbaTypography.bodySmall.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
