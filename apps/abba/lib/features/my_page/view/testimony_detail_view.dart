import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/post.dart';
import '../../../theme/abba_theme.dart';

class TestimonyDetailView extends StatelessWidget {
  final CommunityPost post;

  const TestimonyDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat.yMMMMd(locale);
    final timeFormat = DateFormat.jm(locale);

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        backgroundColor: AbbaColors.cream,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AbbaSpacing.lg,
          vertical: AbbaSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.sm + 2,
                vertical: AbbaSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: post.category == 'testimony'
                    ? AbbaColors.softPink.withValues(alpha: 0.3)
                    : AbbaColors.softSky.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AbbaRadius.sm),
              ),
              child: Text(
                post.category == 'testimony'
                    ? l10n.filterTestimony
                    : l10n.filterPrayerRequest,
                style: AbbaTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.sm),

            // Date & time
            Text(
              '${dateFormat.format(post.createdAt)}  ${timeFormat.format(post.createdAt)}',
              style: AbbaTypography.bodySmall.copyWith(
                color: AbbaColors.muted,
              ),
            ),
            const SizedBox(height: AbbaSpacing.lg),

            // Content card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AbbaSpacing.lg),
              decoration: BoxDecoration(
                color: AbbaColors.white,
                borderRadius: BorderRadius.circular(AbbaRadius.lg),
              ),
              child: Text(
                post.content,
                style: AbbaTypography.body.copyWith(
                  color: AbbaColors.warmBrown,
                  height: 1.8,
                ),
              ),
            ),
            const SizedBox(height: AbbaSpacing.lg),

            // Reactions (read-only)
            Row(
              children: [
                Icon(Icons.favorite, size: 18, color: AbbaColors.error),
                const SizedBox(width: AbbaSpacing.xs),
                Text(
                  '${post.likeCount}',
                  style: AbbaTypography.bodySmall.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
                const SizedBox(width: AbbaSpacing.lg),
                Icon(Icons.chat_bubble_outline,
                    size: 18, color: AbbaColors.muted),
                const SizedBox(width: AbbaSpacing.xs),
                Text(
                  '${post.commentCount}',
                  style: AbbaTypography.bodySmall.copyWith(
                    color: AbbaColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
