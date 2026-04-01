import 'package:flutter/material.dart';

import 'demos/app_card_demo.dart';
import 'demos/app_list_tile_demo.dart';
import 'demos/detail_screen_layout_demo.dart';
import 'demos/feed_list_view_demo.dart';

class FeedDemo extends StatelessWidget {
  const FeedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.view_list),
            title: const Text('FeedListView'),
            subtitle: const Text('Infinite scroll feed with cards'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const FeedListViewDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.credit_card),
            title: const Text('AppCard'),
            subtitle: const Text('Vertical, horizontal, and text-only variants'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AppCardDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('AppListTile'),
            subtitle: const Text('List tile with leading, trailing, and tap'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const AppListTileDemo()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('DetailScreenLayout'),
            subtitle: const Text('Collapsing hero image detail screen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const DetailScreenLayoutDemo(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
