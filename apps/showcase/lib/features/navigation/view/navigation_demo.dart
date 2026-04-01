import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class NavigationDemo extends StatefulWidget {
  const NavigationDemo({super.key});

  @override
  State<NavigationDemo> createState() => _NavigationDemoState();
}

class _NavigationDemoState extends State<NavigationDemo> {
  int _shellIndex = 0;
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'AppShell'),
          SizedBox(
            height: 350,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppShell(
                tabs: [
                  AppShellTab(
                    icon: Icons.home,
                    label: 'Home',
                    body: const Center(child: Text('Home Tab')),
                  ),
                  AppShellTab(
                    icon: Icons.explore,
                    label: 'Explore',
                    body: const Center(child: Text('Explore Tab')),
                  ),
                  AppShellTab(
                    icon: Icons.person,
                    label: 'Profile',
                    body: const Center(child: Text('Profile Tab')),
                  ),
                ],
                currentIndex: _shellIndex,
                onTabChanged: (i) => setState(() => _shellIndex = i),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppBottomNavBar'),
          AppBottomNavBar(
            items: const [
              AppBottomNavItem(icon: Icons.home, label: 'Home'),
              AppBottomNavItem(
                icon: Icons.notifications,
                label: 'Alerts',
                badgeCount: 3,
              ),
              AppBottomNavItem(icon: Icons.settings, label: 'Settings'),
            ],
            currentIndex: _bottomNavIndex,
            onTap: (i) => setState(() => _bottomNavIndex = i),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppTabLayout'),
          SizedBox(
            height: 200,
            child: AppTabLayout(
              tabs: [
                AppTab(
                  label: 'Tab 1',
                  icon: Icons.star,
                  body: const Center(child: Text('Content 1')),
                ),
                AppTab(
                  label: 'Tab 2',
                  icon: Icons.favorite,
                  body: const Center(child: Text('Content 2')),
                ),
                AppTab(
                  label: 'Tab 3',
                  icon: Icons.bookmark,
                  body: const Center(child: Text('Content 3')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppDrawerMenu'),
          SizedBox(
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AppDrawerMenu(
                displayName: 'John Doe',
                email: 'john.doe@example.com',
                items: [
                  DrawerMenuItem(
                    icon: Icons.home,
                    label: 'Home',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () {},
                  ),
                  DrawerMenuItem(
                    icon: Icons.logout,
                    label: 'Log Out',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
