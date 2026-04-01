# TASKS.md — App Library

> Version: 2.0 | Last Updated: 2026-04-01 | Last Verified: 2026-04-01
> Status: In Progress
> Changes: YC 검증, Ralph Loop, 보안 강화, @include 최적화 반영

---

## Phase 0: Spec & 환경 세팅

### 0.1 Spec 문서
- [x] REQUIREMENTS.md 작성
- [x] DESIGN.md 작성
- [x] TASKS.md 작성
- [x] SECURITY.md 작성
- [x] CLAUDE.md 작성 + @include 최적화

### 0.2 Claude Code 강화 (소스 유출 분석 기반)
- [x] CLAUDE.md → 30줄 핵심 + @include 참조로 최적화
- [x] `.claude/rules/` 경로별 규칙 (packages, supabase, apps, security)
- [x] `.claude/settings.local.json` 보안 설정

### 0.3 YC 검증 워크플로우
- [x] IDEA.md 템플릿 생성 (templates/IDEA.md)
- [x] REQUIREMENTS.md에 Step 0: YC 4P 검증 추가
- [ ] yc-agents 설치 (선택, 첫 앱 시)

### 0.4 Ralph Loop 통합
- [x] `.ralphrc` 설정 (Max 플랜 최적화)
- [x] PROMPT_PHASE.md 템플릿 생성
- [x] PROMPT_APP.md 템플릿 생성
- [ ] Ralph 설치 (`git clone + ./install.sh`)

### 0.5 환경
- [ ] Git 초기화 + .gitignore
- [ ] Flutter/Dart SDK 버전 확인 (Dart 3.9+)

**완료 조건:** spec 5개 + rules 4개 + settings + ralph 설정 + git init

---

## Phase 1: Foundation

### 1.1 모노레포 세팅
- [ ] `melos.yaml` 생성
- [ ] Root `pubspec.yaml` 생성 (Pub Workspaces)
- [ ] `analysis_options.yaml` 생성 (공유 린트)
- [ ] `.env.example` 생성
- [ ] `melos bootstrap` 성공 확인

**입력:** DESIGN.md 섹션 7 (Melos 설정)
**완료 조건:** `melos bootstrap` 에러 없음

### 1.2 core 패키지
- [ ] 디렉토리 구조 생성
- [ ] `pubspec.yaml` (순수 Dart, Flutter 의존성 없음)
- [ ] 에러 계층: `AppException`, `NetworkException`, `DatabaseException`, `CacheException`, `AuthException`, `ValidationException`
- [ ] Result 타입: `Result<T>` (Success / Failure)
- [ ] 기본 모델: `PaginatedResult<T>`, `PaginationParams`
- [ ] 상수: 공유 상수
- [ ] barrel export: `core.dart`
- [ ] Unit 테스트

**입력:** praynews `lib/core/errors/app_exceptions.dart`
**완료 조건:** `dart test` 통과, 0 외부 의존성

### 1.3 supabase_client 패키지
- [ ] 디렉토리 구조 생성
- [ ] `AppSupabaseClient`: app_id 자동 스코핑
- [ ] `SupabaseConfig`: URL/Key 환경변수 관리
- [ ] Riverpod provider: `supabaseClientProvider`
- [ ] .env 기반 초기화
- [ ] Unit 테스트 (mock Supabase)

**입력:** devotional `lib/config/supabase_initializer.dart`
**완료 조건:** `flutter test` 통과, app_id 스코핑 검증

---

## Phase 2: Data Layer

### 2.1 pagination 패키지
- [ ] `PaginationParams`, `PaginatedResult<T>`, `PaginationState` 모델 (freezed)
- [ ] `PaginatedSupabaseRepository<T>`: 제네릭 커서 페이지네이션
- [ ] `PaginationNotifier`: Riverpod 3.0 AsyncNotifier
- [ ] `InfiniteScrollList` 위젯
- [ ] `InfiniteScrollGrid` 위젯
- [ ] 새로고침 + 에러 재시도 지원
- [ ] Unit 테스트 + Widget 테스트

**입력:** devotional `lib/data/repositories/base/paginated_supabase_repository.dart`
**완료 조건:** mock 데이터로 페이지네이션 동작 검증

### 2.2 cache 패키지
- [ ] `CacheInterface` 추상 클래스
- [ ] `MemoryCache`: TTL 기반
- [ ] `DiskCache`: SharedPreferences 기반
- [ ] `CacheManager`: 2단계 (메모리 → 디스크)
- [ ] `CacheManagementMixin`: Repository에서 사용
- [ ] Unit 테스트

**입력:** praynews `lib/core/cache/cache_manager.dart`
**완료 조건:** TTL 만료, 캐시 히트/미스 테스트 통과

### 2.3 error_logging 패키지
- [ ] `ErrorLoggingService`: Sentry 래퍼
- [ ] 에러 레벨: `fatal`, `error`, `warning`, `info`
- [ ] `SensitiveDataFilter`: 이메일, 토큰 등 마스킹
- [ ] .env 기반 DSN 관리
- [ ] Riverpod provider
- [ ] Unit 테스트

**입력:** devotional `lib/core/services/error_logging_service.dart`
**완료 조건:** 로그 전송 시 민감 정보 마스킹 확인

---

## Phase 3: Auth + Comments

### 3.1 Supabase 마이그레이션
- [ ] `001_create_profiles.sql`
- [ ] `002_create_comments.sql`
- [ ] `003_create_comment_likes.sql`
- [ ] `004_create_user_preferences.sql`
- [ ] `005_create_notification_schedules.sql`
- [ ] `006_create_app_versions.sql`
- [ ] `007_rls_policies.sql` (NULL 방어 포함)
- [ ] `008_rpc_functions.sql` (toggle_like, handle_new_user)
- [ ] RLS 검증: 다른 app_id로 접근 시 데이터 안 보이는지 테스트

**입력:** DESIGN.md 섹션 4
**완료 조건:** Supabase에 마이그레이션 적용, RLS 테스트 통과

### 3.2 auth 패키지
- [ ] `AuthRepository` 인터페이스 (domain)
- [ ] `AuthState` 모델 (freezed): authenticated, unauthenticated, loading
- [ ] `SupabaseAuthRepository` 구현체
- [ ] `GoogleAuthService`: google_sign_in + Supabase
- [ ] `AppleAuthService`: sign_in_with_apple + Supabase
- [ ] `EmailAuthService`: Supabase email/password
- [ ] JWT app_metadata에 app_id 주입 로직
- [ ] Riverpod providers: `authStateProvider`, `currentUserProvider`
- [ ] `AuthGuard` 위젯 (선택적)
- [ ] Unit 테스트 + Integration 테스트

**입력:** devotional `lib/data/services/social_auth/unified_social_auth_service.dart`
**완료 조건:** Google/Apple/Email 로그인 → 프로필 자동 생성 → app_id 격리 확인

### 3.3 comments 패키지
- [ ] `CommentModel`, `CommentFilter` 모델 (freezed)
- [ ] `CommentRepository` 인터페이스
- [ ] `SupabaseCommentRepository`: CRUD + 좋아요 + 답글
- [ ] `CommentListNotifier`: Riverpod 3.0 AsyncNotifier
- [ ] `CommentSheet` 위젯
- [ ] `CommentItem` + `ReplyList` 위젯
- [ ] `CommentInput` 위젯
- [ ] Unit 테스트 + Widget 테스트

**입력:** devotional `lib/data/repositories/supabase_comment_repository.dart`
**완료 조건:** 댓글 CRUD + 답글 + 좋아요 토글 동작 확인

---

## Phase 4: UI + Polish

### 4.1 theme 패키지
- [ ] `ThemeConfig`: 시드 컬러, 폰트, 라운딩 등 입력
- [ ] `ThemeGenerator`: ThemeConfig → ThemeData (light/dark)
- [ ] 디자인 토큰: `AppColors`, `AppSpacing`, `AppRadius`, `AppTypography`
- [ ] Material 3 기반
- [ ] Unit 테스트

**입력:** praynews `lib/presentation/theme/app_theme.dart`
**완료 조건:** 시드 컬러만 바꿔도 일관된 테마 생성

### 4.2 notifications 패키지
- [ ] `NotificationMessage` 모델
- [ ] `NotificationRepository` 인터페이스
- [ ] `LocalNotificationService`: flutter_local_notifications 래퍼
- [ ] 권한 요청 로직
- [ ] 스케줄 알림 지원
- [ ] Riverpod provider
- [ ] Unit 테스트

**입력:** devotional `lib/core/services/notification_service.dart`
**완료 조건:** 로컬 알림 스케줄 + 즉시 발송 동작 확인

### 4.3 l10n 패키지
- [ ] `LanguageService`: 로케일 감지
- [ ] `RelativeTimeFormatter`: "3분 전", "어제" 등
- [ ] `NumberFormatter`: 숫자 포맷
- [ ] Riverpod provider: `localeProvider`
- [ ] Unit 테스트

**완료 조건:** 로케일 변경 시 포맷 변경 확인

### 4.4 ui_kit 패키지
- [ ] `AnimatedButton`, `SocialLoginButton`
- [ ] `AppCard`, `ExpandableSection`
- [ ] `SkeletonLoader`, `ShimmerWidget`
- [ ] `EmptyState`, `ErrorBoundary`
- [ ] `CustomBottomNavBar`
- [ ] `CustomTextField`
- [ ] `CustomSearchBar`
- [ ] Widget 테스트 (각 위젯 렌더링 확인)

**완료 조건:** 모든 위젯이 독립적으로 렌더링, 테마 토큰 적용 확인

---

## Phase 5: Integration

### 5.1 template_app
- [ ] `main.dart`: Supabase 초기화 + Sentry + ProviderScope
- [ ] `app.dart`: MaterialApp.router + 테마 적용
- [ ] `app_config.dart`: appId, supabase 설정
- [ ] `app_router.dart`: go_router (로그인/홈/설정)
- [ ] 홈 화면: 패키지 연동 데모 (리스트 + 댓글)
- [ ] 로그인 화면: auth 패키지 연동
- [ ] 설정 화면: 테마 전환, 알림 설정

**완료 조건:** 앱 실행 → 로그인 → 리스트 → 댓글 → 설정 전체 플로우 동작

### 5.2 CLAUDE.md 최종화
- [ ] 프로젝트 실제 구조 반영
- [ ] 패키지 선택 가이드 검증
- [ ] 앱 생성 워크플로우 검증

### 5.3 최종 검증
- [ ] `melos bootstrap` 성공
- [ ] `melos run analyze` — 0 에러
- [ ] `melos run test` — 전체 통과
- [ ] template_app 전체 플로우 수동 테스트
- [ ] 두 개의 다른 app_id로 데이터 격리 검증
- [ ] SECURITY.md 체크리스트 전체 확인

**완료 조건:** 모든 체크 통과, 새 앱을 만들 준비 완료
