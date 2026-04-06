import 'package:flutter/material.dart';

import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/premium_blur.dart';

class OriginalLangCard extends StatelessWidget {
  final OriginalLanguage originalLanguage;
  final String title;
  final String locale;
  final VoidCallback onUnlock;

  const OriginalLangCard({
    super.key,
    required this.originalLanguage,
    required this.title,
    required this.locale,
    required this.onUnlock,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumBlur(
      title: title,
      icon: '🔤',
      isLocked: originalLanguage.isPremium,
      onUnlock: onUnlock,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Original word
          Center(
            child: Text(
              originalLanguage.word,
              style: AbbaTypography.hero.copyWith(fontSize: 36),
            ),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Center(
            child: Text(
              '${originalLanguage.transliteration} (${originalLanguage.language})',
              style: AbbaTypography.body.copyWith(
                fontStyle: FontStyle.italic,
                color: AbbaColors.muted,
              ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(
            originalLanguage.meaning(locale),
            style: AbbaTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            originalLanguage.context(locale),
            style: AbbaTypography.body,
          ),
        ],
      ),
    );
  }
}
