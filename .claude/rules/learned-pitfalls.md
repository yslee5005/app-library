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

## 3. Multi-tenant (Supabase)
- 새 테이블 → RLS 즉시 활성화 + COALESCE NULL defense
- 앱별 테이블은 `{app}.*` 스키마 또는 `{app}_*` prefix (apps.md 참조)
- `AppSupabaseClient` 통해 자동 app_id 스코핑
- `signInAnonymously()`에 `app_id` metadata 전달
- `handle_new_user` trigger는 `raw_user_meta_data` 우선, `raw_app_meta_data` fallback
- service_role key는 Edge Function 환경변수만, client에 절대 X
- Edge Function에 JWT `auth.uid()` 검증 필수

## 4. i18n
- View/Widget에서 하드코딩 문자열 0개 — 전부 ARB 키 (`l10n.xxx`)
- ARB 키 **사전 정의 후 코드 작성** (나중에 정리하면 미사용 키 폭증, praybell 754키 사례)
- namedArgs placeholder는 ARB 메타에 명시 (`@key: { placeholders: ... }`)
- 로케일 변경 시 즉시 반영 (앱 재시작 강제 X)
- `scripts/check_hardcoded_strings.sh` / `check_l10n_sync.sh` 활용

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

---

## 사용 가이드

작업 시작 전:
1. 어떤 카테고리가 관련됐는지 식별 (예: 음성 녹음 + 결제 → 1, 2, 11, 16)
2. 해당 항목들 다시 읽기
3. 코드 작성 시 그 항목들 의식적으로 회피
4. 작업 종료 시 `scripts/harness_check.sh` 실행

새 함정 발견 시 이 파일에 추가 (PR 통해).
