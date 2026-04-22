# Prompt Phase 명세

> 5개 phase prompt. 각 phase는 독립 메서드 + 독립 system prompt.
> Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 추가.

---

## Phase 1 · Core Analysis Prompt

### 대상 메서드
- 기존: `GeminiService.analyzePrayerCore(transcript, locale)` 수정
- 위치: `apps/abba/lib/services/real/gemini_service.dart`

### System Prompt (영어 원문 — 모델에는 영어로 전달)

```
You are a compassionate Christian AI assistant analyzing a user's prayer.

Respond in {locale} language ({langName}).
Output JSON only, no prose outside JSON.

Output schema:
{
  "transcript": "<user's prayer text, cleaned up: natural paragraphing, minor typo fixes, NO content change>",
  "prayerSummary": {
    "gratitude": ["<gratitude point 1>", "..."],   // 0-3 items
    "petition":  ["<petition point 1>",  "..."],   // 0-3 items
    "intercession": ["<intercession point 1>", "..."]  // 0-2 items
  }
}

Rules:
- transcript: same meaning as user input, just cleaned formatting. Never add/remove content.
- Each summary array contains ONLY points actually present in the user's prayer.
- Empty array if that category has no content.
- Each point: 1 short sentence, in {locale} language.
- Keep reverent, warm tone in {locale}.
- JSON must be valid, parseable.
```

### 변수 치환
- `{locale}` — e.g. `ko`, `en`
- `{langName}` — e.g. `Korean`, `English` (localeName helper)

### 입력
```
Content: [TextPart(user.transcript)]
```

### 출력 매핑 (Dart)
```dart
PrayerResult(
  transcript: json['transcript'],
  audioUrl: null, // Phase 1: Core prompt는 audioUrl 생성 안 함. Recording flow에서 주입.
  prayerSummary: PrayerSummary.fromJson(json['prayerSummary']),
  scripture: Scripture.placeholder(),    // Phase 2에서 분리
  historicalStory: null,                  // Phase 4
  aiPrayer: null,                         // Phase 5
  originalLanguage: null,                 // Phase 2에서 편입
)
```

### 호출 모드
- **Audio input**: `analyzePrayerFromAudio`는 별도 메서드 (기존). Phase 1에선 **transcription + Core 분석**을 한 번에 처리. 출력 JSON에 `transcription` 필드 추가 (현재 구조 유지).
- **Text input**: `analyzePrayerCore(transcript, locale)` 단독 호출.

### 하드코딩 응답 (개발/테스트용)

`_useHardcodedResponse = true` 상태에서 반환할 샘플:
```json
{
  "transcript": "주님, 오늘도 새로운 아침을 허락해 주셔서 감사합니다. 가족의 건강과 평안을 지켜 주시고, 오늘 하루 주님의 뜻을 따라 살아가게 하소서. 염려하는 친구를 위로하여 주시고, 주님의 사랑 안에서 모두가 평안하기를 간구합니다. 예수님의 이름으로 기도드립니다. 아멘.",
  "prayerSummary": {
    "gratitude": ["새로운 아침을 허락하심"],
    "petition":  ["오늘 하루 주님의 뜻대로 살아가기"],
    "intercession": ["가족의 건강과 평안", "염려하는 친구의 위로"]
  }
}
```

### 검증

- JSON parsing 실패 시 `_fallbackPrayerResult()` 반환 (현재 로직 유지)
- `transcript`가 빈 문자열이면 fallback
- 모든 배열이 비어 있으면 경고 로그

---

## Phase 2-5 Prompt (추가 예정)

### Phase 2 · Scripture Deep (상세)

#### 대상 메서드

**옵션 A**: 기존 `analyzePrayer`/`analyzePrayerCore` 출력 JSON schema 확장 (Scripture 필드에 posture + originalWords 추가). 별도 메서드 신규 생성 X.

**옵션 B**: `analyzeScriptureDeep(transcript, locale)` 신규 메서드. Phase 분리 이점.

→ **옵션 A 권장** (Phase 2 MVP). 현재 1 call 구조 유지, 비용 증가 없음. 나중에 Phase 3 부터 분리.

#### Scripture JSON schema 확장

기존 `analyzePrayer` system prompt에 Scripture 출력 부분 수정:

```
"scripture": {
  "verse_en": "<English verse text>",
  "verse_ko": "<Korean verse text>",
  "reference": "<e.g., Psalm 23:1>",
  "reason_en": "<English: why this verse for this prayer, 3-4 sentences>",
  "reason_ko": "<Korean: why this verse, 3-4 sentences>",
  "posture_en": "<English: how to read it — what attitude/mindset, 2-3 sentences, action-oriented>",
  "posture_ko": "<Korean: posture, 2-3 sentences>",
  "original_words": [
    {
      "word": "<Hebrew/Greek original text>",
      "transliteration": "<romanization>",
      "language": "Hebrew" | "Greek",
      "meaning_en": "<English meaning>",
      "meaning_ko": "<Korean meaning>",
      "nuance_en": "<English: how the original differs from standard translation, 1-2 sentences, concrete>",
      "nuance_ko": "<Korean nuance, 1-2 sentences>"
    }
  ]
}
```

#### 규칙 (시스템 프롬프트 추가)

```
- reason: 이 기도 내용에 이 성경 구절을 주는 이유. 기도 주제와 연결.
- posture: "○○하며 읽으세요" 같은 지시형. 구체적 action 또는 mindset.
  예: "가족을 떠올리며 한 구절씩 천천히 읽으세요", "감사의 마음으로 낭독해 보세요".
- original_words: 이 구절(reference)에 실제 나오는 원어 중 가장 의미 깊은 1-2개만.
  3개 이상 금지 (시니어 UX 과부하 방지).
- nuance: "'love'로 번역됐지만 히브리어 원어는 언약적 사랑/헤세드를 의미" 같이 구체적.
  모호한 "더 깊은 뜻이 있습니다" 같은 표현 금지.
```

#### 하드코딩 샘플 (Phase 2)

```json
{
  "scripture": {
    "verse_en": "The LORD is my shepherd; I shall not want.",
    "verse_ko": "여호와는 나의 목자시니 내게 부족함이 없으리로다",
    "reference": "Psalm 23:1",
    "reason_en": "Your prayer expresses deep trust and gratitude. This verse reminds you that God is your shepherd — constantly guiding, providing, and protecting you.",
    "reason_ko": "당신의 기도는 깊은 신뢰와 감사를 표현하고 있습니다. 이 말씀은 하나님이 당신의 목자로서 항상 인도하시고, 공급하시고, 보호하심을 상기시킵니다.",
    "posture_en": "Read this verse slowly, picturing yourself as a sheep gently led by a caring shepherd. Linger on the word 'my' — this is a personal relationship.",
    "posture_ko": "당신을 부드럽게 인도하시는 목자의 양으로 그려 보며 천천히 읽어 보세요. '나의'라는 단어에 머물러 보세요 — 이것은 개인적인 관계입니다.",
    "original_words": [
      {
        "word": "רֹעִי",
        "transliteration": "ro'i",
        "language": "Hebrew",
        "meaning_en": "my shepherd",
        "meaning_ko": "나의 목자",
        "nuance_en": "Unlike 'shepherd' as a job title, 'ro'i' implies an intimate, personal covenant relationship — 'the one who shepherds me personally'.",
        "nuance_ko": "단순한 직업으로서의 '목자'와 달리, '로이'는 친밀하고 개인적인 언약 관계를 의미합니다 — '나를 개인적으로 돌보시는 분'."
      },
      {
        "word": "חָסֵר",
        "transliteration": "chaser",
        "language": "Hebrew",
        "meaning_en": "lack, be in want",
        "meaning_ko": "부족하다, 결핍되다",
        "nuance_en": "Not just material lack but covenant completeness — with God as shepherd, nothing essential is missing from your life.",
        "nuance_ko": "단순한 물질적 결핍이 아니라 언약적 완전성을 의미합니다 — 하나님이 목자이시면 삶에 본질적인 것이 빠지지 않습니다."
      }
    ]
  }
}
```

### Phase 3 · Prayer Coaching (상세)

#### 대상 메서드 (신규)

`AiService.analyzePrayerCoaching(transcript, locale)` — 모든 구현체(Gemini, Mock, Cached)에 신규 추가. OpenAI 구현체는 2026-04-21 폐기.

#### 입력
- `transcript`: 사용자 기도 원문 (String)
- `locale`: `ko` | `en` | 기타

#### System Prompt 구조

```
[PRAYER_GUIDE_DOC 전체 삽입]  ← rootBundle.loadString('assets/docs/prayer_guide.md')

[영어 직접 지시]:
You are a gentle Christian prayer coach evaluating a user's prayer
based on the Prayer Guide above.

CRITICAL: Your job is EDUCATIONAL, not judgmental.
- Always praise first (strengths)
- Improvements must be CONSTRUCTIVE ("Adding X would deepen...")
- NEVER use words: "inadequate", "lacking", "wrong", "poor"
- Beginner level MUST be encouraged, never shamed

Respond in {locale} language ({langName}).
Output JSON ONLY, no prose outside JSON.

JSON schema:
{
  "scores": {
    "specificity": <int 1-5>,
    "god_centeredness": <int 1-5>,
    "acts_balance": <int 1-5>,
    "authenticity": <int 1-5>
  },
  "strengths": [<2-4 strings in {locale}>],
  "improvements": [<2-4 strings in {locale}>],
  "overall_feedback_en": "<3-4 sentences English>",
  "overall_feedback_ko": "<3-4 sentences Korean>",
  "expert_level": "beginner" | "growing" | "expert"
}

Rules (per Prayer Guide §4-6):
- Scores: 1-5 integer (see rubric in guide §4)
- Strengths must cite specific content from the prayer (not generic)
- Improvements: "Adding X would deepen..." format
- Forbidden words in any output: "lacking", "inadequate", "wrong", "poor"
- Expert level: beginner (avg ≤ 2 OR only 1-2 ACTS) / growing / expert (avg ≥ 4.5)
- overall_feedback: both en and ko always (for device locale switch support)

NEVER output the prayer_guide content back. Use it only as reference for evaluation.
```

#### 하드코딩 샘플 (`_hardcodedCoachingResult()`)

```json
{
  "scores": {
    "specificity": 4,
    "god_centeredness": 3,
    "acts_balance": 4,
    "authenticity": 4
  },
  "strengths": [
    "가족과 친구를 구체적으로 이름처럼 떠올리며 기도하신 점이 좋습니다 — 이는 구체성의 좋은 예입니다.",
    "'감사합니다'로 시작해 '간구합니다'로 이어지는 흐름이 ACTS의 T와 S를 자연스럽게 담고 있어요."
  ],
  "improvements": [
    "회개 (Confession) 한 문장을 더해 보세요. 예: '오늘 급한 말을 용서해 주소서.' 이것만으로도 ACTS 4축이 채워집니다.",
    "하나님의 속성 한 가지 — '거룩하신 주님' 같은 찬양 한 문장 — 을 시작에 더하시면 기도가 더 깊어질 거예요."
  ],
  "overall_feedback_en": "Your prayer shows beautiful balance of gratitude and intercession. Adding one sentence of confession would complete the ACTS rhythm. God loves every heart that prays.",
  "overall_feedback_ko": "감사와 중보가 아름답게 균형 잡힌 기도예요. 회개 한 문장을 더하시면 ACTS 4축이 완성됩니다. 하나님은 기도하는 당신의 마음을 사랑하십니다.",
  "expert_level": "growing"
}
```

#### 에러 처리

- JSON parsing 실패: `PrayerCoaching.placeholder()` 반환 + Sentry 보고
- API 호출 실패: 동일 placeholder
- 금지어 감지 (hallucinate): 출력 후 간단 필터 — "부족", "못 하", "잘못" 포함 시 placeholder로 대체 (안전장치)

#### 호출 시점 / Provider

- 신규 `prayerCoachingProvider` (autoDispose FutureProvider)
- Pro 유저만 자동 fetch (`isUserPremium && transcript.isNotEmpty` 조건)
- Free 유저: placeholder 즉시 반환, ProBlur로 렌더

#### 비용

- Gemini 2.5 flash 기준: system prompt (~2500 토큰) + transcript (~300 토큰) + output (~500 토큰) = ~$0.001/call
- Pro 유저 1 prayer = Coaching 1 call → **비용 무시 가능**

### Phase 4 · Historical Deep (상세)

#### 대상 메서드

**옵션 A**: 기존 `analyzePrayerPremium` 출력의 `historical_story` 섹션 지시만 강화. 신규 메서드 없음.
**옵션 B**: `analyzeHistoricalDeep(transcript, scriptureRef, locale)` 신규 분리.

→ **옵션 A 채택** (Phase 4 MVP). Premium 1 call 유지, 비용 증가 0. Phase 5에서 AiPrayer를 별도 분리할 때 함께 재검토.

#### Historical Story JSON schema 변경 (A-1: single-field)

기존 `_en`/`_ko` 이원 필드 → **사용자 locale 단일 필드**:
```json
"historical_story": {
  "title": "<in $langName>",
  "reference": "<locale-neutral, e.g. 'Bristol, 1838'>",
  "summary": "<in $langName, 8-10 sentences>",
  "lesson": "<in $langName, 2-4 sentences>",
  "is_premium": true
}
```

**다른 섹션(scripture, bible_story, guidance, ai_prayer)의 `_en`/`_ko` 이원 스키마는 Phase 4 scope 밖 — 그대로 유지.** 추후 phase에서 동일 패턴으로 리팩터링 예정.

#### 신규 작성 규칙 (system prompt `_buildPremiumSystemPrompt` + `_buildSystemPrompt`에 추가)

```
HISTORICAL STORY — quality bar (Phase 4):
- summary_en: 8-10 sentences, minimum 800 characters (excluding whitespace).
- summary_ko: 8-10 sentences, minimum 400 characters (excluding whitespace).
- Each sentence should render ONE scene with sensory detail or inner monologue.
  Avoid summarizing multiple events in one sentence.
- Include at least: (1) concrete time/place, (2) named character's inner
  thought or feeling, (3) one physical detail (what they saw, heard, felt).
- Separate major scene transitions with a blank line ("\n\n") so the UI
  can render paragraphs.
- Avoid generic phrases like "and they trusted God". Show the trust through
  action or dialogue.
- lesson_en / lesson_ko: 2-4 sentences tying THIS person's prayer to
  the story's specific moment. Not generic application — name the parallel.

TRUTHFULNESS (★ critical):
- Historical story MUST be a real person/event from the Bible or
  verified church history (post-biblical: Augustine, Luther, Moravians,
  Hudson Taylor, Amy Carmichael, George Müller, Corrie ten Boom, etc.).
- If you are not confident about historicity, pick a different story.
- Never fabricate quotes, dates, or events.
- reference field: Bible chapter:verse OR city + year (e.g., "Bristol, 1838").
```

#### 하드코딩 샘플 강화 방향 (Phase 4)

기존 George Müller 샘플(이미 8문장)의 summary_en 을 "감각 + 내면 + 구체적 시간" 기준으로 리라이트 예시:

```
"One cold November morning in 1838, a heavy mist still hung over the
orphanage yard on Wilson Street. Inside, three hundred children sat
at long wooden tables with empty pewter plates. George Müller stood
at the head of the room, his hands folded, his heart beating louder
than the ticking clock above the door. He did not say 'we have no
breakfast.' Instead, he said, 'Thank you, Father, for the food You
are about to provide.'

Before he had finished the prayer, there came a knock at the kitchen
door. A baker from Clifton Street stood there, flour still on his
apron — he had been unable to sleep, he said, and had baked enough
loaves for every child. Minutes later, a milkman's cart broke its
axle at the gate. Unable to deliver his rounds, he carried his cans
in rather than let the milk sour. Müller would later write in his
journal that evening: 'The children did not know they had been
hungry.'"
```

(korean 번역도 동일 문장 수준으로 리라이트)

lesson 필드는 그대로 유지 (이미 충분히 응답자의 기도와 연결됨).

#### 검증

- JSON parsing 실패: `_fallbackPrayerResult()` 반환 (기존 로직)
- summary 길이 미달(en 800/ko 400자 미만): 경고 로그만, 데이터는 반환 (사용자 경험 유지)
- Sentry 샘플 검토: 출시 전 50개 샘플 수동 확인 — 인물/사건 fact check

#### 비용

- Premium 1 call 유지 (신규 메서드 없음)
- 출력 토큰 증가: 기존 대비 +200-400 token × $0.30/1M = **+$0.0001/call** 무시 가능

### Phase 5 · AI Prayer Deep (상세)

#### 대상 메서드

**옵션 A**: 기존 `analyzePrayerPremium` / `analyzePrayer` 의 `ai_prayer` 섹션 schema만 확장. 신규 메서드 없음.
**옵션 B**: `generateAiPrayerDeep(transcript, locale)` 신규 분리.

→ **옵션 A 채택** (Phase 4와 동일 원칙). Premium 1 call 유지, 비용 증가 0.

#### AI Prayer JSON schema 변경 (single-field + citations)

기존 `text_en`/`text_ko` → **사용자 locale 단일 `text`** + `citations` 배열:

```json
"ai_prayer": {
  "text": "<in $langName, ~300 words = 2-minute read>",
  "citations": [
    {
      "type": "quote",
      "source": "<author, work — MUST be real>",
      "content": "<quoted text in $langName>"
    },
    {
      "type": "science",
      "source": "<study, year, institution — MUST be real>",
      "content": "<scientific fact in $langName>"
    },
    {
      "type": "example",
      "source": "",
      "content": "<concrete example or anecdote in $langName>"
    }
  ],
  "is_premium": true
}
```

#### Phase 5 품질 지시 (system prompt에 추가)

```
AI PRAYER QUALITY BAR (Phase 5):
- text length: ~300 words (2-minute read). Korean/Japanese/Chinese: ~250 chars
  per sentence × 10-12 sentences. English/European: ~300 words.
- NEVER include audio/TTS references — text-only.
- Structure: gentle opening → one concrete image/story → one insight from
  Scripture or a real quote/science → specific prayer for the user's
  situation → quiet close ("In Jesus' name, Amen." or locale equivalent).
- The prayer should read like poetry at key moments — rhythm, breath, silence.

CITATIONS (required: at least 2 of the 3 types; max 4 total):
- type "quote": Real author + real work. C.S. Lewis, Augustine, Bonhoeffer,
  Julian of Norwich, John Piper, Tim Keller, etc. Never fabricate.
- type "science": Real study, journal, or well-known finding. Only include
  if you are confident about the source. If unsure → omit.
- type "example": Concrete anecdote — can be anonymous (no source). Must
  feel specific (a time, a place, a named action). No generic platitudes.

TRUTHFULNESS (★ critical — same rule as Phase 4):
- If you are not 100% confident about a quote's author or a study's source,
  OMIT that citation entirely. Better zero citations than fabricated ones.
- NEVER invent a research paper, professor, or institution name.
- NEVER attribute modern phrases to ancient authors.

FORBIDDEN:
- "According to recent studies..." without a real source
- "Einstein said..." / "Gandhi said..." style misattributions
- Generic self-help language ("You are enough", "Just believe in yourself")
```

#### 하드코딩 샘플 (Phase 5)

`_hardcodedPrayerResult(locale)` 의 AiPrayer 샘플 리라이트 예시 (ko):

```json
"ai_prayer": {
  "text": "하늘에 계신 아버지, 오늘 아침 당신 앞에 조용히 무릎 꿇습니다.\n\n주님, 저는 오늘도 가족의 이름을 불러봅니다. 어머니의 무릎, 아이의 숨결, 배우자의 뒷모습 — 그 익숙한 풍경이 얼마나 큰 은혜인지 이제야 눈이 열립니다. C.S. 루이스는 '우리는 영원을 향해 창조된 존재'라 말했습니다. 하나님, 그 영원이 오늘 아침 제 방 안에, 가족의 평범한 얼굴 속에 이미 들어와 있음을 믿습니다.\n\n하버드 대학은 85년 동안 724명의 삶을 추적하며 '행복을 결정짓는 단 하나의 요인은 관계의 깊이'라는 결론에 도달했습니다. 주님, 과학도 돌아가 증언하는 이 진리 — 사랑의 관계가 곧 생명 — 을 오늘 제 식탁과 잠자리에서 살아내게 하소서.\n\n염려로 잠 못 이루던 밤, 친구의 전화 한 통이 얼마나 큰 위로였는지 기억합니다. 주님, 오늘 저를 그런 전화가 되게 하소서. 짧은 문자 하나, 조용한 기도 하나로 누군가의 밤을 밝히는 사람이 되게 하소서.\n\n주님의 이름으로 기도드립니다. 아멘.",
  "citations": [
    {
      "type": "quote",
      "source": "C.S. Lewis, Mere Christianity",
      "content": "우리는 영원을 향해 창조된 존재입니다."
    },
    {
      "type": "science",
      "source": "Harvard Study of Adult Development (Waldinger, 85년 추적 연구)",
      "content": "행복을 결정짓는 단 하나의 요인은 관계의 깊이다."
    },
    {
      "type": "example",
      "source": "",
      "content": "염려로 잠 못 이루던 밤, 친구의 전화 한 통이 위로가 된 순간."
    }
  ],
  "is_premium": true
}
```

(en 버전도 동일 구조로 별도 제공)

#### 검증

- JSON parsing 실패: `AiPrayer.placeholder(locale)` 반환 + Sentry 보고
- citations.content 빈 항목은 parse 후 필터링
- text 길이 검증은 warning 로그만 (데이터 반환은 계속)

#### 비용

- Premium 1 call 유지. 출력 토큰 증가: +300-500 token × $0.30/1M ≈ **+$0.0002/call** 무시 가능.

---

## 호출 전략 (최종 결정: **Hybrid**, 2026-04-21)

사용자 승인: Free 1 call + Pro 2 call.

| 메서드 | Phase 묶음 | 시점 | 근거 |
|--------|-----------|------|------|
| `analyzePrayerCore` (기존 확장) | **Phase 1 + 2** | Loading 직후 (Free/Pro 공통) | 프롬프트 성격 비슷 (기도 분석 + 성경 해석) → 한 컨텍스트 OK |
| `analyzePrayerPremium` (기존 확장) | **Phase 4 + 5** | Pro 카드 뷰포트 진입 시 on-demand | Historical + AiPrayer 둘 다 성경/영적 이야기 톤 → 묶기 OK |
| `analyzePrayerCoaching` (**신규**) | **Phase 3 단독** | Pro 유저 Coaching 카드 first view 시 | **prayer_guide.md 시스템 프롬프트 삽입** 필요 → 다른 phase와 섞으면 평가 기준 흐트러짐 |

**왜 Coaching만 분리했는가** (Cognition AI "Don't Build Multi-Agents" 원칙의 예외):
- Coaching의 system prompt는 `prayer_guide.md` 전체(~2-3 페이지) 삽입
- 다른 phase와 섞으면 AI가 성경문 생성하다가 평가 기준 흐트러지거나, 평가하다가 기도문 톤 섞임
- Microsoft Red Team 패턴과 유사: 진짜로 컨텍스트 분리 필요한 경우

**비용 추정** (Gemini 2.5 flash $0.075/1M input, $0.30/1M output)
- Free 유저: 1 call × ~$0.0007 = **$0.0007/prayer**
- Pro 유저: 1 Core + 1 Premium + 1 Coaching × ~$0.0007 = **$0.0021/prayer**
- 고려 요소 아님 (하루 1000 prayer = $2)

## 참조

- `apps/abba/lib/services/real/gemini_service.dart` (현재 구현)
- `apps/abba/lib/services/ai_service.dart` (인터페이스)
- `.claude/rules/learned-pitfalls.md` §2 (Subscription — Pro phase 호출 시 credit 체크)
- `.claude/rules/learned-pitfalls.md` §11 (성능 — 병렬 호출로 레이턴시 최소화)
