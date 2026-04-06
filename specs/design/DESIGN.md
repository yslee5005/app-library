# DESIGN.md — App Library

> Version: 1.0 | Last Updated: 2026-04-01
> Status: Draft

---

## 1. 모노레포 디렉토리 구조

```
app-library/
├── CLAUDE.md                           # AI 행동 규칙
├── melos.yaml                          # Melos 워크스페이스 설정
├── pubspec.yaml                        # Pub Workspaces (Dart 3.9+)
├── analysis_options.yaml               # 공유 린트 규칙
├── .gitignore
├── .env.example                        # 환경변수 템플릿
│
├── specs/                              # Spec 문서
│   ├── requirements/REQUIREMENTS.md
│   ├── design/DESIGN.md
│   ├── tasks/TASKS.md
│   └── security/SECURITY.md
│
├── packages/
│   ├── core/                           # Tier 1: 순수 Dart (의존성 0)
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── errors/             # AppException, NetworkException, ...
│   │   │   │   ├── models/             # PaginatedResult, AppConfig, ...
│   │   │   │   ├── utils/              # Result<T>, validators
│   │   │   │   ├── constants/          # 공유 상수
│   │   │   │   ├── environment/        # AppEnvironment, EnvValidator, ScreenSize
│   │   │   │   └── feature_flags/      # FeatureFlag, FeatureFlagRegistry
│   │   │   └── core.dart               # barrel export
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── supabase_client/                # Tier 2: Supabase 래퍼
│   │   ├── lib/src/
│   │   │   ├── client/                 # AppSupabaseClient
│   │   │   ├── config/                 # SupabaseConfig
│   │   │   └── providers/              # supabaseClientProvider
│   │   └── pubspec.yaml
│   │
│   ├── auth/                           # Tier 2: 인증
│   │   ├── lib/src/
│   │   │   ├── domain/                 # AuthRepository (interface), AuthState
│   │   │   ├── data/                   # SupabaseAuthRepository, GoogleAuthService, AppleAuthService
│   │   │   ├── providers/              # authStateProvider, currentUserProvider
│   │   │   └── widgets/               # LoginButton, AuthGuard (선택적)
│   │   └── pubspec.yaml
│   │
│   ├── pagination/                     # Tier 2: 페이지네이션
│   │   ├── lib/src/
│   │   │   ├── domain/                 # PaginationParams, PaginatedResult, PaginationState
│   │   │   ├── data/                   # PaginatedSupabaseRepository<T>
│   │   │   ├── providers/              # paginationProvider
│   │   │   └── widgets/               # InfiniteScrollList, InfiniteScrollGrid
│   │   └── pubspec.yaml
│   │
│   ├── comments/                       # Tier 3: 댓글 시스템
│   │   ├── lib/src/
│   │   │   ├── domain/                 # CommentModel, CommentRepository (interface)
│   │   │   ├── data/                   # SupabaseCommentRepository
│   │   │   ├── providers/              # commentListProvider, addCommentProvider
│   │   │   └── widgets/               # CommentSheet, CommentItem, ReplyList
│   │   └── pubspec.yaml
│   │
│   ├── notifications/
│   │   ├── lib/src/
│   │   │   ├── domain/                 # NotificationMessage, NotificationRepository
│   │   │   ├── data/                   # LocalNotificationService
│   │   │   └── providers/              # notificationProvider
│   │   └── pubspec.yaml
│   │
│   ├── error_logging/
│   │   ├── lib/src/
│   │   │   ├── services/               # ErrorLoggingService, EnvironmentAwareLogging
│   │   │   ├── filters/                # SensitiveDataFilter
│   │   │   └── providers/              # errorLoggingProvider
│   │   └── pubspec.yaml
│   │
│   ├── cache/
│   │   ├── lib/src/
│   │   │   ├─�� interfaces/             # CacheInterface, CacheConfig
│   │   │   ├── memory/                 # MemoryCache
│   │   │   ├── disk/                   # DiskCache
│   │   │   ├── manager/                # CacheManager
│   │   │   └── mixins/                 # CacheManagementMixin
│   │   └── pubspec.yaml
│   │
│   ├── theme/
│   │   ├── lib/src/
│   │   │   ���── tokens/                 # AppColors, AppSpacing, AppRadius, AppTypography
│   │   │   ├── config/                 # ThemeConfig
│   │   │   └── generators/             # ThemeGenerator (light/dark)
│   │   └── pubspec.yaml
│   │
│   ├── l10n/
│   │   ├── lib/src/
│   │   │   ├── services/               # LanguageService
│   │   │   ├── providers/              # localeProvider
│   │   │   └── utils/                  # RelativeTimeFormatter, NumberFormatter
│   │   └── pubspec.yaml
│   │
│   └── ui_kit/
│       ├── lib/src/
│       │   ├── buttons/                # AnimatedButton, SocialLoginButton
│       │   ├── cards/                  # AppCard, ExpandableSection
│       │   ├── loading/                # SkeletonLoader, ShimmerWidget
│       │   ├── empty_states/           # EmptyState, ErrorBoundary
│       │   ├── navigation/             # CustomBottomNavBar
│       │   ├── forms/                  # CustomTextField
│       │   └── search/                 # CustomSearchBar
│       └── pubspec.yaml
│
├── apps/
│   └── template_app/                   # 스타터 앱 템플릿
│       ├── lib/
│       │   ├── main.dart
│       │   ├── app.dart                # MaterialApp + ProviderScope
│       │   ├── config/
│       │   │   └── app_config.dart     # appId, appName, supabase 설정
│       │   ├── router/
│       │   │   └── app_router.dart     # go_router 설정
│       │   └── features/               # 앱 고유 기능 (feature-first)
│       │       └── home/
│       │           ├── viewmodel/
│       │           └── view/
│       ├── pubspec.yaml
│       └── .env.example
│
└── supabase/
    ├── migrations/
    │   ├── 001_create_profiles.sql
    │   ├── 002_create_comments.sql
    │   ├── 003_create_comment_likes.sql
    │   ├── 004_create_user_preferences.sql
    │   ├── 005_create_notification_schedules.sql
    │   ├── 006_create_app_versions.sql
    │   ├── 007_rls_policies.sql
    │   └── 008_rpc_functions.sql
    ├── seed/
    └── functions/
```

---

## 2. 패키지 의존성 그래프

```
core (순수 Dart, 0 외부 의존성)
│
├── supabase_client ──────── (core + supabase_flutter)
│   │
│   ├── auth ─────────────── (+ google_sign_in, sign_in_with_apple)
│   │
│   ├── pagination ───────── (core + supabase_client)
��   │   │
│   │   └── comments ─────── (+ pagination)
│   │
│   └── notifications ────── (+ flutter_local_notifications)
│
├── cache ────────────────── (core only)
│
├── error_logging ────────── (core + sentry_flutter)
│
├── l10n ─────────────────── (core only)
│
├── theme ────────────────── (core + flutter)
│
└── ui_kit ───────────────── (core + theme)
```

**의존성 규칙:**
- 단방향만 허용: core ← data ← providers ← (앱 ViewModel)
- 역방향 의존 절대 금지
- 순환 의존 금지

---

## 3. 아키텍처 패턴

### 3.1 Hexagonal Architecture (Ports & Adapters)

```
┌─────────────────────────────────────────────┐
│                   앱 (ViewModel + View)       │
│                   = Driving Adapter           │
└──────────┬──────────────────────────────────┘
           │ uses
┌──────────▼──────────────────────────────────┐
│              Providers (Riverpod 3.0)         │
│              = Port (Interface)               │
└──────────┬──────────────────────────────────┘
           │ delegates to
┌──────────▼──────────────────────────────────┐
│              Domain (Interfaces + Models)     │
│              = Core (순수 Dart)               │
└──────────┬──────────────────────────────────┘
           │ implemented by
┌──────────▼──────────────────────────────────┐
│              Data (Repository 구현체)          │
│              = Driven Adapter                 │
└──────────┬──────────────────────────────────┘
           │ connects to
┌──────────▼──────────────────────────────────┐
│              Supabase / External Services     │
└─────────────────────────────────────────────┘
```

### 3.2 패키지 내부 레이어

각 패키지는 동일한 구조:

```
packages/{name}/lib/src/
├── domain/        # Interface + Model (순수 Dart, 테스트 용이)
├── data/          # 구현체 (Supabase 의존)
├── providers/     # Riverpod Provider (공유 가능)
└── widgets/       # UI 위젯 (선택적 사용)
```

### 3.3 앱 내부 구조 (feature-first)

```
apps/{app_name}/lib/
├── main.dart
├── app.dart
├── config/
│   └── app_config.dart
├── router/
│   └── app_router.dart
└── features/
    ├── home/
    │   ├── viewmodel/home_viewmodel.dart    # 앱 고유
    │   └── view/home_view.dart              # 앱 고유
    ├── settings/
    │   ├── viewmodel/
    │   └── view/
    └── {feature_name}/
        ├── viewmodel/                       # 앱별 독립 작성
        └── view/                            # 앱별 독립 작성
```

### 3.4 공유 vs 독립 레이어

| 레이어 | 위치 | 공유/독립 |
|--------|------|----------|
| Domain (Interface + Model) | packages/ | 100% 공유 |
| Data (Repository 구현체) | packages/ | 100% 공유 |
| Providers (Riverpod) | packages/ | 90% 공유 (앱에서 override 가능) |
| ViewModel/Notifier | apps/{name}/features/ | 앱별 독립 |
| View/Widget | apps/{name}/features/ | 앱별 독립 |

---

## 4. Supabase 멀티테넌트 스키마

### 4.1 핵심 테이블

```sql
-- profiles: 앱별 사용자 프로필
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  app_id TEXT NOT NULL,
  email TEXT,
  display_name TEXT,
  avatar_url TEXT,
  provider TEXT,              -- 'google', 'apple', 'email'
  onboarding_completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(id, app_id)
);

-- comments: 범용 댓글 시스템
CREATE TABLE comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL,
  content_type TEXT NOT NULL,  -- 앱에서 자유 정의 ('article', 'product', ...)
  content_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  parent_comment_id UUID REFERENCES comments(id) ON DELETE CASCADE,
  body TEXT NOT NULL,
  is_deleted BOOLEAN DEFAULT false,
  like_count INTEGER DEFAULT 0,
  reply_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- comment_likes: 좋아요
CREATE TABLE comment_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, comment_id)
);

-- user_preferences: 앱별 사용자 설정
CREATE TABLE user_preferences (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  key TEXT NOT NULL,
  value JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id, key)
);

-- notification_schedules: 알림 스케줄
CREATE TABLE notification_schedules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  notification_type TEXT NOT NULL,
  schedule_time TEXT,          -- "HH:mm"
  is_enabled BOOLEAN DEFAULT true,
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- app_versions: 앱 버전 관리
CREATE TABLE app_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL UNIQUE,
  min_version TEXT,
  latest_version TEXT,
  force_update BOOLEAN DEFAULT false,
  updated_at TIMESTAMPTZ DEFAULT now()
);
```

### 4.2 인덱스

```sql
CREATE INDEX idx_profiles_app_id ON profiles(app_id);
CREATE INDEX idx_comments_app_content ON comments(app_id, content_type, content_id);
CREATE INDEX idx_comments_parent ON comments(parent_comment_id) WHERE parent_comment_id IS NOT NULL;
CREATE INDEX idx_comments_user ON comments(app_id, user_id);
CREATE INDEX idx_comment_likes_app ON comment_likes(app_id);
CREATE INDEX idx_user_prefs_app_user ON user_preferences(app_id, user_id);
CREATE INDEX idx_notif_sched_app_user ON notification_schedules(app_id, user_id);
```

### 4.3 RLS 정책

```sql
-- 공통 패턴: JWT의 app_id로 필터링 + NULL 방어
-- 모든 테이블에 동일 적용

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "profiles_select" ON profiles FOR SELECT
  USING (app_id = COALESCE(
    current_setting('request.jwt.claims', true)::json->>'app_id',
    '___INVALID___'
  ));

CREATE POLICY "profiles_insert" ON profiles FOR INSERT
  WITH CHECK (
    auth.uid() = id
    AND app_id = COALESCE(
      current_setting('request.jwt.claims', true)::json->>'app_id',
      '___INVALID___'
    )
  );

CREATE POLICY "profiles_update" ON profiles FOR UPDATE
  USING (
    auth.uid() = id
    AND app_id = COALESCE(
      current_setting('request.jwt.claims', true)::json->>'app_id',
      '___INVALID___'
    )
  );

-- comments, comment_likes, user_preferences, notification_schedules:
-- 동일 패턴으로 SELECT(app_id 매칭), INSERT/UPDATE/DELETE(app_id + user_id 매칭)
```

### 4.4 RPC 함수

```sql
-- 좋아요 토글 (원자적)
CREATE OR REPLACE FUNCTION toggle_comment_like(
  p_app_id TEXT, p_user_id UUID, p_comment_id UUID
) RETURNS JSON AS $$
DECLARE
  v_liked BOOLEAN;
  v_count INTEGER;
BEGIN
  IF EXISTS (
    SELECT 1 FROM comment_likes
    WHERE user_id = p_user_id AND comment_id = p_comment_id AND app_id = p_app_id
  ) THEN
    DELETE FROM comment_likes
    WHERE user_id = p_user_id AND comment_id = p_comment_id AND app_id = p_app_id;
    UPDATE comments SET like_count = GREATEST(like_count - 1, 0) WHERE id = p_comment_id;
    v_liked := false;
  ELSE
    INSERT INTO comment_likes (app_id, user_id, comment_id)
    VALUES (p_app_id, p_user_id, p_comment_id);
    UPDATE comments SET like_count = like_count + 1 WHERE id = p_comment_id;
    v_liked := true;
  END IF;
  SELECT like_count INTO v_count FROM comments WHERE id = p_comment_id;
  RETURN json_build_object('is_liked', v_liked, 'like_count', v_count);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 신규 가입 시 프로필 자동 생성
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, app_id, email, display_name, avatar_url, provider)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_app_meta_data->>'app_id', 'default'),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name'),
    NEW.raw_user_meta_data->>'avatar_url',
    COALESCE(NEW.raw_app_meta_data->>'provider', 'email')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

---

## 5. 코드 추출 소스 (기존 프로젝트 → 라이브러리)

| 패키지 | 소스 프로젝트 | 핵심 파일 | 일반화 작업 |
|--------|-------------|----------|------------|
| core | praynews | `lib/core/errors/app_exceptions.dart` | 앱 이름 제거 |
| supabase_client | devotional | `lib/config/supabase_initializer.dart` | app_id 파라미터 추가 |
| auth | devotional | `lib/data/services/social_auth/unified_social_auth_service.dart` | app_id 주입, Kakao 분리 |
| pagination | devotional | `lib/data/repositories/base/paginated_supabase_repository.dart` | 제네릭화 |
| comments | devotional | `lib/data/repositories/supabase_comment_repository.dart` | devotion_id → content_type + content_id |
| cache | praynews | `lib/core/cache/cache_manager.dart` | 인터페이스 추출 |
| error_logging | devotional | `lib/core/services/error_logging_service.dart` | DSN .env 이동 |
| theme | praynews | `lib/presentation/theme/app_theme.dart` | ThemeConfig 기반으로 변환 |
| notifications | devotional | `lib/core/services/notification_service.dart` | 앱 참조 제거 |

### 일반화 규칙

1. **앱 특정 참조 제거**: `PrayNewsException` → `AppException`
2. **하드코딩 → 파라미터**: `devotion_id` → `content_type` + `content_id`
3. **싱글톤 → DI**: `Supabase.instance.client` → 생성자 주입
4. **app_id 추가**: 모든 Supabase 작업에 자동 스코핑
5. **Riverpod 3.0 마이그레이션**: StateNotifier → Notifier/AsyncNotifier

---

## 6. 새 앱 생성 시 구조

```
apps/{app_name}/
├── specs/                              # 앱별 spec
│   └── REQUIREMENTS.md
├── lib/
│   ├── main.dart                       # 엔트리포인트
│   ├── app.dart                        # ProviderScope + MaterialApp.router
│   ├── config/
│   │   └── app_config.dart             # appId, supabase URL/key
│   ├── router/
│   │   └── app_router.dart             # go_router
│   └── features/                       # feature-first
│       ├── {feature}/
│       │   ├── viewmodel/{name}_viewmodel.dart
│       │   └── view/{name}_view.dart
│       └── ...
├── assets/                             # 앱 고유 에셋
├── pubspec.yaml                        # 필요한 패키지만 의존
├── .env.example
└── analysis_options.yaml               # 루트 상속
```

### app_config.dart 예시

```dart
class AppConfig {
  static const String appId = 'calculator';
  static const String appName = 'Calculator';
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String sentryDsn = String.fromEnvironment('SENTRY_DSN');
}
```

### pubspec.yaml 예시 (계산기 앱)

```yaml
name: calculator
description: Calculator app built with App Library

environment:
  sdk: ^3.9.0

dependencies:
  flutter:
    sdk: flutter

  # 공유 패키지 (필요한 것만)
  app_lib_core:
    path: ../../packages/core
  app_lib_supabase_client:
    path: ../../packages/supabase_client
  app_lib_auth:
    path: ../../packages/auth
  app_lib_theme:
    path: ../../packages/theme
  app_lib_error_logging:
    path: ../../packages/error_logging

  # 앱 고유 의존성
  math_expressions: ^2.4.0

resolution: workspace
```

---

## 7. Melos 설정

```yaml
# melos.yaml
name: app_library

packages:
  - packages/**
  - apps/**

command:
  bootstrap:
    usePubspecOverrides: true

scripts:
  analyze:
    run: melos exec -- flutter analyze
    description: Analyze all packages

  test:
    run: melos exec -- flutter test
    description: Run tests in all packages

  build_runner:
    run: melos exec -- dart run build_runner build --delete-conflicting-outputs
    description: Run build_runner in packages that use it
    packageFilters:
      dependsOn: build_runner

  format:
    run: melos exec -- dart format lib
    description: Format all packages

  clean:
    run: melos exec -- flutter clean
    description: Clean all packages
```

### Root pubspec.yaml (Pub Workspaces)

```yaml
name: app_library_workspace
publish_to: none

environment:
  sdk: ^3.9.0

workspace:
  - packages/core
  - packages/supabase_client
  - packages/auth
  - packages/pagination
  - packages/comments
  - packages/notifications
  - packages/error_logging
  - packages/cache
  - packages/theme
  - packages/l10n
  - packages/ui_kit
  - apps/template_app
```
