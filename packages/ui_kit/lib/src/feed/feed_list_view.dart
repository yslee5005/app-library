import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// ListView.builder with pull-to-refresh and load-more indicator.
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

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0 && emptyWidget != null) {
      if (onRefresh != null) {
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

    // Total count: items + optional loading indicator
    final totalCount = itemCount + (isLoadingMore && hasMore ? 1 : 0);

    Widget listView = ListView.separated(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      itemCount: totalCount,
      separatorBuilder: separatorBuilder ??
          (_, __) => SizedBox(height: itemSpacing ?? AppSpacing.sm),
      itemBuilder: (context, index) {
        // Loading indicator at the bottom
        if (index == itemCount) {
          return loadingMoreWidget ??
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(child: CircularProgressIndicator()),
              );
        }

        return itemBuilder(context, index);
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

    // Wrap with RefreshIndicator
    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
