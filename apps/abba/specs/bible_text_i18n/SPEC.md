# Feature: Bible Text i18n + Copyright Safety

> Status: draft · Owner: yslee5005 · Updated: 2026-04-21 · App: abba

## TL;DR

Abba의 Scripture / BibleStory / Guidance 카드를 **저작권 안전한 구조**로 재설계. 성경 구절 본문은 **공공 도메인 번역본**에서 lookup, AI는 **해설·이야기만 창작**. 동시에 prayer_output_redesign Phase 4-5에서 pilot한 **A-1 single-field i18n 패턴**을 Scripture/BibleStory/Guidance에도 확장.

## 배경 (왜 필요한가)

1. Abba는 Pro $6.99/mo **상업 앱** — 표준 번역본(개역개정/NIV/新共同訳) verbatim 사용은 **저작권 침해** 위험
2. 현재 hardcoded `"여호와는 나의 목자시니..."` 등 일부가 개역개정 기반 — 출시 전 조치 필요
3. Scripture/BibleStory/Guidance는 여전히 `_en`/`_ko` 이원 필드 → 33개 locale 유저가 실제로는 영어만 봄 (33-locale UX 버그)
4. Gemini가 verse text를 생성하면서 **표준 번역본 verbatim 가능성** 내재

## 전체 결정 사항 (사용자 승인 완료 2026-04-21)

| # | 결정 | 내용 |
|---|------|------|
| 1 | 저작권 전략 | **PD Bible + AI 해설 창작 하이브리드** (사용자 승인 A안) |
| 2 | Verse 생성 주체 | AI는 **reference만 선택**, verse text는 PD 번들 lookup |
| 3 | i18n 패턴 | Scripture/BibleStory/Guidance **A-1 single-field 확장** |
| 4 | 핵심단어 Hint | Scripture 본문 아래 ✨ **Scripture.keyWordHint** 신규 필드 |
| 5 | PD 배포 방식 | **Supabase Storage on-demand + 로컬 캐시** (앱 bundle 아님) |
| 6 | Supabase Bucket | 기존 **`abba` private bucket 재활용**, 신규 `bibles/` 폴더 + RLS SELECT 정책 추가 |
| 7 | KeyWordHint 위치 | verse 본문 **바로 아래** (사용자 원래 의도 살림) |
| 8 | Attribution | Settings 페이지 한 번만 (카드 clean 유지, PD라 법적 의무 없음) |
| 9 | Phase 분리 | Phase 1 = ko+en 2개 (파이프라인 검증) / Phase 3 = 나머지 25개 일괄 |
| 10 | PD 커버리지 | 27 locale 지원 예상 / 8 locale은 reference-only fallback |

## 범위 (5개 구역)

### 영역 A · Scripture 리팩터링 (가장 큼)
- `Scripture` 모델: `verseEn/Ko`, `reasonEn/Ko`, `postureEn/Ko` → 각 single-field
- `Scripture.keyWordHint` 신규 필드 (신규 UX 패턴, 사용자 아이디어)
- `Scripture.originalWords`는 기존 구조 유지 + 안전장치 강화
- `verse` 필드는 **AI 생성 금지** → `BibleTextService.lookup(reference, locale)` 로 조회

### 영역 B · BibleStory 리팩터링
- `BibleStory`: `titleEn/Ko`, `summaryEn/Ko` → single-field
- AI가 **이야기 요약**을 locale별로 직접 생성 (성경 본문 인용 최소화)

### 영역 C · Guidance 리팩터링
- `Guidance.contentEn/Ko` → 단일 `content`
- AI 창작물 (저작권 이슈 無)

### 영역 D · PD Bible Bundle 인프라
- `BibleTextService` 신규 서비스 (lookup by reference + locale)
- `assets/bibles/{locale}.json` — 공공 도메인 번역본 8-10개 bundle
- 지원 locale: ko(개역한글), en(WEB), es(Reina-Valera 1909), fr(Louis Segond 1910), de(Luther 1912), zh(和合本), ja(口語訳), pt(Almeida), it(Diodati 1821), ru(Synodal 1876)
- 미지원 locale (am, my, sw, hi 등 ~25개): **reference-only fallback**

### 영역 E · Hardcoded 감사 + 안전장치
- `_hardcodedPrayerResult` 내 모든 verse 텍스트 개역개정 잔재 점검 + PD 버전으로 교체
- Gemini prompt에 "Do NOT generate verse text verbatim — only select reference" 강조
- Sentry: `bible_text_not_found` (locale에 해당 reference 없을 때) 계측

## Phase 구조 (3개, 순차)

각 phase는 독립 spec + 사용자 승인 → 구현 → flutter analyze → 다음 phase.

### Phase 1 · Scripture 리팩터링 (core)
- `Scripture` single-field + `keyWordHint` 신규 + `BibleTextService` 최소 구현 (ko/en 2개 PD bundle)
- Gemini prompt: Scripture 섹션 schema 변경 (verse 생성 금지, reference만)
- Hardcoded 감사 + 교체
- Widget: ScriptureCard keyWordHint 섹션 추가

### Phase 2 · BibleStory + Guidance 리팩터링
- 두 모델 single-field 전환
- Gemini prompt: 두 섹션 schema 단일 필드
- Widget: `.title(locale)` 등 getter 호출 제거
- 여기까지 완료하면 prayer_output_redesign의 "모든 _en/_ko 이원 필드" 전환 완료

### Phase 3 · PD Bundle 확장 + Sentry + Attribution
- PD 번역본 8-10 locale로 확장 (각 ~5MB bundle)
- Settings 메뉴 "Bible translations used" attribution 페이지
- Sentry 계측 + 모니터링 dashboard
- 미지원 locale fallback UI polish

## 전체 변경 범위 (추산)

| 영역 | Phase 1 | Phase 2 | Phase 3 | 합계 |
|------|---------|---------|---------|------|
| Dart model | 1 (Scripture) | 2 (BibleStory, Guidance) | 0 | 3 |
| Dart widget | 1 (Scripture) | 2 (BibleStory, Guidance) | 1 (Settings) | 4 |
| Dart service | 1 (BibleTextService) | 0 | 1 (확장) | 2 |
| gemini_service 메서드 | 2 (prompts) | 2 (prompts) | 0 | 4 개 |
| Asset bundle | 2 (ko_krv, en_web) | 0 | 8 (나머지 locale) | ~10 |
| ARB keys (35 locale) | 2-3 신규 | 0 | 1-2 (attribution) | ~4-5 |

## 데이터

@./_details/data_model.md

## 화면 (4 상태 + Scripture 신구조)

@./_details/screens.md

## 인터랙션 매트릭스

@./_details/interactions.md

## l10n 사전 정의

@./_details/l10n_keys.md

## Prompt 명세

@./_details/prompts.md

## 이 feature 관련 함정

@./_details/pitfall_refs.md

## 검증 통과 기준 (Phase별)

- [ ] `flutter analyze apps/abba` 0 error/warning
- [ ] 해당 phase의 INT-XXX widget test 통과
- [ ] 사람 smoke test (신규 구조 golden + locale 3개 대표 점검)
- [ ] PD bundle 무결성 (각 파일 reference lookup 100 random sample → 100% 성공)
- [ ] Hardcoded verse 감사: 개역개정/NIV 문자열 grep 0 hits
- [ ] 사용자(yslee5005) 다음 phase 진행 승인

## 컨펌 게이트 (3개)

- [ ] Phase 1 spec 승인 → 구현 → "Phase 1 OK"
- [ ] Phase 2 spec 작성 → 승인 → 구현 → "Phase 2 OK"
- [ ] Phase 3 spec 작성 → 승인 → 구현 → "Phase 3 OK" → **feature 완료**

## 현재 상태

- [x] 사용자 전략 결정: A안 (PD bundle + AI 창작 하이브리드) (2026-04-21)
- [x] SPEC.md 전체 개요 작성 (2026-04-21)
- [x] Phase 1 `_details/*` 상세 작성 (2026-04-21) ← 현재 여기
- [ ] **Phase 1 사용자 승인 + "실행"**
- [ ] Phase 1 구현
- [ ] Phase 2~3 (대기)

## prayer_output_redesign과의 관계

- prayer_output_redesign은 완료됨 (2026-04-21, Phase 5 commit `eea3bac`)
- 본 feature는 **그 feature의 scope 밖 영역** (Scripture/BibleStory/Guidance 이원필드 + 저작권 안전)을 리팩터링
- HistoricalStory, AiPrayer, PrayerCoaching은 이미 single-field 완료 → 건드리지 않음
- PrayerSummary(감사/간구/중보)는 이미 locale-neutral list — 건드리지 않음
- QtMeditationResult는 scope 밖 (별도 feature 검토)
