import 'package:flutter/material.dart';

import 'demos/app_avatar_demo.dart';
import 'demos/app_cached_image_demo.dart';
import 'demos/expandable_text_demo.dart';
import 'demos/image_carousel_demo.dart';

class MediaDemo extends StatelessWidget {
  const MediaDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('AppCachedImage'),
            subtitle: const Text('Cached image grid with placeholders'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AppCachedImageDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.view_carousel),
            title: const Text('ImageCarousel'),
            subtitle: const Text('Swipeable image slider'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ImageCarouselDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('AppAvatar'),
            subtitle: const Text('Avatar sizes: sm, md, lg with initials'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AppAvatarDemo(),
                  ),
                ),
          ),
          ListTile(
            leading: const Icon(Icons.expand_more),
            title: const Text('ExpandableText'),
            subtitle: const Text('Show more/less text'),
            trailing: const Icon(Icons.chevron_right),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const ExpandableTextDemo(),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
