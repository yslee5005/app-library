import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A labelled column of form fields with an optional description.
class FormSection extends StatelessWidget {
  const FormSection({
    required this.title,
    required this.children,
    this.description,
    this.padding,
    this.titleStyle,
    this.spacing,
    super.key,
  });

  /// Section heading.
  final String title;

  /// Optional helper text below the title.
  final String? description;

  /// The form fields (or any widgets) to lay out vertically.
  final List<Widget> children;

  /// Outer padding. Defaults to vertical [AppSpacing.md].
  final EdgeInsetsGeometry? padding;

  /// Optional text style for the section title.
  final TextStyle? titleStyle;

  /// Optional spacing between form fields. Defaults to [AppSpacing.sm].
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle ?? theme.textTheme.titleMedium),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: spacing ?? AppSpacing.sm),
          ...List.generate(
            children.length * 2 - 1,
            (i) =>
                i.isEven
                    ? children[i ~/ 2]
                    : SizedBox(height: spacing ?? AppSpacing.sm),
          ),
        ],
      ),
    );
  }
}
