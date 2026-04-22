# Screens — qt_output_redesign

Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 작성.

---

## Phase 1 · 신규 카드 2 + 기존 재배치

### Card 1: `MeditationSummaryCard` (신규)

위치: QT Dashboard **맨 위** (Phase 2 Coaching 추가 후 2번째로 이동).

| State | Visual | Notes |
|---|---|---|
| **Empty** | `summary`/`topic` 둘 다 빈 문자열 → 카드 자체 숨김 | 드문 케이스 |
| **Loading** | 상위 Loading에서 처리 | |
| **Error** | 상위 Dashboard 에러 | |
| **Data** | 🌱 icon + summary (body 18pt) + topic (caption 14pt muted italic) | |

### 레이아웃 (Data)

```
┌──────────────────────────────────────┐
│ 🌱 오늘의 묵상                        │  ← AbbaTypography.h2
├──────────────────────────────────────┤
│ 하나님의 신실하신 인도하심 안에서     │  ← body 18pt, warmBrown, h 1.7
│ 안식을 발견하는 묵상                  │
│                                      │
│ · 목자 되신 여호와 ·                  │  ← caption 12pt, italic, muted
└──────────────────────────────────────┘
```

Responsive:
- compact (< 600): summary 2줄, topic 1줄
- medium 이상: 동일 + max-width 720

### Card 2: `QtScriptureCard` (기존 `ScriptureCard` 재사용)

bible_text_i18n에서 완성한 `ScriptureCard` 그대로 사용:
- `reference`, `verse` (PD bundle), `reason`, `posture`, `keyWordHint`, `originalWords`
- 차이: QT 맥락으로 `reason`/`posture` 문구가 묵상 용어. prompt에서 처리 — 위젯 변경 X.

**코드 재사용**: 0 변경. 그대로 재사용. 기존 31 locale 번들 lookup 자동 작동.

---

## Phase 1 · Dashboard 카드 순서 변경 (INT-109)

### Before (현재)

```
📜 Scripture verse (기존 scripture_card 아님, old-style)
📖 Meditation Analysis (key theme + insight)
✅ Application
🔤 Related Knowledge
📚 Growth Story (Pro)
```

### After (Phase 1)

```
🌱 MeditationSummaryCard (NEW)     ← Phase 1
📜 QtScriptureCard (REUSED)         ← Phase 1 (PD bundle + keyWordHint + originalWords)
📖 Meditation Analysis (기존)       ← Phase 5에서 축소
✅ Application (기존)                ← Phase 5 확장
🔤 Related Knowledge (기존)         ← Phase 5 축소
📚 Growth Story (Pro, 기존)         ← Phase 4 품질 강화
```

### Phase 2+ 이후 최종

```
🎯 QT Coaching (Pro)                 ← Phase 2 (맨 위)
🌱 Meditation Summary
📜 QT Scripture (Deep)
📖 Meditation Insight (축소)
✅ Application (1-3개)
💎 Citations (Pro)                   ← Phase 3
🔤 Related Knowledge (축소)
📖 Growth Story (Pro)                ← Phase 4
```

---

## Phase 2-5 카드 (예정)

### Phase 2 · QtCoachingCard
Prayer Coaching 카드 패턴 미러. ProBlur (Free) / loading / error(retry) / data.

### Phase 3 · QtCitationsCard
AI Prayer Citations 섹션을 별도 카드로. type별 아이콘 + 출처 + content.

### Phase 4 · GrowthStory 품질 강화
위젯 변경 없음. 본문 타이포그래피 승격 + 품질 바 prompt 적용.

### Phase 5 · Application 확장
action 1개 → 3개 (morning/day/evening) 토글 UI 또는 세로 목록.

---

## Responsive / RTL

- Scripture 재사용 → bible_text_i18n에서 검증된 responsive/RTL 그대로
- MeditationSummaryCard — 단순 구조라 responsive 이슈 없음

## 참조

- bible_text_i18n/_details/screens.md (Scripture Deep 구조)
- prayer_output_redesign/_details/screens.md (Coaching / Citations / HistoricalStory 패턴)
- `.claude/rules/responsive.md`
