import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';

import 'providers/providers.dart';
import 'router/app_router.dart';
import 'theme/abba_theme.dart';

class AbbaApp extends ConsumerStatefulWidget {
  const AbbaApp({super.key});

  @override
  ConsumerState<AbbaApp> createState() => _AbbaAppState();
}

class _AbbaAppState extends ConsumerState<AbbaApp> {
  @override
  void initState() {
    super.initState();
    // Preload the current locale's Bible bundle at startup. Fire-and-forget
    // — dedup'd by BibleTextService so repeat calls are harmless.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final locale = ref.read(localeProvider);
      unawaited(ref.read(bibleTextServiceProvider).preload(locale));
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    // Dark mode disabled for MVP — AbbaColors.cream backgrounds clash with dark theme.
    // themeModeProvider kept for future use but not applied to MaterialApp.

    return MaterialApp.router(
      title: 'Abba',
      debugShowCheckedModeBanner: false,
      theme: abbaTheme(),
      locale: Locale(locale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        // Existing (5)
        Locale('en'),
        Locale('ko'),
        Locale('ja'),
        Locale('es'),
        Locale('zh'),
        // Tier 1 (5)
        Locale('pt'),
        Locale('fr'),
        Locale('hi'),
        Locale.fromSubtags(languageCode: 'fil'),
        Locale('sw'),
        // Tier 2 (10)
        Locale('de'),
        Locale('it'),
        Locale('pl'),
        Locale('ru'),
        Locale('id'),
        Locale('uk'),
        Locale('ro'),
        Locale('nl'),
        Locale('hu'),
        Locale('cs'),
        // Tier 3 (15)
        Locale('vi'),
        Locale('th'),
        Locale('tr'),
        Locale('ar'),
        Locale('he'),
        Locale('el'),
        Locale('sv'),
        Locale('no'),
        Locale('da'),
        Locale('fi'),
        Locale('hr'),
        Locale('sk'),
        Locale('ms'),
        Locale('am'),
        Locale('my'),
      ],
      routerConfig: appRouter,
    );
  }
}
