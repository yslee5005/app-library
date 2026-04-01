import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class DrawerMenuDemo extends StatelessWidget {
  const DrawerMenuDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppDrawerMenu')),
      drawer: Drawer(
        child: AppDrawerMenu(
          displayName: 'John Doe',
          email: 'john.doe@example.com',
          items: [
            DrawerMenuItem(
              icon: Icons.home,
              label: 'Home',
              onTap: () => Navigator.pop(context),
            ),
            DrawerMenuItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () => Navigator.pop(context),
            ),
            DrawerMenuItem(
              icon: Icons.info,
              label: 'About',
              onTap: () => Navigator.pop(context),
            ),
            DrawerMenuItem(
              icon: Icons.logout,
              label: 'Log Out',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Swipe from left or tap menu icon to open drawer'),
      ),
    );
  }
}
