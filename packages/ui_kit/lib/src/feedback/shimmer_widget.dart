import 'package:flutter/material.dart';

/// A shimmer animation overlay that can wrap any child widget.
///
/// Typically used to indicate loading by sweeping a light gradient across the
/// child.
class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    super.key,
  });

  /// The widget to overlay with the shimmer effect.
  final Widget child;

  /// Base (dark) colour of the gradient. Defaults to the surface container.
  final Color? baseColor;

  /// Highlight (bright sweep) colour. Defaults to surface container low.
  final Color? highlightColor;

  /// Duration of one shimmer sweep.
  final Duration duration;

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base =
        widget.baseColor ?? theme.colorScheme.surfaceContainerHighest;
    final highlight =
        widget.highlightColor ?? theme.colorScheme.surfaceContainerLow;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
