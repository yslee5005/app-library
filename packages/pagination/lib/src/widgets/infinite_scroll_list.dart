import 'package:flutter/material.dart';

import '../domain/pagination_state.dart';

/// A list view that loads more items when the user scrolls near the end.
///
/// Wraps a [ListView.builder] and triggers [onLoadMore] when the scroll
/// position is within [loadMoreThreshold] pixels of the bottom.
///
/// ```dart
/// InfiniteScrollList<Article>(
///   state: paginationState,
///   itemBuilder: (context, article) => ArticleTile(article),
///   onLoadMore: () => ref.read(articleListProvider.notifier).loadMore(),
///   onRefresh: () => ref.read(articleListProvider.notifier).refresh(),
/// )
/// ```
class InfiniteScrollList<T> extends StatefulWidget {
  const InfiniteScrollList({
    super.key,
    required this.state,
    required this.itemBuilder,
    this.onLoadMore,
    this.onRefresh,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.separatorBuilder,
    this.padding,
    this.loadMoreThreshold = 200.0,
    this.physics,
  });

  /// Current pagination state.
  final PaginationState<T> state;

  /// Builder for each item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Called when more items should be loaded.
  final VoidCallback? onLoadMore;

  /// Called on pull-to-refresh. Enables [RefreshIndicator] when non-null.
  final Future<void> Function()? onRefresh;

  /// Shown while loading.
  final Widget? loadingWidget;

  /// Shown on error. Receives the exception.
  final Widget Function(Object exception)? errorWidget;

  /// Shown when the list is empty after loading.
  final Widget? emptyWidget;

  /// Optional separator between items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Distance from the bottom at which [onLoadMore] is triggered.
  final double loadMoreThreshold;

  /// Scroll physics.
  final ScrollPhysics? physics;

  @override
  State<InfiniteScrollList<T>> createState() => _InfiniteScrollListState<T>();
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollList<T>> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.onLoadMore == null) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= widget.loadMoreThreshold) {
      widget.onLoadMore!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.state) {
      PaginationInitial() =>
        widget.loadingWidget ??
            const Center(child: CircularProgressIndicator()),
      PaginationLoading(:final items) when items.isEmpty =>
        widget.loadingWidget ??
            const Center(child: CircularProgressIndicator()),
      PaginationError(:final exception, :final items) when items.isEmpty =>
        widget.errorWidget?.call(exception) ??
            Center(child: Text('Error: $exception')),
      _ => _buildList(),
    };
  }

  Widget _buildList() {
    final items = switch (widget.state) {
      PaginationLoaded(:final items) => items,
      PaginationLoading(:final items) => items,
      PaginationError(:final items) => items,
      _ => <T>[],
    };

    if (items.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('No items'));
    }

    final hasMore = switch (widget.state) {
      PaginationLoaded(:final hasMore) => hasMore,
      PaginationLoading() => true,
      _ => false,
    };

    final isLoading = widget.state is PaginationLoading<T>;
    final isError = widget.state is PaginationError<T>;

    final itemCount = items.length + (hasMore || isError ? 1 : 0);

    Widget list = ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder:
          widget.separatorBuilder ?? (_, __) => const SizedBox.shrink(),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return widget.itemBuilder(context, items[index]);
        }
        // Footer: loading indicator or error retry
        if (isLoading) {
          return widget.loadingWidget ??
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              );
        }
        if (isError && widget.errorWidget != null) {
          final error = (widget.state as PaginationError<T>).exception;
          return widget.errorWidget!(error);
        }
        return const SizedBox.shrink();
      },
    );

    if (widget.onRefresh != null) {
      list = RefreshIndicator(onRefresh: widget.onRefresh!, child: list);
    }

    return list;
  }
}
