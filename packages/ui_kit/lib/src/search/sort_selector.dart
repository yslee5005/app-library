import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A sort option displayed by [SortSelector].
class SortOption {
  const SortOption({required this.id, required this.label, this.icon});

  /// Unique identifier returned via the callback.
  final String id;

  /// Human-readable label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;
}

/// A dropdown / popup-menu button that shows a list of [SortOption]s and calls
/// [onSortChanged] when the user picks one.
class SortSelector extends StatelessWidget {
  const SortSelector({
    required this.options,
    required this.selected,
    required this.onSortChanged,
    this.label = 'Sort by',
    super.key,
  });

  /// Available sort options.
  final List<SortOption> options;

  /// Currently selected option id.
  final String selected;

  /// Called when the user picks a different option.
  final ValueChanged<SortOption> onSortChanged;

  /// Label shown before the selected option.
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = options.firstWhere(
      (o) => o.id == selected,
      orElse: () => options.first,
    );

    return PopupMenuButton<SortOption>(
      onSelected: onSortChanged,
      itemBuilder:
          (_) =>
              options.map((option) {
                return PopupMenuItem<SortOption>(
                  value: option,
                  child: Row(
                    children: [
                      if (option.icon != null) ...[
                        Icon(
                          option.icon,
                          size: 20,
                          color:
                              option.id == selected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Text(
                        option.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              option.id == selected
                                  ? theme.colorScheme.primary
                                  : null,
                          fontWeight:
                              option.id == selected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$label: ${current.label}', style: theme.textTheme.labelLarge),
            const SizedBox(width: AppSpacing.xs),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }
}
