import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../app.dart';

class ThemeSwitchTileDemo extends StatelessWidget {
  const ThemeSwitchTileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ThemeSwitchTile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Toggle dark mode:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      ),
    );
  }
}
