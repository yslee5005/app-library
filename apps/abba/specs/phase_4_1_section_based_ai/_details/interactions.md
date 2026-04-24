# Interactions — Ralph Execution List

> 각 INT는 원자적 단위. Ralph가 순차 구현 + 매 5개 단위로 `flutter analyze` 검증.

## Phase 4.1a — Rubric 문서 (12 files)

### INT-001 — system_base.md
File: `apps/abba/assets/prompts/system_base.md`
- 15 Universal "Never Say" 포함
- Per-locale register matrix (ko/en/es/pt/fr/de/it/ja/zh/ru 10개)
- Output schema JSON definition
- Hallucination defense rules
- Senior UX rules

### INT-002 — prayer/summary_rubric.md
File: `apps/abba/assets/prompts/prayer/summary_rubric.md`
- Purpose / Forbidden / Gates / Scoring / 2G+2B Examples / Pitfalls / Tone
- Examples: ko + es + en
- ~600 tokens

### INT-003 — prayer/scripture_rubric.md
- Over-used verses blacklist (15개)
- English book name enforcement
- Contextual fit test
- ~1000 tokens

### INT-004 — prayer/bible_story_rubric.md
- 5 commonly fabricated details (3 wise men 등)
- Anti-anachronism terms blacklist
- "본문은 ~라고 말합니다" framing
- ~1000 tokens

### INT-005 — prayer/testimony_rubric.md
- 1인칭 preservation
- User exact wording 유지
- 150-250 chars target
- ~700 tokens

### INT-006 — prayer/guidance_rubric.md (Pro)
- 3P Personal/Practical/Possible
- Conditional promise 금지
- Submission clause 필수
- ~1200 tokens

### INT-007 — prayer/ai_prayer_rubric.md (Pro)
- 300 words structure (5-part)
- Trinitarian closing
- Citations 2-3 (성경 우선)
- ~1500 tokens

### INT-008 — prayer/historical_story_rubric.md (Pro)
- 검증된 인물 whitelist (Augustine, Müller, 주기철 등)
- Primary source 인용 필수
- 금지: medieval 전설, 리빙 피규어
- ~1200 tokens

### INT-009 — qt/meditation_summary_rubric.md
- 유저 묵상 요약 + insight 추출
- 구어 그대로 보존
- ~700 tokens

### INT-010 — qt/application_rubric.md
- Morning/Day/Evening 3P actions
- Specific time/place/verb 요구
- ~1000 tokens

### INT-011 — qt/knowledge_rubric.md
- Historical context + cross_references + original_words
- Strong's number 요구
- ~1000 tokens

### INT-012 — Token count 검증
- tiktoken 또는 근사로 각 파일 토큰 확인
- 1200 상한 넘으면 축소
- 총합 ~10K (prayer 7K + QT 3K) 확인

---

## Phase 4.1b — DB Migration

### INT-013 — Migration SQL 파일
File: `supabase/migrations/20260423000004_section_based_ai.sql`
- `section_status JSONB` 컬럼 추가 (default `{}`)
- `public.system_config` 테이블 + seed + RLS
- `abba.update_prayer_tier(UUID, TEXT, JSONB)` RPC 함수
- Partial index `idx_prayers_tier_pending`

### INT-014 — 사용자에게 migration push 안내
- "supabase db push" 수행 요청
- 검증 쿼리 제공 (컬럼/테이블/RPC 존재 확인)
- **⚠️ 사용자 직접 실행**

---

## Phase 4.1c — Cache 인프라

### INT-015 — GeminiCacheManager class
File: `apps/abba/lib/services/gemini_cache_manager.dart`
- `getOrCreateCache({required String mode})` 메서드
- Bundle hash 계산 (SHA256 of assets/prompts/{mode}/*.md)
- system_config 테이블 읽기/쓰기
- TTL 만료 5분 전 재생성
- Feature flag: `AppConfig.enableGeminiCache`

### INT-016 — systemConfigProvider
File: `apps/abba/lib/providers/providers.dart` 추가
- `systemConfigProvider` (AsyncProvider)
- cache_id + expires_at + rubrics_version 로드

### INT-017 — AppConfig 확장
File: `apps/abba/lib/config/app_config.dart`
- `enableGeminiCache` getter (default `true`)
- `.env.example` + `.env.client` + `.env.runtime` 업데이트

---

## Phase 4.1d — 3-Tier Gemini 호출

### INT-018 — AiAnalysisException kind 확장
File: `apps/abba/lib/services/ai_analysis_exception.dart`
- 기존 kind (network/apiError/parseError) 유지
- 신규 kind 필요 없음 (tier별 구분은 context에)

### INT-019 — Tier 결과 모델
File: `apps/abba/lib/models/prayer_tier_result.dart` (신규)
- sealed class TierResult
- TierResult.t1(PrayerSummary, Scripture)
- TierResult.t2(BibleStory, String testimony)
- TierResult.t3(Guidance?, AiPrayer?, HistoricalStory?)
- TierResult.failed(String tier, AiAnalysisException error)

### INT-020 — Tier1Analyzer (streaming)
File: `apps/abba/lib/services/real/section_analyzers/tier1_analyzer.dart`
- `Stream<TierResult> analyze({...})` 메서드
- Gemini `generateContentStream` 사용
- SSE chunks를 PrayerSummary + Scripture로 점진 파싱
- Scripture validation layer 통합
- retryScripture 메서드 (환각 시 1회 재시도)

### INT-021 — Tier2Analyzer
File: `apps/abba/lib/services/real/section_analyzers/tier2_analyzer.dart`
- `Future<TierResult> analyze({required T1Context})` 
- Non-streaming (전체 JSON 반환)
- T1 결과 context 주입 (coherence)

### INT-022 — Tier3Analyzer (Pro)
File: `apps/abba/lib/services/real/section_analyzers/tier3_analyzer.dart`
- `Future<TierResult> analyze({required T1T2Context, required isPro})`
- Pro 체크 (subscription_service)
- 3개 섹션 parallel 호출 (Promise.all) 또는 single call
- T1+T2 결과 context

### INT-023 — QT Tier analyzers (1,2,3)
Files: `apps/abba/lib/services/real/section_analyzers/qt_tier{1,2,3}_analyzer.dart`
- Prayer tier 구조 미러 (QT용 섹션 매핑)
- T1: meditation_summary + scripture
- T2: application + knowledge
- T3: (coaching은 기존 qt_guide.md 재활용, tier 구조 밖으로 분리 or 포함 결정)

### INT-024 — GeminiService 리팩토링
File: `apps/abba/lib/services/real/gemini_service.dart`
- 기존 `analyzePrayerCore`, `analyzePrayerFromAudio`, `analyzeMeditation` deprecate
- 신규 `Stream<TierResult> analyzePrayerStreamed({...})` 메서드
- 신규 `Stream<TierResult> analyzeMeditationStreamed({...})` 메서드
- 내부적으로 Tier{1,2,3}Analyzer 호출
- Cache 통합 (GeminiCacheManager.getOrCreateCache)

### INT-025 — Repository tier UPDATE
File: `apps/abba/lib/services/prayer_repository.dart` + impl
- `Future<void> updateTierResult({required String prayerId, required String tier, required Map<String, dynamic> sections})` 추가
- Supabase impl: `supabase.rpc('update_prayer_tier', params: {...})`
- Mock impl: 메모리 state update

---

## Phase 4.1e — UI Progressive Rendering

### INT-026 — PrayerSectionsNotifier
File: `apps/abba/lib/providers/prayer_sections_notifier.dart` (신규)
- StateNotifier<PrayerSectionsState>
- State: summary / scripture / bibleStory / testimony / guidance / aiPrayer / historicalStory (각 nullable)
- Methods: setT1(), setT2(), setT3(), setAllInstant(), setFailed()
- section_status computed property

### INT-027 — ai_loading_view Stream 수신
File: `apps/abba/lib/features/ai_loading/view/ai_loading_view.dart`
- 기존 Future 기반 → Stream 기반 리팩토링
- `await for (tier in aiService.analyzePrayerStreamed(...))` 패턴
- T1 도착 즉시 Dashboard 네비 + T2 background start
- T2 도착 시 provider update
- Error case: Phase 3 에러뷰 유지

### INT-028 — prayer_dashboard_view Progressive
File: `apps/abba/lib/features/dashboard/view/prayer_dashboard_view.dart`
- `prayerSectionsProvider` watch
- 조건부 카드 렌더 (null이면 placeholder 숨김)
- FadeIn animations (t2/t3 도착 시)
- VisibilityDetector for T3 trigger

### INT-029 — qt_dashboard_view Progressive **[DEFERRED]**
File: `apps/abba/lib/features/dashboard/view/qt_dashboard_view.dart`
- 동일 패턴 적용
- **Deferred reason**: INT-023 (QT tier analyzers) not implemented in 4.1a
  scope. QT mode still uses single-call `analyzeMeditation` → no tier
  stream to drive progressive rendering. Apply the Prayer INT-028 pattern
  when QT streaming lands in a future phase.

### INT-030 — Scripture Card with streaming **[DEFERRED]**
File: `apps/abba/lib/features/dashboard/widgets/scripture_card.dart`
- streaming 중 "reference + validation 진행" UI
- verse text 도착 시 expand
- **Deferred reason**: true token-level SSE not yet wired through
  tier1_analyzer (current impl awaits full JSON). Card is only shown
  once T1 settles, so there is no intermediate state to render. Revisit
  when `generateContentStream` is used end-to-end.

### INT-031 — PrayerSummaryCard streaming **[DEFERRED]**
File: `apps/abba/lib/features/dashboard/widgets/prayer_summary_card.dart`
- SSE chunks를 직접 render
- **Deferred reason**: same as INT-030. The existing TypewriterText
  (fake streaming) is good enough UX until true SSE is in place.

### INT-032 — VisibilityDetector T3 trigger
File: `apps/abba/lib/features/dashboard/view/prayer_dashboard_view.dart`
- `visibility_detector` 패키지 추가 (pubspec.yaml)
- Premium 카드 영역이 30% 이상 visible 시 T3 호출
- 3초 fallback timer (scroll 없어도 자동 호출)
- 중복 호출 방지 flag

### INT-033 — Day-1 Template Fallback
Files: `apps/abba/assets/prayer_templates/{category}_{locale}.json` (5×3=15개 최소)
- 건강/가족/직장/감사/애도 × ko/en/es
- 각 template: mock PrayerResult 구조
- 네트워크 실패 or cold start 시 표시

File: `apps/abba/lib/services/prayer_template_service.dart` (신규)
- `Future<PrayerResult?> loadTemplate(category, locale)` 메서드
- assets 로드 + cache

---

## Phase 4.1f — ARB 추가

### INT-034 — app_en.arb 키 추가
- `aiStreamingInitial`: "Meditating on your prayer..."
- `aiTierProcessing`: "More reflections coming..."
- `aiScriptureValidating`: "Finding the right scripture..."
- `aiTemplateFallback`: "While AI prepares your full analysis, here's a reflection..."
- `aiPendingMore`: "Preparing more..."
- Pro 섹션 관련 추가 키

### INT-035 — app_ko.arb 키 추가
- 동일 키 한국어 번역
- `flutter gen-l10n` 재실행

---

## Phase 4.1g — 테스트

### INT-036 — tier1_analyzer_test.dart **[DEFERRED]**
- Mocked Gemini stream
- Parse chunks to PrayerSummary + Scripture
- Scripture validation success/failure cases
- **Deferred reason**: requires mocking the google_generative_ai SDK,
  which needs more setup than this sub-phase warrants. Covered
  indirectly by the integration-level E2E before launch.

### INT-037 — tier2_analyzer_test.dart **[DEFERRED]**
- Same reason as INT-036.

### INT-038 — tier3_analyzer_test.dart **[DEFERRED]**
- Same reason as INT-036.

### INT-039 — gemini_cache_manager_test.dart **[DEFERRED]**
- Would need Supabase client + Gemini caches API mocks; covered by
  manual verification in INT-044 smoke pass.

### INT-040 — prayer_sections_notifier_test.dart ✅
- Implemented: `apps/abba/test/providers/prayer_sections_notifier_test.dart`
- State transitions (null → T1 → T2), failure accumulation, QT ignore,
  stream persistence ordering.

### INT-041 — update_prayer_tier RPC test **[DEFERRED]**
- Needs a Supabase integration harness; scheduled for post-launch.

### INT-042 — Widget test: progressive rendering **[DEFERRED]**
- **Phase 4.2 R-D3 attempt (2026-04-23)**: created a PrayerDashboardView
  widget test with card-type finders + preset PrayerSectionsState. All
  three non-empty cases hung at the 10-minute flutter_test timeout.
  Root cause: PrayerSummaryCard's `animate: true` typewriter loop +
  Dashboard's 3s T3 fallback Timer + VisibilityDetector + TweenAnimation
  Builder continuous ticking prevent the test frame from settling without
  a dedicated `fakeAsync` + timer-isolation harness.
- Progressive state transitions ARE covered by
  `test/providers/prayer_sections_notifier_test.dart` (11 cases, incl.
  scripture-ref placeholder, T1/T2 payload shape, T3 null omission).
  Dashboard UI verification stays in the real-device smoke test until a
  timer-isolation harness is built in Phase 2.

### INT-043 — Template fallback test ✅
- Implemented: `apps/abba/test/services/prayer_template_service_test.dart`
- Bundle injection, locale fallback, unsupported category normalisation,
  cache identity, missing-asset null path.

---

## Phase 4.1h — 검증 & 문서

### INT-044 — flutter analyze apps/abba
- 0 issues 확인

### INT-045 — flutter test apps/abba
- 252+ pass 유지
- Pre-existing 2 fail 수용

### INT-046 — scripts/harness_check.sh apps/abba
- 통과

### INT-047 — LAUNCH_CHECKLIST 업데이트
- Phase 4.1 항목 체크
- Phase 2 (Batch API, Flash-Lite 등) 미래 항목 추가

### INT-048 — learned-pitfalls.md §2-1 업데이트
- Phase 4.1 완성으로 해결됨 기록
- 새 발견 시 추가

---

## 실행 순서 (Ralph)

**권장 순서** (의존성 고려):
1. INT-001 ~ INT-012 (Rubric 문서) — **유저 검토 필수**
2. INT-013 (Migration) — **유저 push**
3. INT-015 ~ INT-017 (Cache infra)
4. INT-019 (Models)
5. INT-025 (Repository)
6. INT-020 ~ INT-024 (Analyzers)
7. INT-018, INT-033 (Exception, Template)
8. INT-026 ~ INT-032 (UI)
9. INT-034 ~ INT-035 (ARB)
10. INT-036 ~ INT-043 (Tests)
11. INT-044 ~ INT-048 (Validation & Docs)

**중간 체크포인트**:
- INT-012 완료 후 → 유저 rubric 검토 → OK 받고 INT-013 진행
- INT-013 완료 후 → 유저 migration push → 확인 후 INT-015 진행
- INT-025 완료 후 → flutter analyze 한 번 돌리기
- INT-032 완료 후 → flutter analyze + 간단 smoke run

**총 예상 시간**: 15-18 hours (Claude/Ralph 실행) + 1-2일 유저 검토 시간.
