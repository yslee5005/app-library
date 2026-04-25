import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart' show kDebugMode, visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:app_lib_logging/logging.dart';

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../../models/prayer_tier_result.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_analysis_exception.dart';
import '../ai_service.dart';
import '../bible_text_service.dart';
import '../gemini_cache_manager.dart';
import 'section_analyzers/qt_tier1_analyzer.dart';
import 'section_analyzers/qt_tier2_analyzer.dart';
import 'section_analyzers/tier1_analyzer.dart';
import 'section_analyzers/tier2_analyzer.dart';
import 'section_analyzers/tier3_analyzer.dart';
import 'section_analyzers/tier3_hallucination_filters.dart';

// AI mock toggle lives in `AppConfig.useMockAi` (driven by `ENABLE_MOCK_AI`).
// Each AiService method short-circuits to the `_hardcoded*` builders below
// when the flag is true; otherwise it calls Gemini.

const String _hardcodedTranscription =
    '주님, 오늘도 새로운 아침을 허락해 주셔서 감사합니다. 가족의 건강과 평안을 지켜 주시고, '
    '오늘 하루 주님의 뜻을 따라 살아가게 하소서. 염려하는 친구를 위로하여 주시고, '
    '주님의 사랑 안에서 모두가 평안하기를 간구합니다. 예수님의 이름으로 기도드립니다. 아멘.';

class GeminiService implements AiService {
  /// Phase 4.1 — lazy-initialized tier analyzers. Injected via providers
  /// when `GeminiService` is constructed; otherwise lazy-fallback creates
  /// them on first use with fresh instances (rubric bundle is app-local).
  final GeminiCacheManager? _cacheManager;
  final BibleTextService? _bibleService;

  GeminiService({
    GeminiCacheManager? cacheManager,
    BibleTextService? bibleService,
  }) : _cacheManager = cacheManager,
       _bibleService = bibleService;

  // ---------------------------------------------------------------------------
  // AI cost tracking (dev-only)
  //
  // Pricing per 1M tokens (Gemini 2.5 Flash paid tier, verified 2026-04-22):
  //   text/image/video input : $0.30
  //   audio input            : $1.00
  //   output (incl. thinking): $2.50
  //
  // Source: https://ai.google.dev/gemini-api/docs/pricing
  // Re-verify quarterly. If the model in `_createModel` changes, bump these.
  // ---------------------------------------------------------------------------
  static const double _textInputPerMillion = 0.30;
  static const double _audioInputPerMillion = 1.00;
  static const double _outputPerMillion = 2.50;
  static const String _pricingModel = 'gemini-2.5-flash';

  /// Log Gemini call cost to the terminal. No-op in release builds so
  /// production logs never carry pricing chatter.
  void _logAiCost(
    GenerateContentResponse response,
    String method, {
    bool hasAudioInput = false,
  }) {
    if (!kDebugMode) return;

    final usage = response.usageMetadata;
    if (usage == null) {
      apiLog.info('[AI Cost] $method — usageMetadata missing');
      return;
    }

    final promptTokens = usage.promptTokenCount ?? 0;
    final candidateTokens = usage.candidatesTokenCount ?? 0;

    final inputRate = hasAudioInput
        ? _audioInputPerMillion
        : _textInputPerMillion;
    final inputLabel = hasAudioInput ? 'audio' : 'text';
    final inputCost = promptTokens * inputRate / 1000000;
    final outputCost = candidateTokens * _outputPerMillion / 1000000;
    final total = inputCost + outputCost;

    apiLog.info(
      '[AI Cost] $method ($_pricingModel)\n'
      '    in:  $promptTokens $inputLabel tokens '
      '(\$${inputRate.toStringAsFixed(2)}/M) = \$${inputCost.toStringAsFixed(6)}\n'
      '    out: $candidateTokens text tokens  '
      '(\$${_outputPerMillion.toStringAsFixed(2)}/M) = \$${outputCost.toStringAsFixed(6)}\n'
      '    total: \$${total.toStringAsFixed(6)}',
    );
  }

  /// Cached prayer guide markdown — loaded once from bundle, reused across calls.
  String? _prayerGuideCache;

  /// Cached QT guide markdown — loaded once from bundle, reused across calls.
  String? _qtGuideCache;

  Future<String> _loadPrayerGuide() async {
    final cached = _prayerGuideCache;
    if (cached != null) return cached;
    final doc = await rootBundle.loadString('assets/docs/prayer_guide.md');
    _prayerGuideCache = doc;
    return doc;
  }

  Future<String> _loadQtGuide() async {
    final cached = _qtGuideCache;
    if (cached != null) return cached;
    final doc = await rootBundle.loadString('assets/docs/qt_guide.md');
    _qtGuideCache = doc;
    return doc;
  }

  GenerativeModel _createModel({
    required String systemPrompt,
    double temperature = 0.9,
  }) {
    return GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: AppConfig.geminiApiKey,
      systemInstruction: Content.system(systemPrompt),
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        temperature: temperature,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Prayer analysis (text)
  // ---------------------------------------------------------------------------

  @override
  Future<PrayerResult> analyzePrayer({
    required String transcript,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info('Gemini analyzePrayer bypassed (ENABLE_MOCK_AI=true)');
      return _hardcodedPrayerResult(locale);
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini full prayer analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      _logAiCost(response, 'analyzePrayer');
      return parsePrayerJson(response.text, locale);
    } on AiAnalysisException {
      rethrow;
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini prayer analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Gemini prayer analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info('Gemini analyzePrayerCore bypassed (ENABLE_MOCK_AI=true)');
      return _hardcodedPrayerResult(locale);
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini core prayer analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildCoreSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      _logAiCost(response, 'analyzePrayerCore');
      return parsePrayerJson(response.text, locale);
    } on AiAnalysisException {
      rethrow;
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini core analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Gemini core analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Prayer analysis from audio (Gemini processes audio directly)
  // ---------------------------------------------------------------------------

  @override
  Future<({PrayerResult result, String transcription})> analyzePrayerFromAudio({
    required String audioFilePath,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info(
        'Gemini analyzePrayerFromAudio bypassed (ENABLE_MOCK_AI=true)',
      );
      return (
        result: _hardcodedPrayerResult(locale),
        transcription: _hardcodedTranscription,
      );
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini audio prayer analysis started');

    try {
      final audioBytes = await File(audioFilePath).readAsBytes();
      final model = _createModel(
        systemPrompt: _buildAudioCoreSystemPrompt(langName) + _diversityHint(),
      );

      final response = await model.generateContent([
        Content('user', [
          DataPart('audio/mp4', audioBytes),
          TextPart(
            'This is a prayer audio recording. Transcribe and analyze it.',
          ),
        ]),
      ]);
      _logAiCost(response, 'analyzePrayerFromAudio', hasAudioInput: true);

      final json = parseJsonFromResponse(response.text);
      final transcription = json['transcription'] as String? ?? '';
      final result = PrayerResult.fromJson(json);
      return (result: result, transcription: transcription);
    } on FormatException catch (e, stackTrace) {
      apiLog.error(
        'Gemini audio parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Gemini audio response was malformed',
        kind: AiAnalysisFailureKind.parseError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    } on AiAnalysisException {
      rethrow;
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini audio analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Gemini audio analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Premium analysis (text only — transcript already available)
  // ---------------------------------------------------------------------------

  @override
  Future<PremiumContent> analyzePrayerPremium({
    required String transcript,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info('Gemini analyzePrayerPremium bypassed (ENABLE_MOCK_AI=true)');
      return _hardcodedPremiumContent(locale);
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini premium analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildPremiumSystemPrompt(langName) + _diversityHint(),
        // Lower than default 0.9 to reduce citation/quote fabrication rate.
        temperature: 0.7,
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      _logAiCost(response, 'analyzePrayerPremium');
      final parsed = parsePremiumJson(response.text);
      // Same T3 hallucination filters as the tier analyzer path so Pro
      // users on the legacy dashboard path get the same guardrails.
      final historical = parsed.historicalStory == null
          ? null
          : sanitizeHistoricalStory(parsed.historicalStory!);
      final aiPrayer = parsed.aiPrayer == null
          ? null
          : sanitizeAiPrayer(parsed.aiPrayer!);
      return PremiumContent(
        historicalStory: historical,
        aiPrayer: aiPrayer,
        guidance: parsed.guidance,
      );
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini premium analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      return const PremiumContent();
    }
  }

  // ---------------------------------------------------------------------------
  // QT Meditation analysis
  // ---------------------------------------------------------------------------

  @override
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info('Gemini analyzeMeditation bypassed (ENABLE_MOCK_AI=true)');
      return _hardcodedMeditationResult(locale);
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini meditation analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildMeditationPrompt(langName) + _diversityHint(),
      );
      final userMessage =
          'Passage: $passageReference\n\n$passageText\n\nMy meditation:\n$meditationText';
      final response = await model.generateContent([
        Content('user', [TextPart(userMessage)]),
      ]);
      _logAiCost(response, 'analyzeMeditation');
      return parseMeditationJson(response.text, locale);
    } on AiAnalysisException {
      rethrow;
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini meditation analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Gemini meditation analysis failed',
        kind: AiAnalysisFailureKind.apiError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Prayer Coaching (Pro-only, separate context with prayer_guide.md)
  // ---------------------------------------------------------------------------

  @override
  Future<PrayerCoaching> analyzePrayerCoaching({
    required String transcript,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info(
        'Gemini analyzePrayerCoaching bypassed (ENABLE_MOCK_AI=true)',
      );
      return _hardcodedCoachingResult();
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini prayer coaching started');

    try {
      final guide = await _loadPrayerGuide();
      final model = _createModel(
        systemPrompt: _buildCoachingSystemPrompt(langName, guide),
        temperature: 0.4,
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      _logAiCost(response, 'analyzePrayerCoaching');
      return parseCoachingJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini coaching analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      return PrayerCoaching.placeholder();
    }
  }

  PrayerCoaching _hardcodedCoachingResult() {
    return const PrayerCoaching(
      scores: CoachingScores(
        specificity: 4,
        godCenteredness: 3,
        actsBalance: 4,
        authenticity: 4,
      ),
      strengths: [
        '가족과 친구를 구체적으로 떠올리며 기도하신 점이 좋습니다 — 이는 구체성의 좋은 예입니다.',
        '"감사합니다"로 시작해 "간구합니다"로 이어지는 흐름이 ACTS의 T와 S를 자연스럽게 담고 있어요.',
      ],
      improvements: [
        '회개(Confession) 한 문장을 더해 보세요. 예: "오늘 급한 말을 용서해 주소서." 이것만으로도 ACTS 4축이 채워집니다.',
        '"거룩하신 주님" 같이 하나님의 속성을 찬양하는 한 문장을 기도 시작에 더하시면 더 깊어질 거예요.',
      ],
      overallFeedbackEn:
          'Your prayer shows beautiful balance of gratitude and intercession. Adding one sentence of confession would complete the ACTS rhythm. God loves every heart that prays.',
      overallFeedbackKo:
          '감사와 중보가 아름답게 균형 잡힌 기도예요. 회개 한 문장을 더하시면 ACTS 4축이 완성됩니다. 하나님은 기도하는 당신의 마음을 사랑하십니다.',
      expertLevel: 'growing',
    );
  }

  @visibleForTesting
  PrayerCoaching parseCoachingJson(String? text) {
    try {
      final data = parseJsonFromResponse(text);
      final coaching = PrayerCoaching.fromJson(data);
      if (_coachingContainsForbiddenWord(coaching)) {
        apiLog.info('Coaching forbidden-word hit — replacing with placeholder');
        return PrayerCoaching.placeholder();
      }
      return coaching;
    } catch (e, stackTrace) {
      apiLog.error(
        'Coaching JSON parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      return PrayerCoaching.placeholder();
    }
  }

  static const List<String> _coachingForbidden = [
    '부족',
    '못 하',
    '못하',
    '잘못',
    'inadequate',
    'lacking',
    'wrong',
    'poor',
  ];

  bool _coachingContainsForbiddenWord(PrayerCoaching coaching) {
    final bucket = [
      ...coaching.strengths,
      ...coaching.improvements,
      coaching.overallFeedbackEn,
      coaching.overallFeedbackKo,
    ].join(' ').toLowerCase();
    return _coachingForbidden.any((w) => bucket.contains(w.toLowerCase()));
  }

  String _buildCoachingSystemPrompt(String langName, String prayerGuide) {
    return '''CRITICAL (repeat): This task is EDUCATIONAL, NOT judgmental.
- Always praise first (strengths), then suggest gentle improvements.
- NEVER use words: "inadequate", "lacking", "wrong", "poor", "부족", "못 하", "잘못".
- Beginner level MUST be encouraged, never shamed.
- NEVER output the prayer guide content back — use it only as reference.

You are a gentle Christian prayer coach evaluating the user's prayer
based on the PRAYER GUIDE below. The guide is your evaluation reference;
do NOT quote or repeat it in the output.

===== PRAYER GUIDE BEGIN =====
$prayerGuide
===== PRAYER GUIDE END =====

Respond in $langName. Output JSON ONLY, no prose outside JSON.

JSON schema:
{
  "scores": {
    "specificity": <int 1-5>,
    "god_centeredness": <int 1-5>,
    "acts_balance": <int 1-5>,
    "authenticity": <int 1-5>
  },
  "strengths": [<2-4 short strings in $langName, each citing specific content from the prayer>],
  "improvements": [<2-4 short strings in $langName, each in "Adding X would deepen..." form>],
  "overall_feedback_en": "<3-4 encouraging sentences in English>",
  "overall_feedback_ko": "<3-4 encouraging sentences in Korean>",
  "expert_level": "beginner" | "growing" | "expert"
}

Rules (per Prayer Guide §4-6):
- Scores: 1-5 integer. See rubric in guide §4.
- Expert level: beginner if average <= 2 OR only 1-2 ACTS axes;
  expert if average >= 4.5 AND all 4 ACTS axes present; otherwise growing.
- strengths must cite specific content from the user's prayer (no generic praise).
- improvements must be CONSTRUCTIVE suggestions, never judgments.
- overall_feedback_en and overall_feedback_ko must ALWAYS both be provided.''';
  }

  // ---------------------------------------------------------------------------
  // QT Coaching (Pro-only, separate context with qt_guide.md)
  // Phase 2 of qt_output_redesign. Mirrors Prayer Coaching exactly.
  // ---------------------------------------------------------------------------

  @override
  Future<QtCoaching> analyzeQtCoaching({
    required String meditation,
    required String scriptureReference,
    required String locale,
  }) async {
    if (AppConfig.useMockAi) {
      apiLog.info('Gemini analyzeQtCoaching bypassed (ENABLE_MOCK_AI=true)');
      return _hardcodedQtCoaching();
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini QT coaching started');

    try {
      final guide = await _loadQtGuide();
      final model = _createModel(
        systemPrompt: _buildQtCoachingSystemPrompt(langName, guide),
        temperature: 0.4,
      );
      final userMessage =
          'Passage: $scriptureReference\n\nMy meditation:\n$meditation';
      final response = await model.generateContent([
        Content('user', [TextPart(userMessage)]),
      ]);
      _logAiCost(response, 'analyzeQtCoaching');
      return parseQtCoachingJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error(
        'Gemini QT coaching analysis failed',
        error: e,
        stackTrace: stackTrace,
      );
      return QtCoaching.placeholder();
    }
  }

  QtCoaching _hardcodedQtCoaching() {
    return const QtCoaching(
      scores: QtScores(
        comprehension: 4,
        application: 3,
        depth: 4,
        authenticity: 4,
      ),
      strengths: [
        '시편 23편의 "쉴 만한 물가" 이미지를 개인 경험과 연결한 점이 본문 이해의 깊이를 보여줍니다.',
        '하나님의 인도하심에 대한 신뢰를 솔직하게 드러내신 점 — 진정성 있는 묵상이에요.',
      ],
      improvements: [
        '본문 앞부분(시편 22편 끝)을 함께 읽으시면 대조적 감정의 흐름이 보입니다.',
        '오늘 묵상한 내용을 저녁 식사 기도에 한 문장으로 연결해 보시면 3P 적용이 완성됩니다.',
      ],
      overallFeedbackEn:
          'Your meditation shows beautiful trust and honest reflection on the text. Connecting today\'s insight to one concrete action tonight would complete the 3P application. God treasures every heart that meditates on His Word.',
      overallFeedbackKo:
          '신뢰가 아름답게 드러난 묵상이에요. 본문 이해와 영적 깊이가 좋습니다. 오늘 묵상을 저녁의 한 행동으로 이어 가시면 3P 적용까지 완성됩니다. 말씀을 묵상하는 당신의 마음을 하나님이 귀하게 보십니다.',
      expertLevel: 'growing',
    );
  }

  @visibleForTesting
  QtCoaching parseQtCoachingJson(String? text) {
    try {
      final data = parseJsonFromResponse(text);
      final coaching = QtCoaching.fromJson(data);
      if (_qtCoachingContainsForbiddenWord(coaching)) {
        apiLog.info(
          'QT coaching forbidden-word hit — replacing with placeholder',
        );
        return QtCoaching.placeholder();
      }
      return coaching;
    } catch (e, stackTrace) {
      apiLog.error(
        'QT coaching JSON parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      return QtCoaching.placeholder();
    }
  }

  static const List<String> _qtCoachingForbidden = [
    '부족',
    '못 하',
    '못하',
    '잘못',
    'inadequate',
    'lacking',
    'wrong',
    'poor',
  ];

  bool _qtCoachingContainsForbiddenWord(QtCoaching coaching) {
    final bucket = [
      ...coaching.strengths,
      ...coaching.improvements,
      coaching.overallFeedbackEn,
      coaching.overallFeedbackKo,
    ].join(' ').toLowerCase();
    return _qtCoachingForbidden.any((w) => bucket.contains(w.toLowerCase()));
  }

  String _buildQtCoachingSystemPrompt(String langName, String qtGuide) {
    return '''CRITICAL (repeat): This task is EDUCATIONAL, NOT judgmental.
- Always praise first (strengths), then suggest gentle improvements.
- NEVER use words: "inadequate", "lacking", "wrong", "poor", "부족", "못 하", "잘못".
- Beginner level MUST be encouraged, never shamed.
- NEVER output the QT guide content back — use it only as reference.

You are a gentle Christian QT (quiet time / meditation) coach evaluating the
user's meditation based on the QT GUIDE below. The guide is your evaluation
reference; do NOT quote or repeat it in the output.

===== QT GUIDE BEGIN =====
$qtGuide
===== QT GUIDE END =====

Respond in $langName. Output JSON ONLY, no prose outside JSON.

JSON schema:
{
  "scores": {
    "comprehension": <int 1-5>,
    "application": <int 1-5>,
    "depth": <int 1-5>,
    "authenticity": <int 1-5>
  },
  "strengths": [<2-4 short strings in $langName, each citing specific content from the meditation>],
  "improvements": [<2-4 short strings in $langName, each in "Adding X would deepen..." form>],
  "overall_feedback_en": "<3-4 encouraging sentences in English>",
  "overall_feedback_ko": "<3-4 encouraging sentences in Korean>",
  "expert_level": "beginner" | "growing" | "expert"
}

Rules (per QT Guide §4-6):
- Scores: 1-5 integer. See rubric in guide §4.
- Expert level: beginner if average <= 2 OR any axis is 1;
  expert if average >= 4.5 AND all axes >= 4 AND authenticity = 5;
  otherwise growing.
- 4 axes: comprehension (본문 이해), application (개인 적용 — 3P: Personal,
  Practical, Possible), depth (영적 깊이), authenticity (진정성).
- strengths must cite specific content from the user's meditation (no generic praise).
- improvements must be CONSTRUCTIVE suggestions, never judgments.
- overall_feedback_en and overall_feedback_ko must ALWAYS both be provided.
- End with one encouragement line from §7 (힘이 되는 말).''';
  }

  // ---------------------------------------------------------------------------
  // JSON parsing
  // ---------------------------------------------------------------------------

  @visibleForTesting
  Map<String, dynamic> parseJsonFromResponse(String? text) {
    if (text == null || text.isEmpty) throw FormatException('Empty response');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  @visibleForTesting
  PrayerResult parsePrayerJson(String? text, String locale) {
    try {
      final data = parseJsonFromResponse(text);
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error(
        'Prayer JSON parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Prayer JSON parse failed',
        kind: AiAnalysisFailureKind.parseError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  @visibleForTesting
  PremiumContent parsePremiumJson(String? text) {
    try {
      final data = parseJsonFromResponse(text);
      return PremiumContent(
        historicalStory: data['historical_story'] != null
            ? HistoricalStory.fromJson(
                data['historical_story'] as Map<String, dynamic>,
              )
            : null,
        aiPrayer: data['ai_prayer'] != null
            ? AiPrayer.fromJson(data['ai_prayer'] as Map<String, dynamic>)
            : null,
        guidance: data['guidance'] != null
            ? Guidance.fromJson(data['guidance'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      apiLog.error(
        'Premium JSON parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      return const PremiumContent();
    }
  }

  @visibleForTesting
  QtMeditationResult parseMeditationJson(String? text, String locale) {
    try {
      final data = parseJsonFromResponse(text);
      final result = QtMeditationResult.fromJson(data);
      // Sanity: if scripture.reference missing, treat as parse failure —
      // scripture lookup would fail downstream anyway.
      if (result.scripture.reference.isEmpty) {
        apiLog.warning(
          'Meditation JSON missing scripture.reference — treating as parse error',
        );
        throw const FormatException(
          'Meditation JSON missing scripture.reference',
        );
      }
      return result;
    } on AiAnalysisException {
      rethrow;
    } catch (e, stackTrace) {
      apiLog.error(
        'Meditation JSON parse failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw AiAnalysisException(
        'Meditation JSON parse failed',
        kind: AiAnalysisFailureKind.parseError,
        cause: e,
        causeStackTrace: stackTrace,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Hardcoded responses (sample data returned when AppConfig.useMockAi is true).
  // Also used as graceful fallbacks when API calls fail.
  // ---------------------------------------------------------------------------

  PrayerResult _hardcodedPrayerResult(String locale) {
    return PrayerResult(
      prayerSummary: const PrayerSummary(
        gratitude: ['새로운 아침을 허락해 주신 하나님께 감사합니다.'],
        petition: ['오늘 하루 주님의 뜻을 따라 살아가게 하소서.'],
        intercession: ['염려하는 친구를 위로해 주시고 가족의 건강을 지켜 주소서.'],
      ),
      scripture: Scripture(
        reference: 'Psalm 23:1',
        // verse: empty — filled at runtime by BibleTextService.lookup
        reason: locale == 'ko'
            ? '당신이 기도한 하나님은 당신을 인격적으로 인도하시고 채워 주시는 목자이심을 다시 새겨 주는 말씀입니다.'
            : 'This verse reminds you that the God you prayed to is a shepherd who personally leads and provides for you.',
        posture: locale == 'ko'
            ? '당신을 부드럽게 인도하시는 목자의 양으로 그려 보며 천천히 읽어 보세요. "나의"라는 단어에 머물러 보세요 — 이것은 개인적인 관계입니다.'
            : 'Read this verse slowly, picturing yourself as a sheep led by a caring shepherd. Linger on the word "my" — this is a personal relationship.',
        keyWordHint: locale == 'ko'
            ? "'나의 목자' = 히브리어 '로이' — 직업이 아닌 '나를 돌보시는 분'"
            : "'my shepherd' = Hebrew 'ro'i' — not a job title, but 'the one who tends me personally'",
        originalWords: [
          ScriptureOriginalWord(
            word: 'רֹעִי',
            transliteration: "ro'i",
            language: 'Hebrew',
            meaning: locale == 'ko' ? '나의 목자' : 'my shepherd',
            nuance: locale == 'ko'
                ? "단순한 직업으로서의 '목자'와 달리, '로이'는 친밀하고 개인적인 언약 관계를 의미합니다 — '나를 개인적으로 돌보시는 분'."
                : "Unlike 'shepherd' as a job, 'ro'i' implies an intimate, personal covenant relationship — 'the one who shepherds me personally'.",
          ),
          ScriptureOriginalWord(
            word: 'חָסֵר',
            transliteration: 'chaser',
            language: 'Hebrew',
            meaning: locale == 'ko' ? '부족하다, 결핍되다' : 'to lack, be in want',
            nuance: locale == 'ko'
                ? '단순한 물질적 결핍이 아니라 언약적 완전성을 의미합니다 — 하나님이 목자이시면 삶에 본질적인 것이 빠지지 않습니다.'
                : 'Not merely material lack but covenant completeness — with God as shepherd, nothing essential is missing from life.',
          ),
        ],
      ),
      bibleStory: locale == 'ko'
          ? const BibleStory(
              title: '목자 다윗',
              summary:
                  '다윗은 왕이 되기 전, 베들레헴 들판에서 사자와 곰으로부터 양을 지키던 소년이었습니다. 고요한 언덕 위에서 그는 자신의 삶을 인도하시는 진짜 목자가 여호와이심을 배웠습니다.',
            )
          : const BibleStory(
              title: 'David the Shepherd',
              summary:
                  'Before David became king, he tended sheep in the fields of Bethlehem — defending them from lions and bears. In those quiet hills he learned that the LORD was the true shepherd over his own life.',
            ),
      testimony: locale == 'ko'
          ? '주님, 오늘도 새로운 아침을 허락해 주셔서 감사합니다. 가족을 평안으로 인도하시고, 염려하는 친구를 위로해 주세요. 예수님의 이름으로 기도합니다. 아멘.'
          : 'Lord, thank You for this new morning. Guide my family in peace and comfort my friend who is anxious. In Jesus\' name, Amen.',
      guidance: Guidance(
        content: locale == 'ko'
            ? '자신보다 먼저 다른 이들을 기억하는 마음이 기도에 담겨 있습니다. 이는 중보자의 마음입니다. 오늘 만나는 이들과의 대화에서도 그 부드러움을 잃지 마세요.'
            : 'Your prayer shows a heart that remembers others before yourself — a mark of intercession. Carry that same gentleness with you into today\'s conversations.',
        isPremium: true,
      ),
      aiPrayer: _hardcodedAiPrayer(locale),
      historicalStory: _hardcodedHistoricalStory(locale),
    );
  }

  AiPrayer _hardcodedAiPrayer(String locale) {
    if (locale == 'ko') {
      return const AiPrayer(
        text:
            '하늘에 계신 아버지, 오늘 아침 당신 앞에 조용히 무릎 꿇습니다.\n\n'
            '주님, 저는 오늘도 가족의 이름을 불러봅니다. 어머니의 무릎, 아이의 숨결, 배우자의 뒷모습 — 그 익숙한 풍경이 얼마나 큰 은혜인지 이제야 눈이 열립니다. C.S. 루이스는 "우리는 영원을 향해 창조된 존재"라고 말했습니다. 하나님, 그 영원이 오늘 아침 제 방 안에, 가족의 평범한 얼굴 속에 이미 들어와 있음을 믿습니다.\n\n'
            '하버드 대학은 85년 동안 724명의 삶을 추적하며 "행복을 결정짓는 단 하나의 요인은 관계의 깊이"라는 결론에 도달했습니다. 주님, 과학도 돌아가 증언하는 이 진리 — 사랑의 관계가 곧 생명 — 을 오늘 제 식탁과 잠자리에서 살아내게 하소서.\n\n'
            '염려로 잠 못 이루던 밤, 친구의 전화 한 통이 얼마나 큰 위로였는지 기억합니다. 주님, 오늘 저를 그런 전화가 되게 하소서. 짧은 문자 하나, 조용한 기도 하나로 누군가의 밤을 밝히는 사람이 되게 하소서.\n\n'
            '주님의 이름으로 기도드립니다. 아멘.',
        citations: [
          Citation(
            type: 'quote',
            source: 'C.S. Lewis, Mere Christianity',
            content: '우리는 영원을 향해 창조된 존재입니다.',
          ),
          Citation(
            type: 'science',
            source: 'Harvard Study of Adult Development (Waldinger, 85년 추적)',
            content: '행복을 결정짓는 단 하나의 요인은 관계의 깊이다.',
          ),
          Citation(
            type: 'example',
            source: '',
            content: '염려로 잠 못 이루던 밤, 친구의 전화 한 통이 위로가 된 순간.',
          ),
        ],
        isPremium: true,
      );
    }
    return const AiPrayer(
      text:
          'Heavenly Father, this morning I kneel quietly before You.\n\n'
          "Lord, today I find myself speaking the names of my family — my mother's knees, my child's breath, the familiar silhouette of my spouse. Only now do my eyes open to how great a grace this ordinary view is. C.S. Lewis wrote, \"We are creatures made for eternity.\" Father, I believe that eternity has already entered this morning, hidden in the plain faces around my breakfast table.\n\n"
          'Harvard tracked 724 lives across 85 years and arrived at one quiet conclusion: the single strongest predictor of human flourishing is the depth of our relationships. Lord, let even this finding of science bow and testify to what Your Word has always said — that love is life itself. Help me live this truth today at my table and at my bedside.\n\n'
          "I remember a sleepless night when a single phone call from a friend became light enough to carry me until dawn. Lord, today let me be that call for someone else. A short message, a quiet prayer — let me become the hand that steadies another person's darkness.\n\n"
          "In Jesus' name, Amen.",
      citations: [
        Citation(
          type: 'quote',
          source: 'C.S. Lewis, Mere Christianity',
          content: 'We are creatures made for eternity.',
        ),
        Citation(
          type: 'science',
          source:
              'Harvard Study of Adult Development (Waldinger, 85-year study)',
          content:
              'The single strongest predictor of human flourishing is the depth of our close relationships.',
        ),
        Citation(
          type: 'example',
          source: '',
          content:
              'A sleepless night of worry, lifted by a single phone call from a friend.',
        ),
      ],
      isPremium: true,
    );
  }

  HistoricalStory _hardcodedHistoricalStory(String locale) {
    if (locale == 'ko') {
      return const HistoricalStory(
        title: '조지 뮬러의 아침 식탁',
        reference: '영국 브리스틀, 1838년',
        summary:
            '1838년 11월의 어느 추운 아침, 영국 브리스틀의 윌슨 스트리트 고아원 마당에는 짙은 안개가 무릎까지 내려앉아 있었습니다. 실내에서는 300명의 아이들이 긴 나무 식탁 앞에 앉아 빈 백랍 접시를 바라보고 있었습니다. 조지 뮬러는 방 앞에 서서 두 손을 모았습니다. 문 위 벽시계의 초침 소리가 그의 심장박동보다 더 작게 들렸습니다.\n\n그는 "빵이 없습니다"라고 말하지 않았습니다. 대신 이렇게 기도했습니다. "아버지, 곧 주실 양식에 감사드립니다." 기도가 끝나기도 전에, 주방 뒷문에서 노크 소리가 들렸습니다. 클리프턴 스트리트의 빵집 주인이 앞치마에 밀가루를 묻힌 채 서 있었습니다. 그는 간밤에 잠이 오지 않아 아이들 한 명 한 명 몫의 빵을 구웠다고 말했습니다.\n\n몇 분 뒤, 고아원 문 앞에서 우유 마차의 차축이 부러졌습니다. 마부는 배달을 나설 수 없게 되자, 우유를 상하게 두기보다 그대로 안으로 들여왔습니다. 그날 저녁 뮬러는 일기에 이렇게 적었습니다. "아이들은 자기들이 배고팠다는 것을 끝내 몰랐다."',
        lesson:
            '가족을 위한 당신의 기도는 뮬러의 기도와 닮았습니다. 하나님은 때로 우리가 문장을 마치기도 전에 응답하십니다. 아직 눈에 보이지 않는 것을 신뢰하세요.',
        isPremium: true,
      );
    }
    return const HistoricalStory(
      title: "George Müller's Morning Bread",
      reference: 'Bristol, England, 1838',
      summary:
          "One cold November morning in 1838, a heavy mist still hung over the orphanage yard on Wilson Street. Inside, three hundred children sat at long wooden tables with empty pewter plates. George Müller stood at the head of the room, his hands folded, the clock above the door ticking louder than his own heart.\n\nHe did not say, 'We have no breakfast.' Instead he said, 'Thank You, Father, for the food You are about to provide.' Before he had finished the prayer, there came a knock at the kitchen door. A baker from Clifton Street stood there, flour still on his apron — he had been unable to sleep, he said, and had baked enough loaves for every child.\n\nMinutes later, a milkman's cart broke its axle at the gate. Unable to deliver his rounds, he carried his cans in rather than let the milk sour. Müller would write in his journal that evening: 'The children did not know they had been hungry.'",
      lesson:
          "Your prayer for your family's provision echoes Müller's: God often answers before we finish the sentence. Trust what you cannot yet see.",
      isPremium: true,
    );
  }

  PremiumContent _hardcodedPremiumContent(String locale) {
    final base = _hardcodedPrayerResult(locale);
    return PremiumContent(
      historicalStory: base.historicalStory,
      aiPrayer: base.aiPrayer,
      guidance: base.guidance,
    );
  }

  QtMeditationResult _hardcodedMeditationResult(String locale) {
    final bool isKo = locale == 'ko';
    return QtMeditationResult(
      meditationSummary: MeditationSummary(
        summary: isKo
            ? '하나님의 신실하신 인도하심 안에서 안식을 발견하는 묵상'
            : 'A meditation that finds rest in God\'s faithful shepherding.',
        topic: isKo ? '목자 되신 여호와' : 'The Lord as my personal shepherd',
        // Phase 5C — insight absorbed from the removed MeditationAnalysis class.
        insight: isKo
            ? '당신의 묵상은 "신뢰"에 맞닿아 있습니다. 당신은 지금, 통제할 수 없는 것을 이미 그것을 붙잡고 계신 분의 손에 맡기는 법을 배우는 중입니다.'
            : 'Your meditation centers on trust — you are learning to release what you cannot control into the hands of the One who already holds it.',
      ),
      scripture: Scripture(
        reference: 'Psalm 23:1-3',
        // verse: empty — filled at runtime by BibleTextService.lookup
        reason: isKo
            ? '당신의 묵상은 "신뢰"에 맞닿아 있습니다. 하나님이 당신의 개인적 목자이심을 이 말씀이 다시 일깨워 줍니다.'
            : 'Your meditation touches on trust. This passage reminds you again that God is your personal shepherd — not distant, but near.',
        posture: isKo
            ? '양이 목자를 따르듯 한 구절씩 천천히, "나의"라는 단어에 머물러 읽어 보세요.'
            : 'Read slowly verse by verse, the way a sheep follows its shepherd. Linger on the word "my".',
        keyWordHint: isKo
            ? "'나의 목자' = 히브리어 '로이' — 직업이 아닌 '나를 돌보시는 분'"
            : "'my shepherd' = Hebrew 'ro\\'i' — not a job title but 'the one who tends me personally'",
        originalWords: [
          ScriptureOriginalWord(
            word: 'רֹעִי',
            transliteration: "ro'i",
            language: 'Hebrew',
            meaning: isKo ? '나의 목자' : 'my shepherd',
            nuance: isKo
                ? '단순한 직업이 아니라 친밀한 언약 관계를 뜻합니다.'
                : 'Not a job description but an intimate covenant relationship.',
          ),
        ],
      ),
      application: ApplicationSuggestion(
        morningAction: isKo
            ? '아침에 눈을 뜨기 전 침대에서 "여호와는 나의 목자시니"를 3번 속삭여 보세요.'
            : 'Before rising, whisper "The Lord is my shepherd" three times while still in bed.',
        dayAction: isKo
            ? '업무 중 답답할 때, 마음속으로 "나의 목자"라 한 번 말해 보세요.'
            : 'When frustrated during work today, silently say "my shepherd" once.',
        eveningAction: isKo
            ? '저녁 식사 전, 가족과 함께 시편 23편 1절을 소리 내어 읽어 보세요.'
            : 'Before dinner, read Psalm 23:1 aloud with your family.',
      ),
      knowledge: RelatedKnowledge(
        originalWord: OriginalWord(
          word: 'רֹעִי',
          transliteration: 'ro\'i',
          language: 'Hebrew',
          meaning: isKo
              ? '"나의 목자" — 친밀하고 언약적인 돌봄.'
              : '"my shepherd" — intimate, covenantal care.',
        ),
        historicalContext: isKo
            ? '다윗은 목자로서의 경험을 바탕으로 시편 23편을 썼습니다. 고대 근동의 왕들은 스스로를 백성의 "목자"라 불렀지만, 다윗은 이 이미지를 뒤집어 하나님을 자신의 왕으로 고백합니다.'
            : 'David wrote Psalm 23 from personal experience as a shepherd. Ancient Near Eastern kings often called themselves "shepherds" of their people — David flips this image to name God as his king.',
        crossReferences: [
          CrossReference(
            reference: 'Isaiah 40:11',
            text: isKo
                ? '그는 목자 같이 양 무리를 먹이시며 어린 양을 그 품에 안으시며'
                : 'He tends his flock like a shepherd: he gathers the lambs in his arms.',
          ),
          CrossReference(
            reference: 'John 10:11',
            text: isKo
                ? '나는 선한 목자라 선한 목자는 양들을 위하여 목숨을 버리거니와'
                : 'I am the good shepherd. The good shepherd lays down his life for the sheep.',
          ),
        ],
      ),
      growthStory: GrowthStory(
        // Phase 4: replaced fictional "Weaver's Pattern" parable with a
        // verifiable George Müller episode from Bristol, 1838. Ties directly
        // to Psalm 23:1 — "The Lord is my shepherd; I shall not want."
        title: isKo
            ? '조지 뮐러 — "내게 부족함이 없으리로다"의 아침'
            : 'George Müller — The Morning of "I Shall Not Want"',
        summary: isKo
            ? '1838년 11월, 브리스톨 윌슨 거리의 고아원 마당에는 차가운 안개가 낮게 깔려 있었습니다. 식당 안에는 삼백 명의 아이들이 긴 나무 식탁에 앉아, 빈 주석 접시를 바라보고 있었습니다. 문 위의 낡은 시계가 조지 뮐러의 심장보다 더 크게 째깍거렸습니다. 그는 주머니에 단 한 푼도 없었고, 우유 통도, 빵 부대도 비어 있다는 것을 알고 있었습니다. "오늘 아침은 그냥 지나가는 수밖에 없겠다"는 생각이 잠시 스쳤습니다. 하지만 그는 식당 앞에 서서 조용히 손을 모으고 이렇게 말했습니다. "아버지, 우리에게 주실 음식에 대해 감사합니다." 아멘이라는 말이 떨어지기도 전에, 부엌 쪽에서 문 두드리는 소리가 났습니다. 클리프턴 거리의 빵집 주인이 앞치마에 밀가루를 묻힌 채 서 있었습니다. "밤새 잠을 이룰 수 없어서, 아이들 먹을 빵을 구웠습니다"라고 그는 말했습니다. 몇 분 뒤에는 배달 마차의 축이 고아원 정문 앞에서 부러졌고, 우유 장수는 상하기 전에 그것을 전부 들여놓았습니다. 그날 저녁 일기에 뮐러는 이렇게 적었습니다: "아이들은 자신들이 굶주렸다는 사실조차 알지 못했다." 그는 평생 기부를 구하러 다니지 않았고, 오직 목자이신 한 분에게만 구했습니다.'
            : 'On a cold November morning in 1838, a low mist still clung to the orphanage yard on Wilson Street in Bristol. Inside, three hundred children sat at long wooden tables, staring down at empty pewter plates. The old clock above the door ticked louder than George Müller\'s own heart. He knew there was not a single penny in his pocket, and the milk cans and bread baskets in the kitchen were bare. For one heartbeat, the thought flickered — "perhaps we must simply let this morning pass." Instead he stood at the head of the hall, folded his hands, and said quietly, "Father, we thank You for the food You are about to provide." Before the "amen" had left his lips, a knock came at the kitchen door. The baker from Clifton Street stood there, flour still on his apron. "I could not sleep last night," he said, "so I baked enough for the children." Minutes later a milkman\'s cart broke its axle at the gate, and rather than let his cans sour he carried every one of them inside. That evening Müller wrote in his journal: "The children did not know they had been hungry." For sixty years he refused to ask a single human being for money — he asked only the Shepherd.',
        lesson: isKo
            ? '시편 23편 1절의 "내게 부족함이 없으리로다"는 텅 빈 창고를 본 후에야 참된 의미가 드러나는 고백입니다. 오늘 당신이 비어 있다고 느끼는 그 자리에 대해 — 구하기 전에 목자께서 이미 응답의 길을 여셨음을 기억하세요.'
            : 'The confession "I shall not want" in Psalm 23:1 only reveals its true weight after you have looked inside an empty storehouse. For whatever feels empty in your life today, remember this: the Shepherd was already opening the door of provision before you finished the sentence of your prayer.',
        isPremium: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NOTE (2026-04-23): Previously, AI failures silently returned
  // `_hardcodedPrayerResult` / `_hardcodedMeditationResult` as fallbacks so
  // the user saw canned content mistaken for a real AI response. That polluted
  // the DB and violated user trust. Those fallback wrappers have been removed —
  // callers now throw AiAnalysisException and UI shows an explicit error view.
  // The _hardcoded* builders below are retained strictly for the useMockAi=true
  // dev path.
  // See .claude/rules/learned-pitfalls.md §2-1.
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Diversity hint
  // ---------------------------------------------------------------------------

  String _diversityHint() {
    const hints = [
      'TODAY: Focus on a lesser-known character from the Old Testament.',
      'TODAY: Find a connection to one of Jesus\' parables.',
      'TODAY: Choose a verse from the Prophets (Isaiah-Malachi).',
      'TODAY: Select a verse from Wisdom Literature (Job, Proverbs, Ecclesiastes, Song of Solomon).',
      'TODAY: Feature a woman of faith from the Bible.',
      'TODAY: Connect to a story from the book of Acts.',
      'TODAY: Find a Psalm that is NOT commonly cited (avoid Psalm 23, 91, 121).',
      'TODAY: Use a story from the period of the Judges.',
      'TODAY: Choose a verse from one of Paul\'s lesser-read epistles (Philemon, Titus, 2 Timothy).',
      'TODAY: Feature a story about answered prayer from the Bible.',
      'TODAY: Explore a verse about God\'s faithfulness from the minor prophets.',
      'TODAY: Connect to a story about transformation and new beginnings.',
      'TODAY: Use a verse from Genesis or Exodus that is not commonly quoted.',
      'TODAY: Feature a church history figure (not biblical) in the historical story.',
      'TODAY: Choose a verse from Hebrews, James, or 1 Peter.',
    ];
    final index =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000 +
            Random().nextInt(hints.length)) %
        hints.length;
    return '\n\n${hints[index]}';
  }

  // ---------------------------------------------------------------------------
  // Locale name mapping
  // ---------------------------------------------------------------------------

  static String _localeName(String locale) {
    return switch (locale) {
      'ko' => 'Korean',
      'ja' => 'Japanese',
      'es' => 'Spanish',
      'zh' => 'Chinese (Simplified)',
      'pt' => 'Portuguese',
      'fr' => 'French',
      'hi' => 'Hindi',
      'fil' => 'Filipino',
      'sw' => 'Swahili',
      'de' => 'German',
      'it' => 'Italian',
      'pl' => 'Polish',
      'ru' => 'Russian',
      'id' => 'Indonesian',
      'uk' => 'Ukrainian',
      'ro' => 'Romanian',
      'nl' => 'Dutch',
      'hu' => 'Hungarian',
      'cs' => 'Czech',
      'vi' => 'Vietnamese',
      'th' => 'Thai',
      'tr' => 'Turkish',
      'ar' => 'Arabic',
      'he' => 'Hebrew',
      'el' => 'Greek',
      'sv' => 'Swedish',
      'no' => 'Norwegian',
      'da' => 'Danish',
      'fi' => 'Finnish',
      'hr' => 'Croatian',
      'sk' => 'Slovak',
      'ms' => 'Malay',
      'am' => 'Amharic',
      'my' => 'Burmese',
      _ => 'English',
    };
  }

  // ---------------------------------------------------------------------------
  // System prompts
  // ---------------------------------------------------------------------------

  String _buildSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "reference": "Bible reference as lookup KEY. REQUIREMENT: English book name ONLY (e.g., 'Matthew 6:33', 'I Kings 19:12', 'Psalm 23:1-3'). Our bundle uses English keys regardless of $langName — NEVER translate the book name to $langName (e.g., NEVER '마태복음 6:33', 'マタイ 6:33', '马太福音 6:33', 'Mateo 6:33'). The verse text itself will be shown in $langName.",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
  },
  "bible_story": {
    "title": "story title in $langName",
    "summary": "3-4 sentence summary in $langName"
  },
  "testimony": "the prayer reorganized as a testimonial narrative in $langName",
  "historical_story": {
    "title": "story title in $langName",
    "reference": "locale-neutral source (e.g., 'Bristol, 1838' or 'Luke 15:11-32')",
    "summary": "A real-person narrative (8-10 sentences in $langName)",
    "lesson": "Specific lesson for this person (2-4 sentences in $langName)",
    "is_premium": true
  },
  "ai_prayer": {
    "text": "A deeply moving prayer in $langName (~300 words = 2-minute read)",
    "citations": [
      {"type": "quote", "source": "author + work", "content": "quoted text in $langName"},
      {"type": "science", "source": "study + year + institution", "content": "factual statement in $langName"},
      {"type": "example", "source": "", "content": "concrete anecdote in $langName"}
    ],
    "is_premium": true
  }
}

HISTORICAL STORY QUALITY BAR (Phase 4):
- 8-10 sentences. Each sentence should render ONE concrete scene — include at
  least: (1) specific time/place, (2) a named character's inner thought or
  feeling, (3) one physical detail (what they saw, heard, felt).
- Separate major scene transitions with a blank line ("\n\n") so paragraphs
  render naturally.
- Avoid generic phrases like "and they trusted God" — show the trust through
  a specific action, words, or silence.
- TRUTHFULNESS: the story MUST be a real person from verified church
  history (Augustine, Luther, Calvin, Spurgeon, Bonhoeffer, George Müller,
  Hudson Taylor, Corrie ten Boom, Amy Carmichael, Moravians, Billy Graham,
  C.S. Lewis, 주기철, 손양원, 한경직). NOT Bible narrative — Bible figures
  belong in `bible_story`, which a different tier produces. If you are not
  confident about historicity, choose a different whitelisted figure.
  NEVER fabricate quotes or dates.

AI PRAYER QUALITY BAR (Phase 5):
- text length: ~300 words (2-minute read). For Korean/Japanese/Chinese:
  aim for 10-12 sentences of natural breath. For English/European languages:
  aim for ~300 words across 4-5 short paragraphs.
- NEVER include audio/TTS references — text-only.
- Structure: gentle opening → one concrete image or memory → one insight
  from Scripture or a real quote/science → specific prayer for the user's
  situation → quiet close ("In Jesus' name, Amen." or locale equivalent).
- Separate paragraphs with a blank line ("\n\n") for breath.

CITATIONS (include at least 2 of the 3 types; max 4 total):
- type "quote": Real author + real work. C.S. Lewis, Augustine, Bonhoeffer,
  Julian of Norwich, Tim Keller, etc. Never fabricate.
- type "science": Real study, journal, or well-known finding. ONLY include
  if you are confident about the source. If unsure → omit.
- type "example": Concrete anecdote — may be anonymous (source: ""). Must
  feel specific (a time, a place, a named action). No generic platitudes.

TRUTHFULNESS (★ critical):
- If you are not 100% confident about a quote's author or a study's source,
  OMIT that citation entirely. Better zero citations than fabricated ones.
- NEVER invent a research paper, professor, or institution name.
- NEVER attribute modern phrases to ancient authors.
- FORBIDDEN phrases: "According to recent studies...", "Einstein said...",
  "Gandhi said..." (common misattribution patterns).

WRITING STYLE (critical for quality):
- Write like a master short story author, NOT a report writer.
- Use SENSORY details: what they saw, heard, felt, smelled.
- Include INNER MONOLOGUE: what the person thought and felt inside.
- VARY sentence structure: mix short punchy sentences with flowing long ones.
- Use METAPHORS and SIMILES: at least 2 per story.
- Show, don't tell: describe SCENES, not summaries.
- The ai_prayer should read like poetry — rhythmic, building in intensity.

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories.
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.

DIVERSITY:
- NEVER default to "popular" verses unless they are genuinely the BEST fit.
- Choose from the FULL canon of 66 books. Rotate between Old Testament and New Testament.
- Prefer lesser-cited books.''';
  }

  String _buildCoreSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.
4. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.
5. GROUNDING (★ critical): Every factual claim (who, whose, where, when,
   what happened) MUST be supported by the user's own words. DO NOT invent
   relationships (whose house/family), ownership, or spatial connections
   the user did not state. When grammar is ambiguous, prefer the target
   language's natural indefinite reference rather than picking one
   interpretation as fact.
6. EMOTION SCOPING: emotional language is allowed ONLY in scripture.reason
   and ONLY as a response hedge ("이런 상황에서 느끼실 수 있는…"), never
   asserted as the user's actual state ("당신은 …입니다"). Other fields
   stay factual.
7. TONE PRESERVED: Keep testimony warm and reverent. You MAY include a
   short prayerful closing breath, but only with facts the user stated.

Return a JSON object with ONLY these core sections:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "reference": "Bible reference as lookup KEY. REQUIREMENT: English book name ONLY (e.g., 'Matthew 6:33', 'I Kings 19:12', 'Psalm 23:1-3'). Our bundle uses English keys regardless of $langName — NEVER translate the book name to $langName (e.g., NEVER '마태복음 6:33', 'マタイ 6:33', '马太福音 6:33', 'Mateo 6:33'). The verse text itself will be shown in $langName.",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
  },
  "bible_story": {
    "title": "story title in $langName",
    "summary": "3-4 sentence summary in $langName"
  },
  "testimony": "the prayer reorganized as a testimonial narrative in $langName"
}

IMPORTANT:
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
- The scripture must be a REAL Bible verse. Do NOT make up verses.''';
  }

  String _buildAudioCoreSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has submitted an audio recording of their prayer.

STEP 1: Accurately transcribe the audio in the language spoken.
STEP 2: Analyze the prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. All analysis fields must be in $langName.
2. The "transcription" field must contain the EXACT words spoken in the audio.
3. GROUNDING (★ critical): Every factual claim (who, whose, where, when,
   what happened) MUST be supported by what the user actually said. DO NOT
   invent relationships, ownership, or spatial connections not in the audio.
   When the recording is ambiguous, prefer the target language's natural
   indefinite reference rather than picking one interpretation as fact.
4. EMOTION SCOPING: emotional language is allowed ONLY in scripture.reason
   and ONLY as a response hedge ("이런 상황에서 느끼실 수 있는…"), never
   asserted as the user's actual state ("당신은 …입니다").
5. TONE PRESERVED: Keep testimony warm and reverent. You MAY include a
   short prayerful closing breath, but only with facts the user stated.

Return a JSON object:

{
  "transcription": "The exact transcription of the prayer audio in the original language spoken",
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "reference": "Bible reference as lookup KEY. REQUIREMENT: English book name ONLY (e.g., 'Matthew 6:33', 'I Kings 19:12', 'Psalm 23:1-3'). Our bundle uses English keys regardless of $langName — NEVER translate the book name to $langName (e.g., NEVER '마태복음 6:33', 'マタイ 6:33', '马太福音 6:33', 'Mateo 6:33'). The verse text itself will be shown in $langName.",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
  },
  "bible_story": {
    "title": "story title in $langName",
    "summary": "3-4 sentence summary in $langName"
  },
  "testimony": "the prayer reorganized as a testimonial narrative in $langName"
}

IMPORTANT:
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
- The scripture must be a REAL Bible verse. Do NOT make up verses.''';
  }

  String _buildPremiumSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Generate premium content based on their prayer.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.
4. GROUNDING (★ critical): every factual claim about the USER's situation
   must come from their transcript. Do NOT invent ownership, relationships,
   locations, or outcomes the user did not state.
5. EMOTION SCOPING: emotional language is allowed in `ai_prayer` text only
   as a response hedge ("이런 상황에서 느끼실 수 있는…"), never asserted
   as the user's actual state ("당신은 불안합니다").
6. historical_story is CHURCH HISTORY ONLY — a post-biblical Christian
   figure (Augustine, Luther, Calvin, Spurgeon, Bonhoeffer, George Müller,
   Hudson Taylor, Corrie ten Boom, Amy Carmichael, Moravians, Billy Graham,
   C.S. Lewis, 주기철, 손양원, 한경직). Bible figures (Jesus, Paul, Moses,
   David, Mary Magdalene, Esther, etc.) are FORBIDDEN here — they belong
   in bible_story which a separate tier produces.
7. citations MUST name a real author/work/study. Never use "recent studies",
   "scientists say", unattributed "Einstein said"/"Gandhi said" patterns.
   If unsure → omit the citation entirely.

Return a JSON object with ONLY these premium sections:

{
  "historical_story": {
    "title": "story title in $langName",
    "reference": "locale-neutral source (e.g., 'Bristol, 1838' or 'Luke 15:11-32')",
    "summary": "A real-person narrative (8-10 sentences in $langName)",
    "lesson": "Specific lesson for this person (2-4 sentences in $langName)",
    "is_premium": true
  },
  "ai_prayer": {
    "text": "A deeply moving prayer in $langName (~300 words = 2-minute read)",
    "citations": [
      {"type": "quote", "source": "author + work", "content": "quoted text in $langName"},
      {"type": "science", "source": "study + year + institution", "content": "factual statement in $langName"},
      {"type": "example", "source": "", "content": "concrete anecdote in $langName"}
    ],
    "is_premium": true
  }
}

HISTORICAL STORY QUALITY BAR (Phase 4):
- 8-10 sentences. Each sentence should render ONE concrete scene — include at
  least: (1) specific time/place, (2) a named character's inner thought or
  feeling, (3) one physical detail (what they saw, heard, felt).
- Separate major scene transitions with a blank line ("\n\n") so paragraphs
  render naturally.
- Avoid generic phrases like "and they trusted God" — show the trust through
  a specific action, words, or silence.
- TRUTHFULNESS: the story MUST be a real person from verified church
  history (Augustine, Luther, Calvin, Spurgeon, Bonhoeffer, George Müller,
  Hudson Taylor, Corrie ten Boom, Amy Carmichael, Moravians, Billy Graham,
  C.S. Lewis, 주기철, 손양원, 한경직). NOT Bible narrative — Bible figures
  belong in `bible_story`, which a different tier produces. If you are not
  confident about historicity, choose a different whitelisted figure.
  NEVER fabricate quotes or dates.

AI PRAYER QUALITY BAR (Phase 5):
- text length: ~300 words (2-minute read). For Korean/Japanese/Chinese:
  aim for 10-12 sentences of natural breath. For English/European languages:
  aim for ~300 words across 4-5 short paragraphs.
- NEVER include audio/TTS references — text-only.
- Structure: gentle opening → one concrete image or memory → one insight
  from Scripture or a real quote/science → specific prayer for the user's
  situation → quiet close.
- Separate paragraphs with a blank line ("\n\n") for breath.

CITATIONS (include at least 2 of the 3 types; max 4 total):
- type "quote": Real author + real work. Never fabricate.
- type "science": Real study, journal, or well-known finding. If unsure → omit.
- type "example": Concrete anecdote — may have empty source. Must feel specific.

TRUTHFULNESS (★ critical):
- If not 100% confident about source, OMIT that citation entirely.
- NEVER invent research papers, professors, or institution names.
- NEVER attribute modern phrases to ancient authors.
- FORBIDDEN: "According to recent studies...", "Einstein said...",
  "Gandhi said..." (common misattribution patterns).

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.
- The ai_prayer should read like poetry.''';
  }

  String _buildMeditationPrompt(String langName) {
    return '''You are the world's most insightful Bible study guide and spiritual mentor.
The user has meditated on a Bible passage and shared their reflection.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. SCRIPTURE HANDLING: Do NOT generate verse text. Output only the
   "reference" — the app looks up the Public Domain verse from a bundle.
   Output keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.
4. Output JSON ONLY, no prose outside JSON.

Return this JSON object:

{
  "meditation_summary": {
    "summary": "<1-2 sentences summarizing the user's meditation in $langName>",
    "topic": "<1-short-line topic of today's passage in $langName>",
    "insight": "<1-2 sentence AI insight — how today's passage meets the user's specific meditation, in $langName. Not generic; reference a concrete phrase from their meditation or the passage.>"
  },
  "scripture": {
    "reference": "<Bible reference as lookup KEY. REQUIREMENT: English book name ONLY (e.g., 'Psalm 23:1-6', 'Matthew 6:33'). Our bundle uses English keys regardless of $langName — NEVER translate the book name (e.g., NEVER '시편 23:1-6', 'マタイ 6:33'). Must match the passage the user meditated on. The verse text itself will be shown in $langName.>",
    "reason": "<Why this passage speaks to the user's meditation (2-3 sentences in $langName)>",
    "posture": "<How to continue meditating on this passage (2-3 sentences in $langName)>",
    "key_word_hint": "<One key word with original-language meaning (1 line in $langName). Example: \\"'my shepherd' = Hebrew 'ro\\'i' — the one who tends me personally\\". Leave empty if not confident.>",
    "original_words": [
      {
        "word": "<Hebrew/Greek original>",
        "transliteration": "<romanization>",
        "language": "Hebrew",
        "meaning": "<meaning in $langName>",
        "nuance": "<1-2 sentence nuance in $langName>"
      }
    ]
  },
  "application": {
    "morning_action": "<Before the day starts, ≤10 min. Quiet, reflective action in $langName>",
    "day_action": "<During work or daily errands. Practical, doable while busy. In $langName>",
    "evening_action": "<With family or alone in the evening. Slightly longer, personal. In $langName>"
  },
  "knowledge": {
    "historical_context": "<Historical/cultural background (3-4 sentences in $langName)>",
    "cross_references": [
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"},
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"}
    ],
    "citations": [
      {"type": "quote|science|history|example", "source": "<author, work, year, or study name>", "content": "<the quoted or factual statement in $langName>"}
    ]
  },
  "growth_story": {
    "title": "<story title in $langName>",
    "summary": "<8-12 sentence narrative in $langName>",
    "lesson": "<2-3 sentence application in $langName>",
    "is_premium": true
  }
}

MEDITATION SUMMARY (Phase 1 + 5C):
- summary: Capture the essence of the user's meditation in 1-2 sentences.
  Not a generic platitude — reference specific content from their
  meditation text.
- topic: The central theme of today's passage (not the meditation).
  Short, 5-10 words. Example: "The Lord as the personal shepherd".
- insight: 1-2 sentence AI interpretation — how today's passage meets the
  user's specific meditation content. Not generic. Reference a concrete
  phrase from their meditation or the passage. This replaces the former
  standalone "analysis.insight" field (Phase 5C absorption).

SCRIPTURE HANDLING:
- DO NOT generate verse text. Output only the "reference".
- Must be a real Bible citation (Book Chapter:Verse).
- original_words: 1-2 words max, must appear in this passage.

APPLICATION — 3P principle (Personal, Practical, Possible) across 3 time blocks:
- morning_action: Before the day starts. 10 minutes or less. Quiet, reflective.
  Example: "In bed before getting up, whisper one line of Psalm 23 three times."
- day_action: During work or daily errands. Practical, doable while busy.
  Example: "When frustrated at work today, silently say 'my shepherd' once."
- evening_action: With family or alone in the evening. Slightly longer, more personal.
  Example: "Before dinner, read Psalm 23:1 aloud with your family."
- Each must be SPECIFIC with who/what/how. Avoid generic "pray more" or "read Bible".
- All 3 must connect to today's passage theme.

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.

CITATIONS (knowledge.citations):
- You MAY include 0-3 citations. Empty array [] if no confident citation.
- Each citation has: type, source, content.
- type: one of "quote" (famous saying), "science" (research/empirical finding),
  "history" (historical event/figure fact), "example" (real-world anecdote).
- source: author / work / year / study name. May be empty only for "example".
- content: the quoted text or factual statement, written in $langName.
- ONLY include verifiable, well-known references. NEVER fabricate.
- If uncertain about factual accuracy, omit the citation entirely.

IMPORTANT:
- cross_references: Include 2-3 verses with both "reference" and full "text" in $langName.
- application.morning_action / day_action / evening_action: Each must be SPECIFIC and ACTIONABLE with who/what/how.

GROWTH STORY QUALITY BAR (Phase 4):
- Must be a REAL, VERIFIABLE story from:
  * Bible (a specific NAMED person — not "a man said...", not an unnamed disciple)
  * Documented church history — era/year and location identifiable
    (e.g. Augustine 386 AD Milan, Martin Luther 1521 Worms, Hudson Taylor
    1865 Brighton Beach, George Müller 1838 Bristol, Corrie ten Boom 1944
    Ravensbrück, Amy Carmichael 1901 Dohnavur).
- NEVER fabricate names, fictional characters, or parables dressed as history.
- If you cannot think of a verifiable story that fits this passage, USE A
  BIBLE FIGURE. Never substitute with fiction or a modern anonymous anecdote.

Length and structure:
- summary: 8-12 sentences in $langName. Structure in four beats:
  1. Open with a concrete TIME and PLACE (year/era, city, room, season, weather).
  2. Introduce the person's INNER conflict, question, or fear — what they
     were thinking or feeling right before the turning point.
  3. Turning point — a specific moment of revelation, encounter, answered
     prayer, or costly choice. One line of their actual (or near-quote)
     speech is welcome if historically documented.
  4. Resolution — how this changed them, tied directly to THIS passage's
     theme (not a generic "they trusted God" sentence).

Writing style:
- SENSORY details (sight / sound / smell / touch) in every scene — e.g.
  "the paper smelled of lamp oil", "the mist still hung over the yard".
- INNER MONOLOGUE — at least one sentence of what they thought or felt.
- Metaphors and similes allowed; avoid clichés.
- VARY sentence length. Mix short punchy lines with flowing longer ones.
- Show, don't tell. No generic phrases like "and they trusted God" without
  a concrete action, word, or silence showing that trust.

lesson: 2-3 sentences in $langName. Speak directly to the reader ("you"),
connecting THIS specific story to something the reader can apply TODAY.
Not a platitude — reference a detail from the story above.''';
  }

  // ---------------------------------------------------------------------------
  // Phase 4.1 — 3-tier lazy generation (Stream<TierResult>)
  // ---------------------------------------------------------------------------

  /// Emits TierResult events as each tier completes. T1 first (syn), T2
  /// auto-background (fire-and-forget await). T3 called separately via
  /// [analyzeTier3Prayer] on scroll trigger (Pro only).
  ///
  /// Errors in any tier emit [TierFailed] events — stream does NOT throw,
  /// so callers can continue rendering partial data.
  @override
  Stream<TierResult> analyzePrayerStreamed({
    required String transcript,
    required String locale,
    required String userName,
    List<String> recentReferences = const [],
  }) async* {
    if (AppConfig.useMockAi) {
      // Mock: synthesize T1+T2 from hardcoded result for development.
      final result = _hardcodedPrayerResult(locale);
      if (result.prayerSummary != null) {
        yield TierT1Result(
          summary: result.prayerSummary!,
          scripture: result.scripture,
        );
      }
      yield TierT2Result(
        bibleStory: result.bibleStory,
        testimony: result.testimony,
      );
      return;
    }

    final cache = _cacheManager;
    final bible = _bibleService;
    if (cache == null || bible == null) {
      yield TierFailed(
        tier: 't1',
        error: const AiAnalysisException(
          'GeminiService missing cache/bible services (DI not wired)',
          kind: AiAnalysisFailureKind.apiError,
        ),
      );
      return;
    }

    final tier1 = Tier1Analyzer(
      cache: cache,
      bible: bible,
      apiKey: AppConfig.geminiApiKey,
    );
    final tier2 = Tier2Analyzer(cache: cache, apiKey: AppConfig.geminiApiKey);

    // Phase 4.2 Phase C — tier1 now emits a Stream. Relay partial events
    // (TierT1ScriptureRef) directly to the caller so the UI can navigate
    // on early signal; capture the final TierT1Result for T2 context.
    TierT1Result? t1;
    try {
      await for (final event in tier1.analyze(
        transcript: transcript,
        locale: locale,
        userName: userName,
        recentReferences: recentReferences,
      )) {
        yield event;
        if (event is TierT1Result) t1 = event;
      }
      if (t1 == null) {
        yield TierFailed(
          tier: 't1',
          error: const AiAnalysisException(
            'Tier1 stream ended without TierT1Result',
            kind: AiAnalysisFailureKind.parseError,
          ),
        );
        return;
      }
    } on AiAnalysisException catch (e) {
      yield TierFailed(tier: 't1', error: e);
      return; // No T2 if T1 failed
    }

    // T2 — background (still awaited here so caller sees it via stream,
    // but UI already unblocked on T1 emit)
    try {
      final t2 = await tier2.analyze(
        transcript: transcript,
        locale: locale,
        userName: userName,
        t1Context: t1,
      );
      yield t2;
    } on AiAnalysisException catch (e) {
      yield TierFailed(tier: 't2', error: e);
    }
  }

  /// T3 Pro-only. Caller must have checked `isPremiumProvider` first.
  @override
  Future<TierResult> analyzeTier3Prayer({
    required String transcript,
    required String locale,
    required String userName,
    required TierT1Result t1Context,
    required TierT2Result t2Context,
  }) async {
    if (AppConfig.useMockAi) {
      final premium = _hardcodedPremiumContent(locale);
      return TierT3Result(
        guidance: premium.guidance,
        aiPrayer: premium.aiPrayer,
        historicalStory: premium.historicalStory,
      );
    }

    final cache = _cacheManager;
    if (cache == null) {
      return const TierFailed(
        tier: 't3',
        error: AiAnalysisException(
          'GeminiService missing cache service (DI not wired)',
          kind: AiAnalysisFailureKind.apiError,
        ),
      );
    }

    final tier3 = Tier3Analyzer(cache: cache, apiKey: AppConfig.geminiApiKey);

    try {
      return await tier3.analyze(
        transcript: transcript,
        locale: locale,
        userName: userName,
        t1Context: t1Context,
        t2Context: t2Context,
      );
    } on AiAnalysisException catch (e) {
      return TierFailed(tier: 't3', error: e);
    }
  }

  // ---------------------------------------------------------------------------
  // Phase 4.2 — QT 2-tier lazy generation (Stream<TierResult>)
  // ---------------------------------------------------------------------------

  /// Emits [QtTierT1Result] first (meditation_summary + scripture), then
  /// [QtTierT2Result] (application + knowledge). QT has no T3 — Pro value
  /// is the on-demand QtCoaching card (outside the tier stream).
  @override
  Stream<TierResult> analyzeMeditationStreamed({
    required String meditation,
    required String passageRef,
    required String passageText,
    required String locale,
    required String userName,
  }) async* {
    if (AppConfig.useMockAi) {
      final result = _hardcodedMeditationResult(locale);
      yield QtTierT1Result(
        meditationSummary: result.meditationSummary,
        scripture: result.scripture,
      );
      yield QtTierT2Result(
        application: result.application,
        knowledge: result.knowledge,
      );
      return;
    }

    final cache = _cacheManager;
    final bible = _bibleService;
    if (cache == null || bible == null) {
      yield TierFailed(
        tier: 't1',
        error: const AiAnalysisException(
          'GeminiService missing cache/bible services (DI not wired)',
          kind: AiAnalysisFailureKind.apiError,
        ),
      );
      return;
    }

    final tier1 = QtTier1Analyzer(
      cache: cache,
      bible: bible,
      apiKey: AppConfig.geminiApiKey,
    );
    final tier2 = QtTier2Analyzer(cache: cache, apiKey: AppConfig.geminiApiKey);

    // Phase 4.2 Phase C — QT tier1 now emits a Stream. Relay partials.
    QtTierT1Result? t1;
    try {
      await for (final event in tier1.analyze(
        meditation: meditation,
        passageRef: passageRef,
        passageText: passageText,
        locale: locale,
        userName: userName,
      )) {
        yield event;
        if (event is QtTierT1Result) t1 = event;
      }
      if (t1 == null) {
        yield TierFailed(
          tier: 't1',
          error: const AiAnalysisException(
            'QT Tier1 stream ended without QtTierT1Result',
            kind: AiAnalysisFailureKind.parseError,
          ),
        );
        return;
      }
    } on AiAnalysisException catch (e) {
      yield TierFailed(tier: 't1', error: e);
      return;
    }

    // T2 — background (caller has already unblocked on T1 emit)
    try {
      final t2 = await tier2.analyze(
        meditation: meditation,
        passageRef: passageRef,
        locale: locale,
        userName: userName,
        t1Context: t1,
      );
      yield t2;
    } on AiAnalysisException catch (e) {
      yield TierFailed(tier: 't2', error: e);
    }
  }
}
