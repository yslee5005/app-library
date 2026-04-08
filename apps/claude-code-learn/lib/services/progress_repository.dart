import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/bookmark.dart';
import '../models/reading_progress.dart';

/// Persists reading progress and bookmarks as JSON files in the app's
/// documents directory.
class ProgressRepository {
  static const _progressFile = 'reading_progress.json';
  static const _bookmarksFile = 'bookmarks.json';

  Future<String> get _dirPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  // -----------------------------------------------------------------
  // Reading progress
  // -----------------------------------------------------------------

  /// Load all saved progress entries.
  Future<List<ReadingProgress>> loadProgress() async {
    try {
      final file = File('${await _dirPath}/$_progressFile');
      if (!file.existsSync()) return [];
      final json = jsonDecode(await file.readAsString()) as List;
      return json
          .map((e) => ReadingProgress.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Save the full progress list (overwrites previous data).
  Future<void> saveProgress(List<ReadingProgress> progress) async {
    final file = File('${await _dirPath}/$_progressFile');
    final json = progress.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(json));
  }

  /// Update or insert progress for a single content item.
  Future<void> upsertProgress(ReadingProgress entry) async {
    final list = await loadProgress();
    final index = list.indexWhere((e) => e.contentId == entry.contentId);
    if (index >= 0) {
      list[index] = entry;
    } else {
      list.add(entry);
    }
    await saveProgress(list);
  }

  /// Get progress for a single content id.
  Future<ReadingProgress?> getProgress(String contentId) async {
    final list = await loadProgress();
    try {
      return list.firstWhere((e) => e.contentId == contentId);
    } catch (_) {
      return null;
    }
  }

  /// Reset all progress.
  Future<void> clearProgress() async {
    final file = File('${await _dirPath}/$_progressFile');
    if (file.existsSync()) await file.delete();
  }

  // -----------------------------------------------------------------
  // Bookmarks
  // -----------------------------------------------------------------

  /// Load all bookmarks.
  Future<List<Bookmark>> loadBookmarks() async {
    try {
      final file = File('${await _dirPath}/$_bookmarksFile');
      if (!file.existsSync()) return [];
      final json = jsonDecode(await file.readAsString()) as List;
      return json
          .map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Save the full bookmarks list.
  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    final file = File('${await _dirPath}/$_bookmarksFile');
    final json = bookmarks.map((e) => e.toJson()).toList();
    await file.writeAsString(jsonEncode(json));
  }

  /// Toggle bookmark for a content id. Returns `true` if now bookmarked.
  Future<bool> toggleBookmark(String contentId) async {
    final list = await loadBookmarks();
    final index = list.indexWhere((e) => e.contentId == contentId);
    if (index >= 0) {
      list.removeAt(index);
      await saveBookmarks(list);
      return false;
    } else {
      list.add(Bookmark(contentId: contentId, createdAt: DateTime.now()));
      await saveBookmarks(list);
      return true;
    }
  }

  /// Check if a content item is bookmarked.
  Future<bool> isBookmarked(String contentId) async {
    final list = await loadBookmarks();
    return list.any((e) => e.contentId == contentId);
  }
}
