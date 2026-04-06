import 'package:flutter/material.dart';

import '../theme/abba_theme.dart';

class AbbaButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isHero;
  final Color? backgroundColor;
  final Color? textColor;

  const AbbaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isHero = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final height = isHero ? abbaHeroButtonHeight : abbaButtonHeight;
    final bgColor = backgroundColor ?? AbbaColors.sage;
    final fgColor = textColor ?? AbbaColors.white;

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AbbaRadius.lg),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: isHero ? 28 : 24),
              const SizedBox(width: AbbaSpacing.sm),
            ],
            Text(
              label,
              style: AbbaTypography.body.copyWith(
                fontWeight: FontWeight.w600,
                color: fgColor,
                fontSize: isHero ? 20 : 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
