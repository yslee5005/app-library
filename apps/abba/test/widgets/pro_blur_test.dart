import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:abba/l10n/generated/app_localizations.dart';
import 'package:abba/theme/abba_theme.dart';
import 'package:abba/widgets/pro_blur.dart';

/// Minimal GoRouter-hosted harness so `context.push('/settings/membership')`
/// inside [ProBlur] doesn't crash. The real app router lives in
/// `lib/router/app_router.dart`; here we only need a stub `/` + `/membership`.
Widget _buildHarness({
  required Widget child,
  void Function()? onMembershipRoute,
}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/settings/membership',
        builder: (_, __) {
          onMembershipRoute?.call();
          return const Scaffold(body: Text('membership-route'));
        },
      ),
    ],
  );

  return MaterialApp.router(
    routerConfig: router,
    theme: abbaTheme(),
    locale: const Locale('en'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [Locale('en'), Locale('ko')],
  );
}

void main() {
  group('ProBlur', () {
    testWidgets('unlocked: renders full content without lock CTA', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildHarness(
          child: const ProBlur(
            title: 'AI Guidance',
            icon: '💡',
            isLocked: false,
            // onUnlock should not be invoked when unlocked; spy-value kept
            // null-safe by the required-API contract.
            onUnlock: _noop,
            content: Text('secret-body-text'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Title + icon + content all visible.
      expect(find.text('AI Guidance'), findsOneWidget);
      expect(find.text('💡'), findsOneWidget);
      expect(find.text('secret-body-text'), findsOneWidget);
      // Skeleton + hint must NOT render in unlocked mode.
      expect(find.byKey(const ValueKey('pro_blur_skeleton')), findsNothing);
      expect(find.byKey(const ValueKey('pro_blur_hint')), findsNothing);
    });

    testWidgets('locked with lockedHint: renders skeleton + hint + body hidden', (
      tester,
    ) async {
      const hint = 'Discover the deeper history behind a word';
      await tester.pumpWidget(
        _buildHarness(
          child: const ProBlur(
            title: 'AI Guidance',
            icon: '💡',
            isLocked: true,
            onUnlock: _noop,
            content: Text('secret-body-text'),
            lockedHint: hint,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Locked card ALWAYS shows title + icon (discovery UX).
      expect(find.text('AI Guidance'), findsOneWidget);
      expect(find.text('💡'), findsOneWidget);

      // Body content is NOT rendered while locked.
      expect(find.text('secret-body-text'), findsNothing);

      // Skeleton blur preview is rendered (visual placeholder, no real text).
      expect(find.byKey(const ValueKey('pro_blur_skeleton')), findsOneWidget);

      // BackdropFilter must be present inside the skeleton.
      expect(find.byType(BackdropFilter), findsOneWidget);

      // Hint is rendered with its key.
      expect(find.byKey(const ValueKey('pro_blur_hint')), findsOneWidget);
      expect(find.text(hint), findsOneWidget);

      // Membership badge (l10n.membershipTitle = "Membership") is shown.
      expect(find.text('Membership'), findsOneWidget);

      // Pro CTA copy ("Unlock with Pro" in en).
      expect(find.text('Unlock with Pro'), findsOneWidget);
    });

    testWidgets('locked without lockedHint: skeleton renders, hint omitted', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildHarness(
          child: const ProBlur(
            title: 'AI Guidance',
            icon: '💡',
            isLocked: true,
            onUnlock: _noop,
            content: Text('secret-body-text'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Skeleton always renders when locked.
      expect(find.byKey(const ValueKey('pro_blur_skeleton')), findsOneWidget);

      // Hint key must NOT exist when no hint is supplied.
      expect(find.byKey(const ValueKey('pro_blur_hint')), findsNothing);

      // Body still hidden.
      expect(find.text('secret-body-text'), findsNothing);

      // Title + badge still visible.
      expect(find.text('AI Guidance'), findsOneWidget);
      expect(find.text('Membership'), findsOneWidget);
    });

    testWidgets('locked: tap pushes /settings/membership route', (
      tester,
    ) async {
      var navigatedToMembership = false;
      await tester.pumpWidget(
        _buildHarness(
          onMembershipRoute: () => navigatedToMembership = true,
          child: const ProBlur(
            title: 'AI Guidance',
            icon: '💡',
            isLocked: true,
            onUnlock: _noop,
            content: Text('secret-body-text'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // InkWell wraps the entire locked card; tap by locating any visible
      // title text (guaranteed to hit the InkWell hit region).
      await tester.tap(find.text('AI Guidance'));
      await tester.pumpAndSettle();

      expect(navigatedToMembership, isTrue);
      expect(find.text('membership-route'), findsOneWidget);
    });
  });
}

void _noop() {}
