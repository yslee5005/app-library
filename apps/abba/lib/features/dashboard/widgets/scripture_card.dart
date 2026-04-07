import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../models/prayer.dart';
import '../../../theme/abba_theme.dart';
import '../../../widgets/abba_card.dart';

class ScriptureCard extends StatelessWidget {
  final Scripture scripture;
  final String title;
  final String locale;

  const ScriptureCard({
    super.key,
    required this.scripture,
    required this.title,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AbbaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('📜', style: TextStyle(fontSize: 24)),
              const SizedBox(width: AbbaSpacing.sm),
              Text(title, style: AbbaTypography.h2),
            ],
          ),
          const SizedBox(height: AbbaSpacing.md),
          Text(scripture.verse(locale), style: AbbaTypography.body),
          const SizedBox(height: AbbaSpacing.sm),
          Text(
            '— ${scripture.reference}',
            style: AbbaTypography.bodySmall.copyWith(
              color: AbbaColors.muted,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (scripture.reason(locale).isNotEmpty) ...[
            const SizedBox(height: AbbaSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AbbaSpacing.sm),
              decoration: BoxDecoration(
                color: AbbaColors.sage.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(AbbaRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.scriptureReasonLabel,
                    style: AbbaTypography.caption.copyWith(
                      color: AbbaColors.sage,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scripture.reason(locale),
                    style: AbbaTypography.bodySmall.copyWith(
                      color: AbbaColors.sage,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
