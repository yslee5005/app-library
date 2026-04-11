/// Supabase-backed repository providers for BlackLabelled
///
/// To switch from local to Supabase:
/// 1. In repository_providers.dart, replace Local* with Supabase* implementations
/// 2. Or import this file and use these providers directly
///
/// Example:
///   // Before (local)
///   final projectRepositoryProvider = Provider<ProjectRepository>(
///     (ref) => LocalProjectRepository(),
///   );
///
///   // After (Supabase)
///   final projectRepositoryProvider = Provider<ProjectRepository>(
///     (ref) => SupabaseProjectRepository(Supabase.instance.client),
///   );

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../repositories/project_repository.dart';
import '../repositories/furniture_repository.dart';
import 'supabase_project_repository.dart';
import 'supabase_furniture_repository.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// Supabase-backed ProjectRepository
final supabaseProjectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => SupabaseProjectRepository(ref.watch(supabaseClientProvider)),
);

/// Supabase-backed FurnitureRepository
final supabaseFurnitureRepositoryProvider = Provider<FurnitureRepository>(
  (ref) => SupabaseFurnitureRepository(ref.watch(supabaseClientProvider)),
);
