# Interaction Matrix

> Ralph가 한 줄씩 구현. 매 행 구현 전 Pitfall Tags 카테고리 `learned-pitfalls.md` 재독.
> Phase 1만 정의. Phase 2-5 INT-XXX는 해당 phase 진입 시 추가.

---

## Phase 1 · Core + Audio 이동 (INT-001 ~ INT-008)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-001 | `prayer_dashboard` | `[PrayerResult.model]` | build-time | `testimony` 필드를 `transcript`로 rename, `audioUrl` 필드를 최상위로 추가 | freezed 재생성 | `code-gen, riverpod-lifecycle` | pending |
| INT-002 | `prayer_dashboard` | `[PrayerResult.fromJson]` | deserialization | 기존 `testimony` 키 → `transcript` 호환 adapter 추가 | 기존 저장 데이터 호환 | `code-gen` | pending |
| INT-003 | `prayer_dashboard` | `[PrayerSummary.model]` | build-time | optional(?) 제거, 항상 non-null, fallback은 빈 리스트 3개 | freezed 재생성 + fallback 갱신 | `code-gen` | pending |
| INT-004 | `prayer_dashboard` | `[prayer_summary_card]` | build | 카드 하단에 **audio player bar** 렌더 (`audioUrl != null` 일 때만) | 기존 testimony audio 로직 이동 | `riverpod-lifecycle, dispose, color-token` | pending |
| INT-005 | `prayer_dashboard` | `[prayer_summary_audio_play_btn]` | `onTap` | 기도 녹음 재생/일시정지 토글 | `audioPlayerProvider.state = playing` | `riverpod-lifecycle, subscription-crash` | pending |
| INT-006 | `prayer_dashboard` | `[testimony_card]` | build | 제목을 `l10n.testimonyTitle` (dual label), 본문 위에 `l10n.testimonyHelperText` 추가, **audioUrl 파라미터 제거** | 기존 audio 로직 삭제 | `i18n, dead-code-sweep` | pending |
| INT-007 | `prayer_dashboard` | `[prayer_dashboard_view]` | build | `TestimonyCard(audioUrl: ...)` 호출 제거, `PrayerSummaryCard(audioUrl: ref.watch(...))`로 이동 | provider 참조 이동 | `riverpod-lifecycle, layer-violation` | pending |
| INT-008 | N/A | `[gemini_service.dart]` | runtime | `_hardcodedPrayerResult` / `_fallbackPrayerResult` / `_hardcodedTranscription` 를 새 구조(`transcript`, `audioUrl`)로 갱신 | hardcoded fallback 호환 | `code-gen` | pending |

## 컬럼 가이드

- **ID**: `INT-NNN` (3자리, 순서대로)
- **Screen**: `prayer_dashboard` = `prayer_dashboard_view.dart` 기준
- **Widget**: `[semantic_name]` — Key 또는 의미적 식별자
- **Trigger**: `build` / `onTap` / `build-time` (코드 생성) / `deserialization`
- **Pitfall Tags**:
  - `riverpod-lifecycle` (§1)
  - `subscription-crash` (§2) — 오디오가 Pro 기능과 연결될 수 있음
  - `i18n` (§4)
  - `dispose` (§1 세부) — 오디오 player controller dispose
  - `color-token` (§12)
  - `code-gen` (§16) — freezed/json_serializable/l10n 재생성
  - `dead-code-sweep` (§13)
  - `layer-violation` (§14)

## Ralph 실행 가이드

1. **매 행 구현 전** Pitfall Tags 카테고리 다시 읽기 (`learned-pitfalls.md`)
2. 구현 → 해당 INT 관련 widget test 작성 → 통과 시 status `done`
3. 모든 INT-001 ~ INT-008 완료 후:
   - `dart run build_runner build --delete-conflicting-outputs` (freezed/json)
   - `flutter gen-l10n` (ARB 신규 키 반영 — Phase 1 `_details/l10n_keys.md` 참조)
   - `flutter analyze apps/abba` 통과
   - `flutter test apps/abba` 통과
4. 모두 통과 → status `verified` → Phase 1 commit → 사용자 Phase 2 진행 승인 대기

## 테스트 매핑 (Phase 1)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-001, INT-002 | `test/models/prayer_result_test.dart` | `transcript` field 존재 + 기존 `testimony` JSON 역직렬화 호환 |
| INT-003 | `test/models/prayer_summary_test.dart` | `PrayerSummary()` default = 빈 리스트 3개 |
| INT-004, INT-005 | `test/features/dashboard/widgets/prayer_summary_card_test.dart` | 오디오 플레이어 렌더 / 재생 버튼 동작 / `audioUrl == null`에서 플레이어 숨김 |
| INT-006, INT-007 | `test/features/dashboard/widgets/testimony_card_test.dart` | Dual label 표시 / helper text 표시 / audio 위젯 없음 |
| INT-008 | `test/services/gemini_service_hardcoded_test.dart` | 하드코딩 응답이 `PrayerResult.transcript` / `PrayerResult.audioUrl` 반환 |

---

## Phase 2 · Scripture Deep (INT-009 ~ INT-016)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-009 | N/A | `[Scripture.model]` | build-time | `postureEn/Ko` 필드 + `originalWords: List<OriginalWord>` 추가 | fromJson 업데이트 | `code-gen` | pending |
| INT-010 | N/A | `[OriginalWord.model]` | build-time | 신규 클래스 (word, transliteration, language, meaningEn/Ko, nuanceEn/Ko + 로케일 getter) | fromJson | `code-gen` | pending |
| INT-011 | N/A | `[OriginalLanguage.model]` | build-time | **기존 클래스 완전 삭제**, PrayerResult.originalLanguage 필드도 제거, fromJson 모든 참조 제거 | dead code sweep | `code-gen, dead-code-sweep` | pending |
| INT-012 | `prayer_dashboard` | `[scripture_card]` | build | reason 섹션 아래에 **posture 녹색 박스** 렌더 (비어 있으면 숨김), 🌿 아이콘 + posture 라벨 + 본문 | 녹색 박스 2개 시각 구분 | `i18n, color-token` | pending |
| INT-013 | `prayer_dashboard` | `[scripture_card]` | build | posture 아래 **originalWords expandable 섹션** 렌더, 접힘 기본, 펼치면 각 word(원어 hero + transliteration + meaning + nuance) | `OriginalWord` 리스트 iterate | `i18n, color-token` | pending |
| INT-014 | `prayer_dashboard` | `[scripture_card]` | build | 히브리어(`language == 'Hebrew'`) word에 `textDirection: rtl` 적용 | RTL 렌더링 | `i18n` | pending |
| INT-015 | `prayer_dashboard` | `[prayer_dashboard_view]` | build | `OriginalLangCard` 참조 완전 제거 (import + StaggeredFadeIn 블록) | dead code | `dead-code-sweep` | pending |
| INT-016 | N/A | `[original_lang_card.dart]` | file-level | 파일 삭제 + `qt_dashboard_view.dart`, `prayer_dashboard_view.dart` import grep 검증 | file deletion | `dead-code-sweep` | pending |

### Phase 2 추가 구현 항목

- `gemini_service.dart`의 `_hardcodedPrayerResult()` Scripture 부분 업데이트: posture + originalWords 하드코딩 샘플 (예: ברך/barak, חסד/chesed)
- `gemini_service.dart`의 `_parsePrayerJson()` — 신규 필드 파싱 추가
- 기존 API 프롬프트 (`_buildSystemPrompt` 등) — posture + originalWords 필드 JSON schema 추가

### 테스트 매핑 (Phase 2)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-009, INT-010 | `test/models/scripture_test.dart` | Scripture fromJson 신규 필드 포함 / OriginalWord 구조 |
| INT-011 | `test/models/prayer_result_test.dart` | OriginalLanguage 참조 제거 확인 (컴파일 에러 없음) |
| INT-012, INT-013 | `test/features/dashboard/widgets/scripture_card_test.dart` | posture 녹색 박스 / originalWords expandable 접힘/펼침 |
| INT-014 | 위 파일 | 히브리어 RTL 렌더링 |
| INT-015, INT-016 | N/A | grep 검증 (`OriginalLangCard` 0 hits 확인) |

---

---

## Phase 3 · Prayer Coaching 신규 (INT-017 ~ INT-028)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-017 | N/A | `[PrayerCoaching.model]` | build-time | 신규 클래스 (scores, strengths, improvements, overallFeedbackEn/Ko, expertLevel, isPremium + fromJson + placeholder factory) | | `code-gen` | pending |
| INT-018 | N/A | `[CoachingScores.model]` | build-time | 신규 클래스 (specificity, godCenteredness, actsBalance, authenticity 모두 int 1-5, average getter) | | `code-gen` | pending |
| INT-019 | N/A | `[AiService.interface]` | build-time | `analyzePrayerCoaching(transcript, locale)` 메서드 인터페이스 추가 | | `code-gen` | pending |
| INT-020 | N/A | `[GeminiService]` | runtime | `analyzePrayerCoaching` 구현: system prompt = prayer_guide.md asset 로드 + JSON schema 지시, hardcoded fallback 추가 | asset rootBundle 로드 | `subscription-crash, code-gen` | pending |
| INT-021 | N/A | `[MockAiService, CachedAiService, OpenAIService]` | runtime | 동일 인터페이스 구현 (mock: hardcoded 반환, cached: 래핑) | | `code-gen` | pending |
| INT-022 | N/A | `[pubspec.yaml]` | build-time | `apps/abba/assets/docs/prayer_guide.md` asset 경로 등록 | asset 번들 포함 | `code-gen` | pending |
| INT-023 | N/A | `[prayer_guide.md asset file]` | file-level | `apps/abba/specs/prayer_output_redesign/_details/prayer_guide.md` → `apps/abba/assets/docs/prayer_guide.md` 복사 (사용자 승인된 버전) | 배포 자산 | `code-gen` | pending |
| INT-024 | `prayer_dashboard` | `[prayer_coaching_card]` | build | 신규 widget: 4 score bar + expertLevel 배지 + strengths/improvements 리스트 + overallFeedback. ProBlur 래핑 (isPremium && !isUserPremium) | | `subscription-crash, color-token, i18n` | pending |
| INT-025 | `prayer_dashboard` | `[prayer_dashboard_view]` | build | Coaching 카드 렌더 (Pro 카드 섹션 최상위에 배치 — Historical/AiPrayer 위) | provider watch | `riverpod-lifecycle` | pending |
| INT-026 | `prayer_dashboard` | `[prayer_coaching_provider]` | runtime | `FutureProvider<PrayerCoaching?>` — Pro 유저만 자동 fetch, autoDispose(keepAlive=false) | on-demand 호출 | `riverpod-lifecycle, subscription-crash` | pending |
| INT-027 | `prayer_dashboard` | `[prayer_coaching_card]` | `onTap` retry 버튼 | 에러 상태에서 provider invalidate → 재호출 | | `riverpod-lifecycle` | pending |
| INT-028 | N/A | `[l10n]` | build-time | 8 키 × 35 locale 추가 (coachingTitle / coachingScoreSpecificityLabel / coachingScoreGodCenterednessLabel / coachingScoreActsBalanceLabel / coachingScoreAuthenticityLabel / coachingStrengthsTitle / coachingImprovementsTitle / coachingExpertLevel{Beginner,Growing,Expert}) | | `i18n, code-gen` | pending |

### Phase 3 추가 작업

- `_hardcodedCoachingResult()` gemini_service에 추가
- `PrayerResult.fromJson` - `coaching` 키 파싱 추가 (옵션: 저장 안 하면 불필요, MVP는 생략)

### 테스트 매핑 (Phase 3)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-017, INT-018 | `test/models/prayer_coaching_test.dart` | fromJson / scores average / placeholder factory |
| INT-020 | `test/services/gemini_service_coaching_test.dart` | hardcoded result 구조 / asset 로드 테스트 |
| INT-024 | `test/features/dashboard/widgets/prayer_coaching_card_test.dart` | Pro locked ProBlur 렌더 / Pro data 상태 전체 렌더 / loading 상태 / error 상태 retry |
| INT-026 | `test/features/dashboard/providers/prayer_coaching_provider_test.dart` | Pro 유저 autoDispose 동작 / Free 유저 skip |

---

## Phase 4 · Historical Deep (INT-029 ~ INT-037) — A-1 single-field

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-029 | N/A | `[HistoricalStory.model]` | build-time | `titleEn/Ko`, `summaryEn/Ko`, `lessonEn/Ko` 3쌍 → 단일 `title`/`summary`/`lesson` 로 통합. `reference`, `isPremium` 유지. locale getter 3개 제거 | model API 변경 | `code-gen, dead-code-sweep` | pending |
| INT-030 | N/A | `[HistoricalStory.fromJson]` | deserialization | 3단 fallback: `json['title']` → `json['title_en']` → `json['title_ko']` → `''`. summary/lesson도 동일 패턴 | legacy DB compat | `code-gen` | pending |
| INT-031 | N/A | `[HistoricalStory.placeholder]` | runtime | `placeholder()` → `placeholder(String locale)` 로 변경. locale=='ko'면 한국어 샘플, 그 외 영어 샘플 | API 변경 | `code-gen` | pending |
| INT-032 | N/A | `[gemini_service._buildPremiumSystemPrompt]` | runtime | historical_story JSON schema를 single-field (`title`/`summary`/`lesson`, 사용자 locale)로 변경. 품질 바 지시 강화: "8-10 문장, 한 문장=한 장면, 감각+내면+구체적 시간/장소", "실존 인물/사건만, 불확실하면 다른 이야기 선택" | 프롬프트 품질 향상 | `subscription-crash` | pending |
| INT-033 | N/A | `[gemini_service._buildSystemPrompt]` | runtime | 전체 분석 프롬프트(`analyzePrayer`)의 historical_story 섹션도 동일 single-field schema + 품질 지시 반영 | | `subscription-crash` | pending |
| INT-034 | N/A | `[gemini_service._hardcodedPrayerResult]` | runtime | 시그니처 `_hardcodedPrayerResult(String locale)` 로 변경. HistoricalStory 샘플을 locale-aware로 (ko / en 2가지, 영어 샘플은 George Müller 문체 리라이트로 8-10 문장 품질 기준 제시) | hardcoded API 변경 | `code-gen` | pending |
| INT-035 | N/A | `[gemini_service callers]` | runtime | `_hardcodedPrayerResult()` / `_fallbackPrayerResult()` 호출부 전부 `locale` 전달. `analyzePrayer`, `analyzePrayerCore`, `analyzePrayerFromAudio`, `analyzePrayerPremium` 각 경로에서 각자 받은 locale 인자 사용 | 호출 체인 업데이트 | `code-gen` | pending |
| INT-036 | `prayer_dashboard` | `[historical_story_card]` | build | `.title(locale)` / `.summary(locale)` / `.lesson(locale)` 호출 전부 `.title` / `.summary` / `.lesson` 로 변경. `placeholder()` → `placeholder(locale)` 호출로 변경. summary Text typography `bodySmall` → `body.copyWith(height: 1.7)` 승격, lesson 박스 padding `sm` → `md` 증가, lessonLabel `caption` → `label` 승격 | 긴 텍스트 가독성 + API 변경 반영 | `color-token, flutter-layout, dead-code-sweep` | pending |
| INT-037 | `prayer_dashboard` | `[prayer_dashboard_view]` | build | `HistoricalStory.placeholder()` 호출부를 `HistoricalStory.placeholder(locale)` 로 변경 | locale prop 전달 | `code-gen` | pending |

### Phase 4 추가 작업

- `MockAiService.analyzePrayer` 하드코딩 샘플: single-field로 업데이트 (MockDataService가 JSON mock 쓰는 경우 그쪽도 업데이트 필요 — `assets/mock/prayer_result.json`)
- `_parsePrayerJson` / `_parsePremiumJson`: 변경 없음 (HistoricalStory.fromJson이 legacy compat 처리)
- Grep 검증: `grep -r "titleEn\|titleKo\|summaryEn\|summaryKo\|lessonEn\|lessonKo" apps/abba/lib/` → HistoricalStory 관련 참조가 모두 제거됐는지 (Scripture/BibleStory/Guidance 등 다른 모델의 동명 필드는 그대로 유지)
- l10n 신규 키 **0개**

### 테스트 매핑 (Phase 4)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-029, INT-030 | `test/models/prayer_test.dart` | HistoricalStory.fromJson new format, legacy `_en`, legacy `_ko` 3가지 입력에서 크래시 없이 값 추출 |
| INT-031 | 위 파일 | `placeholder('ko')` vs `placeholder('en')` 언어 선택 검증 |
| INT-034 | `test/services/gemini_service_hardcoded_test.dart` (있으면) | `_hardcodedPrayerResult('ko')` / `_hardcodedPrayerResult('en')` 호출 시 HistoricalStory summary가 locale-appropriate인지 |
| INT-036, INT-037 | `test/features/dashboard/widgets/historical_story_card_test.dart` (신규 또는 기존) | 긴 summary (500자) overflow 없음 (compact 320dp, medium 768dp), placeholder 렌더 |

---

## Phase 5 INT-XXX (추가 예정)

Phase 4 done 후 Phase 5 spec 작성 시 INT-034부터 이어서 할당.
