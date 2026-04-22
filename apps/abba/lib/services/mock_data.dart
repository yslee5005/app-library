import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

import '../models/post.dart';
import '../models/prayer.dart';
import '../models/qt_meditation_result.dart';
import '../models/qt_passage.dart';
import '../models/user_profile.dart';

class MockDataService {
  PrayerResult? _prayerResult;
  QtMeditationResult? _qtMeditationResult;
  List<QTPassage>? _qtPassages;
  List<CommunityPost>? _communityPosts;
  UserProfile? _userProfile;

  /// Production constructor — loads data lazily from `assets/mock/*.json`
  /// via `rootBundle`. Keep this path untouched so `main.dart` continues to
  /// work unchanged.
  MockDataService();

  /// Test-only constructor: inject in-memory fixtures and skip the
  /// `rootBundle.loadString` path entirely. Required in `flutter_test`
  /// because the asset bundle shim is not wired for raw `assets/mock/*.json`
  /// lookups — otherwise every getter throws
  /// `Unable to load asset: "assets/mock/*.json"`.
  ///
  /// Pre-seeded fields short-circuit their getters; any fields left `null`
  /// fall back to the normal asset-loading path (useful for narrow tests
  /// that only stub one resource).
  @visibleForTesting
  MockDataService.fromData({
    PrayerResult? prayerResult,
    QtMeditationResult? qtMeditationResult,
    List<QTPassage>? qtPassages,
    List<CommunityPost>? communityPosts,
    UserProfile? userProfile,
  })  : _prayerResult = prayerResult,
        _qtMeditationResult = qtMeditationResult,
        _qtPassages = qtPassages,
        _communityPosts = communityPosts,
        _userProfile = userProfile;

  Future<PrayerResult> getPrayerResult() async {
    if (_prayerResult != null) return _prayerResult!;
    final jsonStr = await rootBundle.loadString(
      'assets/mock/prayer_result.json',
    );
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _prayerResult = PrayerResult.fromJson(json);
    return _prayerResult!;
  }

  Future<QtMeditationResult> getQtMeditationResult() async {
    if (_qtMeditationResult != null) return _qtMeditationResult!;
    final jsonStr = await rootBundle.loadString(
      'assets/mock/qt_meditation_result.json',
    );
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _qtMeditationResult = QtMeditationResult.fromJson(json);
    return _qtMeditationResult!;
  }

  Future<List<QTPassage>> getQTPassages() async {
    if (_qtPassages != null) return _qtPassages!;
    final jsonStr = await rootBundle.loadString('assets/mock/qt_passages.json');
    final list = jsonDecode(jsonStr) as List<dynamic>;
    _qtPassages = list
        .map((e) => QTPassage.fromJson(e as Map<String, dynamic>))
        .toList();
    return _qtPassages!;
  }

  Future<List<CommunityPost>> getCommunityPosts() async {
    if (_communityPosts != null) return _communityPosts!;
    final jsonStr = await rootBundle.loadString(
      'assets/mock/community_posts.json',
    );
    final list = jsonDecode(jsonStr) as List<dynamic>;
    _communityPosts = list
        .map((e) => CommunityPost.fromJson(e as Map<String, dynamic>))
        .toList();
    return _communityPosts!;
  }

  Future<UserProfile> getUserProfile() async {
    if (_userProfile != null) return _userProfile!;
    final jsonStr = await rootBundle.loadString(
      'assets/mock/user_profile.json',
    );
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _userProfile = UserProfile.fromJson(json);
    return _userProfile!;
  }
}
