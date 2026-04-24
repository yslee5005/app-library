import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_tier_result.dart';
import '../../ai_analysis_exception.dart';
import '../../bible_text_service.dart';
import '../../gemini_cache_manager.dart';
import 'tier_telemetry.dart';

/// Phase 4.1 — T1 (summary + scripture) generator.
///
/// T1 is the user-facing critical tier — completes first, unlocks Dashboard.
/// Scripture validation against local Bible bundle; 1 retry on hallucination.
class Tier1Analyzer {
  final GeminiCacheManager _cache;
  final BibleTextService _bible;
  final String _apiKey;

  Tier1Analyzer({
    required GeminiCacheManager cache,
    required BibleTextService bible,
    required String apiKey,
  })  : _cache = cache,
        _bible = bible,
        _apiKey = apiKey;

  /// Generate T1 content. Scripture is validated against Bible bundle;
  /// if invalid, retry once (excluding the bad ref), then safe-fallback.
  Future<TierT1Result> analyze({
    required String transcript,
    required String locale,
    required String userName,
  }) async {
    final systemInstruction = await _cache.loadRubricBundle('prayer');
    const modelName = 'gemini-2.5-flash';
    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.85,
      ),
    );

    final userPrompt = _buildUserPrompt(
      transcript: transcript,
      locale: locale,
      userName: userName,
      excludeRef: null,
    );

    try {
      final response = await model.generateContent([
        Content('user', [TextPart(userPrompt)]),
      ]);
      logTierUsage(
        response: response,
        tier: 't1',
        locale: locale,
        model: modelName,
      );
      final json = _parseJson(response.text);
      final draft = _extractT1(json, locale);

      // Scripture validation
      final validated = await _validateScripture(
        draft.scripture,
        locale,
        transcript: transcript,
        userName: userName,
        model: model,
        modelName: modelName,
      );

      return TierT1Result(summary: draft.summary, scripture: validated);
    } on AiAnalysisException {
      rethrow;
    } catch (e, st) {
      apiLog.error('[Tier1] analyze failed', error: e, stackTrace: st);
      throw AiAnalysisException(
        'Tier1 analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    }
  }

  String _buildUserPrompt({
    required String transcript,
    required String locale,
    required String userName,
    required String? excludeRef,
  }) {
    final buf = StringBuffer();
    buf.writeln('Mode: prayer');
    buf.writeln('Tier: t1');
    buf.writeln('Locale: $locale (respond in ${_localeName(locale)})');
    if (userName.isNotEmpty) buf.writeln('User name: $userName');
    buf.writeln();
    buf.writeln('User prayer transcript:');
    buf.writeln('"""');
    buf.writeln(transcript);
    buf.writeln('"""');
    buf.writeln();
    if (excludeRef != null) {
      buf.writeln('IMPORTANT: Do NOT select scripture "$excludeRef" (previous attempt failed). Choose a DIFFERENT verse that fits this prayer.');
      buf.writeln();
    }
    buf.writeln('Generate ONLY the T1 sections: "summary" and "scripture".');
    buf.writeln('Output JSON with keys: {"summary": {...}, "scripture": {...}}');
    buf.writeln('Remember: scripture.reference MUST use English book name (e.g., "Matthew 6:33").');
    return buf.toString();
  }

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

  /// Strip ```json``` fences some Gemini responses include despite structured-
  /// output config. Idempotent — returns as-is if no fence.
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

  ({PrayerSummary summary, Scripture scripture}) _extractT1(
      Map<String, dynamic> json, String locale) {
    final summaryJson = json['summary'] as Map<String, dynamic>?;
    final scriptureJson = json['scripture'] as Map<String, dynamic>?;
    if (summaryJson == null || scriptureJson == null) {
      throw AiAnalysisException(
        'T1 response missing summary or scripture',
        kind: AiAnalysisFailureKind.parseError,
      );
    }
    return (
      summary: PrayerSummary.fromJson(summaryJson),
      scripture: Scripture.fromJson(scriptureJson),
    );
  }

  Future<Scripture> _validateScripture(
    Scripture draft,
    String locale, {
    required String transcript,
    required String userName,
    required GenerativeModel model,
    required String modelName,
  }) async {
    final ref = draft.reference;
    if (ref.isEmpty) {
      apiLog.warning('[Tier1] scripture.reference empty');
      return draft;
    }
    final verse = await _bible.lookup(ref, locale);
    if (verse != null && verse.isNotEmpty) {
      return draft.withVerse(verse);
    }

    // Hallucination: retry once with excludeRef directive
    apiLog.warning('[Tier1] Invalid scripture ref: $ref — retrying');
    try {
      final retryResp = await model.generateContent([
        Content('user', [
          TextPart(_buildUserPrompt(
            transcript: transcript,
            locale: locale,
            userName: userName,
            excludeRef: ref,
          ))
        ]),
      ]);
      logTierUsage(
        response: retryResp,
        tier: 't1',
        locale: locale,
        model: modelName,
        note: 'scripture-retry',
      );
      final retryJson = _parseJson(retryResp.text);
      final retry = _extractT1(retryJson, locale);
      final retryVerse = await _bible.lookup(retry.scripture.reference, locale);
      if (retryVerse != null && retryVerse.isNotEmpty) {
        apiLog.info('[Tier1] retry succeeded: ${retry.scripture.reference}');
        return retry.scripture.withVerse(retryVerse);
      }
    } catch (e) {
      apiLog.warning('[Tier1] retry failed', error: e);
    }

    // Safe fallback: keep ref but no verse — UI handles empty verse gracefully
    apiLog.warning('[Tier1] scripture validation gave up for ref: $ref');
    return draft;
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
