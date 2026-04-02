import 'package:app_lib_auth/auth.dart';
import 'package:app_lib_comments/comments.dart';
import 'package:app_lib_core/core.dart';
import 'package:app_lib_pagination/pagination.dart';
import 'package:app_lib_theme/theme.dart';
import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Mock feed data & providers (local to this demo)
// ---------------------------------------------------------------------------

class _Article {
  const _Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.colorIndex,
  });
  final String id;
  final String title;
  final String subtitle;
  final int colorIndex;
}

class _MockArticleRepo implements PaginatedRepository<_Article> {
  @override
  Future<Result<PaginatedResult<_Article>>> fetchPage(
    PaginationParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    const total = 30;
    final start = params.cursor != null ? int.parse(params.cursor!) : 0;
    final end = (start + params.limit).clamp(0, total);

    final items = List.generate(
      end - start,
      (i) => _Article(
        id: 'article-${start + i}',
        title: 'Article ${start + i + 1}',
        subtitle: 'A brief summary of article ${start + i + 1}.',
        colorIndex: (start + i) % Colors.primaries.length,
      ),
    );

    return Success(PaginatedResult(
      items: items,
      hasMore: end < total,
      cursor: end < total ? '$end' : null,
      totalCount: total,
    ),);
  }
}

class _ArticleNotifier extends PaginationNotifier<_Article> {
  @override
  PaginatedRepository<_Article> get repository =>
      ref.watch(_articleRepoProvider);
}

final _articleRepoProvider = Provider<_MockArticleRepo>(
  (ref) => _MockArticleRepo(),
);

final _articleListProvider = AsyncNotifierProvider<
    PaginationNotifier<_Article>, PaginationState<_Article>>(
  _ArticleNotifier.new,
);

// ---------------------------------------------------------------------------
// Entry point — decides Login vs Feed based on auth state
// ---------------------------------------------------------------------------

class FullFlowDemo extends ConsumerWidget {
  const FullFlowDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);

    return authAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Full Flow')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Full Flow')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (state) => switch (state) {
        Authenticated(:final user) => _FeedScreen(user: user),
        AuthLoading() => Scaffold(
            appBar: AppBar(title: const Text('Full Flow')),
            body: const Center(child: CircularProgressIndicator()),
          ),
        _ => const _LoginScreen(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 1: Login
// ---------------------------------------------------------------------------

class _LoginScreen extends ConsumerWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Full Flow — Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: LoginForm(
          onLogin: (email, password) {
            ref.read(authNotifierProvider.notifier).signInWithEmail(
                  email: email,
                  password: password,
                );
          },
          onGoogleLogin: () {
            ref.read(authNotifierProvider.notifier).signInWithGoogle();
          },
          onAppleLogin: () {
            ref.read(authNotifierProvider.notifier).signInWithApple();
          },
          onForgotPassword: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Forgot password (mock)')),
            );
          },
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 2: Feed with pagination
// ---------------------------------------------------------------------------

class _FeedScreen extends ConsumerWidget {
  const _FeedScreen({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(_articleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user.displayName ?? "User"}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (paginationState) =>
            _ArticleList(state: paginationState, user: user),
      ),
    );
  }
}

class _ArticleList extends ConsumerWidget {
  const _ArticleList({required this.state, required this.user});

  final PaginationState<_Article> state;
  final UserProfile user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = switch (state) {
      PaginationLoaded(:final items) => items,
      PaginationLoading(:final items) => items,
      PaginationError(:final items) => items,
      PaginationInitial() => <_Article>[],
    };

    final hasMore = switch (state) {
      PaginationLoaded(:final hasMore) => hasMore,
      _ => false,
    };

    final isLoadingMore = state is PaginationLoading<_Article>;

    return FeedListView(
      itemCount: items.length + (hasMore || isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(_articleListProvider.notifier).loadMore();
          });
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final article = items[index];
        return AppCard(
          title: article.title,
          subtitle: article.subtitle,
          image: Container(
            color: Colors.primaries[article.colorIndex].withValues(alpha: 0.3),
            child: Center(
              child: Icon(
                Icons.article,
                size: 48,
                color: Colors.primaries[article.colorIndex],
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    _DetailScreen(article: article, user: user),
              ),
            );
          },
        );
      },
      onRefresh: () async {
        await ref.read(_articleListProvider.notifier).refresh();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Screen 3: Detail + Comments
// ---------------------------------------------------------------------------

class _DetailScreen extends ConsumerStatefulWidget {
  const _DetailScreen({required this.article, required this.user});

  final _Article article;
  final UserProfile user;

  @override
  ConsumerState<_DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<_DetailScreen> {
  final _commentController = TextEditingController();

  CommentListKey get _key => CommentListKey(
        contentType: 'article',
        contentId: widget.article.id,
      );

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentListProvider(_key));
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.article.title)),
      body: Column(
        children: [
          // Article header
          Container(
            width: double.infinity,
            height: 180,
            color: Colors.primaries[widget.article.colorIndex]
                .withValues(alpha: 0.2),
            child: Center(
              child: Icon(
                Icons.article,
                size: 64,
                color: Colors.primaries[widget.article.colorIndex],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.article.title, style: textTheme.headlineSmall),
                const SizedBox(height: 4),
                Text(
                  widget.article.subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: colors.outlineVariant),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Comments', style: textTheme.titleMedium),
            ),
          ),

          // Comments list
          Expanded(
            child: commentsAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (paginationState) =>
                  _CommentList(state: paginationState, commentKey: _key),
            ),
          ),

          // Comment input
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.outlineVariant)),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submitComment(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    icon: const Icon(Icons.send),
                    onPressed: _submitComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    ref.read(commentListProvider(_key).notifier).addComment(
          body: text,
          userId: widget.user.id,
        );
    _commentController.clear();
  }
}

class _CommentList extends ConsumerWidget {
  const _CommentList({required this.state, required this.commentKey});

  final PaginationState<CommentModel> state;
  final CommentListKey commentKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = switch (state) {
      PaginationLoaded(:final items) => items,
      PaginationLoading(:final items) => items,
      PaginationError(:final items) => items,
      PaginationInitial() => <CommentModel>[],
    };

    if (items.isEmpty) {
      return const Center(
        child: Text('No comments yet. Be the first!'),
      );
    }

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final comment = items[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: colors.primaryContainer,
            child: Text(
              comment.userId.substring(comment.userId.length - 1).toUpperCase(),
              style: TextStyle(color: colors.onPrimaryContainer),
            ),
          ),
          title: Text(comment.body),
          subtitle: Text(
            _timeAgo(comment.createdAt),
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          trailing: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref.read(commentListProvider(commentKey).notifier).toggleLike(
                    commentId: comment.id,
                    userId: 'mock-user-1',
                  );
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    comment.isLiked ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: comment.isLiked ? Colors.red : colors.onSurfaceVariant,
                  ),
                  if (comment.likeCount > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '${comment.likeCount}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _timeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
