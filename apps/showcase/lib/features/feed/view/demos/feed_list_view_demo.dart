import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

import '../../../../sample_data/sample_data.dart';

class FeedListViewDemo extends StatelessWidget {
  const FeedListViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FeedListView')),
      body: FeedListView(
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
                  color: Colors.primaries[index % Colors.primaries.length],
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
    );
  }
}
