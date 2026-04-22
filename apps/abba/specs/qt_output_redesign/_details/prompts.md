# Prompt 명세 — qt_output_redesign

Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 작성.

---

## Phase 1 · Meditation Analysis Prompt 재설계

### 대상 메서드

- `GeminiService.analyzeMeditation(passageReference, passageText, meditationText, locale)` 재설계
- 위치: `apps/abba/lib/services/real/gemini_service.dart`

### 새 System Prompt (영어 원문, 모델에 영어로 전달)

```
You are the world's most insightful Bible study guide and spiritual mentor.
The user has meditated on a Bible passage and shared their reflection.

CRITICAL RULES:
1. Respond ENTIRELY in $langName. Do NOT mix languages.
2. Every field must be in $langName only.
3. SCRIPTURE: Do NOT generate verse text. Output only the "reference"
   — the app looks up the Public Domain verse from a bundle.
4. Output JSON ONLY, no prose outside JSON.

Output JSON schema:

{
  "meditation_summary": {
    "summary": "<1-2 sentences summarizing the user's meditation in $langName>",
    "topic": "<1-short-line topic of today's passage in $langName>"
  },
  "scripture": {
    "reference": "<Book Chapter:Verse — must match the passage user meditated on>",
    "reason": "<Why this passage speaks to the user (2-3 sentences in $langName)>",
    "posture": "<How to continue meditating on this passage (2-3 sentences in $langName)>",
    "key_word_hint": "<One key word with original-language meaning (1 line in $langName). Example: \"'my shepherd' = Hebrew 'ro'i' — the one who tends me personally\". Leave empty if not confident.>",
    "original_words": [
      {
        "word": "<Hebrew/Greek original>",
        "transliteration": "<romanization>",
        "language": "Hebrew | Greek",
        "meaning": "<meaning in $langName>",
        "nuance": "<1-2 sentences nuance in $langName>"
      }
    ]
  },
  "analysis": {
    "insight": "<3-4 sentence deep analysis of user's meditation in $langName>"
  },
  "application": {
    "action": "<one specific actionable application in $langName — Personal, Practical, Possible>"
  },
  "knowledge": {
    "historical_context": "<Historical/cultural background (3-4 sentences in $langName)>",
    "cross_references": [
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"},
      {"reference": "Book Chapter:Verse", "text": "Full verse text in $langName"}
    ]
  },
  "growth_story": {
    "title": "<story title in $langName>",
    "summary": "<8-12 sentence narrative in $langName>",
    "lesson": "<2-3 sentence application in $langName>",
    "is_premium": true
  }
}
```

### 변수 치환
- `{locale}` — e.g. `ko`, `en`, `ja`
- `{langName}` — e.g. `Korean`, `English`, `Japanese`

### 입력

```
Passage: ${passageReference}

${passageText}

My meditation:
${meditationText}
```

### 신규 지시 사항 (Phase 1 추가)

```
MEDITATION SUMMARY (new in Phase 1):
- summary: Capture the essence of the user's meditation in 1-2 sentences.
  Not a generic platitude — reference specific content from their
  meditation text.
- topic: The central theme of today's passage (not the meditation).
  Short, 5-10 words. Example: "The Lord as the personal shepherd".

SCRIPTURE HANDLING (Phase 6 + bible_text_i18n standards):
- DO NOT generate verse text. Output only the "reference".
- Must be a real Bible citation (Book Chapter:Verse).
- original_words: 1-2 words max, must appear in this passage.

APPLICATION — 3P principle:
- Personal: "you should" → "today, you can..."
- Practical: concrete action, not abstract
- Possible: achievable today or this week
```

### 하드코딩 응답 (`_hardcodedMeditationResult(locale)`)

```dart
if (locale == 'ko') {
  return QtMeditationResult(
    meditationSummary: const MeditationSummary(
      summary: '하나님의 신실하신 인도하심 안에서 안식을 발견하는 묵상',
      topic: '목자 되신 여호와',
    ),
    scripture: const Scripture(
      reference: 'Psalm 23:1-3',
      // verse: BibleTextService가 runtime 주입
      reason: '당신의 묵상은 "신뢰"에 맞닿아 있습니다. 하나님이 당신의 개인적 목자이심을 이 말씀이 다시 일깨워 줍니다.',
      posture: '양이 목자를 따르듯 한 구절씩 천천히, "나의"라는 단어에 머물러 읽어 보세요.',
      keyWordHint: "'나의 목자' = 히브리어 '로이' — 직업이 아닌 '나를 돌보시는 분'",
      originalWords: [
        ScriptureOriginalWord(
          word: 'רֹעִי',
          transliteration: "ro'i",
          language: 'Hebrew',
          meaning: '나의 목자',
          nuance: '단순한 직업이 아니라 친밀한 언약 관계를 뜻합니다.',
        ),
      ],
    ),
    analysis: const MeditationAnalysis(
      insight: '당신의 묵상은 통제할 수 없는 것을 하나님께 맡기는 자세로 나아가고 있습니다. 이는 시편의 신뢰 기도와 같은 흐름입니다.',
    ),
    application: const ApplicationSuggestion(
      action: '오늘 저녁 식사 전, 가족과 함께 시편 23편을 한 절씩 소리 내어 읽어 보세요.',
    ),
    knowledge: const RelatedKnowledge(
      historicalContext: '다윗은 목자 경험을 바탕으로 시편 23편을 썼습니다. 고대 근동의 왕들은 스스로를 백성의 "목자"라 불렀지만, 다윗은 이 이미지를 뒤집어 하나님을 자신의 왕으로 고백합니다.',
      crossReferences: [
        CrossReference(reference: 'Isaiah 40:11', text: '그는 목자 같이 양 무리를 먹이시며 어린 양을 그 품에 안으시며'),
        CrossReference(reference: 'John 10:11', text: '나는 선한 목자라'),
      ],
    ),
    growthStory: const GrowthStory(
      title: '직조공의 무늬',
      summary: '한 소녀가 할머니가 태피스트리를 짜는 모습을 바라보았습니다. 아래에서 보니 엉킨 매듭과 늘어진 실뿐이어서 소녀는 울었습니다. ...',
      lesson: '오늘의 말씀은 직조공을 신뢰하라고 초대합니다.',
      isPremium: true,
    ),
  );
}
// 영어 버전 동일 구조
```

### 검증

- JSON parsing 실패: `_fallbackMeditationResult(locale)` 반환
- meditationSummary.topic 빈 문자열이면 경고 로그
- Scripture.reference 빈 문자열이면 `_fallbackMeditationResult`

### 비용

- Gemini 2.5 flash 1 call 유지
- 출력 토큰: 기존 대비 약 +100 (meditation_summary + scripture 구조 확장)
- 총: **$0.0007 ~ $0.001/meditation** — 무시 가능

---

## Phase 2-5 prompt (예정)

### Phase 2 · QT Coaching Prompt
- 신규 메서드 `analyzeQtCoaching(meditationText, scriptureReference, locale)`
- qt_guide.md asset 통째 삽입 (~2500 토큰)
- JSON schema: scores + strengths + improvements + overallFeedback + expertLevel
- Prayer Coaching 패턴 미러

### Phase 3 · Citations
- `analyzeMeditation` schema 확장: citations 배열 (type: quote/science/history/example)
- 품질 바: 최소 2 type, 최대 4개, 출처 명확

### Phase 4 · GrowthStory 품질 강화
- summary: 8-12문장 → 세부 장면 (감각+내면+시간/장소)
- Hallucinate 방지 강화

### Phase 5 · Application 확장
- `action` 단일 → `morning_action` / `day_action` / `evening_action` 3개 (optional, 기본 하나)

## 참조

- prayer_output_redesign/_details/prompts.md (Phase 3 Coaching prompt 상세)
- bible_text_i18n/_details/prompts.md (Scripture Deep schema)
- `.claude/rules/learned-pitfalls.md` §2, §11
