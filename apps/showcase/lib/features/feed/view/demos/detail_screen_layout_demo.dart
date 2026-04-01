import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class DetailScreenLayoutDemo extends StatelessWidget {
  const DetailScreenLayoutDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailScreenLayout(
      title: 'Detail View',
      heroImage: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: const Center(
          child: Icon(Icons.photo, size: 64, color: Colors.white70),
        ),
      ),
      expandedHeight: 250,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hero Image Detail',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This is a detail screen layout with a hero image that collapses '
              'as you scroll. Scroll up to see the collapsing effect.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ...List.generate(
              10,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  'Content paragraph ${i + 1}: Lorem ipsum dolor sit amet, '
                  'consectetur adipiscing elit.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
