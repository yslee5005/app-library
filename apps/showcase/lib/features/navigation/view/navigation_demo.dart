import 'package:flutter/material.dart';

import 'demos/app_shell_demo.dart';
import 'demos/bottom_nav_bar_demo.dart';
import 'demos/drawer_menu_demo.dart';
import 'demos/tab_layout_demo.dart';

class NavigationDemo extends StatelessWidget {
  const NavigationDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('AppShell'),
            subtitle: const Text('Full shell with bottom nav + tab bodies'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (_) => const AppShellDemo()),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.view_compact),
            title: const Text('AppBottomNavBar'),
            subtitle: const Text('Standalone bottom navigation bar'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const BottomNavBarDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.menu),
            title: const Text('AppDrawerMenu'),
            subtitle: const Text('Drawer with header and menu items'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const DrawerMenuDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.tab),
            title: const Text('AppTabLayout'),
            subtitle: const Text('TabBar with swipeable content'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const TabLayoutDemo(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
