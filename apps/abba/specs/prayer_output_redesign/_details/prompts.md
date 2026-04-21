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

### Phase 3 · Prayer Coaching (예정 상세)
- 메서드: `analyzePrayerCoaching(transcript, locale)` 신규
- **system prompt에 `prayer_guide.md` 전체 내용 삽입**
- 출력: scores{specificity, godCenteredness, actsBalance, authenticity}, strengths[], improvements[], overallFeedback, expertLevel
- 룰: 판단 금지 / 칭찬 먼저 / beginner 격려
- 호출: Pro 유저만, on-demand

### Phase 4 · Historical Deep (예정 상세)
- 메서드: `analyzeHistoricalDeep(transcript, scriptureReference, locale)` 신규
- 출력: title, summary (8-10문장), todayLesson (3-4문장)
- 인물 풀: 성경 인물 우선, 초대 교회 ~ 현대 성인

### Phase 5 · AI Prayer Deep (예정 상세)
- 메서드: `generateAiPrayerDeep(transcript, improvements, locale)` 신규
- 출력: text (~300 단어, 2분 읽기 분량), citations[{type, source, content}]
- **audioUrl 필드 없음** (TTS 제거 결정)
- 필수 포함: 명언 1+, 과학적 사실 1+, 구체적 예시 1+
- hallucinate 방지: 확실하지 않으면 인용 생략 룰

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
