import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/blacklabelled_theme.dart';

class BlackLabelledApp extends StatelessWidget {
  const BlackLabelledApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BLACKLABELLED',
      debugShowCheckedModeBanner: false,
      theme: BlackLabelledTheme.darkTheme,
      darkTheme: BlackLabelledTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
    );
  }
}
