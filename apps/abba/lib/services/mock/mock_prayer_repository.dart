import 'dart:convert';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart';

import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../prayer_repository.dart';

class MockPrayerRepository implements PrayerRepository {
  final List<Prayer> _prayers;
  final Set<String> _achievedMilestones = {};
  bool _initialized;

  MockPrayerRepository() : _prayers = [], _initialized = false;

  /// Test-only constructor: skip asset load and inject data directly.
  /// Use this in tests where the rootBundle asset shim is not wired, so
  /// `_ensureInitialized` would otherwise fail loading `assets/mock/prayers.json`.
  @visibleForTesting
  MockPrayerRepository.fromData(List<Prayer> prayers)
    : _prayers = List.of(prayers),
      _initialized = true {
    // Sort newest first so getLatestPrayer returns correct result.
    _prayers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Lazy-load seed data from JSON on first read access.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    final jsonStr = await rootBundle.loadString('assets/mock/prayers.json');
    final list = json.decode(jsonStr) as List;
    _prayers.addAll(
      list.map((e) => Prayer.fromJson(e as Map<String, dynamic>)),
    );
    // Sort newest first so getLatestPrayer returns correct result.
    _prayers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> savePrayer(Prayer prayer) async {
    await _ensureInitialized();
    _prayers.insert(0, prayer);
  }

  @override
  Future<String> savePendingPrayer(Prayer prayer) async {
    await _ensureInitialized();
    final pendingPrayer = Prayer(
      id: prayer.id,
      userId: prayer.userId,
      transcript: prayer.transcript,
      mode: prayer.mode,
      qtPassageRef: prayer.qtPassageRef,
      audioPath: prayer.audioPath,
      audioStoragePath: prayer.audioStoragePath,
      durationSeconds: prayer.durationSeconds,
      createdAt: prayer.createdAt,
      aiStatus: PrayerAiStatus.pending,
    );
    _prayers.insert(0, pendingPrayer);
    return pendingPrayer.id;
  }

  @override
  Future<void> completePrayer({
    required String prayerId,
    required String transcript,
    PrayerResult? result,
    QtMeditationResult? qtResult,
  }) async {
    await _ensureInitialized();
    final idx = _prayers.indexWhere((p) => p.id == prayerId);
    if (idx < 0) return;
    final existing = _prayers[idx];
    _prayers[idx] = Prayer(
      id: existing.id,
      userId: existing.userId,
      transcript: transcript,
      mode: existing.mode,
      qtPassageRef: existing.qtPassageRef,
      audioPath: existing.audioPath,
      audioStoragePath: existing.audioStoragePath,
      durationSeconds: existing.durationSeconds,
      createdAt: existing.createdAt,
      result: result ?? existing.result,
      qtResult: qtResult ?? existing.qtResult,
      aiStatus: PrayerAiStatus.completed,
    );
  }

  @override
  Future<void> updateTierResult({
    required String prayerId,
    required String tier,
    required Map<String, dynamic> sectionData,
  }) async {
    // Mock: no-op tier merge. Phase 4.1 tests use this only to verify
    // the call path; real JSONB merge lives in Supabase RPC.
    await _ensureInitialized();
    final idx = _prayers.indexWhere((p) => p.id == prayerId);
    if (idx < 0) return;
    // Mock does not reconstruct PrayerResult from partial JSON — tier
    // progression flows via PrayerSectionsNotifier in-memory state.
  }

  @override
  Future<List<Prayer>> getPrayersByDate(DateTime date) async {
    await _ensureInitialized();
    return _prayers
        .where(
          (p) =>
              p.createdAt.year == date.year &&
              p.createdAt.month == date.month &&
              p.createdAt.day == date.day,
        )
        .toList();
  }

  @override
  Future<List<Prayer>> getPrayersByMonth(int year, int month) async {
    await _ensureInitialized();
    return _prayers
        .where((p) => p.createdAt.year == year && p.createdAt.month == month)
        .toList();
  }

  @override
  Future<Prayer?> getLatestPrayer() async {
    await _ensureInitialized();
    if (_prayers.isEmpty) return null;
    return _prayers.first;
  }

  @override
  Future<int> getTodayPrayerCount() async {
    await _ensureInitialized();
    final now = DateTime.now();
    return _prayers
        .where(
          (p) =>
              p.createdAt.year == now.year &&
              p.createdAt.month == now.month &&
              p.createdAt.day == now.day,
        )
        .length;
  }

  @override
  Future<void> updateStreak() async {
    // No-op: streak is calculated from actual prayer data.
  }

  @override
  Future<({int current, int best})> getStreak() async {
    await _ensureInitialized();
    return _calculateStreak();
  }

  @override
  Future<int> getTotalPrayerCount() async {
    await _ensureInitialized();
    return _prayers.length;
  }

  @override
  Future<List<String>> checkMilestones() async {
    await _ensureInitialized();
    final streak = _calculateStreak();
    final candidates = <String>[];
    if (_prayers.length == 1) candidates.add('first_prayer');
    if (streak.current == 7) candidates.add('7_day_streak');
    if (streak.current == 30) candidates.add('30_day_streak');
    if (_prayers.length == 100) candidates.add('100_prayers');

    // Return only NEW milestones (not already achieved)
    final newMilestones = candidates
        .where((m) => !_achievedMilestones.contains(m))
        .toList();
    _achievedMilestones.addAll(newMilestones);
    return newMilestones;
  }

  /// Calculate current and best streak from actual prayer dates.
  ({int current, int best}) _calculateStreak() {
    if (_prayers.isEmpty) return (current: 0, best: 0);

    // Collect unique prayer dates (date-only, no time).
    final prayerDates = <DateTime>{};
    for (final p in _prayers) {
      prayerDates.add(
        DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day),
      );
    }

    // Sort dates descending (most recent first).
    final sorted = prayerDates.toList()..sort((a, b) => b.compareTo(a));

    // Current streak: count consecutive days ending today (or yesterday).
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    int currentStreak = 0;
    var expected = todayDate;

    // Allow streak to start from today or yesterday.
    if (sorted.isNotEmpty && sorted.first == todayDate) {
      expected = todayDate;
    } else if (sorted.isNotEmpty &&
        sorted.first == todayDate.subtract(const Duration(days: 1))) {
      expected = todayDate.subtract(const Duration(days: 1));
    } else {
      // Most recent prayer is older than yesterday — no active streak.
      currentStreak = 0;
      expected = todayDate; // won't match anything
    }

    for (final date in sorted) {
      if (date == expected) {
        currentStreak++;
        expected = expected.subtract(const Duration(days: 1));
      } else if (date.isBefore(expected)) {
        break;
      }
    }

    // Best streak: walk through all dates in ascending order.
    final ascending = sorted.reversed.toList();
    int bestStreak = 0;
    int runLength = 1;
    for (int i = 1; i < ascending.length; i++) {
      final diff = ascending[i].difference(ascending[i - 1]).inDays;
      if (diff == 1) {
        runLength++;
      } else {
        if (runLength > bestStreak) bestStreak = runLength;
        runLength = 1;
      }
    }
    if (runLength > bestStreak) bestStreak = runLength;
    if (currentStreak > bestStreak) bestStreak = currentStreak;

    return (current: currentStreak, best: bestStreak);
  }
}
