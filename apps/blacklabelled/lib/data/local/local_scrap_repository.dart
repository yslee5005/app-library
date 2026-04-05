import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/scrap.dart';
import '../repositories/scrap_repository.dart';

class LocalScrapRepository implements ScrapRepository {
  static const _storageKey = 'blacklabelled_scraps';

  Future<List<Scrap>> _loadScraps() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((e) => Scrap.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> _saveScraps(List<Scrap> scraps) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(scraps.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  @override
  Future<List<Scrap>> getAll() => _loadScraps();

  @override
  Future<void> toggle(String contentType, String contentId) async {
    final scraps = await _loadScraps();
    final index = scraps.indexWhere(
      (s) => s.contentType == contentType && s.contentId == contentId,
    );

    if (index >= 0) {
      scraps.removeAt(index);
    } else {
      scraps.add(
        Scrap(
          contentType: contentType,
          contentId: contentId,
          createdAt: DateTime.now(),
        ),
      );
    }

    await _saveScraps(scraps);
  }

  @override
  Future<bool> isScrapped(String contentType, String contentId) async {
    final scraps = await _loadScraps();
    return scraps.any(
      (s) => s.contentType == contentType && s.contentId == contentId,
    );
  }
}
