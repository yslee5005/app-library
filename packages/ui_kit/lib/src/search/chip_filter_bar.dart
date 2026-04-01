import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A horizontal scrollable row of [FilterChip]s.
///
/// Calls [onSelectionChanged] with the full set of selected labels whenever
/// the selection changes.
class ChipFilterBar extends StatelessWidget {
  const ChipFilterBar({
    required this.options,
    required this.selected,
    required this.onSelectionChanged,
    this.padding,
    super.key,
  });

  /// All available filter labels.
  final List<String> options;

  /// Currently selected labels.
  final Set<String> selected;

  /// Called with the updated selection set after any change.
  final ValueChanged<Set<String>> onSelectionChanged;

  /// Outer padding. Defaults to horizontal [AppSpacing.md].
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ??
          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: options.map((option) {
          final isSelected = selected.contains(option);
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (value) {
                final updated = Set.of(selected);
                if (value) {
                  updated.add(option);
                } else {
                  updated.remove(option);
                }
                onSelectionChanged(updated);
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
