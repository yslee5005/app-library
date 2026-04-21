# Feature: Prayer Output Redesign

> Status: draft · Owner: yslee5005 · Updated: 2026-04-21 · App: abba

## TL;DR

기도 완료 후 Dashboard에 표시되는 출력을 5개 phase로 재설계. 기존 카드 구조를 유지하되 각 카드의 깊이/정확도/교육 가치를 대폭 강화하고, 신규 "기도 코칭" 카드 추가. 각 phase는 독립 prompt + 독립 commit 단위로 구현.

## 전체 결정 사항 (사용자 승인 완료 2026-04-21)

| # | 결정 | 내용 |
|---|------|------|
| 1 | V1 Scope | **C** — Must + Should + Could 전부 V1. 단 phase 단위 순차 진행 (한 번에 몰아서 X) |
| 2 | Coaching 노출 | **Pro 전용** — 구독 유도 카드 |
| 3 | `prayer_guide.md` 초안 | **Claude 작성** (ACTS + 기도 원칙 + 평가 기준 MVP) |
| 4 | Testimony 이름 | **Dual label** — ARB에서 "Testimony / 기도 원문" 병기 + helper 텍스트 |
| 5 | AI Prayer TTS | **기능 제거** — audioUrl 필드 삭제, 텍스트만 표시 |

## Phase 구조 (5개, 순차 진행)

각 phase는 독립적으로 spec 작성 → 사용자 컨펌 → Ralph 구현 → flutter analyze → 다음 phase.

### Phase 1 · Core + Audio 이동
- **목표**: Prayer Summary에 기도 녹음 오디오 추가 / Testimony에서 오디오 제거 / Testimony 이름 dual label
- **변경 범위**: 2개 카드 위젯, model audioUrl 필드 이동, ARB 신규 ~5 키
- **Prompt Phase**: Core Analysis (기존 `analyzePrayerCore` 수정 — transcript + prayerSummary만)

### Phase 2 · Scripture Deep
- **목표**: Scripture 카드 확장 — `whyThisVerse` + `postureToRead` (녹색 배경) + `originalWords[]` 편입
- **변경 범위**: ScriptureCard 확장, OriginalLangCard 제거, ScriptureDeep 모델, ARB ~10 키
- **Prompt Phase**: Scripture Deep Analysis (신규 메서드)

### Phase 3 · Prayer Coaching (신규 카드)
- **목표**: 기도를 평가/교육하는 AI 조언 카드 (Pro 전용)
- **기반 자산**: `assets/docs/prayer_guide.md` — ACTS + 원칙 + 평가 rubric
- **변경 범위**: PrayerCoachingCard 신규, PrayerCoaching 모델, asset 추가, ARB ~8 키
- **Prompt Phase**: Prayer Coaching (system prompt에 prayer_guide.md 삽입)

### Phase 4 · Historical Deep
- **목표**: Historical Story 길게 (8-10문장) + "오늘의 교훈" 섹션
- **변경 범위**: HistoricalStoryCard 확장, HistoricalStoryDeep 모델, ARB ~3 키
- **Prompt Phase**: Historical Deep Analysis

### Phase 5 · AI Prayer Deep (TTS 제거)
- **목표**: 2분 분량(~300단어) + 명언/과학 사실/구체 예시 포함. **TTS 제거, 텍스트만**
- **변경 범위**: AiPrayerCard 재작성 (audio player 제거), AiPrayerDeep 모델, citations UI, ARB ~5 키
- **Prompt Phase**: AI Prayer Deep (명언/과학 풀 내장, citations 메타데이터 강제)

## 전체 변경 범위 (추산)

| 영역 | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 | 합계 |
|------|---------|---------|---------|---------|---------|------|
| Dart model | 1 | 2 | 2 | 1 | 1 | 7 |
| Dart widget | 2 | 2 (생성 1) | 1 신규 | 1 | 1 | 7 |
| gemini_service | 부분 | 메서드+1 | 메서드+1 | 메서드+1 | 메서드+1 | 5 메서드 |
| ARB keys (35 locale 각각) | ~5 | ~10 | ~8 | ~3 | ~5 | ~31 |
| Asset | 0 | 0 | 1 | 0 | 0 | 1 |
| Widget test | 2 | 2 | 1 | 1 | 1 | 7 |

## 데이터

@./_details/data_model.md

## 화면 (Empty / Loading / Error / Data)

@./_details/screens.md

## 인터랙션 매트릭스 (Ralph가 한 줄씩 구현)

@./_details/interactions.md

## l10n 사전 정의

@./_details/l10n_keys.md

## Prompt 명세 (Phase별 분리)

@./_details/prompts.md

## Prayer Guide Asset (Phase 3 의존)

@./_details/prayer_guide.md

## 이 feature 관련 함정 (learned-pitfalls 부분 link)

@./_details/pitfall_refs.md

## 검증 통과 기준 (Phase별 반복)

각 phase 완료 시:
- [ ] `flutter analyze apps/abba` 0 error/warning
- [ ] 해당 phase의 INT-XXX widget test 전부 통과
- [ ] `scripts/harness_check.sh apps/abba` 통과 (있는 경우)
- [ ] 사람 smoke test (해당 phase 카드 golden + edge case 1개)
- [ ] 해당 phase 신규 ARB 키가 35 locale 모두에 존재
- [ ] 사용자(yslee5005) 다음 phase 진행 승인

## 컨펌 게이트 (총 5개)

- [ ] Phase 1 spec 승인 → Ralph 구현 → 검증 통과 → "Phase 1 OK"
- [ ] Phase 2 spec 작성 → 승인 → 구현 → "Phase 2 OK"
- [ ] Phase 3 spec 작성 (+ prayer_guide.md 초안 검토) → 승인 → 구현 → "Phase 3 OK"
- [ ] Phase 4 spec 작성 → 승인 → 구현 → "Phase 4 OK"
- [ ] Phase 5 spec 작성 → 승인 → 구현 → "Phase 5 OK"

## 현재 상태

- [x] SPEC.md 전체 개요 작성 (2026-04-21)
- [x] Phase 1 `_details/*` 상세 작성 (2026-04-21)
- [x] Phase 1 사용자 승인 (2026-04-21)
- [x] Phase 1 구현 + commit `fea3f28` (2026-04-21)
- [x] Phase 2 `_details/*` 상세 작성 (2026-04-21)
- [x] Phase 2 사용자 승인 (2026-04-21)
- [x] Phase 2 구현 + commit `0ca34c3` (2026-04-21)
- [x] Phase 3 `_details/*` 상세 작성 + prayer_guide.md 초안 v0.1 (2026-04-21) ← 현재 여기
- [ ] **Phase 3 사용자 승인 (prayer_guide.md 중점 검토 필요)**
- [ ] Phase 3 Ralph 구현
- [ ] Phase 4~5 (대기)
