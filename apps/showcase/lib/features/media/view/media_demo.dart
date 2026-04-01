import 'package:app_lib_ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';

class MediaDemo extends StatelessWidget {
  const MediaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle(context, 'AppAvatar sizes'),
          Row(
            children: const [
              AppAvatar(name: 'John Doe', size: AvatarSize.sm),
              SizedBox(width: 12),
              AppAvatar(name: 'John Doe', size: AvatarSize.md),
              SizedBox(width: 12),
              AppAvatar(name: 'John Doe', size: AvatarSize.lg),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'AppCachedImage grid'),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              // Use placeholder since there are no real image URLs
              return Container(
                decoration: BoxDecoration(
                  color: Colors.primaries[index % Colors.primaries.length]
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 36,
                    color: Colors.primaries[index % Colors.primaries.length],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ImageCarousel'),
          // ImageCarousel needs image URLs — use colored placeholder containers
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: 4,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.primaries[(index * 3) % Colors.primaries.length]
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Slide ${index + 1}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle(context, 'ExpandableText'),
          const ExpandableText(
            text:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do '
                'eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim '
                'ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut '
                'aliquip ex ea commodo consequat. Duis aute irure dolor in '
                'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
                'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
                'culpa qui officia deserunt mollit anim id est laborum.',
            maxLines: 2,
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
