# Architecture — App Library

> 에이전트를 위한 코드 지도. 여기서 시작하여 필요한 곳으로 이동.

## 레이어 맵

```
app-library/
├── packages/           ← 공유 레퍼런스 (복붙 소스)
│   ├── core/           ← 기초: Result, NetworkChecker, ScreenSize, EnvValidator
│   ├── auth/           ← 인증 패턴 (AnonymousAuthService 포함)
│   ├── supabase_client/← app_id 스코핑 패턴
│   ├── error_logging/  ← Sentry 래퍼
│   ├── subscriptions/  ← RevenueCat 래핑 (SubscriptionService)
│   ├── gamification/   ← Streak, Milestone, StreakCalculator
│   ├── feed/           ← 소셜 피드 CRUD (FeedRepository)
│   ├── ui_kit/         ← PremiumGate, StreakBadge, 공통 위젯
│   ├── cache/          ← 메모리+디스크 캐시
│   ├── pagination/     ← 커서 페이지네이션
│   ├── comments/       ← 댓글/좋아요
│   ├── notifications/  ← 로컬 알림
│   ├── theme/          ← 시드 컬러 테마
│   └── l10n/           ← 다국어
│
├── apps/               ← 각 앱 (독립적, 패키지에서 복붙)
│   ├── abba/           ← 기도/QT AI 동반자 (Flutter)
│   ├── blacklabelled/  ← 인테리어 스튜디오 (Flutter + Next.js)
│   ├── pet-life/       ← 반려동물 건강관리 (Flutter)
│   ├── showcase/       ← 위젯 카탈로그 데모
│   └── mart-scanner/   ← (specs만, 미구현)
│
├── supabase/           ← 공유 DB 마이그레이션
│   └── migrations/     ← SQL (app_id 스코핑)
│
├── CLAUDE.md           ← 에이전트 행동 원칙 (무엇을 하고 하지 말 것)
├── ARCHITECTURE.md     ← 이 파일 (코드 지도)
└── DECISIONS.md        ← 설계 결정 기록 (왜 이렇게 했는지)
```

## 앱 내부 레이어 (모든 앱 동일)

```
app/lib/
├── main.dart           ← 진입점: AppHarness 또는 수동 초기화
├── config/             ← 환경변수 (--dart-define)
├── router/             ← go_router (화면 경로)
├── providers/          ← Riverpod (서비스 → 뷰 연결)
├── models/             ← 데이터 모델 (fromJson/toJson)
├── services/           ← 비즈니스 로직
│   ├── auth_service.dart       ← abstract
│   ├── mock/                   ← JSON 기반 mock 구현
│   └── real/                   ← Supabase/API 실제 구현
├── features/           ← 화면별 폴더
│   └── {feature}/
│       └── view/               ← UI (ConsumerWidget/ConsumerStatefulWidget)
├── widgets/            ← 공유 위젯
├── theme/              ← 앱 고유 테마
└── l10n/               ← ARB 파일 (다국어)
```

## 데이터 흐름 (단방향)

```
User Action → View → Provider → Service → Supabase/API
                                    ↓
                              Model (fromJson)
                                    ↓
                           Provider (state update)
                                    ↓
                              View (rebuild)
```

## 레이어 규칙 (위반 시 빌드 실패해야 함)

| 레이어 | import 가능 | import 불가 |
|--------|------------|------------|
| models/ | dart:core만 | services, features, providers |
| services/ | models/ | features, providers, widgets |
| providers/ | services/, models/ | features, widgets |
| features/view/ | providers/, models/, widgets/, theme/ | services/ 직접 import 금지 |
| widgets/ | theme/ | services/, providers/, features/ |

**View가 Service를 직접 호출하면 안 됨 → 반드시 Provider를 통해서.**

## 인증 패턴 (Anonymous-First)

```
앱 시작 → getCurrentUser()
          ├── 있음 → Home
          └── 없음 → signInAnonymously() → Home
                     (로그인 화면 없음)

Settings → "계정 연결" → linkIdentity() → 데이터 병합
```

## DB 패턴 (모든 테이블)

```sql
CREATE TABLE {name} (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT '{앱이름}',  -- 필수
  user_id UUID NOT NULL REFERENCES auth.users(id),  -- 필수
  ...
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE {name} ENABLE ROW LEVEL SECURITY;  -- 필수
CREATE POLICY ... USING (
  auth.uid() = user_id AND COALESCE(app_id, '') = '{앱이름}'  -- NULL 방어
);
```

## 여기에 없는 것

- 배포 설정 (fastlane, App Store Connect) → 각 앱의 `ios/fastlane/`
- 환경변수 값 → `.env` (gitignore됨)
- 크롤링/데이터 수집 → `apps/blacklabelled/crawl/` (gitignore됨)
- CI/CD 파이프라인 → 미구현
