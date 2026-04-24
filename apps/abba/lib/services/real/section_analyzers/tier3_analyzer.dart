import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../models/prayer.dart';
import '../../../models/prayer_tier_result.dart';
import '../../ai_analysis_exception.dart';
import '../../gemini_cache_manager.dart';
import 'tier_telemetry.dart';

/// Phase 4.1 — T3 (guidance + ai_prayer + historical_story) generator.
/// Pro-only, triggered by Dashboard scroll to premium area.
class Tier3Analyzer {
  final GeminiCacheManager _cache;
  final String _apiKey;

  Tier3Analyzer({
    required GeminiCacheManager cache,
    required String apiKey,
  })  : _cache = cache,
        _apiKey = apiKey;

  /// Generate premium sections. Caller should check Pro status before calling.
  Future<TierT3Result> analyze({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
    required TierT2Result t2Context,
  }) async {
    final systemInstruction = await _cache.loadRubricBundle('prayer');
    const modelName = 'gemini-2.5-flash';
    final model = GenerativeModel(
      model: modelName,
      apiKey: _apiKey,
      systemInstruction: Content.system(systemInstruction),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: 0.9,
      ),
    );

    final prompt = StringBuffer()
      ..writeln('Mode: prayer')
      ..writeln('Tier: t3')
      ..writeln('Is Pro: true')
      ..writeln('Locale: $locale (respond in ${_localeName(locale)})')
      ..writeln(userName.isNotEmpty ? 'User name: $userName' : '')
      ..writeln()
      ..writeln('User prayer transcript:')
      ..writeln('"""')
      ..writeln(transcript)
      ..writeln('"""')
      ..writeln()
      ..writeln('Previous tier context (do not duplicate):')
      ..writeln('- Scripture: ${t1Context.scripture.reference}')
      ..writeln('- Bible story: ${t2Context.bibleStory.title}')
      ..writeln('- Testimony echoes: ${_truncate(t2Context.testimony, 100)}')
      ..writeln()
      ..writeln('Generate ONLY T3 premium sections: "guidance", "ai_prayer", "historical_story".')
      ..writeln('- guidance: ONE actionable suggestion, 3P (Personal/Practical/Possible), submission clause')
      ..writeln('- ai_prayer: ~300 words, 5-part structure, Trinitarian close, 2-3 citations with sources')
      ..writeln('- historical_story: Whitelist figure only (Augustine/Luther/Müller/Bonhoeffer/주기철/손양원 등)')
      ..writeln('Output JSON: {"guidance": {...}, "ai_prayer": {...}, "historical_story": {...}}');

    try {
      final response = await model.generateContent([
        Content('user', [TextPart(prompt.toString())]),
      ]);
      logTierUsage(
        response: response,
        tier: 't3',
        locale: locale,
        model: modelName,
      );
      final json = _parseJson(response.text);

      Guidance? guidance;
      AiPrayer? aiPrayer;
      HistoricalStory? historicalStory;

      final g = json['guidance'];
      if (g is Map<String, dynamic>) {
        guidance = Guidance.fromJson(g);
      }
      final ap = json['ai_prayer'];
      if (ap is Map<String, dynamic>) {
        aiPrayer = AiPrayer.fromJson(ap);
      }
      final hs = json['historical_story'];
      if (hs is Map<String, dynamic>) {
        historicalStory = HistoricalStory.fromJson(hs);
      }

      if (guidance == null && aiPrayer == null && historicalStory == null) {
        throw AiAnalysisException(
          'T3 response missing all premium sections',
          kind: AiAnalysisFailureKind.parseError,
        );
      }

      return TierT3Result(
        guidance: guidance,
        aiPrayer: aiPrayer,
        historicalStory: historicalStory,
      );
    } on AiAnalysisException {
      rethrow;
    } catch (e, st) {
      apiLog.error('[Tier3] analyze failed', error: e, stackTrace: st);
      throw AiAnalysisException(
        'Tier3 analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: st,
      );
    }
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

  String _truncate(String s, int n) => s.length <= n ? s : '${s.substring(0, n)}...';

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
