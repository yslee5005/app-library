import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class SkeletonLoaderDemo extends StatelessWidget {
  const SkeletonLoaderDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SkeletonLoader')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile skeleton',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const SkeletonLoader(
                  shape: SkeletonShape.circle,
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonLoader(height: 14, width: 120),
                      SizedBox(height: 8),
                      SkeletonLoader(height: 14),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Text skeleton',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const SkeletonLoader(shape: SkeletonShape.text, lineCount: 4),
          ],
        ),
      ),
    );
  }
}
