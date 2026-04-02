import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

/// Shape variants for skeleton placeholders.
enum SkeletonShape { rectangle, circle, text }

/// An animated placeholder mimicking content layout while data loads.
///
/// Use [SkeletonShape.text] for multi-line text blocks (controlled via
/// [lineCount]), [SkeletonShape.circle] for avatars, and
/// [SkeletonShape.rectangle] for images or cards.
class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({
    this.shape = SkeletonShape.rectangle,
    this.width,
    this.height,
    this.borderRadius,
    this.lineCount = 3,
    this.baseColor,
    this.highlightColor,
    super.key,
  });

  /// Shape of the placeholder.
  final SkeletonShape shape;

  /// Width. Defaults to double.infinity for rectangle/text, 48 for circle.
  final double? width;

  /// Height. Defaults to 16 for text lines, 120 for rectangle, width for
  /// circle.
  final double? height;

  /// Border radius. Defaults vary by shape.
  final BorderRadius? borderRadius;

  /// Number of lines when [shape] is [SkeletonShape.text].
  final int lineCount;

  /// Optional base color for the skeleton animation.
  final Color? baseColor;

  /// Optional highlight color for the skeleton animation.
  final Color? highlightColor;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBaseColor = widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final effectiveHighlightColor = widget.highlightColor ?? theme.colorScheme.surfaceContainerLow;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final color = Color.lerp(effectiveBaseColor, effectiveHighlightColor, _animation.value)!;
        return switch (widget.shape) {
          SkeletonShape.rectangle => _rectangle(color),
          SkeletonShape.circle => _circle(color),
          SkeletonShape.text => _textLines(color),
        };
      },
    );
  }

  Widget _rectangle(Color color) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            widget.borderRadius ?? BorderRadius.circular(AppRadius.md),
      ),
    );
  }

  Widget _circle(Color color) {
    final size = widget.width ?? 48.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _textLines(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.lineCount, (i) {
        final isLast = i == widget.lineCount - 1;
        return Padding(
          padding: EdgeInsets.only(
            bottom: isLast ? 0 : AppSpacing.sm,
          ),
          child: Container(
            width: isLast
                ? (widget.width ?? double.infinity) * 0.6
                : widget.width ?? double.infinity,
            height: widget.height ?? 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
          ),
        );
      }),
    );
  }
}
