import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A featured grid layout with one large hero item and smaller sub-items.
///
/// Commonly used for portfolios, featured products, or news highlights.
/// The first item is displayed at [heroAspectRatio] (full width),
/// and subsequent items are displayed in a row at [gridAspectRatio].
///
/// ```dart
/// BentoGrid<Project>(
///   items: projects,
///   itemBuilder: (context, item, index) => Image.network(item.imageUrl),
///   maxItems: 3,
/// )
/// ```
class BentoGrid<T> extends StatelessWidget {
  const BentoGrid({
    required this.items,
    required this.itemBuilder,
    this.heroAspectRatio = 4 / 5,
    this.gridAspectRatio = 1,
    this.maxItems = 3,
    this.spacing = AppSpacing.md,
    this.onItemTap,
    this.gridColumns = 2,
    super.key,
  });

  /// Items to display in the grid.
  final List<T> items;

  /// Builder for each grid item. Receives the item and its index.
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Aspect ratio for the hero (first) item. Defaults to 4:5.
  final double heroAspectRatio;

  /// Aspect ratio for grid (non-hero) items. Defaults to 1:1.
  final double gridAspectRatio;

  /// Maximum number of items to display. Defaults to 3.
  final int maxItems;

  /// Spacing between items. Defaults to [AppSpacing.md].
  final double spacing;

  /// Called when an item is tapped.
  final void Function(T item, int index)? onItemTap;

  /// Number of columns in the sub-grid row. Defaults to 2.
  final int gridColumns;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final displayItems = items.take(maxItems).toList();

    return Column(
      children: [
        // Hero item (first)
        _buildItem(context, displayItems[0], 0, heroAspectRatio),

        // Sub-grid items
        if (displayItems.length > 1) ...[
          SizedBox(height: spacing),
          Row(
            children: [
              for (int i = 1; i < displayItems.length; i++) ...[
                if (i > 1) SizedBox(width: spacing),
                Expanded(
                  child: _buildItem(
                    context,
                    displayItems[i],
                    i,
                    gridAspectRatio,
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildItem(
    BuildContext context,
    T item,
    int index,
    double aspectRatio,
  ) {
    final child = AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: itemBuilder(context, item, index),
      ),
    );

    if (onItemTap != null) {
      return GestureDetector(
        onTap: () => onItemTap!(item, index),
        child: child,
      );
    }

    return child;
  }
}
