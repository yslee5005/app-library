import 'package:flutter/material.dart';

import '../config/app_config.dart';

/// Animated widget shown when a routine is completed
class StreakAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const StreakAnimation({super.key, this.onComplete});

  @override
  State<StreakAnimation> createState() => _StreakAnimationState();
}

class _StreakAnimationState extends State<StreakAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: Transform.scale(
            scale: _scaleAnim.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConfig.accentColor.withValues(alpha: 0.3),
              ),
              child: const Center(
                child: Text('🔥', style: TextStyle(fontSize: 36)),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated check mark for completed routines
class CompletionCheckmark extends StatefulWidget {
  const CompletionCheckmark({super.key});

  @override
  State<CompletionCheckmark> createState() => _CompletionCheckmarkState();
}

class _CompletionCheckmarkState extends State<CompletionCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppConfig.accentColor,
          boxShadow: [
            BoxShadow(
              color: AppConfig.accentColor.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(Icons.check, color: Colors.black, size: 28),
      ),
    );
  }
}
