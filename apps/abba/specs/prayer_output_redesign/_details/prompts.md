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

### Phase 2 · Scripture Deep (예정 상세)
- 메서드: `analyzeScriptureDeep(transcript, locale)` 신규
- 입력: transcript + (optional) 이전 phase의 PrayerSummary
- 출력: verse, reference, whyThisVerse, postureToRead, originalWords[1-2]
- 특이: 원어 단어는 reference 구절에서 **가장 의미 깊은 1-2개**만

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

## 병렬 호출 전략 (Phase 전체 구현 후)

- **즉시 (Loading 화면 동안)**: Phase 1 + Phase 2 **병렬** 호출 → Dashboard 첫 렌더에 Core + Scripture 표시
- **On-demand (Pro 유저 스크롤 시)**: Phase 3, 4, 5는 **개별** 호출 (카드 뷰포트 진입 시 lazy)
- **비용 추정**: Gemini 2.5 flash 기준 phase당 ~$0.002 → 최대 5 phase 전부 호출 시 ~$0.01/prayer

## 참조

- `apps/abba/lib/services/real/gemini_service.dart` (현재 구현)
- `apps/abba/lib/services/ai_service.dart` (인터페이스)
- `.claude/rules/learned-pitfalls.md` §2 (Subscription — Pro phase 호출 시 credit 체크)
- `.claude/rules/learned-pitfalls.md` §11 (성능 — 병렬 호출로 레이턴시 최소화)
