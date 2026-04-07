import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../theme/abba_theme.dart';
import 'milestone_share_card.dart';

/// Milestone data for celebration modals
class MilestoneInfo {
  final String type;
  final String emoji;
  final String titleEn;
  final String titleKo;
  final String descEn;
  final String descKo;

  const MilestoneInfo({
    required this.type,
    required this.emoji,
    required this.titleEn,
    required this.titleKo,
    required this.descEn,
    required this.descKo,
  });

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String desc(String locale) => locale == 'ko' ? descKo : descEn;
}

const milestoneInfoMap = <String, MilestoneInfo>{
  'first_prayer': MilestoneInfo(
    type: 'first_prayer',
    emoji: '🎉',
    titleEn: 'First Prayer!',
    titleKo: '첫 기도를 올렸습니다!',
    descEn: 'Your prayer journey has begun. God is listening.',
    descKo: '기도 여정이 시작되었습니다. 하나님이 듣고 계십니다.',
  ),
  '7_day_streak': MilestoneInfo(
    type: '7_day_streak',
    emoji: '🔥',
    titleEn: '7 Days of Prayer!',
    titleKo: '7일 연속 기도!',
    descEn: 'A week of faithful prayer. Your garden is growing!',
    descKo: '한 주간 신실한 기도. 당신의 정원이 자라고 있습니다!',
  ),
  '30_day_streak': MilestoneInfo(
    type: '30_day_streak',
    emoji: '🌸',
    titleEn: '30 Days!',
    titleKo: '30일 연속!',
    descEn: 'Your garden has blossomed into a flower field!',
    descKo: '당신의 정원이 꽃밭이 되었습니다!',
  ),
  '100_prayers': MilestoneInfo(
    type: '100_prayers',
    emoji: '🙏',
    titleEn: '100th Prayer!',
    titleKo: '100번째 기도!',
    descEn: 'A hundred conversations with God. You are deeply rooted.',
    descKo: '하나님과의 백 번째 대화. 깊이 뿌리내렸습니다.',
  ),
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
              info.title(locale),
              style: AbbaTypography.h1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AbbaSpacing.sm),
            Text(
              info.desc(locale),
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
                  backgroundColor: AbbaColors.sage,
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
