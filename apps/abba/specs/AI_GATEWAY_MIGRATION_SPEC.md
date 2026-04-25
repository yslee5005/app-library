# EDGE_AI_GATEWAY.md — Abba AI Gateway 마이그레이션 설계

> Status: draft | App: abba | Updated: 2026-04-25
>
> 모든 Gemini AI 호출을 Flutter 직접 호출에서 Supabase Edge Function 게이트웨이로 점진 이전. 5인 리뷰 + 사용자 5개 지적 반영 v_final.

---

## 1. 한 줄 목적

**클라이언트는 "기도/QT를 보내고 결과를 받는" 단순 역할만 하고, AI 정책(프롬프트·캐싱·검증·요금·권한·관측)은 모두 서버에 둔다.**

---

## 2. 왜 바꾸나 (5가지 동기, 우선순위 순)

1. **API 키 보호** — 현재 `GEMINI_API_KEY`가 IPA/APK에 평문 자산으로 박혀 있어 누구나 추출 가능. TestFlight 시점부터 burnable. 서버에만 두면 영구 차단.
2. **프롬프트 핫패치** — rubric/sanitizer 한 줄 바꾸려면 현재는 앱 재배포(Apple 심사 1-3일). 서버에 두면 즉시 반영.
3. **비용 절감** — Gemini explicit cachedContents 활용 시 system instruction(rubric ~10k tokens) input 비용 90% 할인. prayer 1건당 약 $0.017 → $0.009 (~48% 절감). 클라에서는 SDK 한계로 못 씀.
4. **에러/관측 정규화** — 현재 Flutter는 SDK 예외 종류로 분기. 서버에서 정규 에러 코드(AI_TIMEOUT/AI_QUOTA/NETWORK)로 통일하면 시니어 카피 분기 깔끔. cachedContentTokenCount 등 telemetry도 서버에서만 측정 가능.
5. **deprecated SDK 탈출** — `google_generative_ai 0.4.7`은 Google 공식 deprecated. 의존성 제거.

---

## 3. 무엇이 바뀌나 (비즈니스 흐름)

### 3-1. 현재 (As-Is)
```
유저 기도 입력
  → Flutter 앱이 직접 Gemini API 호출 (.env.runtime의 키 사용)
  → 시스템 프롬프트(rubric .md 번들 ~10k 토큰) 매 호출 inline 전송
  → Tier1/2/3 분석 결과를 Flutter 안에서 hallucination 필터로 후처리
  → DB에 저장
```
- 키 노출, 비용 풀 가격, 프롬프트 변경 = 앱 재배포

### 3-2. 목표 (To-Be) — **job-first async**

원칙: Edge는 동기 호출이 아니라 **job 생성 → 별도 processor가 처리 → 앱은 job_id로 구독/조회**.

```
[Phase 1: Job 생성 — 앱 ↔ start-analysis Edge]
유저 기도 입력
  → Flutter가 start-analysis Edge 호출 (transcript + idempotency_key)
       1) JWT 검증 + 유저 식별 (auth_guard)
       2) entitlement 확인 (Pro/Trial/Free)
       3) quota 차감 — DB 원자 RPC (Free 1/일, Trial 3/일)
       4) idempotency_key로 중복 탭 방어 (같은 key면 기존 job_id 반환)
       5) abba.analysis_jobs row INSERT (status='queued', tier='t1', user_id, transcript, ...)
       6) 즉시 job_id 반환 (~200-300ms)
  → Flutter: job_id 받음 → 즉시 ai_loading 화면 + 애니메이션 시작

[Phase 2: 처리 — analysis-processor Edge (별도 트리거)]
  Trigger: pg_trigger AFTER INSERT 또는 pg_cron 짧은 주기 또는
           start-analysis가 비동기로 invoke (response와 분리된 호출)
  Process:
    1) status='running' UPDATE
    2) DB에서 base rubric body + locale policy 조회 (Edge memory fast path)
    3) Gemini cache 조회·생성 (system instruction = cachedContents)
    4) Gemini REST 호출 (T1 SSE / T2·T3 normal)
    5) partial event 발생 시 abba.analysis_job_events INSERT (T1 streaming용)
    6) 응답에 hallucination 필터·sanitizer 적용
    7) result JSONB 저장 + status='completed' UPDATE
    8) 실패 시 status='failed' + error_code 저장 + retry_count 증가
    9) timeout(60s) 초과 시 timeout watchdog가 status='timed_out' 으로

[Phase 3: 결과 수령 — Flutter ↔ DB]
  Flutter는 두 채널 중 택일:
    A) Realtime 구독 — analysis_jobs/job_events 변화를 push로 받음
    B) Polling — 1-2초 간격으로 GET /jobs/{job_id}
  status='completed' 시 result 표시
  status='failed' 시 정규 에러 코드 → 한국어 카피 분기
  T1 partial events는 도착 순서대로 fade-in (검증 후 reference 노출)
```

- 키 서버 전용, 비용 cached input 가격, 프롬프트 변경 = 함수 재배포
- **Edge timeout 영향 없음**: start-analysis는 ~200ms 만에 끝. processor는 별도
- **앱 백그라운드 안전**: 앱 죽어도 job은 DB에서 계속 처리됨. 다음 진입 시 결과 보임
- **중복 탭 방어**: idempotency_key로 같은 job 재사용

---

## 4. 보안 정책 (사용자 지적 2번 반영 — 핵심)

### 원칙
**AI endpoint(비용을 발생시키는 함수)는 절대 `verify_jwt = false`로 두지 않는다.**

- `verify_jwt = false`로 두면 anon key만 알면 누구나 호출 가능 → Gemini quota 폭주 위험
- anon key는 IPA/APK에 박혀 있어 추출 가능 (Lina 의견)

### 함수별 정책 매트릭스
| 함수 카테고리 | verify_jwt | Edge 내부 추가 검증 |
|---|---|---|
| AI 분석 (T1/T2/T3, QT, premium) | **true** | auth_guard: 유저 식별 + entitlement (Pro/Trial/Free) + 분당 rate limit |
| anon 데이터 (qt-passages 생성/조회) | false 가능 | service_role 내부 호출만, 모든 유저 공통 데이터 |
| 유저별 cron (streak, weekly) | false (cron) | 시스템 호출만, IP 제한 |
| user-scoped 콜백 (process_pending_prayer) | true | 본인 prayer만 retry 허용 |

### Entitlement 서버 기준 — RevenueCat sync 필수 (사용자 지적 1번)

**문제**: 현재 RevenueCat 상태는 **클라이언트 메모리에만** 존재 (`isPremiumProvider`, `effectiveTierProvider`). Edge는 유저가 Pro인지 Trial인지 Free인지 **판단할 근거가 없음** → Pro-only 게이트(T3) 자체가 무력화.

**해결**: 서버 기준 테이블 + RevenueCat → Supabase 동기화

#### 테이블 — `abba.user_entitlements`
- `user_id` (PK): auth.users 참조
- `app_id`: 'abba'
- `tier`: 'free' / 'trial' / 'pro' (effectiveTier와 1:1 매핑)
- `period_type`: 'normal' / 'trial' / 'intro' (RevenueCat periodType 그대로)
- `entitlement_active`: boolean
- `expires_at`: TIMESTAMPTZ (구독 만료 시점)
- `trial_ends_at`: TIMESTAMPTZ NULL (Free Trial 종료 시점, period_type='trial' 일 때)
- `grace_until`: TIMESTAMPTZ NULL (Grace Period 만료 시점, billing_issue 시 expires_at + 16일)
- `billing_issue_detected_at`: TIMESTAMPTZ NULL (Grace Period 진입 시각)
- `rc_app_user_id`: TEXT (RevenueCat의 appUserId — 디버깅·중복 sync 충돌 추적)
- `source`: TEXT NOT NULL — 'webhook' / 'client_sync' / 'manual' (이 row가 어디서 갱신됐는지)
- `last_verified_at`: TIMESTAMPTZ (이 row가 RC와 마지막으로 일치 검증된 시점)
- `last_synced_at`: TIMESTAMPTZ (마지막 sync 시각, last_verified_at과 다를 수 있음 — 검증 없이 단순 sync된 경우)
- RLS: 유저는 본인 row만 SELECT, INSERT/UPDATE는 service_role만

#### 동기화 경로 (이중)
1. **RevenueCat webhook → Supabase Edge (`rc-webhook` 신규)**: INITIAL_PURCHASE / RENEWAL / CANCELLATION / EXPIRATION / BILLING_ISSUE 이벤트 받아 user_entitlements UPSERT
   - **서명 검증 필수 (BLOCKER)**: 모든 webhook 진입에 **RevenueCat이 제공하는 공식 webhook authorization 방식 그대로 적용** (현재 RC는 Authorization 헤더 + shared secret 비교 또는 HMAC-SHA256 시그니처 헤더 — 시점에 따라 RC 문서 확인 후 일치하게 구현. 핵심 원칙은 "shared secret 불일치 시 401 + DB update 없음").
   - 환경변수 `RC_WEBHOOK_SHARED_SECRET` 보관. 위조 차단 = 누구나 INITIAL_PURCHASE 위조해 Pro 무료 부여 가능한 표면 제거
   - **검증 통과 후에야** UPSERT 진행 — 그 외 어떤 DB 쓰기도 사전 발생 X
2. **클라이언트 sync (보조)**: 앱 시작 + foreground 복귀 시 RevenueCat customerInfo 받으면 별도 Edge `sync-entitlement` 함수에 POST → user_entitlements UPSERT (webhook 누락 보정)
   - 클라가 tier를 "선언"할 권한 없음. customerInfo의 raw 데이터만 전달, Edge가 RC API에 직접 검증 호출 후 신뢰

#### Edge auth_guard 동작 — **stale 위험 분리**
**원칙**: 수용 가능한 stale(Pro 기능 노출 30초)과 절대 stale 금지(quota 차감)를 분리.

- **Pro 기능 게이트** (T3 호출 통과 여부) — Edge 메모리 30초 캐시 OK
  - 30초 stale로 downgrade/cancel 직후 잠깐 Pro 기능 통과 → 수용 가능 손실
  - tier='pro' AND entitlement_active=true 확인
- **Quota 차감** (Free 1/일, Trial 3/일) — **DB 원자 연산 필수, 메모리 X**
  - Supabase Edge는 multi-instance. memory rate limit은 instance 수만큼 우회 가능
  - Postgres RPC `increment_daily_quota(user_id, app_id, today, max_count)` SECURITY DEFINER 호출
    - row UPSERT + COALESCE 0 + INC + max 검증을 한 트랜잭션
    - 초과 시 RPC가 false 반환 → Edge가 429 응답
  - `abba.daily_quota` 테이블: (user_id, app_id, date, count) — UNIQUE(user_id, app_id, date)
- **Rate limit** (분당 N건) — DB 원자 또는 Supabase Realtime 기반 분산 카운터. memory rate limit는 보조용

#### 충돌 해결
- webhook(source='webhook')과 클라 sync(source='client_sync') 동시 도착 시 last_verified_at으로 최신만 유지
- 클라 sync는 tier를 "선언"할 권한 없음 — 클라는 RevenueCat customerInfo의 raw 데이터만 전달, Edge가 필드 매핑·검증
- RC 측 expires_at이 항상 권위 — 클라 sync가 "Pro라고 우김"은 무시
- 같은 user_id에 webhook이 클라 sync보다 신뢰 우선순위 높음 (last_verified_at 같으면 webhook 채택)

### ES256 platform 거부 우회
현재 프로젝트가 새 JWT Signing Keys(ES256)로 마이그레이션돼 platform 검증이 401 반환. 회피 방법:
- ❌ verify_jwt=false로 끄기 — AI endpoint에서는 금지
- ✅ Edge 함수 내부에서 `supabase.auth.getUser(jwt)` 직접 호출 — 알고리즘 무관하게 유효 사용자 확인

---

## 5. 데이터 모델 (사용자 지적 3번 반영)

### 원칙
**rubric을 35 locale × N tier 만큼 복제하지 않는다. base rubric + locale policy 분리.**

이유:
- 동일 hallucination 룰을 35곳에 중복 → drift 위험
- 35개 다른 cache가 생성되어 Gemini cachedContents 효율 저하
- 룰 한 줄 바꾸려고 35 row 업데이트는 비현실적

### 테이블 1 — `rubric_bundles` (base, 영문 단일)
- `tier` (PK): `prayer.scripture` / `prayer.bible_story` / `qt.knowledge` 등 분석 단위 식별자
- `version`: 정수 (1, 2, ...)
- `body`: 영문 rubric markdown 본문 — locale 무관 (Strategy B 공유)
- `hash`: body의 SHA256 — cache key 일관성·invalidation
- `active`: 한 번에 한 버전만 active

→ 1 tier당 1 row. 룰 변경은 새 version INSERT 후 active 토글.

### 테이블 — `abba.analysis_jobs` (job-first 핵심, **canonical 상태**)

**원칙 — 단일 권위**:
- `analysis_jobs.status` = 분석 처리의 **canonical** 상태 (실제 처리·retry·failure reason·processor ownership 권위)
- 기존 `prayers.ai_status`는 **summary/legacy 호환용**으로만 유지 (UI 카드 + 기존 lazy retry 호환). processor가 analysis_jobs.status='completed'로 마킹할 때 동시에 prayers.ai_status='completed'도 mirror UPDATE
- 충돌 시 analysis_jobs가 항상 권위
- REQUIREMENTS §11의 `process_pending_prayer` Edge 함수는 v_final⁴에서 **analysis-processor로 흡수**. process_pending_prayer는 deprecate (Week 6 제거)

**컬럼**:
- `id` (PK): UUID
- `user_id`: auth.users
- `app_id`: 'abba'
- `prayer_id`: prayers.id FK (1:N — 한 prayer가 T1/T2/T3 여러 job 가짐)
- `tier`: 't1' / 't2' / 't3' / 'qt_t1' / 'qt_t2' / 'audio'
- `mode`: 'prayer' / 'qt'
- `status`: 'queued' / 'running' / 'completed' / 'failed' / 'timed_out'
- `idempotency_key`: TEXT — 형식 `{client_uuid}_{tier}` (Flutter가 사용자 탭 시 UUID 생성, 같은 세션에서 retry 시 동일 UUID 사용, 명시적 사용자 retry 시 새 UUID).
  - UNIQUE INDEX: `(user_id, idempotency_key)` — date 스코프 X. 같은 transcript에 client UUID가 다르면 별도 job
- `transcript`: TEXT (또는 audio_storage_path)
- `locale`: TEXT
- `parent_job_id`: UUID NULL — T2가 T1 결과 받을 때, T3가 T2 결과 받을 때 참조
- `result`: JSONB NULL — completed 시 채워짐
- `error_code`: TEXT NULL — 'AI_TIMEOUT' / 'AI_QUOTA' / 'NETWORK' / 'PARSE' / ...
- `error_detail`: TEXT NULL
- `retry_count`: INT DEFAULT 0
- `created_at`, `started_at`, `completed_at`: TIMESTAMPTZ
- INDEX: `(user_id, app_id, status, created_at DESC)` (사용자 최근 job 조회)
- INDEX: `(status, tier) WHERE status IN ('queued', 'running')` (processor 큐)
- RLS: user는 본인 job SELECT만, INSERT/UPDATE는 service_role만

### 테이블 — `abba.analysis_job_events` (T1 streaming, **검증 후 INSERT만**)

**원칙**: 검증되지 않은 AI 출력(예: hallucinated reference candidate)은 **DB에 INSERT 자체를 안 함**. 클라가 unvalidated event를 보면 안 됨 (RLS 통과해도 client 신뢰성 깨짐).

- `id` (PK): UUID
- `job_id`: analysis_jobs FK
- `seq`: INT (순서)
- `event_type`: 'scripture_ref_validated' / 'progress' / 'partial_chunk_safe'
  - **금지**: `scripture_ref_candidate` 같은 검증 전 event는 processor 메모리에만 보유, DB INSERT X
  - processor 흐름: Gemini SSE → reference candidate 받음 → BibleTextService 검증 → **통과 후에만** `scripture_ref_validated` event INSERT
- `payload`: JSONB (검증 통과한 데이터만)
- `created_at`: TIMESTAMPTZ
- INDEX: `(job_id, seq)`
- RLS: 부모 job의 user_id만 SELECT, INSERT는 service_role만

### 테이블 — `abba.daily_quota` (지적 4번)
- `(user_id, app_id, date)` UNIQUE
- `count`: INT DEFAULT 0
- RPC `increment_daily_quota(user_id, app_id, today, max_count)` SECURITY DEFINER:
  - UPSERT + atomic INC + max 검증 한 트랜잭션
  - 초과 시 false 반환

### 테이블 2 — `locale_policies` (35 row)
- `locale` (PK): 'ko', 'ja', 'es', ...
- `language_name`: 'Korean', 'Japanese', ...
- `register_notes`: "honorific 사용", "informal acceptable" 등 문체 가이드
- `reference_display_rules`: "시편 N:N", "詩篇 N:N", "Salmo N:N" 같은 지역별 성경 표기

→ 35 row. 새 locale 추가 = 1 row INSERT.

### 프롬프트 합성 (런타임) — **cache 안에는 base만, locale은 inline**
```
[Gemini cachedContents에 등록되는 부분 — locale 무관, cache key=rubric_bundles[tier].hash]
  = rubric_bundles[tier].body                    ← 영문 base rubric만

[매 요청 inline — cache 밖]
  + locale_policies[locale].register_notes       ← locale 정책
  + locale_policies[locale].reference_display_rules
  + 출력 schema / "respond in $langName" 지시
  + tier context (T1 결과, recentReferences 등)
  + transcript

cache key = rubric_bundles[tier].hash   ← locale 무관 → 모든 35 locale이 1개 cache 공유
```

**왜 분리하나**: locale policy를 cachedContents에 같이 넣으면 cache가 35개로 갈라짐 (locale마다 다른 hash). base만 cache, locale은 매 요청 inline 합쳐야 35 locale이 1 cache 공유 = Strategy B의 진짜 의미.

### Cache 안 vs 밖의 경계 (명확화)
| 위치 | 들어가는 것 | 이유 |
|---|---|---|
| **cachedContents (base, 모든 locale 공유)** | 영문 base rubric 본문 + JSON output schema 정의 + 분석 필드 의미·구조 (예: scripture/prayer_summary/testimony 등 필드가 무엇을 담는지) | locale 무관·모든 호출 동일·hash 안정 |
| **매 요청 inline (locale별)** | `respond in $langName` 지시 + 문체/register 가이드 + 성경 display reference 표기 규칙 + tier context (T1 결과, recentReferences) + transcript | locale별 다름·user별 다름·hash 갈라지면 cache 효율 0 |

→ **JSON 필드 의미는 절대 locale policy에 두지 않음**. 필드 의미가 locale마다 달라지면 클라 파싱 깨짐.

---

## 6. 캐시 전략 (Strategy B 그대로 + 측정 추가)

### Gemini explicit context cache 활성화
- 매 호출마다 inline 보내던 system instruction을 한 번만 등록 → cache 이름 받음
- 이후 호출은 cache 이름만 참조 → input 토큰 90% 할인
- 최소 1024 tokens (우리 ~10k 이상이라 충분)
- TTL 1시간, 만료 5분 전 재생성

### Strategy B = 모드별 단일 캐시
- prayer 1개, qt 1개. 35 locale 공통 (locale은 user prompt에서만 처리)
- rubric hash 변경 시 자동 재생성
- 캐시 ID와 만료 시간은 Supabase `system_config` 테이블에 저장 — 모든 Edge instance 공유

### Edge fast path — DB는 source of truth, 메모리는 빠른 길
**원칙**: Edge cold path마다 DB 조회 X. 지연·장애점만 늘어남.

- **Source of truth (DB)**: `rubric_bundles` (full body), `system_config` (active hash + cache id + 만료시간)
- **Edge in-memory cache** (per-instance):
  - 시작 시 system_config의 active hash 읽어 메모리에 보관
  - active hash가 메모리 보관 중인 hash와 같으면 → DB의 rubric body 안 읽음, 메모리 재사용
  - 다르면 → rubric_bundles에서 body fetch 후 메모리 갱신, Gemini 새 cache 생성
- **rubric 변경 시 invalidation**: 새 version INSERT → active 토글 → 다음 cold start의 첫 호출에서 hash mismatch 감지 → 새 cache 생성 (~수 초 지연 1회 발생)
- **장점**: hot path 99%는 메모리 hit으로 0ms, DB 조회는 cold start + rubric 변경 직후 1회만

### Implicit caching 측정 (Week 0)
- Gemini 2.5 Flash는 자동 prefix caching이 있을 수 있으나 보장 없음
- Dart SDK는 측정 불가 (UsageMetadata에 cachedContentTokenCount 필드 없음)
- → Week 0에 일회용 Edge probe로 REST 응답에서 cachedContentTokenCount 측정 → 현재 implicit hit률 baseline 확보

---

## 7. T1 Streaming 정책 (사용자 지적 4번 반영)

### 원칙
**streaming은 진짜로 구현한다. UI/UX는 latency를 가리는 보조 역할이지 streaming의 대체가 아니다.**

이유:
- 시니어 50-70대는 첫 토큰 1.5초 안에 안 나오면 28% 이탈 (Min-jun)
- "씨앗→꽃" 애니메이션이 stall을 가리려 하면 결국 검증된 stall

### 흐름
```
Flutter T1 호출
  → Edge가 Gemini SSE 받기 시작
  → Edge가 NDJSON으로 Flutter에 streaming 전달
  → Flutter는 첫 청크 도착 즉시:
      - 햅틱 피드백
      - "씨앗→꽃" 애니메이션 스타트
  → reference 부분 도착 → BibleTextService로 서버 또는 클라에서 검증
  → 검증 통과 후 카드에 표시 ← 핵심: 검증 전에는 표시 X
  → 본문/이유/자세 chunk이 도착 순서대로 fade-in
```

### 새 규칙 (사용자 지적 4-1)
- 현재 `TierT1ScriptureRef` early-emit이 BibleTextService 검증 전에 reference를 UI에 노출 → hallucination일 때 잠깐 표시됐다 사라지는 UX 문제
- → **검증 후에만** 카드에 reference 노출. 검증 전에는 "묵상 중..." 인디케이터 또는 헤더만

---

## 8. 모듈 책임 (이름 + 책임만)

### 서버 측 신규 (`supabase/functions/_shared/`)
- `gemini_rest_client` — REST POST/SSE 클라이언트, 재시도 정책, 에러 정규화
- `cache_manager` — cachedContents 생성/조회/만료/hash 검증, system_config 업서트
- `sanitizers` — TS 포팅 버전 (현 Dart hallucination filter와 1:1 동등)
- `auth_guard` — JWT verify (`supabase.auth.getUser`), entitlement 확인, rate limit, 정규화 에러
- `prompt_compose` — `rubric_bundles + locale_policies + tier context` 합성
- `telemetry` — cached/uncached 토큰, 비용, request_id 로그 (Sentry/Supabase logs)

### 서버 측 신규 (job-first 엔드포인트, 통합)
- `start-analysis` — 모든 tier 공통 진입점. auth_guard + entitlement + quota + idempotency + analysis_jobs INSERT (T1만, T2/T3는 processor가 chain) + job_id 반환 (~200ms)
- `analysis-processor` — **dequeue 권위 + tier chaining 책임**.
  - **트리거 (확정, 호출 신호만)**: `pg_trigger AFTER INSERT ON analysis_jobs` → `pg_net.http_post` 로 Edge invoke. **트리거는 "처리해라" 신호일 뿐 job_id를 핸드오프하지 않음**. 같은 trigger가 여러 번 발화돼도, 또는 watchdog가 별개로 invoke해도 결과는 idempotent
  - **dequeue (idempotent 핵심)**: processor가 **자기 책임으로** `SELECT ... FROM analysis_jobs WHERE status='queued' AND app_id='abba' ORDER BY created_at FOR UPDATE SKIP LOCKED LIMIT 1` 트랜잭션으로 직접 잡고 즉시 `UPDATE status='running'`. trigger가 job_id를 직접 넘기지 X — trigger 중복·재시도·watchdog가 동시에 invoke해도 SKIP LOCKED가 한 번만 잡히게 보장 → 이중 과금·이중 처리 0
  - **tier chaining (확정 — Flutter가 X)**: T1 완료 시 processor가 직접 T2 job을 INSERT (parent_job_id=T1.id). 새 INSERT가 다시 trigger → 동일 processor flow. T2 완료 시 T3 INSERT (Pro entitlement check). 이 책임을 Flutter에 두지 않음 — 서버 오케스트레이션 일관성 유지
- `analysis-status` — job_id로 status·result 조회 (**Realtime fallback 전용, primary 아님**)
- `rc-webhook` — RevenueCat webhook 수신 + **HMAC 서명 검증 필수** + user_entitlements UPSERT
- `analysis-watchdog` — pg_cron(1분 간격) running 60초+ job을 timed_out 전환 + retry. v1 MAU<1k 단계엔 manual SQL로 충분 (defer 가능, NIT)

### Realtime vs Polling — **mandate**: Realtime primary
- Flutter는 기본 Realtime 구독 (`analysis_jobs` row의 status 변경)
- Realtime 구독 실패 / app foreground-resume after >30s → polling fallback (analysis-status 호출)
- Flutter 자유 선택 X. 두 경로 다 구현하되 우선순위 명시

→ tier별 함수 X. 단일 processor가 tier 컬럼 보고 분기. **코드 재사용 + 일관 관측**.

### 클라이언트 측 변화
- `gemini_service.dart` — 점진 deprecate, Week 6에 삭제
- `tier_*_analyzer.dart` — Edge 호출 thin wrapper로 축소 (parsing/validation은 서버)
- `tier3_hallucination_filters.dart` — Week 6까지 유지 (parity 안전망)
- `bible_text_service.dart` — 그대로 (PD 번들이 클라에 있으므로 verse lookup은 클라에서)
- `recent_references_service.dart` — 그대로 (Supabase 30-day 조회 → Edge에 인자로 전달)

---

## 9. 단계 (Week 0 ~ Week 6)

### Week 0 — 측정 (1일)
- 일회용 `probe-gemini-cache` Edge 함수 만들어 REST 호출 테스트
- response에서 `usageMetadata.cachedContentTokenCount` 확인 → implicit caching baseline
- 사용자 수동: Gemini Console에서 API 키에 quota cap 설정 ($50/day 등)
- 출구 조건: implicit 90% 이상 자동 hit이면 explicit 우선순위 ↓ / 0%면 우선순위 ↑

### Week 1 — 발판 (4-5일, job 모델 추가로 +1일)
- `_shared/` 6개 모듈 골격 + 단위 테스트
- 5 테이블 마이그레이션:
  - `rubric_bundles` + 시드
  - `locale_policies` + 35 row 시드
  - `user_entitlements` + RLS
  - `analysis_jobs` + `analysis_job_events` (job-first)
  - `daily_quota` + `increment_daily_quota` RPC
- `start-analysis` + `analysis-processor` + `analysis-status` 골격 (T2 stub로 end-to-end 흐름 검증)
- parity fixture: 200+ case golden test로 Dart filter ↔ TS sanitizer 동등성 입증
- 출구 조건:
  - 모든 fixture가 Dart 출력 == TS 출력
  - T2 stub end-to-end: Flutter → start-analysis → analysis-processor → analysis-status → 결과 표시 (mock data)

### Week 2 — T3 endpoint (3일)
- `analyze-prayer-tier3` 함수: verify_jwt=true + auth_guard
- Pro 100명 대상 검증
- Flutter Tier3 → Edge 호출로 교체 (client-side filter는 유지)
- Sentry diff 모니터링: Edge 결과 vs 클라 fallback의 형상 차이

### Week 3 — T2 endpoint (2일)
- 같은 패턴, streaming 불필요
- 백그라운드 호출이라 사용자 체감 영향 0

### Week 4-5 — T1 endpoint (5-7일, 가장 어려움)
- SSE streaming 구현 (Edge ReadableStream + Flutter streamed http)
- scripture reference 검증-후-표시 UX 변경
- 햅틱+애니메이션 즉시 시작
- 가장 큰 위험 — 출시 직후 진행 권장

#### T1 Edge 성공 기준 (반드시 정의 — Week 5 종료 게이트)
| 지표 | 목표 |
|------|------|
| **p95 first meaningful chunk** | ≤ 1.5s (시니어 28% 이탈 임계 안쪽) |
| **p95 full T1 응답** | ≤ 현재 client-direct 평균 + 500ms (cold start tax) |
| **scripture invalid flash** (검증 전 잘못된 ref UI 노출) | **0 회** |
| **Edge 5xx 비율** | < 0.5% |
| **cachedContentTokenCount > 0 비율** | > 90% (출시 직후 기준 — cold start + TTL 재생성 + 첫 갱신 race 고려). 안정기 후 95%로 상향 |

#### T1 client-direct = rollback 전용 (영구안 X)
**원칙**: 최종 목표가 "API 키 서버 전용"이므로 T1 영구 client-direct는 목표와 충돌. hybrid는 영구안이 아님.

- Week 4-5 동안 client-direct 코드는 살아있되 **`rc_t1_use_edge` flag로 분기**
- ramp 단계: 0% → 10% → 50% → 100%
- 위 성공 기준 미달 시 즉시 롤백 (flag 0%로)
- **롤백 후에도 단순 영구화 X**: 원인 분석 → Edge 보정 → 재시도. 출시 +60일 안에 100% 도달 못 하면 별도 재설계 (Cloud Run 등) 트리거

### Week 6 — 정리 (2일)
- 클라이언트 hallucination filter 제거 (Sentry diff 0건 기준)
- `google_generative_ai` 패키지 제거
- `gemini_service.dart` 삭제

---

## 10. 마이그레이션 안전망 (사용자 지적 5번 반영)

### parity 병행 운영
- Week 2 T3 시작 시 Flutter `tier3_hallucination_filters.dart` **유지** (제거 X)
- 매 호출마다: Edge 결과 + 클라 filter 결과를 비교 로그로 남김
- Sentry alert: 두 결과의 형상 diff가 일정 비율 초과 시 알림
- **Week 6에야 클라 filter 제거** (Edge가 안정 입증된 후)

### 롤백 경로
- 함수 단위 feature flag (per user-id 0~100% ramp)
- 실패율 임계 초과 시 자동 fallback to legacy client-direct 경로 (Week 5까지 코드 살아있음)

### 데이터 호환성
- 기존 `prayers.result` JSONB 형식 100% 유지
- Edge가 Flutter와 동일한 PrayerResult 구조 반환

---

## 11. 비용 영향 (⚠️ **추정치 — Week 0/1 telemetry 전엔 확정 X**)

### 변동 요인 (실제 절감률은 이들로 결정됨)
- base rubric 토큰 수 (현 ~10k 추정 — Week 0에서 정확히 측정)
- output 토큰 비중 (T3는 1500-2000 tokens라 input 절감의 영향 작음)
- cache storage / 생성 비용 (10k tokens × $1.00/M/h — 작지만 0 아님)
- T1 streaming payload 크기 (Edge↔Flutter NDJSON 추가 오버헤드)
- implicit caching이 이미 자동 적용되고 있는지 (Week 0 측정 대상)

### 현재 (추정)
- T1 + T2 + T3 = **~$0.017** (출처: 5인 리뷰 단계 추정)
- 시스템 instruction이 input 비용의 큰 비중

### 게이트웨이 + explicit cache 활성화 후 (낙관 추정)
- 1 prayer = **~$0.009** (~48% 절감 가능 *if* implicit가 0%이고 explicit이 잘 hit)
- cache storage: 무시 가능
- Edge invocation: 30k/월 = Supabase 무료 한도 내

### Pro 1,000 MAU × 30 prayers/월 (낙관 시뮬)
- 현재: ~$510/월
- 후: ~$267/월
- 월 절감 **~$243** (이 수치는 출시 후 실측까지 마케팅·재무 결정에 사용 X)

### 실제 확정 시점
**Week 0 probe + Week 2 T3 ramp 후** Sentry telemetry로 다음 지표 확보:
- 실 평균 cachedContentTokenCount / promptTokenCount 비율
- T2/T3 응답당 평균 input·output·storage 비용
- Edge invocation 비용

→ 이 수치 확보 후 spec §11에 **확정 비용표** 갱신.

---

## 12. 검증 게이트

### 코드 게이트
- `flutter analyze apps/abba` — 0 issue
- `deno test` 모든 _shared 모듈 + 각 endpoint
- parity fixture green
- 5 locale 스냅샷 테스트 (en/ko/ja/ar/he)

### 운영 게이트 (각 endpoint별 ramp 시)
- Sentry 5xx 비율 < 1%
- 평균 응답 시간 status quo +30% 이하
- cachedContentTokenCount > 0 (cache 실제 hit)
- T1 첫 청크 도착 시간 < 2.0초 (시니어 임계)

### 사용자 수동 게이트
- Sandbox에서 Free / Trial / Pro 3 경로 검증
- Edge 콜드스타트 새벽 5-7am 시뮬레이션

---

## 13. 결정된 vs 미정

### 결정됨
- 모든 AI 분석을 Edge로 이전 (Path B Strangler T3 → T2 → T1 순)
- AI endpoint는 verify_jwt=true + auth_guard
- rubric은 base + locale_policies 분리
- T1 streaming은 진짜 구현, UI는 보조
- 클라 filter는 Week 6까지 유지
- **canonical 상태는 analysis_jobs.status / prayers.ai_status는 summary mirror**
- **trigger는 pg_trigger + pg_net 단일 / dequeue는 FOR UPDATE SKIP LOCKED**
- **tier chaining 책임은 processor (Flutter X)**
- **Realtime primary, polling fallback only**
- **RC webhook HMAC 서명 검증 필수**
- **검증 안 된 event는 DB INSERT X**
- **T1 client-direct 영구 유지 금지** — Slim 옵션도 sunset path 명시

### Full vs Slim 결정 트리 (§13a)

**Full** (출시 +6주, 권장):
- T1/T2/T3/QT 전부 Edge
- analysis_job_events + Realtime streaming
- 모든 보안·관측·캐시 활성화
- 적합 시점: 출시 ±2주 안정기 도달 후

**Slim** (출시 +3주, 시간 압박 시):
- T2/T3/QT-T2 먼저 Edge (Pro tier 호출 100%)
- T1은 **임시 client-direct + 60일 sunset 게이트**
- T1 sunset 게이트: 출시+60일 안에 T1 Edge로 이전 못하면 별도 재설계 (Cloud Run 검토)
- **금지**: T1 영구 client-direct. 키 노출 = IPA 추출 = 비용 폭발 위험은 T1만 남아도 동일
- 적합 시점: 출시 임박 + Week 0 측정에서 implicit caching이 충분히 동작 (90%+ hit률) 시

**선택 게이트**: Week 0 probe + Week 1 발판 끝난 시점에 Full / Slim 결정. 그 전엔 결정 X.

### 범위 밖 (별도 PR)
- Firebase SDK 마이그레이션
- Cloud Run 등 다른 게이트웨이 옵션
- AI 응답을 영구 캐싱(같은 transcript에 같은 답) — 다른 주제

---

## 14. 안전망 — under-engineering 보강

### per-user 월 cost cap (BLOCKER) — **config 가능, 하드코딩 X**
- `abba.user_entitlements` 에 `monthly_cost_cents` 컬럼 추가 (현재 월 누적 Gemini 비용, 매월 1일 0으로 reset)
- analysis-processor는 매 호출 시 (1) 사전 cap 검사 → 초과면 즉시 status='failed', error_code='COST_CAP', (2) Gemini 응답 받으면 토큰 비용 계산해 INC
- **cap 값은 운영 중 조정 가능해야 함**. 하드코딩 금지. 다음 중 하나로 보관:
  - `public.system_config` 테이블 키: `cost_cap_free_cents`, `cost_cap_trial_cents`, `cost_cap_pro_cents` (DB 기반 — Edge 메모리 30초 캐시. 운영 중 SQL UPDATE로 즉시 반영)
  - 또는 Edge 환경변수 `COST_CAP_FREE_CENTS` 등 (재배포 필요. 더 보수적이지만 즉응 X)
  - v1 권장: **system_config 방식** — 비용 사고 발생 시 DB UPDATE 한 줄로 즉시 cap 강화 가능
- 초기값 (system_config 시드): Free 30 cents / Trial 100 cents / Pro 500 cents
  - Free: 정상 사용 ~27 cents 기준 30 cents 5%+ 차단
  - Trial: 3/일 cap × 30일 × $0.017 ≈ $1.53 — 100 cents는 보수적
  - Pro: 정상 사용 ~$0.30 기준 abuse만 차단
- 초과 도달 시 사용자에게 알림 (한국어 카피 "월 사용량 한도에 도달") + 다음 월 reset까지 신규 분석 차단. 기존 결과 조회는 정상

### existing pending prayers 마이그레이션 (BLOCKER)
- Week 1 마이그레이션 시점에 prayers.ai_status='pending' 인 row 모두 `analysis_jobs` row INSERT (status='queued', tier 추정)
- 동일 prayer_id에 새 analysis_jobs 생성 시 충돌 없음 (1:N 관계)
- 마이그레이션 후 기존 process_pending_prayer Edge function은 deprecate (Week 6 제거)
- backfill SQL은 별도 마이그레이션 파일 (사용자 수동 실행)

### 추가 보안 (Ralph 지적)
- **DB connection pooling**: Supabase Pooler (PgBouncer transaction mode) 사용. multi-instance Edge → many concurrent connections 대비
- **anonymous account abuse**: free tier 1/일이지만 익명 계정 무한 생성으로 우회 가능 → device fingerprint 또는 IP-bucket rate limit (별도 PR로 분리)
- **Sentry SLO**: Edge 5xx > 1% 또는 cachedContentTokenCount=0 비율 > 20% 시 alert. learned-pitfalls §17 적용

### Gemini 30분 outage 시 graceful degradation
- analysis-processor가 5분 안 5건 이상 연속 실패 시 **circuit breaker** 활성 → 신규 start-analysis 호출 즉시 503 + "AI 서비스 점검 중"
- 큐에 들어간 job은 timeout watchdog에 의해 timed_out 처리 (retry_count 소비 X)
- circuit 복구 후 timed_out job 일괄 재시도 옵션
- **quota refund**: status='timed_out' 또는 'failed'(Gemini outage 원인) 시 daily_quota -1 (rollback). 사용자가 outage로 quota 잃지 않음
- 한국어 카피: AI_TIMEOUT, AI_QUOTA, NETWORK, COST_CAP 4종 ARB 키 사전 정의

---

## 14. 참고

- 5인 architect 리뷰 결론 (Lina/Min-jun/Diego/Marcus/Sasha)
- 사용자 5개 지적 (cachedContentTokenCount 측정 불가, verify_jwt=false 위험, rubric 분리, T1 streaming 구현, parity 병행 운영)
- learned-pitfalls §3 multi-tenant, §17 Sentry 에러 로깅, §18 Git 멀티계정
- `apps/abba/specs/REQUIREMENTS.md` §11 Always — pending/retry 아키텍처
- `apps/abba/specs/SUBSCRIPTION.md` — Pro entitlement 판정 (effectiveTierProvider)
