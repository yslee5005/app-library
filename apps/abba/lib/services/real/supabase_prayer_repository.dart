import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/prayer.dart';
import '../prayer_repository.dart';

class SupabasePrayerRepository implements PrayerRepository {
  final SupabaseClient _client;

  SupabasePrayerRepository(this._client);

  String get _userId => _client.auth.currentUser!.id;

  @override
  Future<void> savePrayer(Prayer prayer) async {
    await _client.from('prayers').insert({
      'app_id': 'abba',
      'user_id': _userId,
      'transcript': prayer.transcript,
      'mode': prayer.mode,
      'qt_passage_ref': prayer.qtPassageRef,
      'result': prayer.result != null ? _resultToJson(prayer.result!) : null,
    });
    await updateStreak();
  }

  @override
  Future<List<Prayer>> getPrayersByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final data = await _client
        .from('prayers')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .gte('created_at', startOfDay.toIso8601String())
        .lt('created_at', endOfDay.toIso8601String())
        .order('created_at', ascending: false);

    return (data as List).map((e) => Prayer.fromJson(e)).toList();
  }

  @override
  Future<List<Prayer>> getPrayersByMonth(int year, int month) async {
    final start = DateTime(year, month);
    final end = DateTime(year, month + 1);

    final data = await _client
        .from('prayers')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .gte('created_at', start.toIso8601String())
        .lt('created_at', end.toIso8601String())
        .order('created_at', ascending: false);

    return (data as List).map((e) => Prayer.fromJson(e)).toList();
  }

  @override
  Future<Prayer?> getLatestPrayer() async {
    final data = await _client
        .from('prayers')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (data == null) return null;
    return Prayer.fromJson(data);
  }

  @override
  Future<int> getTodayPrayerCount() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final data = await _client
        .from('prayers')
        .select('id')
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .gte('created_at', startOfDay.toIso8601String())
        .lt('created_at', endOfDay.toIso8601String());

    return (data as List).length;
  }

  @override
  Future<void> updateStreak() async {
    final streak = await _client
        .from('prayer_streaks')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .maybeSingle();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (streak == null) {
      await _client.from('prayer_streaks').insert({
        'app_id': 'abba',
        'user_id': _userId,
        'current_streak': 1,
        'best_streak': 1,
        'last_prayer_date': today.toIso8601String(),
      });
      return;
    }

    final lastDate = streak['last_prayer_date'] != null
        ? DateTime.parse(streak['last_prayer_date'] as String)
        : null;
    int current = streak['current_streak'] as int? ?? 0;
    int best = streak['best_streak'] as int? ?? 0;

    if (lastDate != null) {
      final diff = today.difference(lastDate).inDays;
      if (diff == 0) {
        return; // Already prayed today
      } else if (diff == 1) {
        current++; // Consecutive day
      } else if (diff == 2) {
        // Grace recovery: if missed only 1 day (within 24h window),
        // restore streak instead of resetting
        current++; // Grace recovery — streak continues
      } else {
        current = 1; // Streak broken (missed 2+ days)
      }
    } else {
      current = 1;
    }

    if (current > best) best = current;

    await _client
        .from('prayer_streaks')
        .update({
          'current_streak': current,
          'best_streak': best,
          'last_prayer_date': today.toIso8601String(),
          'updated_at': now.toIso8601String(),
        })
        .eq('app_id', 'abba')
        .eq('user_id', _userId);
  }

  @override
  Future<({int current, int best})> getStreak() async {
    final data = await _client
        .from('prayer_streaks')
        .select()
        .eq('app_id', 'abba')
        .eq('user_id', _userId)
        .maybeSingle();

    if (data == null) return (current: 0, best: 0);
    return (
      current: data['current_streak'] as int? ?? 0,
      best: data['best_streak'] as int? ?? 0,
    );
  }

  @override
  Future<int> getTotalPrayerCount() async {
    final data = await _client
        .from('prayers')
        .select('id')
        .eq('app_id', 'abba')
        .eq('user_id', _userId);

    return (data as List).length;
  }

  @override
  Future<List<String>> checkMilestones() async {
    final newMilestones = <String>[];
    final totalPrayers = await getTotalPrayerCount();
    final streak = await getStreak();

    final milestoneChecks = <String, bool>{
      'first_prayer': totalPrayers >= 1,
      '7_day_streak': streak.current >= 7,
      '30_day_streak': streak.current >= 30,
      '100_prayers': totalPrayers >= 100,
    };

    for (final entry in milestoneChecks.entries) {
      if (!entry.value) continue;

      // Check if already achieved
      final existing = await _client
          .from('milestones')
          .select('id')
          .eq('app_id', 'abba')
          .eq('user_id', _userId)
          .eq('milestone_type', entry.key)
          .maybeSingle();

      if (existing == null) {
        await _client.from('milestones').insert({
          'app_id': 'abba',
          'user_id': _userId,
          'milestone_type': entry.key,
        });
        newMilestones.add(entry.key);
      }
    }

    return newMilestones;
  }

  Map<String, dynamic> _resultToJson(PrayerResult result) {
    return {
      'scripture': {
        'verse_en': result.scripture.verseEn,
        'verse_ko': result.scripture.verseKo,
        'reference': result.scripture.reference,
      },
      'bible_story': {
        'title_en': result.bibleStory.titleEn,
        'title_ko': result.bibleStory.titleKo,
        'summary_en': result.bibleStory.summaryEn,
        'summary_ko': result.bibleStory.summaryKo,
      },
      'testimony': {
        'transcript_en': result.testimonyEn,
        'transcript_ko': result.testimonyKo,
      },
      if (result.guidance != null)
        'guidance': {
          'content_en': result.guidance!.contentEn,
          'content_ko': result.guidance!.contentKo,
          'is_premium': result.guidance!.isPremium,
        },
      if (result.aiPrayer != null)
        'ai_prayer': {
          'text_en': result.aiPrayer!.textEn,
          'text_ko': result.aiPrayer!.textKo,
          'is_premium': result.aiPrayer!.isPremium,
        },
      if (result.originalLanguage != null)
        'original_language': {
          'word': result.originalLanguage!.word,
          'transliteration': result.originalLanguage!.transliteration,
          'language': result.originalLanguage!.language,
          'meaning_en': result.originalLanguage!.meaningEn,
          'meaning_ko': result.originalLanguage!.meaningKo,
          'context_en': result.originalLanguage!.contextEn,
          'context_ko': result.originalLanguage!.contextKo,
          'is_premium': result.originalLanguage!.isPremium,
        },
    };
  }
}
