import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/qt_meditation_result.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/expandable_card.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationSuggestion application;
  final String title;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.title,
  });

  /// Collapsed summary. Prefer morningAction when time-blocks exist;
  /// otherwise the legacy single-line `action`. Cap at 40 chars.
  String get _summary {
    final text = application.hasTimeBlocks
        ? (application.morningAction.isNotEmpty
              ? application.morningAction
              : (application.dayAction.isNotEmpty
                    ? application.dayAction
                    : application.eveningAction))
        : application.action;
    if (text.length <= 40) return text;
    return '${text.substring(0, 40)}...';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ExpandableCard(
      icon: '✏️',
      title: title,
      summary: _summary,
      expandedContent: application.hasTimeBlocks
          ? _TimeBlockList(application: application, l10n: l10n)
          : Text(
              application.action,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.8,
              ),
            ),
    );
  }
}

/// Phase 5B — 3 time-block layout. Empty blocks are hidden.
class _TimeBlockList extends StatelessWidget {
  final ApplicationSuggestion application;
  final AppLocalizations l10n;

  const _TimeBlockList({required this.application, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final blocks = <_Block>[
      if (application.morningAction.isNotEmpty)
        _Block(
          emoji: '🌅',
          label: l10n.applicationMorningLabel,
          action: application.morningAction,
        ),
      if (application.dayAction.isNotEmpty)
        _Block(
          emoji: '☀️',
          label: l10n.applicationDayLabel,
          action: application.dayAction,
        ),
      if (application.eveningAction.isNotEmpty)
        _Block(
          emoji: '🌙',
          label: l10n.applicationEveningLabel,
          action: application.eveningAction,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < blocks.length; i++) ...[
          if (i > 0) const SizedBox(height: AbbaSpacing.md),
          blocks[i],
        ],
      ],
    );
  }
}

class _Block extends StatelessWidget {
  final String emoji;
  final String label;
  final String action;

  const _Block({
    required this.emoji,
    required this.label,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: AbbaSpacing.sm),
            Text(
              label,
              style: AbbaTypography.label.copyWith(
                color: AbbaColors.softGold,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AbbaSpacing.xs),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            action,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.8,
            ),
          ),
        ),
      ],
    );
  }
}
