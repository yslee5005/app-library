# Learned Pitfalls

> praybell (211 fix) + app-library (34 fix) 245개 fix commit에서 추출. 코드 작성 전 관련 카테고리 확인. 같은 함정 반복 방지가 목적.

## 1. Riverpod 라이프사이클
- async gap 후 ref/provider 사용 시 `if (!ref.mounted) return;` 체크 (Ref disposed 크래시)
- AsyncNotifier는 dispose 처리 필수 (Stream/Timer/Controller 정리)
- autoDispose vs keepAlive: 전역(인증/구독)은 keepAlive, 화면 한정은 autoDispose
- `invalidate()` 최소화 — 불필요한 무효화는 N+1 호출 + UX 끊김 유발
- 포그라운드 복귀 시 결제/구독 관련 provider 일괄 invalidate (foreground listener)
- override는 main.dart 또는 ProviderScope 진입점에서만

## 2. Subscription / Payment Crash 방지
- `completePurchase()`는 try-catch 필수 (Apple/Google 서버 응답 실패 시 크래시)
- 3-state 패턴: pending / success / failed (인디케이터 + 에러 메시지 + 재시도)
- 구매 결과는 `Completer`로 listener 받기 (sync return 의존 금지)
- 포그라운드 복귀 시 customer info 자동 갱신
- **Apple Guideline 3.1.2**: 구독 약관/링크를 구매 버튼 바로 아래 배치
- Grace Period (만료 후 16일) 처리 + 그룹/멤버 read_only 전환
- 복원(restore)은 타임아웃 30초+ 필요
- Webhook JWS 디코딩 에러 핸들러 + originalTransactionId 매칭
- **RevenueCat Grace Period 감지**: `EntitlementInfo.billingIssueDetectedAt` (ISO date string) 사용. `isInGracePeriod = billingIssueDetectedAt != null && willRenew`. 배너 UX로 남은 일 수 카운트다운 (16일 기준, `gracePeriodDaysRemaining` getter)
- **동적 가격 표시**: ARB 하드코딩 가격 대신 `Purchases.getOfferings()` → `package.storeProduct.priceString` / `.currencyCode` 사용. Apple PPP tier 자동 반영. yearly/월 환산은 `NumberFormat.simpleCurrency(name: currencyCode)` 로 동일 통화 포맷 유지
- ARB 가격은 fallback 전용으로만 유지 (offering 로드 실패 / 네트워크 없음 시)
- **Webhook은 선택**: client-side SDK `CustomerInfo.entitlement.isActive` + `addCustomerInfoUpdateListener`로 충분. 서버 DB 동기화가 필요한 경우에만 Edge Function + JWS 디코딩 구현

## 2-1. AI 분석 실패 시 하드코딩 fallback으로 인한 DB 오염 + 유저 신뢰 위반
- AI 호출 catch 블록에서 하드코딩 데이터를 성공한 척 반환하지 말 것
  - ❌ `catch (e) { return _hardcodedResult(); }` → 유저는 "진짜 AI 응답"이라 착각, DB에 가짜 저장, 재시도 경로 없음
  - ✅ `catch (e) { throw AiAnalysisException('...', cause: e); }` → UI 레이어가 명시적 에러 처리
- **저장 우선 + AI 분리 패턴**: 유저 원본(텍스트/음성)은 AI 호출 **전** 즉시 DB 저장(`ai_status='pending'`) → AI는 별도 비동기 단계로 분리. 성공 시 `ai_status='completed'` UPDATE, 실패 시 원본은 보존됨
- **재시도 카운터는 client-side session 스코프** (앱 재시작 시 리셋) — DB에 retry_count 박제하면 유저가 영구히 "더는 시도 불가" 상태에 갇힘
- **서버측 cooldown (예: 10분)**으로 Edge Function 비용 폭증 방어. 누적 실패 10회 초과 시 `ai_status='failed'` 확정 (무한 루프 방지)
- **완성된 레코드에 재시도 버튼 노출 금지** — 토큰 낭비 + AI diversity로 결과 매번 달라짐 → UX 혼란 + 기존 result 덮어쓰기/버전 관리 복잡성
- **Lazy retry on visit 패턴**: 유저 재방문(홈 진입)이 트리거 → Edge Function이 pending 기도 1개 처리 → 성공 시 환영 모달. 주기적 cron 불필요 (유저 안 오면 비용 0)
- 적용 사례: abba prayer AI analysis (REQUIREMENTS.md §11 Always, DESIGN.md §10 Pending Prayer Retry Flow)

## 3. Multi-tenant (Supabase)
- 새 테이블 → RLS 즉시 활성화 + COALESCE NULL defense
- 앱별 테이블은 `{app}.*` 스키마 또는 `{app}_*` prefix (apps.md 참조)
- `AppSupabaseClient` 통해 자동 app_id 스코핑
- `signInAnonymously()`에 `app_id` metadata 전달
- `handle_new_user` trigger는 `raw_user_meta_data` 우선, `raw_app_meta_data` fallback
- service_role key는 Edge Function 환경변수만, client에 절대 X
- Edge Function에 JWT `auth.uid()` 검증 필수
- **Polymorphic JSONB 재사용**: 새 엔티티 저장 전 기존 테이블의 JSONB 컬럼 + discriminator(예: `mode`) 재활용 가능 여부 점검. 예: `abba.prayers.result` + `mode='prayer'|'qt'`로 PrayerResult/QtMeditationResult 저장 → migration 없이 QT 영속화 달성. 새 테이블 만들기 전 항상 재사용 경로 먼저 검토

## 4. i18n
- View/Widget에서 하드코딩 문자열 0개 — 전부 ARB 키 (`l10n.xxx`)
- ARB 키 **사전 정의 후 코드 작성** (나중에 정리하면 미사용 키 폭증, praybell 754키 사례)
- namedArgs placeholder는 ARB 메타에 명시 (`@key: { placeholders: ... }`)
- 로케일 변경 시 즉시 반영 (앱 재시작 강제 X)
- `scripts/check_hardcoded_strings.sh` / `check_l10n_sync.sh` 활용
- ⚠️ `check_l10n_sync.sh` naive regex 버그 — ARB **값**(영어 단어)을 **키**로 오탐. Python JSON 기반 검증 권장: `set(k for k in json.load(...) if not k.startswith('@'))` 비교
- **Single-field 3-tier legacy fallback** 패턴: `json[key]` → `json[key_en]` → `json[key_ko]` → `''`. Dual → single 전환 시 DB 기존 레코드 호환 (GrowthStory / MeditationSummary / testimony / ScriptureOriginalWord 등)
- **Context 없는 서비스 레이어 l10n**: `flutter_local_notifications` 같은 서비스는 `AppLocalizations.of(context)` 불가. 해결 패턴 = `setLocalization(AppLocalizations l10n)` 메서드 추가 + `app.dart`에 Bridge Widget (`didChangeDependencies`에서 `ref.read(service).setLocalization(l10n)` fire-and-forget, `_lastAppliedLocale`로 중복 호출 방지). `_l10n == null` 윈도우는 영어 fallback 클래스 (`_EnFallback`)로 보호
- **Android notification 채널 locale 대응**: 동일 채널 ID(`prayer_reminders`)로 `createNotificationChannel` 재호출하여 name/description만 업데이트. 채널 ID 변경 시 유저 권한 설정 리셋되므로 금지
- **STT 대신 Gemini 멀티모달 활용**: `speech_to_text` 35 locale mapping 테이블 대신 `Gemini.analyzePrayerFromAudio(audioFilePath, locale)` 한 호출로 transcribe + 분석 동시 처리. 모든 locale 자동 지원

## 5. Auth Lifecycle
- Refresh Token 만료 → `PlatformDispatcher.onError + runZonedGuarded`로 크래시 방지
- 로그인 버튼 더블탭 방지 (`_isStarting` flag debounce)
- Apple `SignInWithAppleAuthorizationException.canceled`는 에러 처리 X (정상 흐름)
- 이메일 인증 페이지 `Timer`는 dispose 시 cancel (메모리 릭)
- linkWithGoogle/Apple은 `linkIdentityWithIdToken()` (UUID 보존)
- `identity_already_exists` → `signInWithIdToken()` fallback (기존 계정 복구)
- 회원가입 시 약관 명시적 동의 (GDPR)
- 약관/개인정보 URL은 locale 대응 (영문 404 흔함)

## 6. DateTime / Timezone
- DB는 UTC 저장, 표시는 Local 변환 — 매번 `toLocal()` / `toUtc()` 명시
- 공용 `DateTimeUtils` 통해 일관 처리 (직접 변환 금지)
- weekday 시작점: ISO 8601 = 월요일(1) — 일요일 시작 가정 시 -1 누락 빈번
- SQL 타임존 파라미터 명시 (Postgres `TIMESTAMPTZ`)
- 주간 통계는 `weekday - 1` (월요일 시작) 패턴

## 7. iOS Privacy / Compliance (Apple 2024+)
- `PrivacyInfo.xcprivacy` 필수 (AdMob/FCM/Analytics 데이터 선언)
- iPad orientation key 제거 (`UISupportedInterfaceOrientations~ipad` 충돌)
- `ITSAppUsesNonExemptEncryption = false` 명시
- Zone mismatch + Sentry 중복 캡처 방지: `runZonedGuarded` 1회만
- Release 빌드: `--obfuscate --split-debug-info`

## 8. Navigation
- `pop` 전 `canPop()` 체크 (GoError "There is nothing to pop" 크래시)
- `context.push` vs `context.go`: dashboard/공유 시 `push` (히스토리 보존), 탭 전환 시 `go`
- FCM 알림 탭 → 딥링크 라우팅 + 자동 스크롤 + 섹션 펼침까지 구현
- `StatefulShellRoute` 사용 시 탭 전환 분기 명시
- `PopScope` `canPop` 업데이트는 listener 추가 필수

## 9. FCM / Webhook
- 로그아웃 → 재로그인 시 FCM 토큰 재활성화 명시
- 추방/탈퇴 멤버에게 알림 전송 차단 (멤버십 체크 가드)
- 알림 템플릿 테이블은 RLS 활성화 + service_role만 INSERT
- Webhook 페이로드 스키마 변경에 견고한 디코딩 (예외 catch + 로깅)

## 10. Optimistic UI
- 좋아요/북마크/즐겨찾기 같은 즉시성 액션은 Optimistic 업데이트 (DB 기다리지 않음)
- DB 호출 후 invalidate가 아니라 **로컬 상태 변경 → 백그라운드 sync**
- 실패 시 rollback + snackbar
- 불필요한 invalidate 일괄 제거 패턴 (praybell 13건 사례)

## 11. 성능 (N+1, fire-and-forget, lazy)
- 그룹 단위 쿼리 N+1 검사 — 한 번에 RPC로 모음 (61쿼리 → 1쿼리 사례)
- 비동기 후처리(예: pool 생성)는 fire-and-forget 패턴 — UI blocking X (70초 → 300ms)
- Lazy loading: 통계/디테일 페이지 분리 (홈에서 다 로드 X)
- 복합 인덱스 추가로 RPC 쿼리 최적화

## 12. Color / Design Token 일관성
- `Colors.green/red/grey` 직접 사용 X — `AppColors.X` 또는 앱별 토큰 (`AbbaColors`)
- 하드코딩 색상은 디자인 변경 시 누락 위험
- 그라디언트/스낵바도 동일 (Theme.of(context).colorScheme 활용)

## 13. Dead Code Sweep
- `flutter analyze unused_*` 정기 점검
- 사용 안 하는 provider/메서드/import는 즉시 제거
- praybell: 16 dead providers + 11 orphaned invalidate 일괄 제거 사례
- 제거 전 git grep으로 외부 참조 확인

## 14. Layer Violation (View → DB 직접)
- View/Widget에서 Supabase client 직접 호출 금지
- 항상 Repository 또는 Provider 통해
- `scripts/check_layer_violations.sh` 활용
- 위반 누적 시 배포 직전 대규모 리팩토링 발생 (praybell 사례)

## 15. Web 함정 (Next.js / blacklabelled)
- combobox/dropdown은 portal로 렌더 (parent `overflow:hidden` 회피)
- IME composition (한글 입력) 중간 글자 처리 — `onCompositionEnd` 활용
- 모바일 hover 동작 분리 (touch에서 hover stuck 발생)
- Mobile carousel vs Desktop grid 분기

## 16. Code Generation 누락
- pubspec 변경 후 `flutter pub get` (workspace는 root에서)
- freezed/json_serializable 모델 변경 후 `dart run build_runner build`
- l10n ARB 변경 후 `flutter gen-l10n`
- iOS Pod 변경 후 `cd ios && pod install`, `[CP] Copy Pods Resources` phase 확인
- Android Kotlin/Gradle 변경 후 `./gradlew clean`
- workspace 모드: 앱별 `dart pub get`은 작동 안 함, 반드시 root에서

## 17. Sentry 에러 로깅
- catch 블록 3 패턴 분류: **A** (`appLogger.error(error: e, stackTrace: st)` + Sentry 자동 승격) / **B** (의도된 silent fallback, 주석 필수) / **C** (rethrow)
- ⚠️ `appLogger.error`에 `error: e` 파라미터 **미전달**하면 Sentry `captureException` 자동 승격 안 됨 (`SentryBreadcrumbOutput` 조건: `entry.level >= LogLevel.error && entry.error != null`)
- 마스킹 규칙 `beforeSend`: email만으론 부족 → phone / JWT (`eyJ...`) / 긴 한국어 transcript (`[가-힣]{50,}`) / URL query params 포함
- `event.message` 마스킹만으론 부족 — `event.breadcrumbs[].message` + `event.exceptions[].value`도 마스킹 (SDK 버전별 API 호환성 확인)
- private 마스킹 함수는 `@visibleForTesting`으로 public 노출 → 단위 테스트 가능
- Sentry Dashboard에서 Data Scrubber 추가 활성화 (서버측 이중 방어)
- `tracesSampleRate`: prod 0.2 / dev 1.0 (비용 + 신호 비율 균형)

## 18. Git 멀티계정 운영
- `git push` 403 실패 시 → `gh auth switch --user <account>` + `gh auth setup-git` 재실행
- 로컬 `user.name` 정상이어도 credential helper가 다른 active account 사용 가능
- 프로젝트별 `memory/git_commit_account.md`에 기록 → 재확인 생략
- `--global` 플래그 절대 사용 금지 (다른 프로젝트 영향)

## 19. MoAI Phase별 Pre-Execution Report 룰
- 여러 Phase로 구분된 작업은 **각 Phase 실행 전 반드시 Pre-Execution Report** 작성 → 사용자 승인 → 실행
- Report 구성: 목적 / 수정 파일 / 변경 내역 / 변경 안 되는 것 (명시적 배제) / 리스크 / 검증 방법 / 사용자 승인 필요 사항 / 예상 시간 / 산출물
- Phase 완료 후: "Post-Execution Summary" + 다음 Phase Pre-Execution Report 요청
- 여러 Phase 묶어 임의 실행 금지 (🛡️ §1 자율성 등급 B3 "범위 외 작업" 위반)
- `flutter_tools`처럼 `-D` vs `-d` 오타로 인해 Generated.xcconfig에 UUID가 base64 DART_DEFINES로 박제되는 등 캐시 오염이 발생 가능 → Phase 시작 전 `git status` + `flutter clean` 필요 시 실행
- Phase 간 DB/Edge Function/배포 같은 **사용자 외부 액션이 필요한 중단점**을 명시

---

## 사용 가이드

작업 시작 전:
1. 어떤 카테고리가 관련됐는지 식별 (예: 음성 녹음 + 결제 → 1, 2, 11, 16)
2. 해당 항목들 다시 읽기
3. 코드 작성 시 그 항목들 의식적으로 회피
4. 작업 종료 시 `scripts/harness_check.sh` 실행

새 함정 발견 시 이 파일에 추가 (PR 통해).

## 업데이트 이력
- 2026-04-22: §2/§3/§4 확장 + §17 Sentry 에러 로깅 + §18 Git 멀티계정 신규 (abba 출시 준비 세션에서 발견)
- 2026-04-23: §2-1 AI fallback DB 오염 + §19 MoAI Phase-first Pre-Execution Report 신규 (abba pending/retry 아키텍처 세션)
- 2026-04-24: §1 추가 함정 (AutoDispose StateNotifier + 화면 전환 중 background Stream 구독 유실) + §16 추가 함정 (flutter_test `rootBundle` 한계 + AssetBundle 의존성 주입) 보강 (abba Phase 4.1 section-based AI 세션)

## §1 보강 (2026-04-24 Phase 4.1)
- **화면 이동 중 background Stream subscription 유실**: ai_loading_view가 Stream을 시작하고 Dashboard로 nav하는 경우, subscription이 view state에 묶여 있으면 나머지 tier(T2/T3) 이벤트가 유실됨. 해결 = Notifier 안에서 listen, view 전환 후에도 구독 유지. 단 autoDispose StateNotifier라면 "구독자 0" 짧은 순간 dispose → stream 끊김. **해결 2단계**: (a) Notifier가 `StreamSubscription` 보관 + dispose에서 cancel, (b) provider를 `StateNotifierProvider.autoDispose` → 일반 `StateNotifierProvider`로 변경하고 시작 시 명시적 `reset()` 호출. 애플리케이션-범위 상태(스트리밍 result)에는 autoDispose가 적합하지 않음.
- **`ref.read(userProfileProvider).value?.name` 호환성**: FutureProvider에 `.value`(AsyncValue API)는 있지만 레거시 `.valueOrNull`은 Riverpod 3.0에서 제거됨. 사용 시 analyzer error. 항상 `.value?.x ?? fallback` 패턴 사용.

## §16 보강 (2026-04-24 Phase 4.1)
- **`flutter_test`에서 `rootBundle.loadString()` 실패**: 테스트 환경의 `PlatformAssetBundle`은 pubspec의 assets 매니페스트를 로드하지 못함 — 프로덕션에서 로드되는 JSON 에셋도 `"Unable to load asset"`. 해결 = 서비스에서 `AssetBundle` 인자를 받도록 (`{AssetBundle? bundle}`, 기본값 `rootBundle`), 테스트는 `CachingAssetBundle` 서브클래스(메모리 맵) 주입. flutter_test에서 `assets/mock/*`가 동작하는 이유는 `MockDataService.fromData(...)` 패턴으로 bundle을 아예 우회하기 때문. 새 서비스도 같은 주입 가능 구조 권장.
- **MockAiService stream 초입 delay 필요**: widget 테스트가 최초 pump에서 로딩 프레임을 기대하는데, Stream 생성자에서 즉시 await하면 subscription 미 루프에서 에러가 나서 error-view로 전환. 해결 = Stream 본체 첫 줄에 `await Future.delayed(Duration(seconds: 1))` 등 명시적 yield 구간. 기존 Future-based mock도 동일 패턴으로 늦춰져 있음.
