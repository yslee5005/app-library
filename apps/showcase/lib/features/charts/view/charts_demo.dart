import 'package:flutter/material.dart';

import 'demos/app_progress_bar_demo.dart';
import 'demos/heatmap_calendar_demo.dart';
import 'demos/stat_card_demo.dart';

class ChartsDemo extends StatelessWidget {
  const ChartsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Charts')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text('StatCard'),
            subtitle: const Text('Stat cards with trend indicators'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const StatCardDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.linear_scale),
            title: const Text('AppProgressBar'),
            subtitle: const Text('Linear and circular progress indicators'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AppProgressBarDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_view_month),
            title: const Text('HeatmapCalendar'),
            subtitle: const Text('GitHub-style activity heatmap'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const HeatmapCalendarDemo()),
            ),
          ),
        ],
      ),
    );
  }
}
