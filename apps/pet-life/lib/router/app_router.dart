import 'package:go_router/go_router.dart';

import '../features/analysis/view/analysis_view.dart';
import '../features/records/view/records_view.dart';
import '../features/home/view/home_view.dart';
import '../features/onboarding/view/onboarding_view.dart';
import '../features/settings/view/settings_view.dart';
import '../widgets/main_shell.dart';

class AppRouter {
  final bool isOnboarded;

  AppRouter({required this.isOnboarded});

  late final router = GoRouter(
    initialLocation: isOnboarded ? '/home' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeView(),
            ),
          ),
          GoRoute(
            path: '/analysis',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AnalysisView(),
            ),
          ),
          GoRoute(
            path: '/records',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RecordsView(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsView(),
            ),
          ),
        ],
      ),
    ],
  );
}
