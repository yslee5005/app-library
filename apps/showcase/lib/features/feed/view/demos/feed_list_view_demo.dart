import 'package:app_lib_core/core.dart';
import 'package:app_lib_pagination/pagination.dart';
import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mock feed item model.
class _FeedItem {
  const _FeedItem({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}

/// Mock repository that produces paginated feed items.
class _MockFeedRepository implements PaginatedRepository<_FeedItem> {
  int _total = 20;

  @override
  Future<Result<PaginatedResult<_FeedItem>>> fetchPage(
    PaginationParams params,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    final start = params.cursor != null ? int.parse(params.cursor!) : 0;
    final end = (start + params.limit).clamp(0, _total);
    final items = List.generate(
      end - start,
      (i) => _FeedItem(
        title: 'Item ${start + i + 1}',
        subtitle:
            'Description for item ${start + i + 1}. Tap to see more details.',
      ),
    );

    return Success(PaginatedResult(
      items: items,
      hasMore: end < _total,
      cursor: end < _total ? '$end' : null,
      totalCount: _total,
    ),);
  }

  /// Simulates adding more items on the server.
  void addMore(int count) => _total += count;
}

/// Notifier subclass that provides the mock repository.
class _FeedNotifier extends PaginationNotifier<_FeedItem> {
  @override
  PaginatedRepository<_FeedItem> get repository =>
      ref.watch(_feedRepoProvider);
}

final _feedRepoProvider = Provider<_MockFeedRepository>((ref) {
  return _MockFeedRepository();
});

final _feedListProvider = AsyncNotifierProvider<
    PaginationNotifier<_FeedItem>, PaginationState<_FeedItem>>(
  _FeedNotifier.new,
);

class FeedListViewDemo extends ConsumerWidget {
  const FeedListViewDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(_feedListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('FeedListView')),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (paginationState) => _FeedBody(state: paginationState),
      ),
    );
  }
}

class _FeedBody extends ConsumerWidget {
  const _FeedBody({required this.state});

  final PaginationState<_FeedItem> state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = switch (state) {
      PaginationLoaded(:final items) => items,
      PaginationLoading(:final items) => items,
      PaginationError(:final items) => items,
      PaginationInitial() => <_FeedItem>[],
    };

    final hasMore = switch (state) {
      PaginationLoaded(:final hasMore) => hasMore,
      _ => false,
    };

    final isLoadingMore = state is PaginationLoading<_FeedItem>;

    return FeedListView(
      itemCount: items.length + (hasMore || isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          // Load more trigger
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(_feedListProvider.notifier).loadMore();
          });
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = items[index];
        return AppCard(
          title: item.title,
          subtitle: item.subtitle,
          image: Container(
            color: Colors.primaries[index % Colors.primaries.length]
                .withValues(alpha: 0.3),
            child: Center(
              child: Icon(
                Icons.image,
                size: 48,
                color: Colors.primaries[index % Colors.primaries.length],
              ),
            ),
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped ${item.title}')),
            );
          },
        );
      },
      onRefresh: () async {
        await ref.read(_feedListProvider.notifier).refresh();
      },
    );
  }
}
