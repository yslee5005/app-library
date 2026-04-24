import 'dart:convert';

import 'package:app_lib_logging/logging.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../config/app_config.dart';
import '../../../models/prayer_tier_result.dart';
import '../../../models/qt_meditation_result.dart'
    show ApplicationSuggestion, RelatedKnowledge;
import '../../ai_analysis_exception.dart';
import '../../gemini_cache_manager.dart';
import 'tier_telemetry.dart';

/// Phase 4.2 — QT T2 (application + knowledge) generator. Background call
/// after T1 completes. Receives T1 context so the application and
/// knowledge stay coherent with the meditation theme chosen in T1.
///
/// Honours [AppConfig.tier2Model] so the user can A/B flash vs flash-lite
/// for T2 quality (same knob as Prayer T2).
class QtTier2Analyzer {
  final GeminiCacheManager _cache;
  final String _apiKey;

  QtTier2Analyzer({
    required GeminiCacheManager cache,
    required String apiKey,
  })  : _cache = cache,
        _apiKey = apiKey;

  Future<QtTierT2Result> analyze({
    required String meditation,
    required String passageRef,
    required String locale,
    required String userName,
    required QtTierT1Result t1Context,
  }) async {
    final systemInstruction = await _cache.loadRubricBundle('qt');
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
      ..writeln('Mode: qt')
      ..writeln('Tier: t2')
      ..writeln('Locale: $locale (respond in ${_localeName(locale)})')
      ..writeln(userName.isNotEmpty ? 'User name: $userName' : '')
      ..writeln()
      ..writeln('Today\'s QT passage: $passageRef')
      ..writeln()
      ..writeln('User meditation:')
      ..writeln('"""')
      ..writeln(meditation)
      ..writeln('"""')
      ..writeln()
      ..writeln('Previous tier context (DO NOT duplicate):')
      ..writeln('- Meditation topic: ${t1Context.meditationSummary.topic}')
      ..writeln('- Meditation summary: ${t1Context.meditationSummary.summary}')
      ..writeln('- Scripture chosen in T1: ${t1Context.scripture.reference}')
      ..writeln()
      ..writeln('Generate ONLY T2 sections: "application" and "knowledge".')
      ..writeln('- application: 3 time-block actions (morning_action, day_action, evening_action). '
          '3P rule (Personal / Practical / Possible). Each ≤15 min.')
      ..writeln('- knowledge: historical_context (3-4 sentences), 2-3 cross_references '
          '(reference ONLY — app fills verse text at runtime), '
          '0-2 original_words with transliteration + meaning.')
      ..writeln('Output JSON: {"application": {...}, "knowledge": {...}}');

    try {
      final response = await model.generateContent([
        Content('user', [TextPart(prompt.toString())]),
      ]);
      logTierUsage(
        response: response,
        tier: 'qt-t2',
        locale: locale,
        model: modelName,
      );
      final json = _parseJson(response.text);

      final appJson = json['application'] as Map<String, dynamic>?;
      final kJson = json['knowledge'] as Map<String, dynamic>?;
      if (appJson == null || kJson == null) {
        throw AiAnalysisException(
          'QT T2 response missing application or knowledge',
          kind: AiAnalysisFailureKind.parseError,
        );
      }

      return QtTierT2Result(
        application: ApplicationSuggestion.fromJson(appJson),
        knowledge: RelatedKnowledge.fromJson(kJson),
      );
    } on AiAnalysisException {
      rethrow;
    } catch (e, st) {
      apiLog.error('[QtTier2] analyze failed', error: e, stackTrace: st);
      throw AiAnalysisException(
        'QT Tier2 analysis failed',
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
