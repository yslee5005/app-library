import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// ListView.builder with pull-to-refresh, load-more, and horizontal support.
class FeedListView extends StatelessWidget {
  const FeedListView({
    required this.itemCount,
    required this.itemBuilder,
    this.onRefresh,
    this.onLoadMore,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.padding,
    this.separatorBuilder,
    this.emptyWidget,
    this.loadingMoreWidget,
    this.itemSpacing,
    this.scrollDirection = Axis.vertical,
    this.itemExtent,
    this.height,
    this.physics,
    super.key,
  });

  /// Number of items in the feed.
  final int itemCount;

  /// Builds each feed item.
  final Widget Function(BuildContext context, int index) itemBuilder;

  /// Called when the user pulls to refresh.
  final Future<void> Function()? onRefresh;

  /// Called when the user scrolls near the bottom.
  final VoidCallback? onLoadMore;

  /// Whether more items are currently loading.
  final bool isLoadingMore;

  /// Whether there are more items to load.
  final bool hasMore;

  /// Padding around the list.
  final EdgeInsetsGeometry? padding;

  /// Optional separator between items.
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  /// Widget shown when itemCount is 0.
  final Widget? emptyWidget;

  /// Custom loading-more indicator widget.
  final Widget? loadingMoreWidget;

  /// Spacing between items. Defaults to [AppSpacing.sm].
  final double? itemSpacing;

  /// Scroll direction. Defaults to [Axis.vertical].
  /// When [Axis.horizontal], pull-to-refresh is disabled.
  final Axis scrollDirection;

  /// Fixed extent for each item (width in horizontal, height in vertical).
  /// When set, items are constrained to this size.
  final double? itemExtent;

  /// Fixed height for the list container (useful for horizontal lists).
  final double? height;

  /// Custom scroll physics.
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyWidget != null) {
      if (onRefresh != null && scrollDirection == Axis.vertical) {
        return RefreshIndicator(
          onRefresh: onRefresh!,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(child: emptyWidget!),
            ],
          ),
        );
      }
      return emptyWidget!;
    }

    final isHorizontal = scrollDirection == Axis.horizontal;

    // Total count: items + optional loading indicator
    final totalCount = itemCount + (isLoadingMore && hasMore ? 1 : 0);

    final defaultSeparator = isHorizontal
        ? SizedBox(width: itemSpacing ?? AppSpacing.sm)
        : SizedBox(height: itemSpacing ?? AppSpacing.sm);

    Widget listView = ListView.separated(
      scrollDirection: scrollDirection,
      physics: physics,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      itemCount: totalCount,
      separatorBuilder: separatorBuilder ?? (_, __) => defaultSeparator,
      itemBuilder: (context, index) {
        // Loading indicator at the end
        if (index == itemCount) {
          return loadingMoreWidget ??
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              );
        }

        final child = itemBuilder(context, index);

        if (itemExtent != null) {
          return SizedBox(
            width: isHorizontal ? itemExtent : null,
            height: isHorizontal ? null : itemExtent,
            child: child,
          );
        }

        return child;
      },
    );

    // Attach scroll listener for load-more
    if (onLoadMore != null && hasMore) {
      listView = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification &&
              notification.metrics.extentAfter < 200 &&
              !isLoadingMore) {
            onLoadMore!();
          }
          return false;
        },
        child: listView,
      );
    }

    // Wrap with RefreshIndicator (vertical only)
    if (onRefresh != null && !isHorizontal) {
      listView = RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    // Constrain height for horizontal lists
    if (height != null) {
      return SizedBox(height: height, child: listView);
    }

    return listView;
  }
}
