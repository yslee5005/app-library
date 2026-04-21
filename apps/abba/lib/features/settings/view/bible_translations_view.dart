import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../providers/providers.dart';
import '../../../theme/abba_theme.dart';

/// Settings > Bible Translations — attribution page.
/// Lists every Public Domain Bible translation the app uses, for
/// transparency (legal attribution is not required for PD content,
/// but this builds trust with senior users).
class BibleTranslationsView extends ConsumerWidget {
  const BibleTranslationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final service = ref.watch(bibleTextServiceProvider);
    final attributions = service.attributions();

    return Scaffold(
      backgroundColor: AbbaColors.cream,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          l10n.settingsBibleTranslationsLabel,
          style: AbbaTypography.h1,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AbbaSpacing.md),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AbbaSpacing.md,
              vertical: AbbaSpacing.lg,
            ),
            child: Text(
              l10n.settingsBibleTranslationsIntro,
              style: AbbaTypography.body.copyWith(
                color: AbbaColors.warmBrown,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: AbbaSpacing.md),
          for (final entry in attributions.entries)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AbbaSpacing.md,
                vertical: AbbaSpacing.xs,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 48,
                    child: Text(
                      entry.key,
                      style: AbbaTypography.label.copyWith(
                        color: AbbaColors.muted,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AbbaSpacing.sm),
                  Expanded(
                    child: Text(
                      '${entry.value} · Public Domain',
                      style: AbbaTypography.body.copyWith(
                        color: AbbaColors.warmBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AbbaSpacing.xl),
        ],
      ),
    );
  }
}
