# App Library

Flutter 마스터 레퍼런스 라이브러리. 검증된 코드를 보관하고, 새 앱을 만들 때 필요한 코드를 복붙해서 독립 repo로 운영.

## 핵심 전략

- **마스터 레퍼런스** (이 repo) = 정답 코드 보관소 + showcase 데모
- **각 앱** = 독립 repo, 마스터에서 필요한 코드를 복붙 + 커스텀
- **인프라 공유** = Supabase 1개 + Sentry 1개, app_id로 앱 구분
- **앱 간 의존성 없음** = 한 앱 수정이 다른 앱에 영향 안 줌

## 기술 스택
Flutter (Dart 3.9+), Riverpod 3.0, Supabase, go_router, freezed, Sentry

## 마스터 레퍼런스 구조

```
app-library/              ← 이 repo (마스터)
├── packages/             ← 레퍼런스 구현 (복붙 소스)
│   ├── core/             ← Result, Exception, 모델
│   ├── supabase_client/  ← app_id 스코핑 패턴
│   ├── auth/             ← Google/Apple/Email 인증
│   ├── error_logging/    ← Sentry 래퍼 + 필터
│   ├── cache/            ← 메모리+디스크 캐시
│   ├── pagination/       ← 커서 페이지네이션
│   ├── comments/         ← 댓글/좋아요
│   ├── notifications/    ← 로컬 알림
│   ├── theme/            ← 시드 컬러 테마
│   ├── l10n/             ← 다국어
│   └── ui_kit/           ← 위젯 카탈로그 (43개)
├── apps/showcase/        ← 데모 앱 (위젯 카탈로그)
├── supabase/migrations/  ← 공유 스키마 + RLS (모든 앱 공통)
└── specs/                ← SDD 문서
```

```
별도 repo (각 앱):
pet-life/          ← 독립 빌드, .env로 인프라 연결
blacklabelled/     ← 독립 빌드, .env로 인프라 연결
mart-scanner/      ← (예정)
```

## 공유 인프라

Supabase 1개 인스턴스 + Sentry 1개 프로젝트를 모든 앱이 공유. app_id로 격리.

각 앱의 `.env`:
```
APP_ID=pet-life
SUPABASE_URL=https://xxx.supabase.co
SUPABASE_ANON_KEY=eyJ...
SENTRY_DSN=https://xxx@sentry.io/xxx
```

URL, KEY, DSN 동일. APP_ID만 다름.

## 새 앱 생성 워크플로우

### Step 0: YC 검증 (아이디어 → 만들기 전에)
4P 질문으로 아이디어 검증:
1. **Persona** — 누가 쓰나? 구체적 사용자 프로필
2. **Problem** — 그 사람의 "hair on fire" 문제가 뭔가?
3. **Promise** — 한 문장으로 뭘 해결하나?
4. **Product** — MVP로 뭘 만들면 검증 가능한가?
산출물: `apps/{app}/specs/IDEA.md`

### Step 1: 상의 + SDD spec 생성
기술 질문 → REQUIREMENTS.md + DESIGN.md 생성

### Step 2: Stitch 디자인
UI 디자인 받아서 DESIGN.md에 반영

### Step 3: 독립 repo 생성
- 마스터에서 필요한 코드 복붙 (아래 "복붙 가이드" 참고)
- `.env` 설정 (APP_ID + Supabase + Sentry)
- `flutter create` → 앱 코드 작성

### Step 4: Ralph 자율 실행 → 리뷰 → 배포

## 복붙 가이드 (마스터에서 앱으로)

| 필요한 기능 | 마스터에서 복붙할 곳 | 앱에서 커스텀할 것 |
|------------|-------------------|-----------------|
| 인증 | `packages/auth/` | provider, UI |
| DB 연결 | `packages/supabase_client/` | APP_ID, .env |
| 에러 로깅 | `packages/error_logging/` | DSN, 필터 규칙 |
| 캐시 | `packages/cache/` | TTL, 키 |
| 페이지네이션 | `packages/pagination/` | 위젯 UI |
| 댓글 | `packages/comments/` | content_type |
| 알림 | `packages/notifications/` | 알림 내용 |
| UI 위젯 | `packages/ui_kit/` | 디자인 전체 |
| 테마 | `packages/theme/` | 시드 컬러, 폰트 |

**원칙: 복붙 후 앱에 맞게 자유롭게 수정. 마스터와 동기화 강제 없음.**

## 배포 전 AI 체크리스트

앱 배포 전 AI에게 확인 요청:
- [ ] `.env`에 service_role 키 없는지
- [ ] RLS app_id 스코핑 정상 작동하는지
- [ ] Sentry에 민감 정보 필터 적용됐는지
- [ ] 마스터 대비 보안 관련 코드 차이 확인 (중요 버그 수정 누락 여부)

## 추천 pub.dev 패키지 (래핑 불필요, 앱에서 직접 사용)

| 기능 | 패키지 | 비고 |
|------|--------|------|
| 이미지 캐싱 | cached_network_image | |
| URL 열기 | url_launcher | |
| 스와이프 액션 | flutter_slidable | Flutter Favorite |
| 무한 스크롤 UI | infinite_scroll_pagination | Flutter Favorite |
| 차트 | fl_chart | |
| 시머 로딩 | shimmer | |
| 이미지 선택 | image_picker | 공식 |
| 웹뷰 | webview_flutter | 공식 |
| 지도 | google_maps_flutter | 공식 |
| 카메라 | camera | 공식 |
| 소셜 공유 | share_plus | 공식 |
| 위치 | geolocator | |
| 생체인증 | local_auth | 공식 |

이 패키지들은 이미 수백만 다운로드로 검증됨. 직접 구현하지 말 것.

## Boundaries (컴팩션 후에도 유지되도록 여기에 명시)

### Always
- 새 테이블 → RLS 즉시 활성화 + app_id 컬럼 필수
- RLS에 COALESCE NULL 방어
- flutter_secure_storage로 민감 데이터 저장
- .env → .gitignore
- 릴리스 → --obfuscate

### Never
- service_role 키 클라이언트 포함
- JWT Secret 클라이언트 포함
- SharedPreferences에 토큰 저장
- 클라이언트 app_id를 RLS에서 신뢰
- pub.dev 배포
- rm -rf
- .env 파일 커밋

### Ask First
- Supabase 스키마/RLS 변경
- 마스터 레퍼런스 코드의 인터페이스 변경
