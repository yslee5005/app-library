import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/data_providers.dart';
import '../../../theme/blacklabelled_theme.dart';

final _selectedFurnitureCategoryProvider = StateProvider<String>(
  (ref) => 'ALL',
);

const _furnitureCategories = [
  'ALL',
  'Kitchen',
  'Bath',
  'Design Furniture',
  'System',
];

class FurnitureView extends ConsumerWidget {
  const FurnitureView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(_selectedFurnitureCategoryProvider);
    final furnitureAsync = ref.watch(
      furnitureByCategoryProvider(selectedCategory),
    );
    final theme = Theme.of(context);

    return Column(
      children: [
        // Category Filter
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: BlackLabelledSpacing.contentPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: _furnitureCategories.length,
            separatorBuilder:
                (_, __) => const SizedBox(width: BlackLabelledSpacing.lg),
            itemBuilder: (context, index) {
              final category = _furnitureCategories[index];
              final isSelected = category == selectedCategory;
              return GestureDetector(
                onTap:
                    () =>
                        ref
                            .read(_selectedFurnitureCategoryProvider.notifier)
                            .state = category,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    category,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      letterSpacing: 0.5,
                      color:
                          isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Divider(height: 0.5, thickness: 0.5, color: theme.colorScheme.outline),

        // Grid
        Expanded(
          child: furnitureAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No furniture found',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.all(
                  BlackLabelledSpacing.contentPadding,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 24,
                  childAspectRatio: 0.7,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final furniture = items[index];
                  return GestureDetector(
                    onTap: () => context.push('/furniture/${furniture.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl:
                                furniture.images.isNotEmpty
                                    ? furniture.images[0]
                                    : '',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            placeholder:
                                (_, __) =>
                                    Container(color: theme.colorScheme.surface),
                            errorWidget:
                                (_, __, ___) => Container(
                                  color: theme.colorScheme.surface,
                                  child: Icon(
                                    Icons.image_outlined,
                                    color: theme.colorScheme.secondary,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          furniture.title,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          furniture.category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, __) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}
