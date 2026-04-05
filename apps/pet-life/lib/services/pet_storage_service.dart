import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/daily_log.dart';
import '../models/pet_profile.dart';

class PetStorageService {
  static const _profileKey = 'pet_life_profile';
  static const _logsKey = 'pet_life_logs';
  static const _streakFreezesKey = 'pet_life_streak_freezes';
  static const _onboardingCompleteKey = 'pet_life_onboarding_complete';

  static final PetStorageService _instance = PetStorageService._();
  factory PetStorageService() => _instance;
  PetStorageService._();

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --- Profile ---

  Future<void> saveProfile(PetProfile profile) async {
    final prefs = await _getPrefs;
    await prefs.setString(_profileKey, json.encode(profile.toJson()));
  }

  Future<PetProfile?> loadProfile() async {
    final prefs = await _getPrefs;
    final str = prefs.getString(_profileKey);
    if (str == null) return null;
    try {
      return PetProfile.fromJson(json.decode(str) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteProfile() async {
    final prefs = await _getPrefs;
    await prefs.remove(_profileKey);
  }

  // --- Daily Logs ---

  Future<void> saveLogs(List<DailyLog> logs) async {
    final prefs = await _getPrefs;
    final encoded = logs.map((l) => l.toJson()).toList();
    await prefs.setString(_logsKey, json.encode(encoded));
  }

  Future<List<DailyLog>> loadLogs() async {
    final prefs = await _getPrefs;
    final str = prefs.getString(_logsKey);
    if (str == null) return [];
    try {
      final list = json.decode(str) as List<dynamic>;
      return list
          .map((e) => DailyLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> addLog(DailyLog log) async {
    final logs = await loadLogs();
    // Remove existing log for same date + routine
    logs.removeWhere(
        (l) => l.date == log.date && l.routineId == log.routineId);
    logs.add(log);
    await saveLogs(logs);
  }

  Future<List<DailyLog>> getLogsForDate(String date) async {
    final logs = await loadLogs();
    return logs.where((l) => l.date == date).toList();
  }

  /// Get streak count for a routine (consecutive days completed)
  Future<int> getStreak(String routineId) async {
    final logs = await loadLogs();
    final completedLogs = logs
        .where((l) => l.routineId == routineId && l.completed)
        .toList();

    if (completedLogs.isEmpty) return 0;

    // Get unique completed dates, sorted descending
    final dates = completedLogs
        .map((l) => l.date)
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = _dateString(DateTime.now());
    final yesterday = _dateString(DateTime.now().subtract(const Duration(days: 1)));

    // Streak must start from today or yesterday
    if (dates.first != today && dates.first != yesterday) return 0;

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      final current = DateTime.parse(dates[i]);
      final prev = DateTime.parse(dates[i + 1]);
      final diff = current.difference(prev).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  // --- Streak Freezes ---

  Future<int> getRemainingFreezes() async {
    final prefs = await _getPrefs;
    final monthKey = '${_streakFreezesKey}_${_monthString(DateTime.now())}';
    final used = prefs.getInt(monthKey) ?? 0;
    return 2 - used;
  }

  Future<void> useStreakFreeze() async {
    final prefs = await _getPrefs;
    final monthKey = '${_streakFreezesKey}_${_monthString(DateTime.now())}';
    final used = prefs.getInt(monthKey) ?? 0;
    await prefs.setInt(monthKey, used + 1);
  }

  // --- Onboarding ---

  Future<bool> isOnboardingComplete() async {
    final prefs = await _getPrefs;
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool complete) async {
    final prefs = await _getPrefs;
    await prefs.setBool(_onboardingCompleteKey, complete);
  }

  // --- Helpers ---

  static String _dateString(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  static String _monthString(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
  }

  /// Public helper for date formatting
  static String dateString(DateTime dt) => _dateString(dt);
}
