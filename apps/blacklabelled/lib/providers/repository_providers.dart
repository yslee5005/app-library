import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/supabase/supabase_project_repository.dart';
import '../data/supabase/supabase_furniture_repository.dart';
import '../data/supabase/supabase_magazine_repository.dart';
import '../data/supabase/supabase_scrap_repository.dart';
import '../data/repositories/furniture_repository.dart';
import '../data/repositories/magazine_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/scrap_repository.dart';

/// Supabase client — initialized in main.dart
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Projects: Supabase backend
final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => SupabaseProjectRepository(ref.watch(supabaseClientProvider)),
);

/// Furniture: Supabase backend
final furnitureRepositoryProvider = Provider<FurnitureRepository>(
  (ref) => SupabaseFurnitureRepository(ref.watch(supabaseClientProvider)),
);

/// Magazines: Supabase backend
final magazineRepositoryProvider = Provider<MagazineRepository>(
  (ref) => SupabaseMagazineRepository(ref.watch(supabaseClientProvider)),
);

/// Scraps: Supabase backend (Anonymous-First)
final scrapRepositoryProvider = Provider<ScrapRepository>(
  (ref) => SupabaseScrapRepository(ref.watch(supabaseClientProvider)),
);
