import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:flutter/foundation.dart' show visibleForTesting;
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
  }) : _cache = cache,
       _bible = bible,
       _apiKey = apiKey;

  /// Phase 4.2 Phase C — true SSE streaming. Consumes Gemini's
  /// `generateContentStream` chunk-by-chunk and emits:
  ///   1. [TierT1ScriptureRef] as soon as the regex finds
  ///      `"reference": "..."` in the accumulated buffer (~2-3s into
  ///      generation) — lets the caller unblock navigation.
  ///   2. [TierT1Result] once the full JSON has arrived AND scripture
  ///      has been validated against the Bible bundle.
  ///
  /// On invalid reference the validation retry remains non-streaming
  /// (one full `generateContent` call) — MVP simplicity.
  Stream<TierResult> analyze({
    required String transcript,
    required String locale,
    required String userName,
    List<String> recentReferences = const [],
  }) async* {
    final systemInstruction = await _cache.loadRubricBundle('prayer');
    const modelName = 'gemini-2.5-flash';
    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.75,
      ),
    );

    final userPrompt = _buildUserPrompt(
      transcript: transcript,
      locale: locale,
      userName: userName,
      excludeRef: null,
      recentReferences: recentReferences,
    );

    apiLog.info(
      '[Tier1] analyze start — model=$modelName locale=$locale '
      'transcriptLen=${transcript.length} userNameLen=${userName.length} '
      'systemInstrLen=${systemInstruction.length}',
    );

    final buffer = StringBuffer();
    GenerateContentResponse? lastChunk;
    bool emittedRef = false;
    final refRegex = RegExp(r'"reference"\s*:\s*"([^"\\]+)"');

    try {
      final stream = model.generateContentStream([
        Content('user', [TextPart(userPrompt)]),
      ]);
      await for (final chunk in stream) {
        lastChunk = chunk;
        final piece = chunk.text;
        if (piece == null || piece.isEmpty) continue;
        buffer.write(piece);
        if (!emittedRef) {
          final m = refRegex.firstMatch(buffer.toString());
          if (m != null) {
            emittedRef = true;
            yield TierT1ScriptureRef(m.group(1)!);
          }
        }
      }
      if (lastChunk != null) {
        logTierUsage(
          response: lastChunk,
          tier: 't1',
          locale: locale,
          model: modelName,
        );
      }

      final json = _parseJson(buffer.toString());
      // v7 telemetry — log model's verse_span_recommendation when present.
      // Field is metadata only; not propagated to Scripture model (MVP simplicity).
      final scriptureMeta = json['scripture'];
      if (scriptureMeta is Map &&
          scriptureMeta['verse_span_recommendation'] is String) {
        apiLog.info(
          '[Tier1] verse_span_recommendation='
          '${scriptureMeta['verse_span_recommendation']}',
        );
      }
      final draft = _extractT1(json, locale);
      // v7 — strip any leaked quote marks from `posture` (model paraphrases
      // were being read as verbatim verse quotes → trust break). Audit-log.
      final stripped = _stripPostureQuotes(draft.scripture);

      // Scripture validation (non-streaming retry path on hallucination)
      final validated = await _validateScripture(
        stripped,
        locale,
        transcript: transcript,
        userName: userName,
        recentReferences: recentReferences,
        model: model,
        modelName: modelName,
      );

      yield TierT1Result(summary: draft.summary, scripture: validated);
    } on AiAnalysisException {
      rethrow;
    } on InvalidApiKey catch (e, st) {
      // 401/403: GEMINI_API_KEY missing or revoked. Most common cause of
      // instant tier1 failure — log with explicit cue for the user.
      apiLog.error(
        '[Tier1] InvalidApiKey — check GEMINI_API_KEY in .env.runtime: '
        '${e.message}',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Gemini API key rejected: ${e.message}',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    } on UnsupportedUserLocation catch (e, st) {
      apiLog.error(
        '[Tier1] UnsupportedUserLocation — Gemini blocks this region',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Gemini not available in this region',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    } on ServerException catch (e, st) {
      // 4xx / 5xx bubbled up from the REST layer. Message usually carries
      // the server's own diagnostic — surface it verbatim for debugging.
      apiLog.error(
        '[Tier1] ServerException: ${e.message} (bufferLen=${buffer.length})',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Gemini server error: ${e.message}',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    } on GenerativeAIException catch (e, st) {
      // Catch-all for other Gemini-SDK exception subtypes not handled above.
      apiLog.error(
        '[Tier1] GenerativeAIException (${e.runtimeType}): ${e.toString()}',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Gemini SDK error: ${e.toString()}',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    } catch (e, st) {
      // Last-resort: any non-Gemini exception (parse, timeout, etc.).
      apiLog.error(
        '[Tier1] analyze failed: ${e.runtimeType} — ${e.toString()} '
        '(bufferLen=${buffer.length})',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Tier1 analysis failed: ${e.runtimeType}',
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
    List<String> recentReferences = const [],
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
    if (recentReferences.isNotEmpty) {
      buf.writeln(
        'Recent scripture references already used (last 30 days, most recent first) — AVOID picking these unless absolutely uniquely apt for this prayer:',
      );
      for (final ref in recentReferences) {
        buf.writeln('- $ref');
      }
      buf.writeln();
      buf.writeln(
        'Rotation rule: pick a DIFFERENT canonical reference. ESCAPE: if the user\'s prayer is sustained lament or grief AND no recent reference clearly matches the depth of this prayer, you MAY repeat one — and in that case, briefly note in `reason` why this passage was returned.',
      );
      buf.writeln();
    }
    if (excludeRef != null) {
      buf.writeln(
        'IMPORTANT: Do NOT select scripture "$excludeRef" (previous attempt failed). Choose a DIFFERENT verse that fits this prayer.',
      );
      buf.writeln();
    }
    buf.writeln('Generate ONLY the T1 sections: "summary" and "scripture".');
    buf.writeln(
      'Output JSON with keys: {"summary": {...}, "scripture": {...}}',
    );
    buf.writeln(
      'Remember: scripture.reference MUST use English book name (e.g., "Matthew 6:33").',
    );
    buf.writeln(
      'Range format note: ranges like "Romans 8:31-39" are supported only within the same chapter. Cross-chapter ranges are NOT supported.',
    );
    return buf.toString();
  }

  @visibleForTesting
  String buildUserPromptForTest({
    required String transcript,
    required String locale,
    required String userName,
    String? excludeRef,
    List<String> recentReferences = const [],
  }) => _buildUserPrompt(
    transcript: transcript,
    locale: locale,
    userName: userName,
    excludeRef: excludeRef,
    recentReferences: recentReferences,
  );

  /// v7 — Removes ASCII + CJK quotation marks from `posture` only, leaving
  /// `key_word_hint` (which legitimately quotes original-language words)
  /// untouched. Logs a warning when anything was stripped — that signal
  /// tells us the rubric rule is leaking despite §2 prohibition.
  @visibleForTesting
  Scripture stripPostureQuotesForTest(Scripture s) => _stripPostureQuotes(s);

  static final RegExp _postureQuoteRegex = RegExp(r'''['"‘’“”「」『』]''');

  Scripture _stripPostureQuotes(Scripture s) {
    if (s.posture.isEmpty) return s;
    final cleaned = s.posture.replaceAll(_postureQuoteRegex, '');
    if (cleaned == s.posture) return s;
    apiLog.warning(
      '[Tier1] posture contained quote marks — stripped (rubric §2 leak)',
    );
    return Scripture(
      reference: s.reference,
      verse: s.verse,
      reason: s.reason,
      posture: cleaned,
      keyWordHint: s.keyWordHint,
      originalWords: s.originalWords,
    );
  }

  @visibleForTesting
  Map<String, dynamic> parseJsonForTest(String? text) => _parseJson(text);

  @visibleForTesting
  ({PrayerSummary summary, Scripture scripture}) extractT1ForTest(
    Map<String, dynamic> json,
    String locale,
  ) => _extractT1(json, locale);

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
    Map<String, dynamic> json,
    String locale,
  ) {
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
    required List<String> recentReferences,
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
          TextPart(
            _buildUserPrompt(
              transcript: transcript,
              locale: locale,
              userName: userName,
              excludeRef: ref,
              recentReferences: recentReferences,
            ),
          ),
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
      final retryStripped = _stripPostureQuotes(retry.scripture);
      final retryVerse = await _bible.lookup(retryStripped.reference, locale);
      if (retryVerse != null && retryVerse.isNotEmpty) {
        apiLog.info('[Tier1] retry succeeded: ${retryStripped.reference}');
        return retryStripped.withVerse(retryVerse);
      }
    } catch (e) {
      // warning() doesn't take stackTrace — retry is a soft path,
      // runtimeType in the message is enough for triage.
      apiLog.warning('[Tier1] retry failed: ${e.runtimeType}', error: e);
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
