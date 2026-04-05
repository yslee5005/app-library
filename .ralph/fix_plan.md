# Ralph Fix Plan — App Library Foundation (전체 패키지 완성)

> 최종 목표: 11개 패키지 + template_app이 production-ready 상태로, 새 앱이 패키지 조립으로 완성 가능
> 기준일: 2026-03-31
> 현재 상태: 모든 패키지 초기 구현 완료, 검증 및 보완 필요

---

## Phase 1: Foundation (core + supabase_client)

### 1.1 모노레포 세팅 확인
- [x] `melos.yaml` 생성 — 존재함 (scripts: analyze, test, test:dart, build_runner, format, clean)
- [x] Root `pubspec.yaml` 생성 — 존재함 (workspace 11 packages + 2 apps)
- [x] `analysis_options.yaml` 생성 — 존재함
- [x] `.env.example` 생성 — 존재함
- [x] `.gitignore` 생성 — 존재함
- [ ] `melos bootstrap` 성공 확인 — 실행 필요
- [ ] workspace에 `apps/template_app` 추가 필요 (현재: showcase, pet-life만)

### 1.2 core 패키지 완성
현재 파일:
- [x] `lib/src/errors/app_exception.dart` — AppException, NetworkException, DatabaseException, AuthException, CacheException, ValidationException (모두 sealed)
- [x] `lib/src/utils/result.dart` — Result<T>, Success<T>, Failure<T> (sealed, 패턴매칭 지원)
- [x] `lib/src/models/paginated_result.dart` — PaginatedResult<T>, PaginationParams
- [x] `lib/src/constants/app_constants.dart` — AppConstants (defaultPageSize, maxPageSize, defaultCacheTtlSeconds, rlsInvalidAppId)
- [x] `lib/core.dart` — barrel export (errors, models, utils, constants)
- [x] `test/result_test.dart` — Result, AppException, PaginatedResult 테스트

검증 항목:
- [ ] `dart test` 실행 → 전체 통과 확인
- [ ] `dart analyze` → 0 errors 확인
- [ ] pubspec.yaml 확인: 외부 의존성 0개 (lints, test만 dev)
- [ ] 테스트 커버리지 확인: PaginationParams, AppConstants 테스트 있는지

### 1.3 supabase_client 패키지 완성
현재 파일:
- [x] `lib/src/client/app_supabase_client.dart` — from(), insert(), update(), delete(), rpc(), initialize()
- [x] `lib/src/config/supabase_config.dart` — SupabaseConfig (url, anonKey, appId)
- [x] `lib/supabase_client.dart` — barrel export
- [x] `test/supabase_config_test.dart` — SupabaseConfig 생성/비교 테스트

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] providers 디렉토리 없음 — `supabaseClientProvider` 추가 필요 (TASKS.md 요구사항)
  - 파일: `lib/src/providers/supabase_providers.dart`
  - barrel export에 추가
- [ ] pubspec.yaml에 flutter_riverpod 의존성 추가 필요
- [ ] `dart analyze` → 0 errors 확인

---

## Phase 2: Data Layer (pagination + cache + error_logging)

### 2.1 pagination 패키지
현재 파일:
- [x] `lib/src/domain/paginated_repository.dart` — PaginatedRepository<T> 인터페이스
- [x] `lib/src/domain/pagination_state.dart` — PaginationInitial, PaginationLoading, PaginationLoaded, PaginationError (sealed)
- [x] `lib/src/providers/pagination_providers.dart` — PaginationNotifier (Riverpod)
- [x] `lib/pagination.dart` — barrel export
- [x] `test/pagination_test.dart` — PaginationState, PaginatedRepository 테스트

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] PaginatedSupabaseRepository<T> 구현체 확인 — data/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/data/paginated_supabase_repository.dart`
- [ ] InfiniteScrollList 위젯 확인 — widgets/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/widgets/infinite_scroll_list.dart`
- [ ] InfiniteScrollGrid 위젯 확인 — 추가 필요
  - 파일: `lib/src/widgets/infinite_scroll_grid.dart`
- [ ] barrel export 업데이트
- [ ] `dart analyze` → 0 errors 확인

### 2.2 cache 패키지
현재 파일:
- [x] `lib/src/interfaces/cache_interface.dart` — CacheInterface 추상 클래스
- [x] `lib/src/interfaces/cache_entry.dart` — CacheEntry<T> (TTL 기반)
- [x] `lib/src/memory/memory_cache.dart` — MemoryCache (maxSize, eviction)
- [x] `lib/src/manager/cache_manager.dart` — CacheManager (primary/secondary 2단계)
- [x] `lib/cache.dart` — barrel export
- [x] `test/cache_test.dart` — CacheEntry, MemoryCache, CacheManager 테스트 (매우 충실)

검증 항목:
- [ ] `dart test` 실행 → 전체 통과 확인
- [ ] DiskCache 구현 확인 — disk/ 디렉토리 없음 (TASKS.md: SharedPreferences 기반)
  - 순수 Dart 패키지이므로 DiskCache 추가 시 Flutter 의존성 필요 → 설계 결정 필요
  - 대안: DiskCache 인터페이스만 정의, 앱에서 구현
- [ ] CacheManagementMixin 확인 — mixins/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/mixins/cache_management_mixin.dart`
- [ ] barrel export 업데이트
- [ ] `dart analyze` → 0 errors 확인

### 2.3 error_logging 패키지
현재 파일:
- [x] `lib/src/services/error_level.dart` — ErrorLevel enum (fatal, error, warning, info)
- [x] `lib/src/services/error_logging_service.dart` — ErrorLoggingService 추상 클래스 (log, captureException, addBreadcrumb)
- [x] `lib/src/filters/sensitive_data_filter.dart` — SensitiveDataFilter (이메일, Bearer, API key, JWT 마스킹)
- [x] `lib/error_logging.dart` — barrel export
- [x] `test/error_logging_test.dart` — ErrorLevel, SensitiveDataFilter, ErrorLoggingService mock 테스트

검증 항목:
- [ ] `dart test` 실행 → 전체 통과 확인
- [ ] Sentry 구현체 없음 — 현재 순수 Dart 패키지 (sentry_flutter 의존성 없음)
  - DESIGN.md에는 `error_logging ── (core + sentry_flutter)` 명시
  - pubspec.yaml에 sentry_flutter 없음 → 추가 여부 결정 필요
  - 대안: SentryErrorLoggingService 구현체를 앱 레벨로 이동, 패키지는 인터페이스만
- [ ] Riverpod provider 확인 — providers/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/providers/error_logging_providers.dart`
- [ ] barrel export 업데이트
- [ ] `dart analyze` → 0 errors 확인

---

## Phase 3: Auth + Comments

### 3.1 Supabase 마이그레이션 SQL
현재: supabase/ 디렉토리 없음
- [ ] `supabase/migrations/001_create_profiles.sql` 생성
- [ ] `supabase/migrations/002_create_comments.sql` 생성
- [ ] `supabase/migrations/003_create_comment_likes.sql` 생성
- [ ] `supabase/migrations/004_create_user_preferences.sql` 생성
- [ ] `supabase/migrations/005_create_notification_schedules.sql` 생성
- [ ] `supabase/migrations/006_create_app_versions.sql` 생성
- [ ] `supabase/migrations/007_rls_policies.sql` 생성 (COALESCE NULL 방어)
- [ ] `supabase/migrations/008_rpc_functions.sql` 생성 (toggle_like, handle_new_user)

### 3.2 auth 패키지
현재 파일:
- [x] `lib/src/domain/auth_repository.dart` — AuthRepository 인터페이스
- [x] `lib/src/domain/auth_state.dart` — Authenticated, Unauthenticated, AuthLoading, AuthError (sealed)
- [x] `lib/src/domain/user_profile.dart` — UserProfile (fromJson, toJson, copyWith, equality)
- [x] `lib/src/data/google_auth_service.dart` — GoogleAuthService
- [x] `lib/src/data/apple_auth_service.dart` — AppleAuthService
- [x] `lib/src/data/email_auth_service.dart` — EmailAuthService
- [x] `lib/src/data/supabase_auth_repository.dart` — SupabaseAuthRepository
- [x] `lib/src/providers/auth_providers.dart` — Riverpod providers
- [x] `lib/auth.dart` — barrel export
- [x] `test/auth_test.dart` — UserProfile, AuthState 테스트 (충실)

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] JWT app_metadata에 app_id 주입 로직 확인
- [ ] AuthGuard 위젯 확인 — widgets/ 디렉토리 없음 (선택적이므로 OK)
- [ ] `dart analyze` → 0 errors 확인

### 3.3 comments 패키지
현재 파일:
- [x] `lib/src/domain/comment_model.dart` — CommentModel
- [x] `lib/src/domain/comment_filter.dart` — CommentFilter
- [x] `lib/src/domain/comment_repository.dart` — CommentRepository 인터페이스
- [x] `lib/src/domain/create_comment_request.dart` — CreateCommentRequest
- [x] `lib/src/data/supabase_comment_repository.dart` — SupabaseCommentRepository
- [x] `lib/src/providers/comment_providers.dart` — Riverpod providers
- [x] `lib/comments.dart` — barrel export
- [x] `test/comments_test.dart` — 기본 테스트

검증 항목:
- [ ] `flutter test` 또는 `dart test` 실행 → 전체 통과 확인
- [ ] Widget layer 확인 — widgets/ 디렉토리 없음
  - 파일: `lib/src/widgets/comment_sheet.dart` — 추가 필요 (TASKS.md)
  - 파일: `lib/src/widgets/comment_item.dart` — 추가 필요
  - 파일: `lib/src/widgets/reply_list.dart` — 추가 필요
  - 파일: `lib/src/widgets/comment_input.dart` — 추가 필요
- [ ] pubspec.yaml에 flutter 의존성이 이미 있으므로 widgets 추가 가능
- [ ] barrel export 업데이트
- [ ] `dart analyze` → 0 errors 확인

---

## Phase 4: UI + Polish (theme + notifications + l10n + ui_kit)

### 4.1 theme 패키지
현재 파일:
- [x] `lib/src/tokens/app_colors.dart` — AppColors.fromSeed(), light/dark ColorScheme
- [x] `lib/src/tokens/app_spacing.dart` — AppSpacing (xs~xxl, 4px grid)
- [x] `lib/src/tokens/app_radius.dart` — AppRadius (sm~xl, BorderRadius helpers)
- [x] `lib/src/tokens/app_typography.dart` — AppTypography (custom fontFamily)
- [x] `lib/src/config/theme_config.dart` — ThemeConfig (seedColor, fontFamily, borderRadius, useMaterial3)
- [x] `lib/src/generators/theme_generator.dart` — ThemeGenerator (light/dark ThemeData)
- [x] `lib/theme.dart` — barrel export
- [x] `test/theme_test.dart` — AppColors, AppSpacing, AppRadius, AppTypography, ThemeConfig, ThemeGenerator (충실)

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] `dart analyze` → 0 errors 확인
- [ ] 상태: 매우 완성도 높음, 보완 불필요할 가능성 높음

### 4.2 notifications 패키지
현재 파일:
- [x] `lib/src/domain/notification_message.dart` — NotificationMessage 모델
- [x] `lib/src/domain/notification_repository.dart` — NotificationRepository 인터페이스
- [x] `lib/src/data/local_notification_service.dart` — LocalNotificationService
- [x] `lib/notifications.dart` — barrel export
- [x] `test/notification_message_test.dart` — NotificationMessage 테스트

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] Riverpod provider 확인 — providers/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/providers/notification_providers.dart`
- [ ] 권한 요청 로직 확인
- [ ] 스케줄 알림 지원 확인
- [ ] barrel export 업데이트
- [ ] `dart analyze` → 0 errors 확인

### 4.3 l10n 패키지
현재 파일:
- [x] `lib/src/services/language_service.dart` — LanguageService (resolve, isSupported, custom locales)
- [x] `lib/src/utils/relative_time_formatter.dart` — RelativeTimeFormatter (en/ko, past/future)
- [x] `lib/src/utils/number_formatter.dart` — NumberFormatter (compact: K/M/B)
- [x] `lib/l10n.dart` — barrel export
- [x] `test/l10n_test.dart` — RelativeTimeFormatter (en/ko), NumberFormatter, LanguageService (충실)

검증 항목:
- [ ] `dart test` 실행 → 전체 통과 확인
- [ ] Riverpod provider 확인 — providers/ 디렉토리 없음, 추가 필요
  - 파일: `lib/src/providers/l10n_providers.dart`
  - 참고: 순수 Dart 패키지 → Riverpod 추가 시 Flutter 의존성 필요 → 설계 결정
  - 대안: provider는 앱 레벨에서 정의
- [ ] `dart analyze` → 0 errors 확인

### 4.4 ui_kit 패키지
현재 파일 (40+ 위젯):
- [x] Navigation: AppBottomNavBar, AppDrawerMenu, AppShell, AppTabLayout
- [x] Onboarding: ForgotPasswordForm, LoginForm, OnboardingCarousel, SignUpForm
- [x] Profile: LanguagePickerTile, ProfileEditForm, ProfileHeader, SettingsScreen, ThemeSwitchTile
- [x] Feed: AppCard, AppListTile, DetailScreenLayout, FeedListView
- [x] Search: AppSearchBar, ChipFilterBar, FilterBottomSheet, SortSelector
- [x] Forms: AppButton, AppDateTimePicker, AppImagePicker, AppRatingBar, AppTextField, FormSection
- [x] Feedback: AppDialog, AppToast, BadgeWidget, EmptyStateView, ErrorStateView, ShimmerWidget, SkeletonLoader
- [x] Media: AppAvatar, AppCachedImage, ExpandableText, ImageCarousel
- [x] Data Viz: AppProgressBar, HeatmapCalendar, StatCard
- [x] `lib/ui_kit.dart` — barrel export (66 lines, comprehensive)
- [x] Tests: 8 test files covering key widgets

검증 항목:
- [ ] `flutter test` 실행 → 전체 통과 확인
- [ ] `dart analyze` → 0 errors 확인
- [ ] TASKS.md 체크: AnimatedButton, SocialLoginButton, ExpandableSection, ErrorBoundary, CustomBottomNavBar, CustomTextField, CustomSearchBar
  - 이미 구현된 것: AppButton(=AnimatedButton), AppBottomNavBar, AppTextField, AppSearchBar
  - 추가 확인 필요: SocialLoginButton, ExpandableSection, ErrorBoundary
- [ ] 상태: 매우 완성도 높음 (TASKS.md보다 더 많은 위젯 구현됨)

---

## Phase 5: Integration

### 5.1 template_app 생성
현재: apps/template_app/ 미존재
- [ ] `apps/template_app/pubspec.yaml` 생성
  - 의존성: 필수 패키지 (core, supabase_client, theme, error_logging) + 선택 패키지
- [ ] `apps/template_app/lib/main.dart` — Supabase init + Sentry + ProviderScope
- [ ] `apps/template_app/lib/app.dart` — MaterialApp.router + ThemeGenerator
- [ ] `apps/template_app/lib/config/app_config.dart` — appId, appName, supabase 설정
- [ ] `apps/template_app/lib/router/app_router.dart` — go_router (login/home/settings)
- [ ] `apps/template_app/lib/features/home/view/home_view.dart` — 패키지 연동 데모
- [ ] `apps/template_app/lib/features/login/view/login_view.dart` — auth 패키지 연동
- [ ] `apps/template_app/lib/features/settings/view/settings_view.dart` — 테마 전환, 알림
- [ ] `apps/template_app/.env.example` — 환경변수 템플릿
- [ ] Root `pubspec.yaml` workspace에 `apps/template_app` 추가
- [ ] `melos.yaml`에 자동 포함 확인 (packages: - apps/**)

### 5.2 전체 통합 검증
- [ ] `melos bootstrap` 성공
- [ ] `melos run analyze` — 0 errors (전체 패키지)
- [ ] `melos run test` — 전체 통과
- [ ] CLAUDE.md 패키지 선택 가이드 검증
- [ ] SECURITY.md 체크리스트 확인

### 5.3 최종 커밋
- [ ] Git commit: "feat: app-library 전체 패키지 완성 — production ready"

---

## 우선순위 요약

| 순서 | 작업 | 난이도 | 상태 |
|------|------|--------|------|
| 1 | Phase 1: core/supabase_client 검증 | 낮음 | 대기 |
| 2 | Phase 2: pagination/cache/error_logging 보완 | 중간 | 대기 |
| 3 | Phase 3: auth/comments + SQL 마이그레이션 | 중간 | 대기 |
| 4 | Phase 4: theme/notifications/l10n/ui_kit 검증 | 낮음 | 대기 |
| 5 | Phase 5: template_app + 통합 | 높음 | 대기 |

## 누락 항목 정리 (TASKS.md 대비)

### 확실히 누락된 것
1. `supabase_client/providers/` — supabaseClientProvider (Riverpod)
2. `pagination/data/` — PaginatedSupabaseRepository<T>
3. `pagination/widgets/` — InfiniteScrollList, InfiniteScrollGrid
4. `cache/mixins/` — CacheManagementMixin
5. `comments/widgets/` — CommentSheet, CommentItem, ReplyList, CommentInput
6. `notifications/providers/` — notificationProvider
7. `supabase/migrations/` — 8개 SQL 파일
8. `apps/template_app/` — 전체 생성 필요

### 설계 결정 필요
1. error_logging: Sentry 래퍼를 패키지에 포함? or 앱 레벨?
2. cache: DiskCache (SharedPreferences 의존)를 순수 Dart 패키지에 포함?
3. l10n/error_logging: Riverpod provider를 순수 Dart 패키지에 추가? (Flutter 의존성 추가 필요)
