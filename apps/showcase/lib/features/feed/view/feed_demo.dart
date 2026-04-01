import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../sample_data/sample_data.dart';

class FeedDemo extends StatelessWidget {
  const FeedDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feed')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'FeedListView with AppCards'),
          SizedBox(
            height: 500,
            child: FeedListView(
              itemCount: SampleData.feedItems.length,
              itemBuilder: (context, index) {
                final item = SampleData.feedItems[index];
                return AppCard(
                  title: item['title']!,
                  subtitle: item['subtitle'],
                  image: Container(
                    color: Colors.primaries[index % Colors.primaries.length]
                        .withValues(alpha: 0.3),
                    child: Center(
                      child: Icon(
                        Icons.image,
                        size: 48,
                        color:
                            Colors.primaries[index % Colors.primaries.length],
                      ),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tapped ${item['title']}')),
                    );
                  },
                );
              },
              onRefresh: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
              },
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppCard (horizontal layout)'),
          AppCard(
            title: 'Horizontal Card',
            subtitle: 'This card uses a horizontal layout.',
            layout: AppCardLayout.horizontal,
            image: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Center(child: Icon(Icons.image, size: 36)),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppListTile'),
          ...List.generate(5, (i) {
            return AppListTile(
              title: 'List item ${i + 1}',
              subtitle: 'Subtitle for item ${i + 1}',
              leading: CircleAvatar(child: Text('${i + 1}')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            );
          }),
          const SizedBox(height: 24),
          _sectionTitle(context, 'DetailScreenLayout'),
          SizedBox(
            height: 400,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: DetailScreenLayout(
                title: 'Detail View',
                heroImage: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: const Center(
                    child: Icon(Icons.photo, size: 64, color: Colors.white70),
                  ),
                ),
                expandedHeight: 200,
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'This is a detail screen layout with a hero image '
                    'that collapses as you scroll.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
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
