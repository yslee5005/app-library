import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppShellDemo extends StatefulWidget {
  const AppShellDemo({super.key});

  @override
  State<AppShellDemo> createState() => _AppShellDemoState();
}

class _AppShellDemoState extends State<AppShellDemo> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppShell(
      tabs: [
        AppShellTab(
          icon: Icons.home,
          label: 'Home',
          body: const Center(child: Text('Home Tab Content')),
        ),
        AppShellTab(
          icon: Icons.explore,
          label: 'Explore',
          body: const Center(child: Text('Explore Tab Content')),
        ),
        AppShellTab(
          icon: Icons.person,
          label: 'Profile',
          body: const Center(child: Text('Profile Tab Content')),
        ),
      ],
      currentIndex: _currentIndex,
      onTabChanged: (i) => setState(() => _currentIndex = i),
    );
  }
}
