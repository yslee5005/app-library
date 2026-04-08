import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/providers.dart';
import 'router/app_router.dart';
import 'theme/learn_theme.dart';

class LearnApp extends ConsumerWidget {
  const LearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Claude Code Learn',
      debugShowCheckedModeBanner: false,
      theme: learnThemeGenerator.light(),
      darkTheme: learnThemeGenerator.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
