import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/premium_blur.dart';

class GuidanceCard extends StatelessWidget {
  final Guidance guidance;
  final String title;
  final String locale;
  final VoidCallback onUnlock;

  const GuidanceCard({
    super.key,
    required this.guidance,
    required this.title,
    required this.locale,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumBlur(
      title: title,
      icon: '💬',
      isLocked: guidance.isPremium,
      onUnlock: onUnlock,
      content: Text(
        guidance.content(locale),
        style: AbbaTypography.body,
      ),
    );
  }
}
