import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app.dart';

class SettingsScreenDemo extends StatefulWidget {
  const SettingsScreenDemo({super.key});

  @override
  State<SettingsScreenDemo> createState() => _SettingsScreenDemoState();
}

class _SettingsScreenDemoState extends State<SettingsScreenDemo> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    ShowcaseApp.themeMode.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    ShowcaseApp.themeMode.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isDark = ShowcaseApp.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('SettingsScreen')),
      body: SettingsScreen(
        sections: [
          SettingsSection(
            title: 'Appearance',
            items: [
              SettingsItem(
                title: 'Dark Mode',
                icon: Icons.dark_mode,
                type: SettingsItemType.toggle,
                value: isDark,
                onChanged: (val) {
                  ShowcaseApp.themeMode.value =
                      (val as bool) ? ThemeMode.dark : ThemeMode.light;
                },
              ),
              SettingsItem(
                title: 'Language',
                subtitle: 'English',
                icon: Icons.language,
                type: SettingsItemType.navigation,
                onTap: () {},
              ),
            ],
          ),
          SettingsSection(
            title: 'Account',
            items: [
              SettingsItem(
                title: 'Notifications',
                icon: Icons.notifications,
                type: SettingsItemType.toggle,
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() => _notificationsEnabled = val as bool);
                },
              ),
              SettingsItem(
                title: 'Privacy',
                icon: Icons.lock,
                type: SettingsItemType.navigation,
                onTap: () {},
              ),
              SettingsItem(
                title: 'Log Out',
                icon: Icons.logout,
                type: SettingsItemType.navigation,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
