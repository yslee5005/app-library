import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../config/app_config.dart';
import '../../../models/prayer.dart';
import '../../../models/prayer_tier_result.dart';
import '../../ai_analysis_exception.dart';
import '../../gemini_cache_manager.dart';
import 'tier_telemetry.dart';

/// Phase 4.1 — T2 (bible_story + testimony) generator. Background call
/// after T1 completes. Receives T1 context for coherence (avoid reusing
/// the same scripture in bible_story, preserve user's concrete details).
class Tier2Analyzer {
  final GeminiCacheManager _cache;
  final String _apiKey;

  Tier2Analyzer({
    required GeminiCacheManager cache,
    required String apiKey,
  })  : _cache = cache,
        _apiKey = apiKey;

  Future<TierT2Result> analyze({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
  }) async {
    final systemInstruction = await _cache.loadRubricBundle('prayer');
    final modelName = AppConfig.tier2Model;
    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.85,
      ),
    );

    final prompt = StringBuffer()
      ..writeln('Mode: prayer')
      ..writeln('Tier: t2')
      ..writeln('Locale: $locale (respond in ${_localeName(locale)})')
      ..writeln(userName.isNotEmpty ? 'User name: $userName' : '')
      ..writeln()
      ..writeln('User prayer transcript:')
      ..writeln('"""')
      ..writeln(transcript)
      ..writeln('"""')
      ..writeln()
      ..writeln('Previous tier context (DO NOT duplicate this content):')
      ..writeln('- Scripture already chosen: ${t1Context.scripture.reference}')
      ..writeln('- Summary gratitude: ${t1Context.summary.gratitude.join(", ")}')
      ..writeln('- Summary petition: ${t1Context.summary.petition.join(", ")}')
      ..writeln('- Summary intercession: ${t1Context.summary.intercession.join(", ")}')
      ..writeln()
      ..writeln('Generate ONLY T2 sections: "bible_story" and "testimony".')
      ..writeln('- bible_story: Choose a DIFFERENT biblical narrative (not ${t1Context.scripture.reference}\'s passage)')
      ..writeln('- testimony: Preserve user\'s concrete language')
      ..writeln('Output JSON with keys: {"bible_story": {...}, "testimony": "..."}');

    try {
      final response = await model.generateContent([
        Content('user', [TextPart(prompt.toString())]),
      ]);
      logTierUsage(
        response: response,
        tier: 't2',
        locale: locale,
        model: modelName,
      );
      final json = _parseJson(response.text);

      final storyJson = json['bible_story'] as Map<String, dynamic>?;
      final testimony = json['testimony'];

      if (storyJson == null || testimony is! String) {
        throw AiAnalysisException(
          'T2 response missing bible_story or testimony',
          kind: AiAnalysisFailureKind.parseError,
        );
      }

      return TierT2Result(
        bibleStory: BibleStory.fromJson(storyJson),
        testimony: testimony,
      );
    } on AiAnalysisException {
      rethrow;
    } catch (e, st) {
      apiLog.error('[Tier2] analyze failed', error: e, stackTrace: st);
      throw AiAnalysisException(
        'Tier2 analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    }
  }

  @visibleForTesting
  Map<String, dynamic> parseJsonForTest(String? text) => _parseJson(text);

  Map<String, dynamic> _parseJson(String? text) {
    if (text == null || text.isEmpty) {
      throw AiAnalysisException(
        'Empty Gemini response',
        kind: AiAnalysisFailureKind.parseError,
      );
    }
    try {
      final cleaned = _stripCodeFence(text);
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (e, st) {
      throw AiAnalysisException(
        'Gemini JSON parse failed',
        kind: AiAnalysisFailureKind.parseError,
        cause: e,
        causeStackTrace: st,
      );
    }
  }

  String _stripCodeFence(String text) {
    final trimmed = text.trim();
    if (trimmed.startsWith('```')) {
      final firstNewline = trimmed.indexOf('\n');
      if (firstNewline == -1) return trimmed;
      final without = trimmed.substring(firstNewline + 1);
      return without.endsWith('```')
          ? without.substring(0, without.length - 3).trim()
          : without;
    }
    return trimmed;
  }

  static String _localeName(String locale) {
    return switch (locale) {
      'ko' => 'Korean',
      'ja' => 'Japanese',
      'es' => 'Spanish',
      'zh' => 'Chinese',
      'pt' => 'Portuguese',
      'fr' => 'French',
      'de' => 'German',
      'it' => 'Italian',
      'ru' => 'Russian',
      'ar' => 'Arabic',
      'he' => 'Hebrew',
      'el' => 'Greek',
      _ => 'English',
    };
  }
}
