import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../models/prayer.dart' show Scripture, ScriptureOriginalWord;
import '../../../models/prayer_tier_result.dart';
import '../../../models/qt_meditation_result.dart' show MeditationSummary;
import '../../ai_analysis_exception.dart';
import '../../bible_text_service.dart';
import '../../gemini_cache_manager.dart';
import 'tier_telemetry.dart';

/// Phase 4.2 — QT T1 (meditation_summary + scripture) generator.
///
/// Mirrors [Tier1Analyzer] for the QT flow. Unlike Prayer, QT is passage-
/// anchored: the user is meditating on a specific Bible passage chosen from
/// the daily QT selection, so the prompt injects `{{QT_PASSAGE_REF}}` and
/// `{{QT_PASSAGE_TEXT}}` into the user prompt.
///
/// Scripture validation still runs — if the AI returns a reference that
/// BibleTextService cannot resolve, one retry (excluding the bad ref).
class QtTier1Analyzer {
  final GeminiCacheManager _cache;
  final BibleTextService _bible;
  final String _apiKey;

  QtTier1Analyzer({
    required GeminiCacheManager cache,
    required BibleTextService bible,
    required String apiKey,
  }) : _cache = cache,
       _bible = bible,
       _apiKey = apiKey;

  /// Phase 4.2 Phase C — true SSE streaming. Mirror of
  /// [Tier1Analyzer.analyze] but emits [QtTierT1ScriptureRef] instead of
  /// the Prayer variant.
  Stream<TierResult> analyze({
    required String meditation,
    required String passageRef,
    required String passageText,
    required String locale,
    required String userName,
  }) async* {
    final systemInstruction = await _cache.loadRubricBundle('qt');
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
      meditation: meditation,
      passageRef: passageRef,
      passageText: passageText,
      locale: locale,
      userName: userName,
      excludeRef: null,
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
            yield QtTierT1ScriptureRef(m.group(1)!);
          }
        }
      }
      if (lastChunk != null) {
        logTierUsage(
          response: lastChunk,
          tier: 'qt-t1',
          locale: locale,
          model: modelName,
        );
      }

      final json = _parseJson(buffer.toString());
      final draft = _extractT1(json, locale);

      final validated = await _validateScripture(
        draft.scripture,
        locale,
        meditation: meditation,
        passageRef: passageRef,
        passageText: passageText,
        userName: userName,
        model: model,
        modelName: modelName,
      );

      yield QtTierT1Result(
        meditationSummary: draft.meditationSummary,
        scripture: validated,
      );
    } on AiAnalysisException {
      rethrow;
    } on InvalidApiKey catch (e, st) {
      apiLog.error(
        '[QtTier1] InvalidApiKey — check GEMINI_API_KEY: ${e.message}',
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
        '[QtTier1] UnsupportedUserLocation',
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
      apiLog.error(
        '[QtTier1] ServerException: ${e.message} (bufferLen=${buffer.length})',
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
      apiLog.error(
        '[QtTier1] GenerativeAIException (${e.runtimeType}): ${e.toString()}',
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
      apiLog.error(
        '[QtTier1] analyze failed: ${e.runtimeType} — ${e.toString()} '
        '(bufferLen=${buffer.length})',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'QT Tier1 analysis failed: ${e.runtimeType}',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    }
  }

  String _buildUserPrompt({
    required String meditation,
    required String passageRef,
    required String passageText,
    required String locale,
    required String userName,
    required String? excludeRef,
  }) {
    final buf = StringBuffer();
    buf.writeln('Mode: qt');
    buf.writeln('Tier: t1');
    buf.writeln('Locale: $locale (respond in ${_localeName(locale)})');
    if (userName.isNotEmpty) buf.writeln('User name: $userName');
    buf.writeln();
    buf.writeln('GROUNDING (★ critical):');
    buf.writeln(
      '- Every factual claim must be supported by the user\'s own words below.',
    );
    buf.writeln(
      '- Do NOT invent ownership, relationships, locations, or outcomes the user did not state.',
    );
    buf.writeln(
      '- When grammar is ambiguous, prefer the target language\'s natural indefinite reference rather than picking one interpretation as fact.',
    );
    buf.writeln();
    buf.writeln('Today\'s QT passage reference: $passageRef');
    buf.writeln('NOTE: the QT passage reference above is a localized DISPLAY reference (the user-facing card label). It may be in any locale, including non-English book names. Do NOT copy it into your output as-is.');
    buf.writeln();
    if (passageText.isNotEmpty) {
      buf.writeln('Today\'s QT passage text:');
      buf.writeln('"""');
      buf.writeln(passageText);
      buf.writeln('"""');
    }
    buf.writeln();
    buf.writeln('User meditation text:');
    buf.writeln('"""');
    buf.writeln(meditation);
    buf.writeln('"""');
    buf.writeln();
    if (excludeRef != null) {
      buf.writeln(
        'IMPORTANT: Previous attempt chose scripture "$excludeRef" '
        'which could not be resolved. Pick a DIFFERENT verse within or '
        'closely related to today\'s passage that fits the user\'s meditation.',
      );
      buf.writeln();
    }
    buf.writeln(
      'Generate ONLY the T1 sections: "meditation_summary" and "scripture".',
    );
    buf.writeln(
      'Output JSON with keys: {"meditation_summary": {...}, "scripture": {...}}',
    );
    buf.writeln(
      'Remember: your output `scripture.reference` is a LOOKUP REFERENCE — it MUST use English book names (e.g., "Psalm 23:1-6") because the app resolves verse text from a Public Domain bundle keyed in English. Do NOT translate the book name to ${_localeName(locale)} or any other language. Do NOT generate verse text — only the reference string.',
    );
    return buf.toString();
  }

  ({MeditationSummary meditationSummary, Scripture scripture}) _extractT1(
    Map<String, dynamic> json,
    String locale,
  ) {
    final ms = json['meditation_summary'];
    final sc = json['scripture'];
    if (ms is! Map<String, dynamic> || sc is! Map<String, dynamic>) {
      throw AiAnalysisException(
        'QT T1 response missing meditation_summary or scripture',
        kind: AiAnalysisFailureKind.parseError,
      );
    }
    final summary = MeditationSummary.fromJson(ms);
    final originalWords =
        (sc['original_words'] as List<dynamic>?)
            ?.map((raw) {
              final m = raw as Map<String, dynamic>;
              return ScriptureOriginalWord(
                word: m['word'] as String? ?? '',
                transliteration: m['transliteration'] as String? ?? '',
                language: m['language'] as String? ?? '',
                meaning: m['meaning'] as String? ?? '',
                nuance: m['nuance'] as String? ?? '',
              );
            })
            .where((w) => w.word.isNotEmpty)
            .toList() ??
        const [];
    final scripture = Scripture(
      reference: sc['reference'] as String? ?? '',
      reason: sc['reason'] as String? ?? '',
      posture: sc['posture'] as String? ?? '',
      keyWordHint: sc['key_word_hint'] as String? ?? '',
      originalWords: originalWords,
    );
    return (meditationSummary: summary, scripture: scripture);
  }

  Future<Scripture> _validateScripture(
    Scripture draft,
    String locale, {
    required String meditation,
    required String passageRef,
    required String passageText,
    required String userName,
    required GenerativeModel model,
    required String modelName,
  }) async {
    final ref = draft.reference;
    if (ref.isEmpty) {
      apiLog.warning('[QtTier1] scripture.reference empty');
      return draft;
    }
    final verse = await _bible.lookup(ref, locale);
    if (verse != null && verse.isNotEmpty) {
      return draft.withVerse(verse);
    }

    apiLog.warning('[QtTier1] invalid scripture ref: $ref — retrying');
    try {
      final retryResp = await model.generateContent([
        Content('user', [
          TextPart(
            _buildUserPrompt(
              meditation: meditation,
              passageRef: passageRef,
              passageText: passageText,
              locale: locale,
              userName: userName,
              excludeRef: ref,
            ),
          ),
        ]),
      ]);
      logTierUsage(
        response: retryResp,
        tier: 'qt-t1',
        locale: locale,
        model: modelName,
        note: 'scripture-retry',
      );
      final retryJson = _parseJson(retryResp.text);
      final retry = _extractT1(retryJson, locale);
      final retryVerse = await _bible.lookup(retry.scripture.reference, locale);
      if (retryVerse != null && retryVerse.isNotEmpty) {
        apiLog.info('[QtTier1] retry succeeded: ${retry.scripture.reference}');
        return retry.scripture.withVerse(retryVerse);
      }
    } catch (e) {
      apiLog.warning('[QtTier1] retry failed', error: e);
    }

    apiLog.warning('[QtTier1] scripture validation gave up for ref: $ref');
    return draft;
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
