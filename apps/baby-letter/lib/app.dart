import 'package:flutter/material.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

/// 앱 루트 위젯
class BabyLetterApp extends StatelessWidget {
  const BabyLetterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '아기의 편지',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
