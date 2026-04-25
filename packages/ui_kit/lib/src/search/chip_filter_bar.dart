import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Visual style for [ChipFilterBar].
enum ChipFilterStyle {
  /// Material [FilterChip] pills (default).
  chip,

  /// Text-only with underline indicator on selection.
  underline,
}

/// A horizontal scrollable row of filter options.
///
/// Supports [ChipFilterStyle.chip] (Material FilterChip) and
/// [ChipFilterStyle.underline] (text with bottom border indicator).
///
/// When [singleSelect] is true, only one option can be selected at a time
/// and the callback receives a single-element set.
class ChipFilterBar extends StatelessWidget {
  const ChipFilterBar({
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
    this.style = ChipFilterStyle.chip,
    this.singleSelect = false,
    this.padding,
    this.height,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    super.key,
  });

  /// All available filter labels.
  final List<String> options;

  /// Currently selected labels.
  final Set<String> selected;

  /// Called with the updated selection set after any change.
  final ValueChanged<Set<String>> onSelectionChanged;

  /// Visual style of the filter bar.
  final ChipFilterStyle style;

  /// When true, selecting an option deselects all others.
  final bool singleSelect;

  /// Outer padding. Defaults to horizontal [AppSpacing.md].
  final EdgeInsetsGeometry? padding;

  /// Height of the filter bar (used in [ChipFilterStyle.underline]).
  final double? height;

  /// Text style for selected items in underline mode.
  final TextStyle? selectedTextStyle;

  /// Text style for unselected items in underline mode.
  final TextStyle? unselectedTextStyle;

  void _handleSelection(String option) {
    if (singleSelect) {
      onSelectionChanged({option});
    } else {
      final updated = Set.of(selected);
      if (updated.contains(option)) {
        updated.remove(option);
      } else {
        updated.add(option);
      }
      onSelectionChanged(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (style) {
      ChipFilterStyle.chip => _buildChips(context),
      ChipFilterStyle.underline => _buildUnderline(context),
    };
  }

  Widget _buildChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children:
            options.map((option) {
              final isSelected = selected.contains(option);
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: FilterChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (value) {
                    if (singleSelect) {
                      onSelectionChanged({option});
                    } else {
                      final updated = Set.of(selected);
                      if (value) {
                        updated.add(option);
                      } else {
                        updated.remove(option);
                      }
                      onSelectionChanged(updated);
                    }
                  },
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildUnderline(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: height ?? 48,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children:
              options.map((option) {
                final isSelected = selected.contains(option);
                return GestureDetector(
                  onTap: () => _handleSelection(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      option,
                      style:
                          isSelected
                              ? (selectedTextStyle ??
                                  theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                  ))
                              : (unselectedTextStyle ??
                                  theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w400,
                                  )),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
