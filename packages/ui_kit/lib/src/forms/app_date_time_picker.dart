import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A tappable field that shows a date and/or time picker dialog and displays
/// the selected value.
class AppDateTimePicker extends StatelessWidget {
  const AppDateTimePicker({
    required this.onChanged,
    this.value,
    this.label,
    this.hint = 'Select date & time',
    this.pickDate = true,
    this.pickTime = true,
    this.firstDate,
    this.lastDate,
    this.dateFormat,
    this.borderRadius,
    this.fillColor,
    super.key,
  });

  /// Called when the user selects a date/time.
  final ValueChanged<DateTime> onChanged;

  /// Currently selected value.
  final DateTime? value;

  /// Field label.
  final String? label;

  /// Placeholder when [value] is null.
  final String hint;

  /// Whether to show a date picker.
  final bool pickDate;

  /// Whether to show a time picker.
  final bool pickTime;

  /// Earliest selectable date (defaults to 2000-01-01).
  final DateTime? firstDate;

  /// Latest selectable date (defaults to 2100-12-31).
  final DateTime? lastDate;

  /// Optional custom formatter. When null uses a default representation.
  final String Function(DateTime)? dateFormat;

  /// Optional border radius override.
  final double? borderRadius;

  /// Optional fill color for the input field.
  final Color? fillColor;

  String _formatDefault(DateTime dt) {
    final parts = <String>[];
    if (pickDate) {
      parts.add(
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}',
      );
    }
    if (pickTime) {
      parts.add(
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
      );
    }
    return parts.join(' ');
  }

  Future<void> _pick(BuildContext context) async {
    DateTime result = value ?? DateTime.now();

    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: result,
        firstDate: firstDate ?? DateTime(2000),
        lastDate: lastDate ?? DateTime(2100),
      );
      if (date == null) return;
      result = DateTime(
        date.year,
        date.month,
        date.day,
        result.hour,
        result.minute,
      );
    }

    if (pickTime && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(result),
      );
      if (time == null) return;
      result = DateTime(
        result.year,
        result.month,
        result.day,
        time.hour,
        time.minute,
      );
    }

    onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = value != null
        ? (dateFormat?.call(value!) ?? _formatDefault(value!))
        : null;

    final effectiveRadius = borderRadius ?? AppRadius.md;
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: const Icon(Icons.calendar_today),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          filled: fillColor != null,
          fillColor: fillColor,
          border: borderRadius != null
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(borderRadius!),
                )
              : null,
        ),
        child: displayText != null
            ? Text(displayText, style: theme.textTheme.bodyLarge)
            : null,
      ),
    );
  }
}
