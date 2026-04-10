import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/ai_loading/view/ai_loading_view.dart';
import '../features/calendar/view/calendar_view.dart';
import '../features/community/view/community_view.dart';
import '../features/community/view/write_post_view.dart';
import '../features/dashboard/view/dashboard_view.dart';
import '../features/dashboard/view/prayer_dashboard_view.dart';
import '../features/dashboard/view/qt_dashboard_view.dart';
import '../features/home/view/home_view.dart';
import '../features/qt/view/qt_view.dart';
import '../features/my_page/view/my_page_view.dart';
import '../features/settings/view/settings_view.dart';
import '../features/welcome/view/welcome_view.dart';
import '../widgets/abba_tab_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/welcome',
  redirect: (context, state) {
    // Anonymous-first: no auth redirect needed
    // Welcome is shown only on first launch (handled by initial location)
    if (state.matchedLocation == '/login') return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeView()),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return _ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeView(),
              routes: [
                GoRoute(
                  path: 'ai-loading',
                  builder: (context, state) => const AiLoadingView(),
                ),
                GoRoute(
                  path: 'dashboard',
                  builder: (context, state) => const DashboardView(),
                ),
                GoRoute(
                  path: 'prayer-dashboard',
                  builder: (context, state) =>
                      const PrayerDashboardView(),
                ),
                GoRoute(
                  path: 'qt-dashboard',
                  builder: (context, state) => const QtDashboardView(),
                ),
                GoRoute(
                  path: 'qt',
                  builder: (context, state) => const QtView(),
                ),
              ],
            ),
          ],
        ),
        // Tab 1: Calendar
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const CalendarView(),
            ),
          ],
        ),
        // Tab 2: Community
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/community',
              builder: (context, state) => const CommunityView(),
              routes: [
                GoRoute(
                  path: 'write',
                  builder: (context, state) => const WritePostView(),
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Settings
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsView(),
              routes: [
                GoRoute(
                  path: 'my-page',
                  builder: (context, state) => const MyPageView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _ScaffoldWithNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AbbaTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
