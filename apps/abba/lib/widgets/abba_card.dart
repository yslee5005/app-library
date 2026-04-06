import 'package:flutter/material.dart';

import '../theme/abba_theme.dart';

class AbbaCard extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AbbaCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          margin ??
          const EdgeInsets.symmetric(
            horizontal: AbbaSpacing.md,
            vertical: AbbaSpacing.sm,
          ),
      padding: padding ?? const EdgeInsets.all(AbbaSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor ?? AbbaColors.white,
        borderRadius: BorderRadius.circular(AbbaRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AbbaColors.warmBrown.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
