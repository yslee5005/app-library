# App Library

Flutter 공유 컴포넌트 라이브러리 (Melos 모노레포, 11개 패키지). 새 앱은 패키지 조립 + UI 테마 적용으로 빠르게 생성.

## 기술 스택
Flutter (Dart 3.9+), Riverpod 3.0, Supabase, go_router, freezed, Sentry, Melos + Pub Workspaces

## 아키텍처
Hexagonal (Ports & Adapters). 의존성: core ← data ← providers ← app (역방향 금지)

## Spec (코드 작성 전 반드시 읽을 것)
@specs/requirements/REQUIREMENTS.md
@specs/design/DESIGN.md
@specs/tasks/TASKS.md
@specs/security/SECURITY.md

## 새 앱 생성 워크플로우

### Step 0: YC 검증 (아이디어 → 만들기 전에)
4P 질문으로 아이디어 검증:
1. **Persona** — 누가 쓰나? 구체적 사용자 프로필
2. **Problem** — 그 사람의 "hair on fire" 문제가 뭔가?
3. **Promise** — 한 문장으로 뭘 해결하나?
4. **Product** — MVP로 뭘 만들면 검증 가능한가?
추가 질문: 기존 대안은? 첫 100명 유저를 어디서 찾나?
"tar pit idea"(이미 포화된 단순 아이디어) 경고할 것.
산출물: `apps/{app}/specs/IDEA.md`

### Step 1: 상의 + SDD spec 생성
기술 질문 → REQUIREMENTS.md + DESIGN.md 생성

### Step 2: Stitch 디자인
UI 디자인 받아서 DESIGN.md에 반영

### Step 3: PROMPT.md → Ralph 자율 실행
Phase별 PROMPT.md 생성 → `ralph --monitor`

### Step 4: 리뷰 + 테스트 + 배포

## 패키지 선택 가이드

| 기능 | 패키지 |
|------|--------|
| 기본 (필수) | core, supabase_client, theme, error_logging |
| 로그인 | + auth |
| 리스트/피드 | + pagination |
| 댓글/리뷰 | + comments |
| 알림 | + notifications |
| 캐시 | + cache |
| 다국어 | + l10n |
| 공통 위젯 | + ui_kit |

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
인프라 래핑이 필요한 것(FCM, RevenueCat, Analytics)은 Thin Wrapper 패턴으로.

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
- 패키지 간 역방향 의존
- pub.dev 배포
- git push (Ralph 실행 중)
- rm -rf
- .env 파일 수정 (Ralph 실행 중)

### Ask First
- 새 외부 의존성 추가
- core 인터페이스 변경
- Supabase 스키마/RLS 변경
