import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Represents the state of all applied filters.
class FilterState {
  const FilterState({this.selected = const {}, this.rangeValues = const {}});

  /// Keys are section identifiers, values are the selected option labels.
  final Map<String, Set<String>> selected;

  /// Keys are section identifiers, values are the selected range.
  final Map<String, RangeValues> rangeValues;
}

/// Definition of a single filter section displayed inside [FilterBottomSheet].
class FilterSection {
  const FilterSection({
    required this.id,
    required this.title,
    this.options = const [],
    this.range,
    this.initialSelected = const {},
  });

  /// Unique identifier for this section.
  final String id;

  /// Display title.
  final String title;

  /// Checkbox / chip options.
  final List<String> options;

  /// If non-null this section displays a [RangeSlider] instead of chips.
  final RangeValues? range;

  /// Pre-selected options.
  final Set<String> initialSelected;
}

/// A modal bottom sheet that presents [sections] of filter options and returns
/// a [FilterState] via [onApply].
class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    required this.sections,
    required this.onApply,
    this.title = 'Filters',
    this.applyLabel = 'Apply',
    this.resetLabel = 'Reset',
    super.key,
  });

  final List<FilterSection> sections;
  final ValueChanged<FilterState> onApply;
  final String title;
  final String applyLabel;
  final String resetLabel;

  /// Convenience method to show the sheet as a modal.
  static Future<void> show(
    BuildContext context, {
    required List<FilterSection> sections,
    required ValueChanged<FilterState> onApply,
    String title = 'Filters',
    String applyLabel = 'Apply',
    String resetLabel = 'Reset',
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder:
          (_) => FilterBottomSheet(
            sections: sections,
            onApply: onApply,
            title: title,
            applyLabel: applyLabel,
            resetLabel: resetLabel,
          ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final Map<String, Set<String>> _selected;
  late final Map<String, RangeValues> _ranges;

  @override
  void initState() {
    super.initState();
    _selected = {
      for (final s in widget.sections)
        if (s.options.isNotEmpty) s.id: Set.of(s.initialSelected),
    };
    _ranges = {
      for (final s in widget.sections)
        if (s.range != null) s.id: s.range!,
    };
  }

  void _reset() {
    setState(() {
      for (final s in widget.sections) {
        if (s.options.isNotEmpty) _selected[s.id] = {};
        if (s.range != null) _ranges[s.id] = s.range!;
      }
    });
  }

  void _apply() {
    widget.onApply(FilterState(selected: _selected, rangeValues: _ranges));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder:
          (context, scrollController) => Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Text(widget.title, style: theme.textTheme.titleLarge),
                    const Spacer(),
                    TextButton(
                      onPressed: _reset,
                      child: Text(widget.resetLabel),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Sections
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: widget.sections.length,
                  separatorBuilder:
                      (_, __) => const SizedBox(height: AppSpacing.lg),
                  itemBuilder: (context, index) {
                    final section = widget.sections[index];
                    return _buildSection(section, theme);
                  },
                ),
              ),

              // Apply button
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _apply,
                      child: Text(widget.applyLabel),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildSection(FilterSection section, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: theme.textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        if (section.range != null)
          _buildRange(section, theme)
        else
          _buildChips(section, theme),
      ],
    );
  }

  Widget _buildChips(FilterSection section, ThemeData theme) {
    final selected = _selected[section.id] ?? {};
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      children:
          section.options.map((option) {
            final isSelected = selected.contains(option);
            return FilterChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selected.add(option);
                  } else {
                    selected.remove(option);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  Widget _buildRange(FilterSection section, ThemeData theme) {
    final range = _ranges[section.id] ?? section.range!;
    return RangeSlider(
      values: range,
      min: section.range!.start,
      max: section.range!.end,
      divisions: (section.range!.end - section.range!.start).round(),
      labels: RangeLabels(
        range.start.round().toString(),
        range.end.round().toString(),
      ),
      onChanged: (values) {
        setState(() => _ranges[section.id] = values);
      },
    );
  }
}
