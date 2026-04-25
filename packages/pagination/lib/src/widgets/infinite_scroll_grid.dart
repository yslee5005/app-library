import 'package:flutter/material.dart';

import '../domain/pagination_state.dart';

/// A grid view that loads more items when the user scrolls near the end.
///
/// Wraps a [GridView.builder] and triggers [onLoadMore] when the scroll
/// position is within [loadMoreThreshold] pixels of the bottom.
///
/// ```dart
/// InfiniteScrollGrid<Product>(
///   state: paginationState,
///   crossAxisCount: 2,
///   itemBuilder: (context, product) => ProductCard(product),
///   onLoadMore: () => ref.read(productListProvider.notifier).loadMore(),
///   onRefresh: () => ref.read(productListProvider.notifier).refresh(),
/// )
/// ```
class InfiniteScrollGrid<T> extends StatefulWidget {
  const InfiniteScrollGrid({
    super.key,
    required this.state,
    required this.itemBuilder,
    required this.crossAxisCount,
    this.onLoadMore,
    this.onRefresh,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.padding,
    this.loadMoreThreshold = 200.0,
    this.mainAxisSpacing = 0.0,
    this.crossAxisSpacing = 0.0,
    this.childAspectRatio = 1.0,
    this.physics,
  });

  /// Current pagination state.
  final PaginationState<T> state;

  /// Builder for each item.
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// Number of columns.
  final int crossAxisCount;

  /// Called when more items should be loaded.
  final VoidCallback? onLoadMore;

  /// Called on pull-to-refresh. Enables [RefreshIndicator] when non-null.
  final Future<void> Function()? onRefresh;

  /// Shown while loading.
  final Widget? loadingWidget;

  /// Shown on error.
  final Widget Function(Object exception)? errorWidget;

  /// Shown when the list is empty.
  final Widget? emptyWidget;

  /// Padding around the grid.
  final EdgeInsetsGeometry? padding;

  /// Distance from the bottom at which [onLoadMore] is triggered.
  final double loadMoreThreshold;

  /// Spacing between rows.
  final double mainAxisSpacing;

  /// Spacing between columns.
  final double crossAxisSpacing;

  /// Aspect ratio of each child.
  final double childAspectRatio;

  /// Scroll physics.
  final ScrollPhysics? physics;

  @override
  State<InfiniteScrollGrid<T>> createState() => _InfiniteScrollGridState<T>();
}

class _InfiniteScrollGridState<T> extends State<InfiniteScrollGrid<T>> {
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
      _ => _buildGrid(),
    };
  }

  Widget _buildGrid() {
    final items = switch (widget.state) {
      PaginationLoaded(:final items) => items,
      PaginationLoading(:final items) => items,
      PaginationError(:final items) => items,
      _ => <T>[],
    };

    if (items.isEmpty) {
      return widget.emptyWidget ?? const Center(child: Text('No items'));
    }

    Widget grid = CustomScrollView(
      controller: _scrollController,
      physics: widget.physics ?? const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: widget.padding ?? EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              mainAxisSpacing: widget.mainAxisSpacing,
              crossAxisSpacing: widget.crossAxisSpacing,
              childAspectRatio: widget.childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => widget.itemBuilder(context, items[index]),
              childCount: items.length,
            ),
          ),
        ),
        if (widget.state is PaginationLoading<T>)
          SliverToBoxAdapter(
            child:
                widget.loadingWidget ??
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
          ),
        if (widget.state is PaginationError<T> && widget.errorWidget != null)
          SliverToBoxAdapter(
            child: widget.errorWidget!(
              (widget.state as PaginationError<T>).exception,
            ),
          ),
      ],
    );

    if (widget.onRefresh != null) {
      grid = RefreshIndicator(onRefresh: widget.onRefresh!, child: grid);
    }

    return grid;
  }
}
