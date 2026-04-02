import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// A text widget with a "Show more" / "Show less" toggle.
///
/// Truncates to [maxLines] and shows a toggle when the text overflows.
class ExpandableText extends StatefulWidget {
  const ExpandableText({
    required this.text,
    this.maxLines = 3,
    this.style,
    this.expandLabel = 'Show more',
    this.collapseLabel = 'Show less',
    this.linkColor,
    super.key,
  });

  /// The full text content.
  final String text;

  /// Number of lines shown in the collapsed state.
  final int maxLines;

  /// Text style. Defaults to [TextTheme.bodyMedium].
  final TextStyle? style;

  /// Label for the expand action.
  final String expandLabel;

  /// Label for the collapse action.
  final String collapseLabel;

  /// Optional color for the expand/collapse link.
  final Color? linkColor;

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = widget.style ?? theme.textTheme.bodyMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Measure the text to decide whether to show the toggle.
        final span = TextSpan(text: widget.text, style: effectiveStyle);
        final painter = TextPainter(
          text: span,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: effectiveStyle,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? null : TextOverflow.ellipsis,
            ),
            if (overflows) ...[
              const SizedBox(height: AppSpacing.xs),
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Text(
                  _expanded ? widget.collapseLabel : widget.expandLabel,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: widget.linkColor ?? theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}
