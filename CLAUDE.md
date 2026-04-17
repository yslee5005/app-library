# App Library

Flutter 마스터 레퍼런스 라이브러리. 검증된 코드를 보관하고, 새 앱을 만들 때 복붙해서 독립 repo로 운영.

## 핵심 전략
- **마스터 레퍼런스** (이 repo) = 정답 코드 보관소
- **각 앱** = 독립, 마스터에서 복붙 + 커스텀
- **인프라 공유** = Supabase 1개 + Sentry 1개, 앱별 PostgreSQL 스키마로 격리
- **앱 간 의존성 없음** = 한 앱 수정이 다른 앱에 영향 안 줌

## 기술 스택
Flutter (Dart 3.9+), Riverpod 3.0, Supabase, go_router, freezed, Sentry, Next.js (web)

## 명령어
```bash
# Flutter
flutter analyze apps/{app}
flutter run --profile  # 물리 디바이스 (iOS 26 JIT 제한)
flutter run             # 시뮬레이터

# Next.js (BlackLabelled web)
cd apps/blacklabelled/web && npm run build
cd apps/blacklabelled/web && npx vitest run

# Supabase (수동 실행 — Ralph 직접 실행 금지)
supabase db push --linked
```

## Boundaries

### Always
- 새 테이블 → RLS 즉시 활성화
- RLS에 COALESCE NULL 방어
- flutter_dotenv 런타임 로딩 (`String.fromEnvironment` 금지)
- .env → .gitignore
- 릴리스 → `--obfuscate`
- **Anonymous-First** — 모든 앱은 로그인 없이 시작
- 수정 전 반드시 해당 파일 Read

### Never
- service_role 키 클라이언트 포함
- JWT Secret 클라이언트 포함
- SharedPreferences에 토큰 저장
- pub.dev 배포
- rm -rf
- .env 파일 커밋
- 로그인을 앱 시작의 필수 조건으로 만들기

### Ask First
- Supabase 스키마/RLS 변경
- 마스터 레퍼런스 코드의 인터페이스 변경
- DB 마이그레이션 직접 실행

## MoAI 워크플로우

### Decision Gate (기능 결정 시 /decide 필수)
- 유저 동작/경험이 바뀌는 변경 → `/decide` 실행 후 옵션 제시 → STOP
- 버그 수정/리팩토링 → 6하원칙 분석 → STOP
- **코드 수정은 "실행" 후에만** — 옵션 선택 없이 임의로 결정 금지

### 분석/계획 ("계획해" = 분석만, 코드 수정 금지)
- Agent로 deep research + 파일 Read 필수
- 결과: 문제정의 / 핵심발견 / 실행계획 / 예상결과
- false positive check 포함
- STOP — "실행" 전까지 대기

### 실행 ("실행" 후)
- 3개+ 파일 → Ralph agent 사용
- 코드 전 구현 방향 1줄 설명
- 완료 후 `flutter analyze` / `next build` 필수
- 과최적화 체크: "MVP에 필요한가?"

### Ralph Loop
- 최대 반복: 10회
- 완료: zero errors + 로직 검증

### 컨텍스트 관리
- 대화 1개 = 1개 기능 단위
- 길어지면 → 커밋 → 새 대화

## 상세 규칙 (자동 로드)
`.claude/rules/` 디렉토리에 도메인별 규칙 파일:
- `auth.md` — Anonymous-First 인증 패턴
- `env.md` — flutter_dotenv 사용법
- `security.md` — 키/시크릿 보호
- `supabase.md` — 테이블/RLS/마이그레이션
- `responsive.md` — 반응형 레이아웃
- `apps.md` — 앱 구조/네이밍
- `deploy.md` — 배포 체크리스트 + 추천 패키지
- `copy-paste.md` — 마스터→앱 복붙 가이드
- `moai.md` — MoAI 프롬프트 템플릿
