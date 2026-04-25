import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/content_catalog.dart';
import '../../../providers/providers.dart';
import '../../../theme/learn_theme.dart';

class BookmarksView extends ConsumerWidget {
  const BookmarksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Bookmarks', style: LearnTypography.h1)),
      body: bookmarksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bookmarks) {
          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: LearnColors.muted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: LearnTypography.body.copyWith(
                      color: LearnColors.muted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the bookmark icon while reading to save articles',
                    style: LearnTypography.caption,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: bookmarks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              final item = ContentCatalog.findById(bookmark.contentId);
              if (item == null) return const SizedBox.shrink();

              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(
                    Icons.bookmark,
                    color: LearnColors.bookmarkAmber,
                  ),
                  title: Text(item.title, style: LearnTypography.body),
                  subtitle: Text(
                    ContentCatalog.sectionLabel(item.section),
                    style: LearnTypography.caption,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/read/${item.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
