import 'package:flutter/material.dart';

import 'demos/language_picker_tile_demo.dart';
import 'demos/profile_edit_form_demo.dart';
import 'demos/profile_header_demo.dart';
import 'demos/settings_screen_demo.dart';
import 'demos/theme_switch_tile_demo.dart';

class ProfileDemo extends StatelessWidget {
  const ProfileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('ProfileHeader'),
            subtitle: const Text('Avatar, name, bio, and stats'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileHeaderDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('ProfileEditForm'),
            subtitle: const Text('Editable name and bio fields'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfileEditFormDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('SettingsScreen'),
            subtitle: const Text('Grouped settings with toggles and nav'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreenDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('ThemeSwitchTile'),
            subtitle: const Text('Dark mode toggle tile'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ThemeSwitchTileDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('LanguagePickerTile'),
            subtitle: const Text('Language selector dropdown'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const LanguagePickerTileDemo(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
