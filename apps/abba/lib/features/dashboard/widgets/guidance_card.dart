import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/pro_blur.dart';

class GuidanceCard extends StatelessWidget {
  final Guidance guidance;
  final String title;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const GuidanceCard({
    super.key,
    required this.guidance,
    required this.title,
    required this.onUnlock,
    this.isUserPremium = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = guidance.isPremium && !isUserPremium;

    if (isLocked) {
      return ProBlur(
        title: title,
        icon: '💬',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    final content = guidance.content;

    return ExpandableCard(
      icon: '💬',
      title: title,
      summary: content,
      expandedContent: Text(
        content,
        style: AbbaTypography.body.copyWith(
          color: AbbaColors.warmBrown,
          height: 1.6,
        ),
      ),
    );
  }
}
