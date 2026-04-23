# Rubric 설계

## 원칙

1. **영어로 작성** (Shi 2023, Sclar 2024 — Gemini dominant language instructions)
2. **Locale 예시만 다국어** (ko/es/en 샘플 3개)
3. **Forbidden Phrases 최상단 배치** (Primacy effect, Liu 2024)
4. **1200 token 상한/섹션** (Lost-in-Middle 방지)
5. **2 Good + 2 Bad 대조 예시** (Lampinen 2022 — 단독 positive 대비 +12%)
6. **Shared system_base.md** 중복 guardrail 추출

## 파일 구조

```
apps/abba/assets/prompts/
├── system_base.md           — 공통 원칙 (모든 섹션 공유, ~400 tokens)
├── prayer/
│   ├── summary_rubric.md
│   ├── scripture_rubric.md
│   ├── bible_story_rubric.md
│   ├── testimony_rubric.md
│   ├── guidance_rubric.md            (Pro)
│   ├── ai_prayer_rubric.md           (Pro)
│   └── historical_story_rubric.md    (Pro)
└── qt/
    ├── meditation_summary_rubric.md
    ├── application_rubric.md
    └── knowledge_rubric.md
```

**Prayer rubrics: 8개 (base + 7 sections)**
**QT rubrics: 4개 (base + 3 sections, coaching은 기존 qt_guide.md 재활용)**
**Total: 12개 파일**

## Rubric 템플릿 (개선된 버전)

```markdown
# [Section Name] Rubric

## 1. Purpose (2-3 lines)
[What this section outputs; for which prayer context.]

## 2. Forbidden Patterns (HIGHEST PRIORITY — first for primacy)
[Exact patterns that must never appear. Use target-locale literal strings + English equivalent.]

- "God promises you healing" / "하나님이 치유를 약속하셨습니다"
- "If you believe more, your prayer will be answered" / "믿음이 부족해서..."
- [10-12 items, locale-specific when needed]

## 3. Verification Gates (binary checks)
- [ ] Output length within 150-400 tokens
- [ ] Contains 1 scripture reference (English book name format)
- [ ] No forbidden patterns (grep check)
- [ ] Responds in specified locale

## 4. Scoring Rubric (anchor 1 / 3 / 5)
| Score | Criteria | Example |
|-------|----------|---------|
| 1 | [concrete failure mode] | [example] |
| 3 | [acceptable baseline] | [example] |
| 5 | [excellence] | [example] |

## 5. Few-Shot Examples (2 Good + 2 Bad)

### GOOD-1 (Korean)
User prayer: "아들이 수능 앞두고 긴장해요."
Output: "..."
Why good: [brief]

### GOOD-2 (English)
User prayer: "My mother is sick."
Output: "..."
Why good: [brief]

### BAD-1
User prayer: "..."
Output: "..."
Why bad: [specific rule violated]

### BAD-2
User prayer: "..."
Output: "..."
Why bad: [specific rule violated]

## 6. Tone Guidelines
- Reverent but warm
- Senior-friendly (short sentences, concrete imagery)
- No jargon
- Match locale's natural prayer register (see system_base §Per-Locale Registers)

## 7. Common Pitfalls (max 6)
1. [Pitfall] — [Mitigation]
2. ...

(Citations → shared system_base.md appendix)
```

## `system_base.md` 구조

```markdown
# Abba AI — System Base (Shared Across All Sections)

## 0. Core Principle: AI as Observer, Not Prophet
The AI NEVER:
- Speaks for God ("God is telling you X")
- Declares prophecy
- Pronounces absolution
- Judges user's prayer quality
- Promises specific outcomes (healing, prosperity, answers)

The AI ALWAYS:
- References scripture (does not add to it)
- Invites reflection
- Preserves user's concrete language
- Respects denominational diversity

## 1. Output Language
- Respond in {{LANG_NAME}} only — do not mix languages
- Bible references: English book name format ("Matthew 6:33"), never translated
- Verse text: provided by app from bundle, not generated

## 2. 15 Universal "Never Say" (All Sections)
[List of 15 forbidden patterns — see globalization.md]

## 3. Per-Locale Prayer Register
{{LOCALE_REGISTER_APPENDIX}}  ← dynamically inserted per locale

## 4. Coherence (Tier-based)
When context from previous tier is provided:
- Do NOT repeat scripture already selected in T1
- Do NOT duplicate bible_story across sections
- Build on, don't restate

## 5. Hallucination Defense
- Church history: only from curated whitelist (Augustine, Luther, Wesley, Müller, ten Boom, 주기철, etc.)
- Hebrew/Greek: require Strong's number; if uncertain, omit field
- Bible references: must match bundled translation
- Quotes: require verifiable source

## 6. Senior UX (50-70 target)
- Short sentences (12-18 words)
- Concrete imagery over abstraction
- No Gen-Z idioms
- Call user by name if provided ({{USER_NAME}})

## Appendix: Citations
- Fee & Stuart, How to Read the Bible for All Its Worth
- Carson, Exegetical Fallacies
- Vanhoozer, Is There a Meaning in This Text?
- [추가: 목사/학자 reviewer 3인 insight]
```

## 각 Rubric 요약 (실제 작성 시 참조)

### `summary_rubric.md` (~600 tokens)
- **Purpose**: Categorize user's prayer into gratitude/petition/intercession
- **Forbidden**: Adding categories user didn't express; abstracting concrete language
- **Scoring**: 1 = missing, 3 = 2 axes correct, 5 = all 3 + preserves user phrasing
- **Examples**: Korean prayer → categorized output; Spanish prayer → categorized

### `scripture_rubric.md` (~1000 tokens)
- **Purpose**: Select Bible verse matching user's prayer
- **Forbidden**: Translated book names; over-used verses (list of 15)
- **Gates**: English book format, not in over-used list, bundled translation
- **Scoring**: 1 = generic/irrelevant, 3 = thematic fit, 5 = specific + non-cliché
- **Pitfalls**: Proof-texting, over-use of Jer 29:11, translated names

### `bible_story_rubric.md` (~1000 tokens)
- **Purpose**: Retell Bible narrative relevant to user's prayer
- **Forbidden**: 5 common fabrications (3 wise men, whale, apple, etc.)
- **Gates**: Cites chapter:verse, uses bundled translation words, 3-4 sentences
- **Scoring**: 1 = fabricated details, 5 = textually accurate + concrete imagery

### `testimony_rubric.md` (~700 tokens)
- **Purpose**: Reorganize user's prayer into personal testimony narrative
- **Forbidden**: Spiritualizing ordinary requests; claiming answered prayers
- **Gates**: 1st person, 150-250 chars, preserves user phrasing
- **Scoring**: 1 = 3rd person/cold, 5 = warm 1st person with user's words

### `guidance_rubric.md` (Pro, ~1200 tokens)
- **Purpose**: Pastoral advice following 3P (Personal/Practical/Possible)
- **Forbidden**: "If you do X, God will Y" (prosperity), "You must" (prescriptive)
- **Gates**: One actionable suggestion, submission clause, empathy first
- **Scoring**: 1 = generic, 3 = one of 3P, 5 = all 3P + specific

### `ai_prayer_rubric.md` (Pro, ~1500 tokens)
- **Purpose**: AI-written 300-word prayer for the user
- **Forbidden**: Prosperity claims, guarantee of outcomes, cursing others
- **Gates**: Trinitarian closing, submission clause, ~300 words
- **Scoring**: 1 = formulaic, 5 = poetic + specific to user situation

### `historical_story_rubric.md` (Pro, ~1200 tokens)
- **Purpose**: Real church history narrative (Müller, Bonhoeffer, etc.)
- **Forbidden**: Fabricated quotes/dates; medieval legends w/o primary source
- **Gates**: Whitelist figure, verifiable date/place, one figure per story
- **Scoring**: 1 = unverifiable, 5 = concrete sensory + primary source

### `meditation_summary_rubric.md` (QT, ~700 tokens)
- **Purpose**: Summarize user's meditation on a Bible passage
- **Forbidden**: Adding insights user didn't express
- **Gates**: Cites user's concrete phrases, notes 3P readiness

### `application_rubric.md` (QT, ~1000 tokens)
- **Purpose**: Morning/day/evening 3P applications
- **Forbidden**: Abstract platitudes ("love more")
- **Gates**: Each action specific time/place/verb

### `knowledge_rubric.md` (QT, ~1000 tokens)
- **Purpose**: Historical context + cross-references + original words
- **Forbidden**: Made-up etymologies, false scholarly consensus
- **Gates**: Strong's numbers, cross-refs use bundled translation

## Token Budget

| File | Tokens |
|------|--------|
| system_base.md | 400 |
| Prayer × 7 | 7,000 (avg 1,000) |
| QT × 3 | 2,700 (avg 900) |
| **Total prayer cache** | **~7,400** |
| **Total qt cache** | **~3,100** |

Cache budget:
- Prayer: 7,400 tokens × $0.05/M = $0.00037 per cached call
- QT: 3,100 tokens × $0.05/M = $0.00016 per cached call
- Storage: Prayer $5.33/월, QT $2.23/월, total $7.56/월

## User Prompt (Runtime)

시스템 prompt = 캐시된 rubric. User prompt는 작고 동적:

```
Transcript: "{transcript}"
Locale: {{LOCALE_NAME}}
Mode: {{MODE}}  -- 'prayer' | 'qt'
Tier: {{TIER}}  -- 't1' | 't2' | 't3'
{% if tier != 't1' %}
Context from previous tiers:
{{T1_RESULT_SUMMARY}}
{% if tier == 't3' %}
{{T2_RESULT_SUMMARY}}
{% endif %}
{% endif %}
User name: {{USER_NAME}}  -- optional, may be empty
QT passage: {{QT_PASSAGE_REF}}  -- QT mode only
Is Pro: {{IS_PRO}}  -- 'true' | 'false'

Generate the {{TIER}} sections only. Output JSON matching the schema in system_base §Output Schema.
```

**평균 user prompt 크기**: ~500 tokens (transcript + context). 캐시 비용 영향 거의 없음.

## Writing 프로세스

Phase 4.1a에서 12개 파일 작성 순서:

1. `system_base.md` 먼저 (shared 원칙)
2. Prayer 7개 (summary → scripture → bible_story → testimony → guidance → ai_prayer → historical_story)
3. QT 3개 (meditation_summary → application → knowledge)

각 파일 작성 후:
- Token count 계산 (tiktoken 근사)
- 1200 token 상한 준수 확인
- Forbidden patterns 첫 section 배치 확인
- 2 Good + 2 Bad 예시 포함 확인
- **사용자 검토** (신학적 정확성)

## 업데이트 주기

Rubric 변경 시:
1. md 파일 수정 + commit
2. 앱 재배포 (rubric은 assets 번들)
3. 유저 앱 업데이트 후 첫 호출 → cache bundle hash 변경 감지 → 자동 재생성
4. 수동 `warm` 불필요 (lazy 재생성)

**권장 주기**: 출시 후 첫 6개월 월 1회 rubric 리뷰. 이후 분기 1회.
