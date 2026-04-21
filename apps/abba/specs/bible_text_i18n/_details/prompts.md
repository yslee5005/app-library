# Prompt 명세 — bible_text_i18n

Phase 1만 상세. Phase 2-3은 해당 phase 진입 시 작성.

---

## Phase 1 · Scripture 섹션 prompt 변경

### 대상 메서드

- `GeminiService._buildSystemPrompt(langName)` — analyzePrayer 전체 경로
- `GeminiService._buildPremiumSystemPrompt(langName)` — analyzePrayerPremium 경로
- `GeminiService._buildCoreSystemPrompt(langName)` — analyzePrayerCore 경로
- `GeminiService._buildAudioCoreSystemPrompt(langName)` — 오디오 기반

모두 Scripture JSON schema 부분만 변경. 전체 prompt 재작성 아님.

### 기존 Scripture schema

```json
"scripture": {
  "verse_en": "Bible verse in English",
  "verse_ko": "same verse in Korean",
  "reference": "Book Chapter:Verse",
  "reason_en": "Why this verse... (English)",
  "reason_ko": "이 말씀을 선택한 이유 (한국어)",
  "posture_en": "How to read it (English)",
  "posture_ko": "어떻게 읽을지 (한국어)",
  "original_words": [...]
}
```

### 변경 후 (Phase 1 after)

```json
"scripture": {
  "reference": "Book Chapter:Verse (e.g., Psalm 23:1-3)",
  "reason": "Why this verse for this prayer (2-3 sentences in $langName)",
  "posture": "How to read it — action or mindset (2-3 sentences in $langName)",
  "key_word_hint": "One key word from the verse with short original-language meaning (1 line in $langName)",
  "original_words": [
    {
      "word": "<Hebrew/Greek original>",
      "transliteration": "<romanization>",
      "language": "Hebrew | Greek",
      "meaning": "<meaning in $langName>",
      "nuance": "<1-2 sentences in $langName>"
    }
  ]
}
```

### 신규 지시 사항 (system prompt 내 critical rules 섹션에 추가)

```
SCRIPTURE HANDLING (Phase 6 - critical):
- DO NOT generate the verse text itself. The app will look up the verse
  from a Public Domain translation bundle based on the "reference" you select.
- Only select "reference" — must be a real Bible citation in standard format
  (e.g., "Psalm 23:1", "Romans 8:28-30", "John 3:16").
- Never output strings like "verse", "verse_en", "verse_ko" — these fields
  are gone.
- reference must be a verse or short passage (max 5 verses) from the 66-book
  canon. Prefer passages with a central thought.

KEY_WORD_HINT (new field):
- Format: "'<English word in verse>' = <source language> '<transliteration>'
  — <1-sentence explanation in $langName>"
- Pick ONE central word from the verse. The word should be meaningful in
  the original Hebrew/Greek, not a function word (articles, prepositions).
- Example (English locale): "'my shepherd' = Hebrew 'ro'i' — not a job
  title, but 'the one who tends me personally'"
- Example (Korean locale): "'나의 목자' = 히브리어 '로이' — 직업이
  아닌 '나를 돌보시는 분'"
- If you're not confident about the original language meaning → output
  empty string "".

ORIGINAL_WORDS (existing but strengthened):
- 1-2 words MAX. Must actually appear in the verse you referenced.
- Must be real Hebrew/Greek words with verifiable Strong's Concordance
  entries. If unsure → reduce count or omit.
- NEVER fabricate a word. NEVER pair a real word with wrong meaning.
- transliteration must follow standard Hebrew/Greek romanization.

FORBIDDEN:
- Generating verse text in any form
- "verse_en", "verse_ko" output keys
- Making up Hebrew/Greek words
- Attributing meanings not in established lexicons
```

### Hardcoded fallback sample (Phase 1)

`_hardcodedPrayerResult(locale)` 의 Scripture 부분 — **verse 필드 비움** (BibleTextService가 runtime 주입):

```dart
Scripture(
  reference: 'Psalm 23:1-3',
  verse: '',   // BibleTextService.lookup이 채움
  reason: locale == 'ko'
      ? '당신의 기도는 깊은 신뢰와 감사를 표현합니다. 이 말씀은 하나님이 당신을 인도하시고 채워 주시는 목자이심을 상기시킵니다.'
      : 'Your prayer expresses deep trust and gratitude. This verse reminds you that God is your shepherd who personally leads and provides for you.',
  posture: locale == 'ko'
      ? '목자의 양이 되어 천천히 읽어 보세요. "나의"라는 단어에 머물러 보세요 — 개인적인 관계입니다.'
      : 'Read as a sheep led by a caring shepherd. Linger on the word "my" — this is a personal relationship.',
  keyWordHint: locale == 'ko'
      ? "'나의 목자' = 히브리어 '로이' — 직업이 아닌 '나를 돌보시는 분'"
      : "'my shepherd' = Hebrew 'ro\\'i' — not a job title, but 'the one who tends me personally'",
  originalWords: [...],  // Phase 2 유지
)
```

### 검증

- JSON 파싱 후 scripture.verse_en/verse_ko 키가 있으면 warning 로그 (Gemini가 이전 패턴 재현 시도) → 무시
- reference 빈 문자열이면 `_fallbackPrayerResult(locale)` 발동
- key_word_hint 50자 초과 시 warning (너무 긴 annotation)

### 비용

- 출력 토큰 감소: Scripture verse 2개 (en/ko) 제거 → ~150 token 절감
- key_word_hint 추가: ~30 token
- 총: Phase 6 완료 후 **-120 token/call 순 절감**

---

## Phase 2-3 prompt 변경 (추가 예정)

### Phase 2

- BibleStory: `title_en/_ko`, `summary_en/_ko` → 단일 `title`, `summary` (`$langName`)
- Guidance: `content_en/_ko` → 단일 `content` (`$langName`)

### Phase 3

- 변경 없음 (infra 확장이라 prompt 영향 無)

## 참조

- prayer_output_redesign/_details/prompts.md Phase 4-5 (A-1 precedent)
- `.claude/rules/learned-pitfalls.md` §2 Subscription, §11 성능
