import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/furniture.dart';
import '../models/magazine.dart';
import '../models/project.dart';
import '../models/scrap.dart';
export 'repository_providers.dart' show scrapRepositoryProvider;
import 'repository_providers.dart';

// Project providers
final allProjectsProvider = FutureProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).getAll();
});

final featuredProjectsProvider = FutureProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).getFeatured();
});

final projectsByCategoryProvider = FutureProvider.family<List<Project>, String>(
  (ref, category) {
    if (category == 'ALL') {
      return ref.watch(projectRepositoryProvider).getAll();
    }
    return ref.watch(projectRepositoryProvider).getByCategory(category);
  },
);

final projectByIdProvider = FutureProvider.family<Project?, String>((ref, id) {
  return ref.watch(projectRepositoryProvider).getById(id);
});

// Furniture providers
final allFurnitureProvider = FutureProvider<List<Furniture>>((ref) {
  return ref.watch(furnitureRepositoryProvider).getAll();
});

final furnitureByCategoryProvider =
    FutureProvider.family<List<Furniture>, String>((ref, category) {
      if (category == 'ALL') {
        return ref.watch(furnitureRepositoryProvider).getAll();
      }
      return ref.watch(furnitureRepositoryProvider).getByCategory(category);
    });

final furnitureByIdProvider = FutureProvider.family<Furniture?, String>((
  ref,
  id,
) {
  return ref.watch(furnitureRepositoryProvider).getById(id);
});

// Magazine providers
final magazinesProvider = FutureProvider<List<Magazine>>((ref) {
  return ref.watch(magazineRepositoryProvider).getAll();
});

// Scrap providers
final scrapsProvider = FutureProvider<List<Scrap>>((ref) {
  return ref.watch(scrapRepositoryProvider).getAll();
});

final isScrappedProvider =
    FutureProvider.family<bool, ({String contentType, String contentId})>((
      ref,
      params,
    ) {
      return ref
          .watch(scrapRepositoryProvider)
          .isScrapped(params.contentType, params.contentId);
    });
