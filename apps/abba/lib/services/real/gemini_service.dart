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
      return _parsePrayerJson(response.text, locale);
    } catch (e, stackTrace) {
      apiLog.error('Gemini prayer analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult(locale);
    }
  }

  @override
  Future<PrayerResult> analyzePrayerCore({
    required String transcript,
    required String locale,
  }) async {
    if (_useHardcodedResponse) {
      apiLog.info('Gemini analyzePrayerCore bypassed (hardcoded)');
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
      return _parsePrayerJson(response.text, locale);
    } catch (e, stackTrace) {
      apiLog.error('Gemini core analysis failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult(locale);
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
          TextPart('This is a prayer audio recording. Transcribe and analyze it.'),
        ]),
      ]);

      final json = _parseJsonFromResponse(response.text);
      final transcription = json['transcription'] as String? ?? '';
      final result = PrayerResult.fromJson(json);
      return (result: result, transcription: transcription);
    } catch (e, stackTrace) {
      apiLog.error('Gemini audio analysis failed', error: e, stackTrace: stackTrace);
      return (result: _fallbackPrayerResult(locale), transcription: '');
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
      return _hardcodedPremiumContent(locale);
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

  PrayerResult _parsePrayerJson(String? text, String locale) {
    try {
      final data = _parseJsonFromResponse(text);
      return PrayerResult.fromJson(data);
    } catch (e, stackTrace) {
      apiLog.error('Prayer JSON parse failed', error: e, stackTrace: stackTrace);
      return _fallbackPrayerResult(locale);
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
        originalWords: const [
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
          source: 'Harvard Study of Adult Development (Waldinger, 85-year study)',
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

  PrayerResult _fallbackPrayerResult(String locale) => _hardcodedPrayerResult(locale);

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
    "reference": "Book Chapter:Verse (e.g., Psalm 23:1-3) — DO NOT include verse text; the app looks it up from a PD bundle",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
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
- TRUTHFULNESS: the story MUST be a real person from the Bible or verified
  church history (Augustine, Luther, Moravians, Hudson Taylor, Amy Carmichael,
  George Müller, Corrie ten Boom, etc.). If you are not confident about
  historicity, choose a different story. NEVER fabricate quotes or dates.

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
3. The user's prayer transcript is their raw spoken words — summarize and organize it in $langName.

Return a JSON object with ONLY these core sections:

{
  "prayer_summary": {
    "gratitude": ["gratitude items summarized in $langName"],
    "petition": ["petition items summarized in $langName"],
    "intercession": ["intercession items summarized in $langName"]
  },
  "scripture": {
    "reference": "Book Chapter:Verse (e.g., Psalm 23:1-3) — DO NOT include verse text; the app looks it up from a PD bundle",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
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
    "reference": "Book Chapter:Verse (e.g., Psalm 23:1-3) — DO NOT include verse text; the app looks it up from a PD bundle",
    "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
    "posture": "How to read it — action/mindset (2-3 sentences in $langName)",
    "key_word_hint": "One key word from the verse with its original-language meaning (1 short line in $langName). Example: 'my shepherd' = Hebrew 'roi' — not a job title, but 'the one who tends me personally'. Leave empty if not confident."
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
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.

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
- TRUTHFULNESS: the story MUST be a real person from the Bible or verified
  church history (Augustine, Luther, Moravians, Hudson Taylor, Amy Carmichael,
  George Müller, Corrie ten Boom, etc.). If you are not confident about
  historicity, choose a different story. NEVER fabricate quotes or dates.

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
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference" — the
   app looks up the exact Public Domain verse text from a bundle. Output
   keys "verse_en"/"verse_ko"/"verse" are FORBIDDEN.

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
