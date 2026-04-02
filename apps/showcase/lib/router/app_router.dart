import 'package:go_router/go_router.dart';

import '../features/charts/view/charts_demo.dart';
import '../features/feed/view/feed_demo.dart';
import '../features/feedback/view/feedback_demo.dart';
import '../features/forms/view/forms_demo.dart';
import '../features/full_flow/view/full_flow_demo.dart';
import '../features/home/view/home_view.dart';
import '../features/media/view/media_demo.dart';
import '../features/navigation/view/navigation_demo.dart';
import '../features/onboarding/view/onboarding_demo.dart';
import '../features/profile/view/profile_demo.dart';
import '../features/search/view/search_demo.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/navigation',
      builder: (context, state) => const NavigationDemo(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingDemo(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileDemo(),
    ),
    GoRoute(
      path: '/feed',
      builder: (context, state) => const FeedDemo(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchDemo(),
    ),
    GoRoute(
      path: '/forms',
      builder: (context, state) => const FormsDemo(),
    ),
    GoRoute(
      path: '/feedback',
      builder: (context, state) => const FeedbackDemo(),
    ),
    GoRoute(
      path: '/media',
      builder: (context, state) => const MediaDemo(),
    ),
    GoRoute(
      path: '/charts',
      builder: (context, state) => const ChartsDemo(),
    ),
    GoRoute(
      path: '/full-flow',
      builder: (context, state) => const FullFlowDemo(),
    ),
  ],
);
