import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bookmark.dart';
import '../models/reading_progress.dart';
import '../services/content_service.dart';
import '../services/progress_repository.dart';
import '../services/search_service.dart';

// ---------------------------------------------------------------------------
// Service singletons
// ---------------------------------------------------------------------------

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepository();
});

final searchServiceProvider = Provider<SearchService>((ref) {
  final contentService = ref.watch(contentServiceProvider);
  return SearchService(contentService);
});

// ---------------------------------------------------------------------------
// Async data providers
// ---------------------------------------------------------------------------

/// All reading progress entries loaded from disk.
final allProgressProvider = FutureProvider<List<ReadingProgress>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.loadProgress();
});

/// All bookmarks loaded from disk.
final bookmarksProvider = FutureProvider<List<Bookmark>>((ref) {
  final repo = ref.watch(progressRepositoryProvider);
  return repo.loadBookmarks();
});

// ---------------------------------------------------------------------------
// App settings — using Notifier (Riverpod 3.x)
// ---------------------------------------------------------------------------

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void set(ThemeMode mode) => state = mode;
}

/// Light / Dark / System theme mode.
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class FontSizeNotifier extends Notifier<double> {
  @override
  double build() => 16.0;

  void set(double size) => state = size;
}

/// Reader font size (default 16.0).
final fontSizeProvider =
    NotifierProvider<FontSizeNotifier, double>(FontSizeNotifier.new);
