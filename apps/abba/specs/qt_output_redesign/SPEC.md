# Feature: QT Output Redesign

> Status: draft · Owner: yslee5005 · Updated: 2026-04-21 · App: abba

## TL;DR

QT(묵상) Dashboard를 Prayer Dashboard와 동급 품질로 재설계. 기존 4카드 → 7카드. Prayer Coaching 패턴 미러하는 **QT Coaching (Pro)** 신규, AI Prayer Citations 패턴 미러하는 **Citations (Pro)**, 기존 **GrowthStory 유지 (Pro)**, Scripture Deep 패턴 재사용, PrayerResult 전체 i18n 통일 패턴 QT에도 완전 적용.

## 사용자 비전 (2026-04-21 대화 기반)

1. 묵상 분석을 기도 분석처럼 **한 마디로 요약**
2. QT 주제 + 본문 + 본문 해석
3. 본문 내 **원어 단어 의미**
4. 관련 자료 (역사/과학/유명 사건/감동 실화) + **명확한 출처**
5. **맨 위에 QT 평가** (웹서치 기반 4축 평가 기준 → qt_guide.md asset)
6. **힘이 되는 말** (qt_guide에 내장)
7. 각 locale별 알맞은 아웃풋
8. 합칠 수 있는 것 합치기 (코드/카드 일관성)

## 웹서치 결과 (2026-04-21) — QT 평가 기준

주요 방법론 확인:
- **Lectio Divina** (Read → Meditate → Pray → Contemplate)
- **SOAP** (Scripture → Observation → Application → Prayer)
- **PRAY** (Praise → Repent → Ask → Yield)
- **SPACE** (Sins · Promises · Actions · Commands · Examples) — George Müller
- **한국 QT (두란노 등)**: 적용 3P 원칙 (Personal · Practical · Possible)

핵심 가치: Simplicity · Regular · Sustainable · Honest. "적용 없는 QT는 QT 아니다."

## 전체 결정 사항 (사용자 승인 2026-04-21)

| # | 결정 | 내용 |
|---|------|------|
| 1 | 통합 패턴 | 5개 추천 전부 채택 |
| 2 | Application 카드 | 유지 (Coaching과 분리, 오늘의 행동 제안) |
| 3 | GrowthStory | 유지 (Pro, 긴 이야기 8-12문장) |
| 4 | Web search | 즉시 실행 (2026-04-21 완료, 4축 도출) |
| 5 | Pro 경계 | 3카드 Pro (Prayer와 대칭): Coaching / Citations / GrowthStory |
| 6 | QT Coaching 4축 | 본문 이해 / 개인 적용 / 영적 깊이 / 진정성 |
| 7 | qt_guide.md 구조 | prayer_guide.md 미러 (8 섹션) |
| 8 | i18n | 전 모델 single-field + locale별 Gemini 생성 |

## 최종 Dashboard 구조 (7 카드)

```
┌──────────────────────────────────────┐
│ 🎯 오늘의 묵상 코칭 (Pro)             │  ← Phase 2
│    [4 score bars + strengths +       │
│     improvements + overallFeedback + │
│     🌱/🌿/🌳 level badge]            │
├──────────────────────────────────────┤
│ 🌱 오늘의 묵상                        │  ← Phase 1
│    [한 마디 요약 + 주제]              │
├──────────────────────────────────────┤
│ 📜 오늘의 말씀                        │  ← Phase 1
│    [본문(PD) + ✨ 핵심 단어 +        │
│     ❓ 왜 + 🌿 어떻게 + ▼ 원어]      │
├──────────────────────────────────────┤
│ ✅ 오늘의 적용                        │  ← Phase 5
│    [morning/day/evening 3개 행동]    │
├──────────────────────────────────────┤
│ 💎 영감 주는 자료 (Pro)               │  ← Phase 3
│    [💭 quote / 🔬 science /           │
│     📜 history / ✨ example,         │
│     각 명확한 출처]                   │
├──────────────────────────────────────┤
│ 📖 성장 이야기 (Pro)                  │  ← Phase 4
│    [8-12 문장 감동 실화 + 교훈]      │
├──────────────────────────────────────┤
│ 🔤 관련 지식                          │  ← Phase 5 (축소)
│    [역사/문화 배경 + 교차 참조]      │
└──────────────────────────────────────┘
```

## Phase 구조 (5개, 순차)

### Phase 1 · Core (묵상 요약 + Scripture Deep)
- `MeditationSummary` 신규 모델 (summary + topic 단일 필드)
- `QtMeditationResult.scripture` 신규 필드 (기존 `Scripture` 재사용)
- `QtMeditationResult.meditationSummary` 신규 필드
- PD bundle lookup 재사용 (`BibleTextService`)
- `MeditationSummaryCard` 신규 + `QtScriptureCard` (기존 `ScriptureCard` 재사용)
- Gemini `analyzeMeditation` prompt 재설계 (Scripture Deep 필드 + meditationSummary + topic)

### Phase 2 · QT Coaching (Pro)
- `assets/docs/qt_guide.md` 신규 (prayer_guide.md 미러, 4축 기반)
- `QtCoaching` + `QtScores` 모델 신규 (Prayer Coaching 미러)
- `AiService.analyzeQtCoaching(transcript, locale)` 신규 메서드
- `qtCoachingProvider` (FutureProvider.autoDispose)
- `QtCoachingCard` 신규 widget (Prayer Coaching 미러)
- l10n 14 키 × 35 locale (Prayer Coaching과 동일 세트 QT 버전)

### Phase 3 · Citations (Pro)
- `Citation` 재사용 (기존 AiPrayer.citations 에서)
- `QtMeditationResult.citations: List<Citation>` 신규 필드
- Citation type 확장: `quote` / `science` / `history` / `example`
- `QtCitationsCard` 신규 widget (AiPrayer Citations section 패턴 재사용)
- Gemini prompt 확장: citations 배열 (최소 2 type, 최대 4)
- Hallucinate 방지 ★ (Phase 5 AI Prayer와 동일 엄격도)

### Phase 4 · GrowthStory 유지 + 품질 강화
- `GrowthStory` single-field 전환 (title/summary/lesson)
- 긴 이야기 품질 바: 8-12문장 / 감각 + 내면 + 구체적 시간/장소 (Historical Story 패턴)
- `_hardcodedMeditationResult(locale)` locale 분기
- hallucinate 방지 (실존 인물만)

### Phase 5 · 나머지 i18n 통일 + Application 확장 + 통합
- `MeditationAnalysis` → `meditationInsight` 단일 필드 (keyTheme은 Phase 1 summary로 흡수)
- `RelatedKnowledge.historicalContext` single-field
- `OriginalWord.meaning` single-field (단, Phase 1에서 `ScriptureOriginalWord` 로 이관 시 불필요)
- `ApplicationSuggestion` 확장: `morningAction`, `dayAction`, `eveningAction` 3개 (옵션)
- Dashboard 최종 카드 순서 + 기타 l10n + Supabase repo

## 전체 변경 범위 (추산)

| 영역 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 | 합계 |
|------|---------|---------|---------|---------|---------|------|
| Dart model | 2 신규 | 2 신규 | 0 (재사용) | 1 수정 | 3 수정 | 8 |
| Dart widget | 2 신규/1 재사용 | 1 신규 | 1 신규 | 1 수정 | 2 수정 | 7 |
| gemini_service | 재설계 | 메서드+1 | 메서드 확장 | 샘플 locale | schema 최종 | — |
| Asset | 0 | 1 (qt_guide.md) | 0 | 0 | 0 | 1 |
| ARB keys (35 locale) | ~4 | ~14 | ~5 | ~1 | ~3 | ~27 |

## 데이터

@./_details/data_model.md

## 화면

@./_details/screens.md

## 인터랙션 매트릭스

@./_details/interactions.md

## l10n

@./_details/l10n_keys.md

## Prompt 명세

@./_details/prompts.md

## qt_guide.md asset

@./_details/qt_guide.md

## 이 feature 관련 함정

@./_details/pitfall_refs.md

## 검증 통과 기준 (Phase별)

- [ ] `flutter analyze apps/abba` 0 error/warning
- [ ] 해당 phase의 INT-XXX widget test 통과
- [ ] 사람 smoke test (해당 phase 카드 + 35 locale 대표 3-4개 전환)
- [ ] qt_guide.md 반영 시 Sentry 샘플 fact-check (Phase 2, 3, 4)
- [ ] 사용자(yslee5005) 다음 phase 진행 승인

## 컨펌 게이트 (5개)

- [ ] Phase 1 spec 승인 → 구현 → "Phase 1 OK"
- [ ] Phase 2 spec 작성 → 승인 → 구현 → "Phase 2 OK"
- [ ] Phase 3 spec 작성 → 승인 → 구현 → "Phase 3 OK"
- [ ] Phase 4 spec 작성 → 승인 → 구현 → "Phase 4 OK"
- [ ] Phase 5 spec 작성 → 승인 → 구현 → "Phase 5 OK" → **feature 완료**

## 현재 상태

- [x] 사용자 비전 인터뷰 + 5 추천 채택 (2026-04-21)
- [x] Web search — QT 평가 기준 4축 도출 (2026-04-21)
- [x] SPEC.md 전체 개요 작성 (2026-04-21)
- [x] Phase 1 `_details/*` 초안 + qt_guide.md v0.1 (2026-04-21) ← 현재 여기
- [ ] **Phase 1 사용자 승인 (qt_guide.md 중점 검토)**
- [ ] Phase 1 구현 (Ralph 위임)
- [ ] Phase 2~5 (대기)

## 구현 정책 (CLAUDE.md 준수)

| 단계 | 담당 |
|------|------|
| Spec 작성 / 결정 / 설계 | Claude (직접) |
| qt_guide.md asset | Claude |
| **구현 (3+ 파일 수정)** | **Ralph agent** |
| flutter analyze / commit | Claude (감독) |
| smoke test | 사용자 |

## 관계된 기존 feature

- **prayer_output_redesign** (완료): Prayer Coaching, HistoricalStory, AiPrayer Citations — QT가 **미러 패턴 사용**
- **bible_text_i18n** (완료): PD Bible bundle 31 locale + `BibleTextService` — QT에서 **재사용** (추가 작업 0)
- **testimony single-field** (완료): i18n 통일 패턴 정착 — QT 모델에 동일 적용
