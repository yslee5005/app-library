import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';
import '../../../widgets/premium_blur.dart';

class AiPrayerCard extends ConsumerWidget {
  final AiPrayer aiPrayer;
  final String title;
  final String locale;
  final VoidCallback onUnlock;
  final bool isUserPremium;

  const AiPrayerCard({
    super.key,
    required this.aiPrayer,
    required this.title,
    required this.locale,
    required this.onUnlock,
    this.isUserPremium = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLocked = aiPrayer.isPremium && !isUserPremium;

    if (isLocked) {
      return PremiumBlur(
        title: title,
        icon: '🙏',
        isLocked: true,
        onUnlock: onUnlock,
        content: const SizedBox.shrink(),
      );
    }

    final prayerText = aiPrayer.text(locale);

    return ExpandableCard(
      icon: '🙏',
      title: title,
      summary: prayerText,
      expandedContent: Text(
        prayerText,
        style: AbbaTypography.body.copyWith(
          color: AbbaColors.warmBrown,
          height: 1.6,
        ),
      ),
    );
  }
}
