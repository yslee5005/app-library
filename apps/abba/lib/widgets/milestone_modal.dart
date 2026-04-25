import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';
import 'milestone_share_card.dart';

/// Milestone metadata (type + emoji only — copy comes from l10n).
class MilestoneInfo {
  final String type;
  final String emoji;

  const MilestoneInfo({required this.type, required this.emoji});

  /// Localized title for this milestone.
  String title(AppLocalizations l10n) {
    switch (type) {
      case 'first_prayer':
        return l10n.milestoneFirstPrayerTitle;
      case '7_day_streak':
        return l10n.milestoneSevenDayStreakTitle;
      case '30_day_streak':
        return l10n.milestoneThirtyDayStreakTitle;
      case '100_prayers':
        return l10n.milestoneHundredPrayersTitle;
      default:
        return '';
    }
  }

  /// Localized description for this milestone.
  String desc(AppLocalizations l10n) {
    switch (type) {
      case 'first_prayer':
        return l10n.milestoneFirstPrayerDesc;
      case '7_day_streak':
        return l10n.milestoneSevenDayStreakDesc;
      case '30_day_streak':
        return l10n.milestoneThirtyDayStreakDesc;
      case '100_prayers':
        return l10n.milestoneHundredPrayersDesc;
      default:
        return '';
    }
  }
}

const milestoneInfoMap = <String, MilestoneInfo>{
  'first_prayer': MilestoneInfo(type: 'first_prayer', emoji: '🎉'),
  '7_day_streak': MilestoneInfo(type: '7_day_streak', emoji: '🔥'),
  '30_day_streak': MilestoneInfo(type: '30_day_streak', emoji: '🌸'),
  '100_prayers': MilestoneInfo(type: '100_prayers', emoji: '🙏'),
};

/// Shows a celebration modal for a milestone achievement
Future<void> showMilestoneModal(
  BuildContext context,
  String milestoneType,
  String locale, {
  int streakDays = 0,
  String userName = '',
}) async {
  final info = milestoneInfoMap[milestoneType];
  if (info == null) return;

  final l10n = AppLocalizations.of(context)!;

  await showDialog(
    context: context,
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AbbaRadius.xl),
      ),
      backgroundColor: AbbaColors.cream,
      child: Padding(
        padding: const EdgeInsets.all(AbbaSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(info.emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: AbbaSpacing.md),
            Text(
              info.title(l10n),
              style: AbbaTypography.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              info.desc(l10n),
              style: AbbaTypography.body.copyWith(color: AbbaColors.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.xl),
            // Share button
            if (streakDays > 0)
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    MilestoneShareCard.share(
                      context: context,
                      streakDays: streakDays,
                      userName: userName,
                      locale: locale,
                    );
                  },
                  icon: const Icon(Icons.share, color: AbbaColors.sage),
                  label: Text(
                    l10n.milestoneShare,
                    style: AbbaTypography.body.copyWith(
                      color: AbbaColors.sage,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.lg),
                    ),
                  ),
                ),
              ),
            if (streakDays > 0) const SizedBox(height: AbbaSpacing.sm),
            SizedBox(
              width: double.infinity,
              height: abbaButtonHeight,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AbbaColors.sageDark,
                  foregroundColor: AbbaColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AbbaRadius.lg),
                  ),
                ),
                child: Text(
                  l10n.milestoneThankGod,
                  style: AbbaTypography.body.copyWith(
                    color: AbbaColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
