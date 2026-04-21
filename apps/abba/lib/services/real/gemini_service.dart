import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:app_lib_logging/logging.dart';

import '../../config/app_config.dart';
import '../../models/prayer.dart';
import '../../models/qt_meditation_result.dart';
import '../ai_service.dart';

// Toggle: when true, skip Gemini API calls and return the hardcoded values
// defined in `_hardcoded*` builders below. Flip to false to use real API.
const bool _useHardcodedResponse = true;

const String _hardcodedTranscription =
    '주님, 오늘도 새로운 아침을 허락해 주셔서 감사합니다. 가족의 건강과 평안을 지켜 주시고, '
    '오늘 하루 주님의 뜻을 따라 살아가게 하소서. 염려하는 친구를 위로하여 주시고, '
    '주님의 사랑 안에서 모두가 평안하기를 간구합니다. 예수님의 이름으로 기도드립니다. 아멘.';

class GeminiService implements AiService {
  /// Cached prayer guide markdown — loaded once from bundle, reused across calls.
  String? _prayerGuideCache;

  Future<String> _loadPrayerGuide() async {
    final cached = _prayerGuideCache;
    if (cached != null) return cached;
    final doc = await rootBundle.loadString('assets/docs/prayer_guide.md');
    _prayerGuideCache = doc;
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
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayer bypassed (hardcoded)');
      return _hardcodedPrayerResult();
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
      return _parsePrayerJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini prayer analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayerCore bypassed (hardcoded)');
      return _hardcodedPrayerResult();
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
      return _parsePrayerJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini core analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
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
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayerFromAudio bypassed (hardcoded)');
      return (
        result: _hardcodedPrayerResult(),
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
          TextPart('This is a prayer audio recording. Transcribe and analyze it.'),
        ]),
      ]);

      final json = _parseJsonFromResponse(response.text);
      final transcription = json['transcription'] as String? ?? '';
      final result = PrayerResult.fromJson(json);
      return (result: result, transcription: transcription);
    } catch (e, stackTrace) {
      apiLog.error('Gemini audio analysis failed', error: e, stackTrace: stackTrace);
      return (result: _fallbackPrayerResult(), transcription: '');
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
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayerPremium bypassed (hardcoded)');
      return _hardcodedPremiumContent();
    }
    final langName = _localeName(locale);
    apiLog.info('Gemini premium analysis started');

    try {
      final model = _createModel(
        systemPrompt: _buildPremiumSystemPrompt(langName) + _diversityHint(),
      );
      final response = await model.generateContent([
        Content('user', [TextPart(transcript)]),
      ]);
      return _parsePremiumJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini premium analysis failed', error: e, stackTrace: stackTrace);
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
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzeMeditation bypassed (hardcoded)');
      return _hardcodedMeditationResult();
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
      return _parseMeditationJson(response.text);
    } catch (e, stackTrace) {
      apiLog.error('Gemini meditation analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
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
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayerCoaching bypassed (hardcoded)');
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
      return _parseCoachingJson(response.text);
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

  PrayerCoaching _parseCoachingJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
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
    '부족', '못 하', '못하', '잘못',
    'inadequate', 'lacking', 'wrong', 'poor',
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
  // JSON parsing
  // ---------------------------------------------------------------------------

  Map<String, dynamic> _parseJsonFromResponse(String? text) {
    if (text == null || text.isEmpty) throw FormatException('Empty response');
    return jsonDecode(text) as Map<String, dynamic>;
  }

  PrayerResult _parsePrayerJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Prayer JSON parse failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult();
    }
  }

  PremiumContent _parsePremiumJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return PremiumContent(
        historicalStory: data['historical_story'] != null
            ? HistoricalStory.fromJson(data['historical_story'] as Map<String, dynamic>)
            : null,
        aiPrayer: data['ai_prayer'] != null
            ? AiPrayer.fromJson(data['ai_prayer'] as Map<String, dynamic>)
            : null,
        guidance: data['guidance'] != null
            ? Guidance.fromJson(data['guidance'] as Map<String, dynamic>)
            : null,
      );
    } catch (e, stackTrace) {
      apiLog.error('Premium JSON parse failed', error: e, stackTrace: stackTrace);
      return const PremiumContent();
    }
  }

  QtMeditationResult _parseMeditationJson(String? text) {
    try {
      final data = _parseJsonFromResponse(text);
      return QtMeditationResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Meditation JSON parse failed', error: e, stackTrace: stackTrace);
      return _fallbackMeditationResult();
    }
  }

  // ---------------------------------------------------------------------------
  // Hardcoded responses (visible sample data used when _useHardcodedResponse)
  // Also used as graceful fallbacks when API calls fail.
  // ---------------------------------------------------------------------------

  PrayerResult _hardcodedPrayerResult() {
    return PrayerResult(
      prayerSummary: const PrayerSummary(
        gratitude: ['새로운 아침을 허락해 주신 하나님께 감사합니다.'],
        petition: ['오늘 하루 주님의 뜻을 따라 살아가게 하소서.'],
        intercession: ['염려하는 친구를 위로해 주시고 가족의 건강을 지켜 주소서.'],
      ),
      scripture: const Scripture(
        verseEn: 'The LORD is my shepherd; I shall not want.',
        verseKo: '여호와는 나의 목자시니 내게 부족함이 없으리로다',
        reference: 'Psalm 23:1',
        reasonEn:
            'This verse reminds you that the God you prayed to is a shepherd who personally leads and provides for you.',
        reasonKo: '당신이 기도한 하나님은 당신을 인격적으로 인도하시고 채워 주시는 목자이심을 다시 새겨 주는 말씀입니다.',
        postureEn:
            'Read this verse slowly, picturing yourself as a sheep led by a caring shepherd. Linger on the word "my" — this is a personal relationship.',
        postureKo:
            '당신을 부드럽게 인도하시는 목자의 양으로 그려 보며 천천히 읽어 보세요. "나의"라는 단어에 머물러 보세요 — 이것은 개인적인 관계입니다.',
        originalWords: [
          ScriptureOriginalWord(
            word: 'רֹעִי',
            transliteration: "ro'i",
            language: 'Hebrew',
            meaningEn: 'my shepherd',
            meaningKo: '나의 목자',
            nuanceEn:
                "Unlike 'shepherd' as a job, 'ro'i' implies an intimate, personal covenant relationship — 'the one who shepherds me personally'.",
            nuanceKo:
                "단순한 직업으로서의 '목자'와 달리, '로이'는 친밀하고 개인적인 언약 관계를 의미합니다 — '나를 개인적으로 돌보시는 분'.",
          ),
          ScriptureOriginalWord(
            word: 'חָסֵר',
            transliteration: 'chaser',
            language: 'Hebrew',
            meaningEn: 'to lack, be in want',
            meaningKo: '부족하다, 결핍되다',
            nuanceEn:
                'Not merely material lack but covenant completeness — with God as shepherd, nothing essential is missing from life.',
            nuanceKo:
                '단순한 물질적 결핍이 아니라 언약적 완전성을 의미합니다 — 하나님이 목자이시면 삶에 본질적인 것이 빠지지 않습니다.',
          ),
        ],
      ),
      bibleStory: const BibleStory(
        titleEn: 'David the Shepherd',
        titleKo: '목자 다윗',
        summaryEn:
            'Before David became king, he tended sheep in the fields of Bethlehem — defending them from lions and bears. In those quiet hills he learned that the LORD was the true shepherd over his own life.',
        summaryKo:
            '다윗은 왕이 되기 전, 베들레헴 들판에서 사자와 곰으로부터 양을 지키던 소년이었습니다. 고요한 언덕 위에서 그는 자신의 삶을 인도하시는 진짜 목자가 여호와이심을 배웠습니다.',
      ),
      testimonyEn:
          'Lord, thank You for this new morning. Guide my family in peace and comfort my friend who is anxious. In Jesus\' name, Amen.',
      testimonyKo:
          '주님, 오늘도 새로운 아침을 허락해 주셔서 감사합니다. 가족을 평안으로 인도하시고, 염려하는 친구를 위로해 주세요. 예수님의 이름으로 기도합니다. 아멘.',
      guidance: const Guidance(
        contentEn:
            'Your prayer shows a heart that remembers others before yourself — a mark of intercession. Carry that same gentleness with you into today\'s conversations.',
        contentKo:
            '자신보다 먼저 다른 이들을 기억하는 마음이 기도에 담겨 있습니다. 이는 중보자의 마음입니다. 오늘 만나는 이들과의 대화에서도 그 부드러움을 잃지 마세요.',
        isPremium: true,
      ),
      aiPrayer: const AiPrayer(
        textEn:
            'Heavenly Father, we come before You with hearts full of gratitude. You know the burdens we carry and the ones we carry for others. Lead us beside quiet waters today. Restore what feels worn. Speak peace where there is worry. In Jesus\' name, Amen.',
        textKo:
            '하늘에 계신 아버지, 감사하는 마음으로 주 앞에 나아갑니다. 우리가 짊어진 짐과 다른 이를 위해 지는 짐을 주님은 아십니다. 오늘도 쉴 만한 물가로 인도하여 주옵소서. 지친 마음을 회복시켜 주시고, 염려하는 자리에 평안을 말씀하여 주소서. 예수님의 이름으로 기도드립니다. 아멘.',
        isPremium: true,
      ),
      historicalStory: const HistoricalStory(
        titleEn: 'George Müller\'s Morning Bread',
        titleKo: '조지 뮬러의 아침 식탁',
        reference: 'Bristol, 1838',
        summaryEn:
            'One morning in Bristol, the orphanage had no food. George Müller gathered three hundred children, set empty plates, and gave thanks aloud for breakfast. Before the prayer ended, a baker knocked — unable to sleep, he had baked bread for them. Minutes later, a milkman\'s cart broke down at the gate; rather than waste the milk, he brought it in.',
            summaryKo:
            '1838년 어느 아침, 브리스틀의 고아원에는 먹을 것이 하나도 없었습니다. 조지 뮬러는 300명의 아이들을 빈 식탁에 앉히고 아침 식사에 대한 감사 기도를 올렸습니다. 기도가 끝나기 전, 빵집 주인이 문을 두드렸습니다 — 잠이 오지 않아 아이들을 위해 빵을 구웠다고 했습니다. 잠시 후 우유 마차가 문 앞에서 고장이 났고, 마부는 우유를 버리는 대신 안으로 들고 들어왔습니다.',
        lessonEn:
            'Your prayer for your family\'s provision echoes Müller\'s: God often answers before we finish the sentence. Trust what you cannot yet see.',
        lessonKo:
            '가족을 위한 당신의 기도는 뮬러의 기도와 같습니다. 하나님은 때로 우리가 말을 마치기 전에 응답하십니다. 아직 보이지 않는 것을 신뢰하세요.',
        isPremium: true,
      ),
    );
  }

  PremiumContent _hardcodedPremiumContent() {
    final base = _hardcodedPrayerResult();
    return PremiumContent(
      historicalStory: base.historicalStory,
      aiPrayer: base.aiPrayer,
      guidance: base.guidance,
    );
  }

  QtMeditationResult _hardcodedMeditationResult() {
    return const QtMeditationResult(
      analysis: MeditationAnalysis(
        keyThemeEn: 'God\'s Faithful Shepherding',
        keyThemeKo: '신실한 인도하심',
        insightEn:
            'Your meditation centers on trust — you are learning to release what you cannot control into the hands of the One who already holds it.',
        insightKo:
            '당신의 묵상은 "신뢰"에 맞닿아 있습니다. 당신은 지금, 통제할 수 없는 것을 이미 그것을 붙잡고 계신 분의 손에 맡기는 법을 배우는 중입니다.',
      ),
      application: ApplicationSuggestion(
        action: '오늘 저녁 식사 전, 가족과 함께 시편 23편을 한 절씩 소리 내어 읽어 보세요.',
      ),
      knowledge: RelatedKnowledge(
        originalWord: OriginalWord(
          word: 'רֹעִי',
          transliteration: 'ro\'i',
          language: 'Hebrew',
          meaningEn: '"my shepherd" — intimate, covenantal care.',
          meaningKo: '"나의 목자" — 친밀하고 언약적인 돌봄.',
        ),
        historicalContextEn:
            'David wrote Psalm 23 from personal experience as a shepherd. Ancient Near Eastern kings often called themselves "shepherds" of their people — David flips this image to name God as his king.',
        historicalContextKo:
            '다윗은 목자로서의 경험을 바탕으로 시편 23편을 썼습니다. 고대 근동의 왕들은 스스로를 백성의 "목자"라 불렀지만, 다윗은 이 이미지를 뒤집어 하나님을 자신의 왕으로 고백합니다.',
        crossReferences: [
          CrossReference(
            reference: 'Isaiah 40:11',
            text: '그는 목자 같이 양 무리를 먹이시며 어린 양을 그 품에 안으시며',
          ),
          CrossReference(
            reference: 'John 10:11',
            text: '나는 선한 목자라 선한 목자는 양들을 위하여 목숨을 버리거니와',
          ),
        ],
      ),
      growthStory: GrowthStory(
        titleEn: 'The Weaver\'s Pattern',
        titleKo: '직조공의 무늬',
        summaryEn:
            'A young girl watched her grandmother weave a tapestry. From below, she saw only knots and loose threads, and she cried. Her grandmother lifted her to the top of the loom — where the same threads formed a garden of roses. "This is how God sees your life," she whispered. "From below it looks tangled. From above, it is already beautiful."',
        summaryKo:
            '한 소녀가 할머니가 태피스트리를 짜는 모습을 바라보고 있었습니다. 아래에서 보니 엉킨 매듭과 늘어진 실뿐이어서 소녀는 울었습니다. 할머니는 소녀를 베틀 위로 들어 올렸습니다 — 같은 실이 위에서는 장미 정원이 되어 있었습니다. "하나님이 네 인생을 보시는 방식이 이것이란다"라고 할머니는 속삭였습니다. "아래에서는 엉킨 것처럼 보여도, 위에서는 이미 아름답단다."',
        lessonEn:
            'Today\'s passage invites you to trust the weaver — to see today\'s tangled threads as part of a pattern only God fully sees.',
        lessonKo:
            '오늘의 말씀은 직조공을 신뢰하라고 초대합니다 — 오늘의 엉킨 실들이 하나님만이 온전히 보시는 무늬의 일부임을 믿으세요.',
        isPremium: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Fallbacks (for API error paths — reuse the rich hardcoded content)
  // ---------------------------------------------------------------------------

  PrayerResult _fallbackPrayerResult() => _hardcodedPrayerResult();

  QtMeditationResult _fallbackMeditationResult() => _hardcodedMeditationResult();

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
    final index = (DateTime.now().millisecondsSinceEpoch ~/ 1000 + Random().nextInt(hints.length)) % hints.length;
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
  // System prompts (preserved from OpenAI service)
  // ---------------------------------------------------------------------------

  String _buildSystemPrompt(String langName) {
    return '''You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  },
  "historical_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "reference": "source (Bible chapter:verse or historical source)",
    "summary_en": "A story with narrative arc (7-10+ sentences in English)",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어)",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English)",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어)",
    "is_premium": true
  }
}

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
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object with ONLY these core sections:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  }
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

Return a JSON object:

{
  "transcription": "The exact transcription of the prayer audio in the original language spoken",
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "verse_en": "Bible verse in English",
    "verse_ko": "same verse in Korean",
    "reference": "Book Chapter:Verse",
    "reason_en": "Why this verse was chosen (2-3 sentences in English)",
    "reason_ko": "이 말씀을 선택한 이유 (2-3문장, 한국어)"
  },
  "bible_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "summary_en": "3-4 sentence summary in English",
    "summary_ko": "3-4 sentence summary in Korean"
  },
  "testimony": {
    "transcript_en": "the prayer reorganized in English as a testimony",
    "transcript_ko": "기도 내용을 한국어 간증문으로 재구성"
  }
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

Return a JSON object with ONLY these premium sections:

{
  "historical_story": {
    "title_en": "story title in English",
    "title_ko": "story title in Korean",
    "reference": "source (Bible chapter:verse or historical source)",
    "summary_en": "A story with narrative arc (7-10+ sentences in English)",
    "summary_ko": "기승전결 구조의 이야기 (7-10문장 이상, 한국어)",
    "lesson_en": "Specific lesson for this person (2-3 sentences in English)",
    "lesson_ko": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "A deeply moving prayer (5-8 sentences in English)",
    "text_ko": "감동적인 기도문 (5-8문장, 한국어)",
    "is_premium": true
  }
}

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.
- The ai_prayer should read like poetry.

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories.''';
  }

  String _buildMeditationPrompt(String langName) {
    return '''You are the world's most insightful Bible study guide and spiritual mentor.
The user has meditated on a Bible passage and shared their reflection.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.

Return a JSON object:

{
  "analysis": {
    "key_theme_en": "key theme in English (2-3 words)",
    "key_theme_ko": "핵심 테마 (2-3단어, 한국어)",
    "insight_en": "Deep analysis of the user's meditation (3-4 sentences in English).",
    "insight_ko": "사용자의 묵상을 깊이 분석한 인사이트 (3-4문장)."
  },
  "application": {
    "action": "A very specific actionable application in $langName. Must include who/what/how."
  },
  "knowledge": {
    "original_word": {
      "word": "Hebrew or Greek word from the passage",
      "transliteration": "romanized pronunciation",
      "language": "Hebrew or Greek",
      "meaning_en": "Deep meaning (2-3 sentences in English).",
      "meaning_ko": "원어의 깊은 뜻 (2-3문장)."
    },
    "historical_context_en": "Historical/cultural background (3-4 sentences in English).",
    "historical_context_ko": "역사적/문화적 배경 (3-4문장).",
    "cross_references": [
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"},
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"}
    ]
  },
  "growth_story": {
    "title_en": "Growth story title in English",
    "title_ko": "영적 성장 스토리 제목 (한국어)",
    "summary_en": "A story with narrative arc (8-12 sentences in English).",
    "summary_ko": "기승전결 구조의 감동적인 실화 (8-12문장).",
    "lesson_en": "How this story connects to today's meditation (2-3 sentences)",
    "lesson_ko": "이 이야기가 오늘 묵상과 어떻게 연결되는지 (2-3문장)",
    "is_premium": true
  }
}

WRITING STYLE:
- Write like a master short story author, NOT a report writer.
- Use SENSORY details, INNER MONOLOGUE, METAPHORS and SIMILES.
- VARY sentence structure. Show, don't tell.

IMPORTANT:
- cross_references: Include 2-3 verses with both "reference" and full "text" in $langName.
- application.action: Must be SPECIFIC and ACTIONABLE with who/what/how.
- growth_story: Must be a REAL story from Bible or verified church history. Minimum 8 sentences.''';
  }
}
