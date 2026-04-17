import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/prayer.dart';
import '../prayer_repository.dart';

class MockPrayerRepository implements PrayerRepository {
  final List<Prayer> _prayers = [];
  bool _initialized = false;

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
    final milestones = <String>[];
    if (_prayers.length == 1) milestones.add('first_prayer');
    if (streak.current == 7) milestones.add('7_day_streak');
    if (streak.current == 30) milestones.add('30_day_streak');
    if (_prayers.length == 100) milestones.add('100_prayers');
    return milestones;
  }

  /// Calculate current and best streak from actual prayer dates.
  ({int current, int best}) _calculateStreak() {
    if (_prayers.isEmpty) return (current: 0, best: 0);

    // Collect unique prayer dates (date-only, no time).
    final prayerDates = <DateTime>{};
    for (final p in _prayers) {
      prayerDates.add(DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day));
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
