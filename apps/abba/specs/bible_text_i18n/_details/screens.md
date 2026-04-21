# Screens — bible_text_i18n

Phase 1만 상세. Phase 2-3은 해당 phase 진입 시 추가.

---

## Phase 1 · ScriptureCard 신구조

### Card: `ScriptureCard`

기존 카드 재설계. verse는 PD bundle lookup, keyWordHint 신규 섹션 추가.

| State | Visual | Notes |
|---|---|---|
| Empty | `reference` 빈 문자열 → 카드 자체 숨김 | 드문 케이스 |
| Loading | 상위 Loading 처리 | 변경 없음 |
| Error | 상위 Dashboard 에러 | 변경 없음 |
| **Data (verse 있음, PD 번들 있음)** | reference · verse(PD 본문, clean) · keyWordHint(✨) · reason(green) · posture(green) · originalWords(▼) | 정상 상태 |
| **Data (verse 없음, PD 번들 없음)** | reference · "나의 성경으로 찾아보세요" · keyWordHint · reason · posture · originalWords | fallback — ~25 locale |

### 레이아웃 (Data 상태, PD 번들 있음)

```
┌─────────────────────────────────────────┐
│ 📜 오늘의 말씀                           │
├─────────────────────────────────────────┤
│ 시편 23:1-3                              │  ← h2
│ (개역한글, Public Domain)                 │  ← caption muted italic
│                                          │
│ 여호와는 나의 목자시니 내게 부족함이       │  ← body 18pt, height 1.7
│ 없으리로다. 그가 나를 푸른 풀밭에 누이    │     PD 본문 그대로
│ 시며 쉴 만한 물가로 인도하시는도다. 내    │
│ 영혼을 소생시키시고 자기 이름을 위하여    │
│ 의의 길로 인도하시는도다.                 │
│                                          │
│ ┌─────────────────────────────────────┐│
│ │ ✨ 오늘의 핵심 단어                    ││  ← 신규 섹션
│ │ '나의 목자' = 히브리어 '로이' — 직업이││     softGold background α 0.1
│ │ 아닌 '나를 돌보시는 분'               ││     bodySmall warmBrown
│ └─────────────────────────────────────┘│
│                                          │
│ ┌─────────────────────────────────────┐│
│ │ ❓ 왜 이 말씀을                        ││  ← 기존 reason green box
│ │ 당신의 기도는 깊은 신뢰와 감사를...   ││
│ └─────────────────────────────────────┘│
│                                          │
│ ┌─────────────────────────────────────┐│
│ │ 🌿 어떤 마음으로                       ││  ← 기존 posture green box
│ │ 목자의 양이 되어 천천히...            ││
│ └─────────────────────────────────────┘│
│                                          │
│ [▼ 원어로 만나는 깊은 뜻 (2)]             │  ← Phase 2 expandable 유지
└─────────────────────────────────────────┘
```

### 레이아웃 (Data 상태, PD 번들 없음 — am/my/sw 등)

```
┌─────────────────────────────────────────┐
│ 📜 오늘의 말씀                           │
├─────────────────────────────────────────┤
│ Psalm 23:1-3                             │  ← reference 만
│                                          │
│ ┌─────────────────────────────────────┐│
│ │ 📖 나의 성경으로 이 말씀을 찾아        ││  ← fallback hint
│ │ 묵상해 보세요.                        ││     caption muted, 아이콘 center
│ └─────────────────────────────────────┘│
│                                          │
│ ✨ 오늘의 핵심 단어 (여전히 표시)          │  ← AI 창작이라 OK
│ ❓ 왜 이 말씀을                           │
│ 🌿 어떤 마음으로                          │
│ [▼ 원어로 만나는 깊은 뜻 (2)]             │
└─────────────────────────────────────────┘
```

### 신규 섹션 스펙: KeyWordHint (✨ 오늘의 핵심 단어)

- 위치: verse 본문 **바로 아래** (reason/posture **위**)
- 배경: `AbbaColors.softGold.withValues(alpha: 0.1)` (기존 sage green box와 다른 색 → 시각 구분)
- 아이콘: ✨ (sparkle)
- 라벨: `l10n.scriptureKeyWordHintTitle` = "오늘의 핵심 단어" / "Today's Key Word"
- 본문: `Scripture.keyWordHint` (bodySmall, warmBrown, height 1.5)
- `keyWordHint.isEmpty` → 섹션 자체 숨김
- Radius: `AbbaRadius.md`, Padding: `AbbaSpacing.md`

### Verse 본문 스펙 (typography)

- `AbbaTypography.body.copyWith(height: 1.7)` (Phase 4 HistoricalStory와 동일 수준)
- 색: `AbbaColors.warmBrown`
- 단락 구분은 PD bundle 원본 그대로 (`\n` 이 있으면 줄바꿈, 없으면 한 문단)
- selectable: false (복사 방지 — PD지만 앱 신뢰도)

### Attribution caption

- 위치: reference 아래
- 형식: `l10n.bibleTranslationAttribution` with namedArg `{name}` — 예: "(개역한글, Public Domain)"
- 스타일: `AbbaTypography.caption.copyWith(color: AbbaColors.muted, fontStyle: FontStyle.italic)`
- PD 번들 없을 때: 숨김 (attribution할 것이 없음)

### Responsive

- compact (< 600): verse 본문 폰트 그대로, keyWordHint 세로 full-width
- medium/expanded: 동일 — reading primarily mobile context
- overflow 체크: 긴 verse 범위 (예: 로마서 8:28-39 11절) compact 320dp 렌더 시 스크롤 정상

### RTL

- 히브리어 locale (`he`): verse 본문 자동 RTL
- keyWordHint 안 히브리어 word 자체는 RTL, 한국어/영어 설명은 LTR 섞임 가능 → Flutter Text 자동 처리

---

## Phase 2 · BibleStoryCard + GuidanceCard (예정)

### BibleStoryCard
- `.title(locale)` → `.title`, `.summary(locale)` → `.summary`
- 구조 기본 유지 (expandable, 요약)

### GuidanceCard
- `.content(locale)` → `.content`
- 구조 기본 유지 (ProBlur locked vs unlocked)

---

## Phase 3 · Settings Attribution Page (예정)

Settings 메뉴에 **"사용된 성경 번역본" 페이지** 신규 — 법적 attribution + 사용자 투명성.

```
┌───────────────────────────────────┐
│ ← 사용된 성경 번역본                │
├───────────────────────────────────┤
│ 이 앱의 성경 구절은 모두 공공 도메인│
│ 번역본을 사용합니다.                │
│                                    │
│ • 한국어: 개역한글 (1961, 2012     │
│   저작권 만료)                      │
│ • English: World English Bible     │
│   (Public Domain)                  │
│ • 日本語: 口語訳                    │
│ • 中文: 和合本                      │
│ • ... (전체 목록)                   │
│                                    │
│ AI가 생성하는 주석·기도·이야기는    │
│ Abba의 창작물입니다.                │
└───────────────────────────────────┘
```

## 참조

- `.claude/rules/responsive.md`
- `.claude/rules/flutter-layout.md`
- prayer_output_redesign/_details/screens.md (기존 ScriptureCard 레이아웃 참고)
