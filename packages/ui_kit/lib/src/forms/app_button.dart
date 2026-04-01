import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Visual variant for [AppButton].
enum AppButtonVariant { primary, secondary, outline, text }

/// A themed button with loading and disabled states.
///
/// Renders as [FilledButton], [FilledButton.tonal], [OutlinedButton], or
/// [TextButton] depending on [variant].
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.expand = false,
    super.key,
  });

  /// Button label.
  final String label;

  /// Tap handler. When null the button is rendered as disabled.
  final VoidCallback? onPressed;

  /// Visual variant.
  final AppButtonVariant variant;

  /// When true a circular progress indicator replaces the label.
  final bool isLoading;

  /// Optional leading icon.
  final IconData? icon;

  /// When true the button stretches to fill available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveOnPressed = isLoading ? null : onPressed;

    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: AppSpacing.sm),
                  Text(label),
                ],
              )
            : Text(label);

    final style = expand
        ? const ButtonStyle(
            minimumSize: WidgetStatePropertyAll(
              Size(double.infinity, 48),
            ),
          )
        : null;

    return switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        ),
      AppButtonVariant.secondary => FilledButton.tonal(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        ),
      AppButtonVariant.outline => OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        ),
      AppButtonVariant.text => TextButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        ),
    };
  }
}
