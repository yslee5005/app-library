import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/providers.dart';
import '../theme/abba_theme.dart';
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
import '../features/settings/view/membership_view.dart';
import '../features/settings/view/notification_settings_view.dart';
import '../features/settings/view/settings_view.dart';
import '../features/welcome/view/welcome_view.dart';
import '../widgets/abba_tab_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
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
                GoRoute(
                  path: 'my-records',
                  builder: (context, state) => const MyPageView(),
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
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) =>
                      const NotificationSettingsView(),
                ),
                GoRoute(
                  path: 'membership',
                  builder: (context, state) => const MembershipView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const _ScaffoldWithNavBar({required this.navigationShell});

  Future<bool> _confirmLeave(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AbbaRadius.lg),
        ),
        title: Text(
          l10n.leaveRecordingTitle,
          style: AbbaTypography.h2,
          textAlign: TextAlign.center,
        ),
        content: Text(
          l10n.leaveRecordingMessage,
          style: AbbaTypography.body,
          textAlign: TextAlign.center,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(
          AbbaSpacing.lg, 0, AbbaSpacing.lg, AbbaSpacing.lg,
        ),
        actions: [
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AbbaColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.leaveButton,
                    style: AbbaTypography.body.copyWith(color: AbbaColors.white),
                  ),
                ),
              ),
              const SizedBox(height: AbbaSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: abbaButtonHeight,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AbbaColors.sage),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AbbaRadius.md),
                    ),
                  ),
                  child: Text(
                    l10n.stayButton,
                    style: AbbaTypography.body.copyWith(color: AbbaColors.sage),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecording = ref.watch(isRecordingProvider);

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AbbaTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) async {
          if (isRecording) {
            final leave = await _confirmLeave(context);
            if (!leave) return;
            ref.read(isRecordingProvider.notifier).state = false;
          }
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
