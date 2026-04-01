# REQUIREMENTS.md — App Library

> Version: 2.0 | Last Updated: 2026-04-01 | Last Verified: 2026-04-01
> Status: Draft
> Changes: YC 검증 워크플로우 추가, Ralph Loop 통합, 보안 강화, @include 최적화

---

## 1. 프로젝트 비전

재사용 가능한 Flutter 컴포넌트 패키지 라이브러리를 구축하여, 새 앱 아이디어가 있을 때 AI가 패키지를 조립하고 UI만 입히면 앱이 완성되는 시스템.

**핵심 가치:**
- 아이디어 → AI가 패키지 조립 → UI 테마 적용 → 새 앱 완성
- 새 DB 호스팅 불필요 (단일 Supabase, app_id로 격리)
- 기존 6개 앱은 리팩토링하지 않음, 신규 앱에만 적용

---

## 2. 기술 스택

| 항목 | 선택 | 비고 |
|------|------|------|
| Framework | Flutter (Dart 3.9+) | |
| State Management | Riverpod 3.0 | |
| Backend | Supabase | 신규 프로젝트, 멀티테넌트 |
| Router | go_router | |
| Models | freezed + json_serializable | |
| Error Logging | Sentry | |
| Monorepo | Melos + Pub Workspaces | |
| 패키지 배포 | path 의존성만 (pub.dev 없음) | |

---

## 3. 공유 패키지 요구사항

### 3.1 core
- **목적:** 순수 Dart 기반 공통 모듈 (Flutter 의존성 없음)
- **포함:** 에러 계층 (AppException hierarchy), Result 타입, 기본 모델 (PaginatedResult 등), 유틸리티, 상수
- **제약:** 외부 의존성 0개

### 3.2 supabase_client
- **목적:** app_id 인식 Supabase 클라이언트 래퍼
- **기능:**
  - AppSupabaseClient: 모든 쿼리에 자동 app_id 스코핑
  - 환경별 설정 (dev/staging/prod)
  - .env 기반 URL/Key 관리
- **제약:** service_role 키는 클라이언트에 포함 금지

### 3.3 auth
- **목적:** 인증 모듈
- **기본 제공:** Google Sign-In, Apple Sign-In, Email/Password
- **확장 가능:** Kakao 등 추가 provider는 나중에 UI 토글로 활성화
- **기능:**
  - Supabase Auth 연동
  - JWT app_metadata에 app_id 주입
  - AuthState 관리 (Riverpod provider)
  - 프로필 자동 생성 (신규 가입 시)
  - 로그아웃, 계정 삭제
- **제약:** provider 추가/제거가 앱 코드 변경 없이 가능해야 함

### 3.4 pagination
- **목적:** 커서 기반 페이지네이션 + 무한 스크롤
- **기능:**
  - PaginationController (Riverpod Notifier)
  - PaginatedSupabaseRepository (제네릭)
  - InfiniteScrollList / InfiniteScrollGrid 위젯
  - 새로고침, 에러 재시도
- **제약:** UI 위젯은 선택적 사용 (로직만 쓸 수 있어야 함)

### 3.5 comments
- **목적:** 댓글 + 답글 + 좋아요 시스템
- **기능:**
  - CRUD (생성, 읽기, 수정, 삭제)
  - 중첩 답글 (parent_comment_id)
  - 좋아요 토글 (원자적)
  - content_type + content_id로 어떤 콘텐츠에든 연결
  - 페이지네이션 (pagination 패키지 의존)
- **제약:** content_type은 앱에서 자유롭게 정의

### 3.6 notifications
- **목적:** 로컬 + 푸시 알림
- **기능:**
  - 로컬 알림 스케줄링
  - 알림 권한 요청
  - 알림 설정 저장 (Supabase)
- **제약:** FCM 푸시는 Phase 2에서 추가 (v1은 로컬만)

### 3.7 error_logging
- **목적:** Sentry 통합 래퍼
- **기능:**
  - 에러 레벨별 로깅
  - 민감 정보 필터링
  - 환경별 DSN 관리
  - breadcrumb 추가
- **제약:** Sentry DSN은 .env로 관리

### 3.8 cache
- **목적:** 메모리 + 디스크 2단계 캐시
- **기능:**
  - CacheInterface (추상)
  - MemoryCache (TTL 기반)
  - DiskCache (SharedPreferences 또는 Hive)
  - CacheManager (2단계 조합)
  - CacheManagementMixin (Repository에서 사용)
- **제약:** 민감 데이터는 캐시 금지 (flutter_secure_storage 사용)

### 3.9 theme
- **목적:** 시드 컬러 기반 테마 생성기
- **기능:**
  - ThemeConfig: 시드 컬러, 폰트 지정 → 전체 ThemeData 생성
  - 라이트/다크 모드 자동 생성
  - 디자인 토큰 (AppColors, AppSpacing, AppRadius, AppTypography)
- **제약:** Material 3 기반

### 3.10 l10n
- **목적:** 다국어 헬퍼
- **기능:**
  - 로케일 감지
  - 상대 시간 포맷팅
  - 숫자 포맷팅
- **제약:** 앱별 번역 파일은 앱 내부에서 관리

### 3.11 ui_kit
- **목적:** 공통 UI 위젯
- **포함:** 버튼, 카드, 로딩 (스켈레톤/시머), 빈 상태, 에러 바운더리, 검색바, 바텀 내비게이션
- **제약:** theme 패키지의 디자인 토큰 사용

---

## 4. 멀티테넌트 요구사항

### 4.1 데이터 격리
- 모든 테이블에 `app_id` 컬럼 필수
- RLS 정책으로 app_id 기반 자동 필터링
- JWT app_metadata에서만 app_id 읽기 (클라이언트 파라미터 신뢰 금지)

### 4.2 인증
- 단일 Supabase Auth 인스턴스
- 앱별 사용자 프로필 분리 (같은 이메일이라도 app_id별 별도 프로필)
- Google/Apple OAuth redirect URL은 앱별 설정

### 4.3 스키마 관리
- 공통 테이블: profiles, comments, comment_likes, user_preferences, notification_schedules, app_versions
- 앱 고유 테이블: `{app_id}_{table_name}` 네이밍 또는 공통 테이블에 content_type으로 구분

---

## 5. 새 앱 생성 워크플로우 요구사항

사용자가 "계산기 앱 만들어줘"라고 했을 때:

### Step 0: YC 검증 (NEW — 아이디어 검증)
1. YC 4P 질문: Persona, Problem, Promise, Product(MVP)
2. Tar pit 체크 (이미 포화된 아이디어 경고)
3. 첫 100명 유저 확보 전략
4. 산출물: `apps/{app_name}/specs/IDEA.md`
5. 판정: VALIDATED / PIVOT / REJECTED

### Step 1: 상의 + SDD spec 생성
1. 기술 질문 (로그인?, 데이터 저장?)
2. `apps/{app_name}/specs/REQUIREMENTS.md` 작성
3. 필요한 패키지 자동 선택 (매핑 테이블 기반)

### Step 2: 디자인 (Stitch)
1. Stitch에 요구사항 전달 → UI 디자인
2. 시드 컬러, 레이아웃 확정 → DESIGN.md 반영

### Step 3: Ralph 자율 실행
1. PROMPT.md 생성 (SDD spec + Boundaries)
2. feature 브랜치 생성: `ralph/{app_name}`
3. `ralph --monitor` 실행
4. Ralph 자율 구현 (2-4시간)

### Step 4: 리뷰 + 배포
1. `git diff` 리뷰
2. 앱 실행 + 수동 테스트
3. 문제 있으면 Claude Code에 수정 요청
4. Supabase 마이그레이션 수동 적용
5. main 머지 → 빌드 → 배포

---

## 6. 경계 조건 (하지 않을 것)

- 기존 6개 앱을 이 라이브러리로 마이그레이션하지 않음
- pub.dev에 패키지를 배포하지 않음
- 앱스토어 배포 자동화는 범위 밖 (CI/CD는 별도)
- Flutter Web/Desktop 지원은 범위 밖 (모바일 only)
- 백엔드 서버 구축 없음 (Supabase + Edge Function만)

---

## 7. 새 앱 생성 규칙 (v1 — 기본)

<!-- TODO: 첫 앱 구현 시 v2로 구체화 -->

### 7.1 앱별 Spec 템플릿

새 앱 생성 시 `apps/{app_name}/specs/` 에 아래 파일 생성:

```markdown
# apps/{app_name}/specs/REQUIREMENTS.md
## 앱 이름: {app_name}
## 한줄 설명: ...
## 핵심 기능: (bullet list)
## 필요한 공유 패키지: (체크리스트)
## 앱 고유 기능: (bullet list)
## Supabase 추가 테이블: (있으면 기술)
```

### 7.2 패키지 선택 가이드

| 앱에 이 기능이 있으면 | 이 패키지를 import |
|---------------------|-------------------|
| 아무 앱이나 (필수) | core, supabase_client, theme, error_logging |
| 로그인/회원가입 | auth |
| 리스트 (피드, 목록) | pagination |
| 댓글/리뷰/답글 | comments (+ pagination) |
| 알림/리마인더 | notifications |
| 오프라인/캐시 | cache |
| 다국어 지원 | l10n |
| 공통 UI 위젯 | ui_kit |

### 7.3 앱 스캐폴딩

1. `apps/template_app/` 을 `apps/{app_name}/` 으로 복사
2. `app_config.dart` 에서 `appId`, `appName`, Supabase 설정 수정
3. 불필요한 패키지 의존성 pubspec.yaml에서 제거
4. `features/` 디렉토리에 앱 고유 기능 추가

### 7.4 Supabase 테이블 추가 규칙

- 테이블명: `snake_case`, 복수형
- `app_id TEXT NOT NULL` 컬럼 필수
- `created_at TIMESTAMPTZ DEFAULT now()` 필수
- RLS 즉시 활성화 + 정책 추가
- 마이그레이션 파일: `supabase/migrations/{순번}_{설명}.sql`

### 7.5 앱 간 데이터 공유 범위

- **기본 정책: 완전 격리** — 각 앱의 데이터는 해당 app_id로만 접근
- 같은 이메일로 다른 앱에 가입해도 별도 프로필
- 향후 필요 시 "공유 프로필" 옵션 추가 가능

### 7.6 UI 디자인 입력 방식

- **v1:** 시드 컬러 + 폰트를 ThemeConfig에 지정, 위젯은 수동 작성
- **향후:** Stitch/Figma 디자인 → 코드 변환 워크플로우 추가 예정
