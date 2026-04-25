import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/content_catalog.dart';
import '../../../models/content_item.dart';
import '../../../providers/providers.dart';
import '../../../theme/learn_theme.dart';

class ChapterListView extends ConsumerWidget {
  final String sectionId;

  const ChapterListView({super.key, required this.sectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ContentSection.values.firstWhere(
      (s) => s.name == sectionId,
      orElse: () => ContentSection.gettingStarted,
    );
    final items = ContentCatalog.bySection(section);
    final progressAsync = ref.watch(allProgressProvider);
    final progressList = progressAsync.value ?? [];
    final completedIds = progressList
        .where((p) => p.isCompleted)
        .map((p) => p.contentId)
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ContentCatalog.sectionLabel(section),
          style: LearnTypography.h2,
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                'No content in this section',
                style: LearnTypography.body,
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isCompleted = completedIds.contains(item.id);

                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? LearnColors.progressGreen
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : Text(
                                '${index + 1}',
                                style: LearnTypography.label,
                              ),
                      ),
                    ),
                    title: Text(item.title, style: LearnTypography.body),
                    subtitle: item.parentId != null
                        ? Text('Sub-chapter', style: LearnTypography.caption)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/read/${item.id}'),
                  ),
                );
              },
            ),
    );
  }
}
