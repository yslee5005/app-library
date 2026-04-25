import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class AppCardDemo extends StatelessWidget {
  const AppCardDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AppCard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Vertical layout',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AppCard(
            title: 'Vertical Card',
            subtitle:
                'This card uses the default vertical layout with an image on top.',
            image: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: const Center(child: Icon(Icons.image, size: 48)),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Text(
            'Horizontal layout',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          AppCard(
            title: 'Horizontal Card',
            subtitle:
                'This card uses a horizontal layout with image on the side.',
            layout: AppCardLayout.horizontal,
            image: Container(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: const Center(child: Icon(Icons.photo, size: 36)),
            ),
            onTap: () {},
          ),
          const SizedBox(height: 24),
          Text('Without image', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          AppCard(
            title: 'Text-only Card',
            subtitle: 'This card has no image, just title and subtitle.',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
