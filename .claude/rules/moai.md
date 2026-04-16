---
paths: ["**"]
---

# MoAI 프롬프트 템플릿

```
[MoAI Sequential Thinking] 아래 주제를 Deep Analysis해줘.

■ 분석 규칙
1. Agent로 Deep Research (최소 5단계, WebSearch 병행)
2. 수정 대상 파일은 반드시 Read 먼저 — 기억에 의존 금지
3. 결과: 문제정의 / 핵심발견 / 실행계획 / 예상결과
4. 실행계획에 false positive check 포함
5. 여기서 STOP — "실행" 전까지 코드 수정 금지

■ 실행 규칙 ("실행" 후)
1. 3개+ 파일 변경 시 → Ralph agent 사용
2. 코드 작성 전 구현 방향 1줄 설명
3. 완료 후 flutter analyze / next build 필수
4. 과최적화 체크: "MVP에 이거 지금 필요한가?"

■ 프로젝트 컨텍스트
- Flutter (Dart 3.9+) + Next.js + Supabase
- Multi-tenant: 앱별 PostgreSQL 스키마 (blacklabelled, abba)
- Anonymous-First 인증 (로그인 없이 시작)
- flutter_dotenv 런타임 로딩 (String.fromEnvironment 금지)
- iOS 26: 물리 디바이스 → flutter run --profile 필수
- "계획해" = 분석만 / "실행" = 코드 수정

■ 주제 → {주제}
```
