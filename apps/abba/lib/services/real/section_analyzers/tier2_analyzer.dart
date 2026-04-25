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

  Tier2Analyzer({required GeminiCacheManager cache, required String apiKey})
    : _cache = cache,
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
        temperature: 0.75,
      ),
    );

    final prompt = StringBuffer()
      ..writeln('Mode: prayer')
      ..writeln('Tier: t2')
      ..writeln('Locale: $locale (respond in ${_localeName(locale)})')
      ..writeln(userName.isNotEmpty ? 'User name: $userName' : '')
      ..writeln()
      ..writeln('GROUNDING (★ critical for testimony):')
      ..writeln(
        '- Every factual claim (who, whose, where, when, what happened) MUST come from the user\'s own words below.',
      )
      ..writeln(
        '- DO NOT invent ownership, relationships, or spatial connections the user did not state (e.g., do NOT assume a door is "the user\'s home" unless they said so).',
      )
      ..writeln(
        '- When grammar is ambiguous, use the target language\'s natural indefinite reference (not English "someone") rather than picking one interpretation as fact.',
      )
      ..writeln(
        '- Keep testimony warm and reverent; you MAY add a short prayerful closing breath, but only with facts the user stated.',
      )
      ..writeln()
      ..writeln('User prayer transcript:')
      ..writeln('"""')
      ..writeln(transcript)
      ..writeln('"""')
      ..writeln()
      ..writeln('Previous tier context (DO NOT duplicate this content):')
      ..writeln('- Scripture already chosen: ${t1Context.scripture.reference}')
      ..writeln(
        '- Summary gratitude: ${t1Context.summary.gratitude.join(", ")}',
      )
      ..writeln('- Summary petition: ${t1Context.summary.petition.join(", ")}')
      ..writeln(
        '- Summary intercession: ${t1Context.summary.intercession.join(", ")}',
      )
      ..writeln()
      ..writeln('Generate ONLY T2 sections: "bible_story" and "testimony".')
      ..writeln(
        '- bible_story: Choose a DIFFERENT biblical narrative (not ${t1Context.scripture.reference}\'s passage).',
      )
      ..writeln(
        '  AVOID popular-but-wrong tradition patterns: "three wise men" (Matt 2 says magi, number not given), Jonah\'s "whale" (큰 물고기, 종 미상), "apple" as the forbidden fruit (fruit unspecified), "Paul fell from a horse" (Acts 9 never mentions a horse), "Mary Magdalene was a prostitute" (no scriptural basis).',
      )
      ..writeln(
        '- testimony: Preserve user\'s concrete language. DO NOT add outcomes/answers/peace the user did not state. If the user described anxiety, do not claim they "felt God\'s peace"; keep the prayer open-ended as the user left it.',
      )
      ..writeln(
        'Output JSON with keys: {"bible_story": {...}, "testimony": "..."}',
      );

    try {
      var attempt = await _runOnce(
        model: model,
        modelName: modelName,
        prompt: prompt.toString(),
        locale: locale,
        transcript: transcript,
      );

      // If bible_story uses a popular-but-incorrect tradition, retry once
      // with an explicit reminder. Keep testimony as-is across retries.
      if (attempt.bibleStoryHits.isNotEmpty) {
        apiLog.warning(
          '[Tier2] bible_story tradition-error detected, retrying once: ${attempt.bibleStoryHits.join(", ")}',
        );
        final retryPrompt = StringBuffer(prompt.toString())
          ..writeln()
          ..writeln(
            'RETRY REMINDER: your previous attempt used a tradition-error phrase. Choose a DIFFERENT bible_story that does NOT contain: ${attempt.bibleStoryHits.join(", ")}',
          );
        attempt = await _runOnce(
          model: model,
          modelName: modelName,
          prompt: retryPrompt.toString(),
          locale: locale,
          transcript: transcript,
        );
        if (attempt.bibleStoryHits.isNotEmpty) {
          apiLog.error(
            '[Tier2] bible_story retry still failed: ${attempt.bibleStoryHits.join(", ")}',
          );
          throw AiAnalysisException(
            'Tier2 bible_story rejected after retry (tradition errors: ${attempt.bibleStoryHits.join(", ")})',
            kind: AiAnalysisFailureKind.parseError,
          );
        }
      }

      final cleanedTestimony = _stripTestimonyOverreach(
        attempt.testimony,
        transcript,
      );

      return TierT2Result(
        bibleStory: attempt.bibleStory,
        testimony: cleanedTestimony,
      );
    } on AiAnalysisException {
      rethrow;
    } on GenerativeAIException catch (e, st) {
      apiLog.error(
        '[Tier2] GenerativeAIException (${e.runtimeType}): ${e.toString()}',
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
        '[Tier2] analyze failed: ${e.runtimeType} — ${e.toString()}',
        error: e,
        stackTrace: st,
      );
      throw AiAnalysisException(
        'Tier2 analysis failed: ${e.runtimeType}',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    }
  }

  @visibleForTesting
  Map<String, dynamic> parseJsonForTest(String? text) => _parseJson(text);

  @visibleForTesting
  List<String> detectBibleStoryPitfallsForTest(BibleStory s) =>
      _detectBibleStoryPitfalls(s);

  @visibleForTesting
  String stripTestimonyOverreachForTest(String testimony, String transcript) =>
      _stripTestimonyOverreach(testimony, transcript);

  /// Single Gemini call + parse + pitfall scan. Returns the parsed artefacts
  /// plus any tradition-error hits so the caller can decide to retry or keep.
  Future<_T2Attempt> _runOnce({
    required GenerativeModel model,
    required String modelName,
    required String prompt,
    required String locale,
    required String transcript,
  }) async {
    final response = await model.generateContent([
      Content('user', [TextPart(prompt)]),
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
    final bibleStory = BibleStory.fromJson(storyJson);
    return _T2Attempt(
      bibleStory: bibleStory,
      testimony: testimony,
      bibleStoryHits: _detectBibleStoryPitfalls(bibleStory),
    );
  }

  List<String> _detectBibleStoryPitfalls(BibleStory s) {
    final hay = '${s.title} ${s.summary}'.toLowerCase();
    return _bibleStoryTraditionErrors
        .where((p) => hay.contains(p.toLowerCase()))
        .toList();
  }

  /// Regex-strip overreach phrases that appear in the testimony but not in
  /// the transcript — i.e. the AI added a resolution the user never claimed.
  /// Replacing (rather than throwing) keeps the testimony usable while
  /// removing the fabricated resolution clause.
  String _stripTestimonyOverreach(String testimony, String transcript) {
    final u = transcript.toLowerCase();
    var out = testimony;
    final removed = <String>[];
    for (final phrase in _testimonyOverreachPhrases) {
      if (u.contains(phrase.toLowerCase())) continue; // user said it; keep.
      // Strip the phrase plus an optional leading comma/period and trailing
      // punctuation so the remaining sentence still reads cleanly.
      final escaped = RegExp.escape(phrase);
      final pattern = RegExp(
        r'[\s]*[,\.][\s]*' + escaped + r'[\.\s]*',
        caseSensitive: false,
      );
      if (pattern.hasMatch(out)) {
        out = out.replaceAll(pattern, '.');
        removed.add(phrase);
        continue;
      }
      // Bare occurrence (start of sentence etc.)
      final bare = RegExp(RegExp.escape(phrase), caseSensitive: false);
      if (bare.hasMatch(out)) {
        out = out.replaceAll(bare, '');
        removed.add(phrase);
      }
    }
    if (removed.isNotEmpty) {
      apiLog.warning(
        '[Tier2] testimony stripped overreach phrase(s): ${removed.join(", ")}',
      );
      out = out.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    }
    return out;
  }

  /// Popular-but-incorrect bible traditions to watch for in bible_story.
  static const _bibleStoryTraditionErrors = <String>[
    'three wise men',
    'three kings',
    '세 명의 동방박사',
    '동방박사 세',
    'jonah and the whale',
    '요나와 고래',
    '고래 뱃속',
    'apple in the garden',
    'forbidden apple',
    '선악과 사과',
    'paul fell from his horse',
    'paul\'s horse',
    '바울이 말에서',
    'mary magdalene was a prostitute',
    '막달라 마리아는 창녀',
  ];

  /// Resolution phrases that, when added unprompted, convert a lament into
  /// a false testimony of answered prayer.
  static const _testimonyOverreachPhrases = <String>[
    '응답이라 믿습니다',
    '응답을 주셨습니다',
    '응답해 주셨습니다',
    '평안을 주셨습니다',
    '평안을 주신',
    '치유해 주셨습니다',
    '해결해 주셨습니다',
    'felt god\'s peace',
    'god answered',
    'god healed',
    'god provided',
  ];

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

class _T2Attempt {
  final BibleStory bibleStory;
  final String testimony;
  final List<String> bibleStoryHits;
  _T2Attempt({
    required this.bibleStory,
    required this.testimony,
    required this.bibleStoryHits,
  });
}
