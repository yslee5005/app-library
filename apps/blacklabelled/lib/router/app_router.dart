import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/consult/view/consult_view.dart';
import '../features/furniture/view/furniture_detail_view.dart';
import '../features/furniture/view/furniture_view.dart';
import '../features/home/view/home_view.dart';
import '../features/mypage/view/mypage_view.dart';
import '../features/portfolio/view/portfolio_detail_view.dart';
import '../features/portfolio/view/portfolio_view.dart';
import '../features/shell/main_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder:
          (context, state, navigationShell) =>
              MainShell(navigationShell: navigationShell),
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),
        // Tab 2: Portfolio
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/portfolio',
              builder: (context, state) => const PortfolioView(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder:
                      (context, state) =>
                          PortfolioDetailView(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Furniture
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/furniture',
              builder: (context, state) => const FurnitureView(),
              routes: [
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder:
                      (context, state) =>
                          FurnitureDetailView(id: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        // Tab 4: Consult
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/consult',
              builder: (context, state) => const ConsultView(),
            ),
          ],
        ),
        // Tab 5: My Page
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/mypage',
              builder: (context, state) => const MyPageView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
