import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/view/splash_screen.dart';
import '../features/onboarding/view/welcome_screen.dart';
import '../features/onboarding/view/pregnancy_input_screen.dart';
import '../features/onboarding/view/postnatal_input_screen.dart';
import '../features/home/view/home_screen.dart';
import '../features/record/view/record_screen.dart';
import '../features/growth/view/growth_screen.dart';
import '../features/us/view/us_screen.dart';
import '../features/settings/view/settings_screen.dart';
import 'shell_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // --- Onboarding ---
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/onboarding/pregnancy',
      builder: (context, state) => const PregnancyInputScreen(),
    ),
    GoRoute(
      path: '/onboarding/postnatal',
      builder: (context, state) => const PostnatalInputScreen(),
    ),

    // --- Main Shell (Bottom Navigation) ---
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/record',
              builder: (context, state) => const RecordScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/growth',
              builder: (context, state) => const GrowthScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/us', builder: (context, state) => const UsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
