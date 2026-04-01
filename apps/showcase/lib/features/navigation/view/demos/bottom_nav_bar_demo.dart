import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class BottomNavBarDemo extends StatefulWidget {
  const BottomNavBarDemo({super.key});

  @override
  State<BottomNavBarDemo> createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  int _currentIndex = 0;

  static const _labels = ['Home', 'Alerts', 'Settings'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppBottomNavBar')),
      body: Center(
        child: Text(
          '${_labels[_currentIndex]} selected',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        items: const [
          AppBottomNavItem(icon: Icons.home, label: 'Home'),
          AppBottomNavItem(
            icon: Icons.notifications,
            label: 'Alerts',
            badgeCount: 3,
          ),
          AppBottomNavItem(icon: Icons.settings, label: 'Settings'),
        ],
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
