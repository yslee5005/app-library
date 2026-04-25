import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final pages = [
    const OnboardingPage(title: 'Welcome', subtitle: 'First page description'),
    const OnboardingPage(
      title: 'Features',
      subtitle: 'Second page description',
      image: Icon(Icons.star, size: 100),
    ),
    const OnboardingPage(
      title: 'Get Started',
      subtitle: 'Third page description',
    ),
  ];

  Widget buildApp({VoidCallback? onFinish, VoidCallback? onSkip}) {
    return MaterialApp(
      home: Scaffold(
        body: OnboardingCarousel(
          pages: pages,
          onFinish: onFinish ?? () {},
          onSkip: onSkip,
        ),
      ),
    );
  }

  testWidgets('renders first page title and subtitle', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('First page description'), findsOneWidget);
  });

  testWidgets('shows skip button when onSkip is provided', (tester) async {
    bool skipped = false;
    await tester.pumpWidget(buildApp(onSkip: () => skipped = true));

    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    expect(skipped, isTrue);
  });

  testWidgets('hides skip button when onSkip is null', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Skip'), findsNothing);
  });

  testWidgets('tapping Next advances to the next page', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Next'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Features'), findsOneWidget);
  });

  testWidgets('last page shows finish button label', (tester) async {
    await tester.pumpWidget(buildApp());

    // Advance to last page
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Get Started'), findsWidgets);
  });

  testWidgets('calls onFinish when finish button is tapped on last page', (
    tester,
  ) async {
    bool finished = false;
    await tester.pumpWidget(buildApp(onFinish: () => finished = true));

    // Go to last page
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // "Get Started" appears as both the page title and the button label.
    // Tap the FilledButton specifically.
    await tester.tap(find.widgetWithText(FilledButton, 'Get Started'));
    expect(finished, isTrue);
  });

  testWidgets('renders page indicators matching page count', (tester) async {
    await tester.pumpWidget(buildApp());

    // 3 page indicators (AnimatedContainers)
    final indicators = find.byType(AnimatedContainer);
    expect(indicators, findsNWidgets(3));
  });
}
