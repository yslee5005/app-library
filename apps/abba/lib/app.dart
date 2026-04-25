import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'l10n/generated/app_localizations.dart';

import 'providers/providers.dart';
import 'router/app_router.dart';
import 'theme/abba_theme.dart';

class AbbaApp extends ConsumerWidget {
  const AbbaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      // Inject AppLocalizations into NotificationService whenever the locale
      // changes. Uses the `child` subtree so every rebuild sees a valid
      // AppLocalizations instance (localizationsDelegates are already loaded
      // at this level).
      builder: (context, child) {
        return _NotificationLocalizationBridge(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}

/// Listens to locale-aware [AppLocalizations] and pushes the current instance
/// down to [NotificationService] so background-scheduled reminders render in
/// the user's selected language.
class _NotificationLocalizationBridge extends ConsumerStatefulWidget {
  final Widget child;

  const _NotificationLocalizationBridge({required this.child});

  @override
  ConsumerState<_NotificationLocalizationBridge> createState() =>
      _NotificationLocalizationBridgeState();
}

class _NotificationLocalizationBridgeState
    extends ConsumerState<_NotificationLocalizationBridge> {
  String? _lastAppliedLocale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    if (_lastAppliedLocale == l10n.localeName) return;

    _lastAppliedLocale = l10n.localeName;
    // Fire-and-forget — don't block the widget tree on I/O.
    ref.read(notificationServiceProvider).setLocalization(l10n);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
