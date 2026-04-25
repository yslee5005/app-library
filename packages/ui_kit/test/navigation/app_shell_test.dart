import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tabs = [
    const AppShellTab(icon: Icons.home, label: 'Home', body: Text('Home Page')),
    const AppShellTab(
      icon: Icons.settings,
      activeIcon: Icons.settings_outlined,
      label: 'Settings',
      body: Text('Settings Page'),
    ),
  ];

  Widget buildApp({
    int currentIndex = 0,
    ValueChanged<int>? onTabChanged,
    PreferredSizeWidget? appBar,
    Widget? drawer,
  }) {
    return MaterialApp(
      home: AppShell(
        tabs: tabs,
        currentIndex: currentIndex,
        onTabChanged: onTabChanged ?? (_) {},
        appBar: appBar,
        drawer: drawer,
      ),
    );
  }

  testWidgets('renders all tab labels in the navigation bar', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('shows body of the selected tab', (tester) async {
    await tester.pumpWidget(buildApp(currentIndex: 0));

    // IndexedStack keeps both children in the tree
    expect(find.text('Home Page'), findsOneWidget);

    // The non-selected tab body is still in the tree (IndexedStack)
    // but the first tab should be visible
    final homeFinder = find.text('Home Page');
    expect(tester.getSize(homeFinder).width, greaterThan(0));
  });

  testWidgets('calls onTabChanged when a nav destination is tapped', (
    tester,
  ) async {
    int? tappedIndex;
    await tester.pumpWidget(buildApp(onTabChanged: (i) => tappedIndex = i));

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(tappedIndex, 1);
  });

  testWidgets('renders optional AppBar', (tester) async {
    await tester.pumpWidget(
      buildApp(appBar: AppBar(title: const Text('My App'))),
    );

    expect(find.text('My App'), findsOneWidget);
  });

  testWidgets('renders optional Drawer', (tester) async {
    await tester.pumpWidget(
      buildApp(
        appBar: AppBar(title: const Text('D')),
        drawer: const Drawer(child: Text('Drawer Content')),
      ),
    );

    // Open drawer via scaffold
    final scaffoldState = tester.firstState<ScaffoldState>(
      find.byType(Scaffold),
    );
    scaffoldState.openDrawer();
    await tester.pumpAndSettle();

    expect(find.text('Drawer Content'), findsOneWidget);
  });
}
