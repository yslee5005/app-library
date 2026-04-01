import 'package:app_lib_theme/theme.dart';
import 'package:flutter/material.dart';

import 'router/app_router.dart';

class ShowcaseApp extends StatefulWidget {
  const ShowcaseApp({super.key});

  static final themeConfig = ThemeConfig(
    seedColor: const Color(0xFF6750A4),
    borderRadius: 12.0,
  );

  static final _generator = ThemeGenerator(themeConfig);

  /// Global notifier so any screen can toggle dark mode.
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.system);

  @override
  State<ShowcaseApp> createState() => _ShowcaseAppState();
}

class _ShowcaseAppState extends State<ShowcaseApp> {
  @override
  void initState() {
    super.initState();
    ShowcaseApp.themeMode.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ShowcaseApp.themeMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Showcase',
      debugShowCheckedModeBanner: false,
      theme: ShowcaseApp._generator.light(),
      darkTheme: ShowcaseApp._generator.dark(),
      themeMode: ShowcaseApp.themeMode.value,
      routerConfig: appRouter,
    );
  }
}
