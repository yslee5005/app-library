import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../sample_data/sample_data.dart';

class ProfileDemo extends StatelessWidget {
  const ProfileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'ProfileHeader'),
          ProfileHeader(
            displayName: SampleData.userName,
            bio: SampleData.userBio,
            stats: const [
              ProfileStat(label: 'Followers', count: 1200),
              ProfileStat(label: 'Posts', count: 342),
              ProfileStat(label: 'Following', count: 180),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ProfileEditForm'),
          ProfileEditForm(
            initialName: SampleData.userName,
            initialBio: SampleData.userBio,
            onSave: (name, bio) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Saved: $name')),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'SettingsScreen'),
          SizedBox(
            height: 500,
            child: SettingsScreen(
              sections: [
                SettingsSection(
                  title: 'Appearance',
                  items: [
                    SettingsItem(
                      title: 'Dark Mode',
                      icon: Icons.dark_mode,
                      type: SettingsItemType.toggle,
                      value: ShowcaseApp.themeMode.value == ThemeMode.dark,
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
                      value: true,
                      onChanged: (_) {},
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
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ThemeSwitchTile'),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ShowcaseApp.themeMode,
            builder: (context, mode, _) {
              return ThemeSwitchTile(
                isDarkMode: mode == ThemeMode.dark,
                onChanged: (val) {
                  ShowcaseApp.themeMode.value =
                      val ? ThemeMode.dark : ThemeMode.light;
                },
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'LanguagePickerTile'),
          LanguagePickerTile(
            currentLanguage: 'en',
            languages: const [
              LanguageOption(code: 'en', label: 'English'),
              LanguageOption(code: 'ko', label: 'Korean'),
              LanguageOption(code: 'ja', label: 'Japanese'),
            ],
            onChanged: (code) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Language: $code')),
              );
            },
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
