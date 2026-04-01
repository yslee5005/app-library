# PROMPT.md — App Library Phase {N}: {Phase 이름}

## 컨텍스트
CLAUDE.md를 읽고 따를 것.
specs/design/DESIGN.md 섹션 {관련 섹션}을 참조할 것.
specs/security/SECURITY.md를 참조할 것.

## 체크리스트
{TASKS.md에서 해당 Phase의 태스크 복사}

## 수락 기준
{각 태스크의 완료 조건}

## MCP 도구 활용

### Supabase MCP (DB 작업 시)
- 마이그레이션 SQL 작성 후 → Supabase MCP로 dev DB에 테스트 적용
- RLS 정책 적용 후 → 다른 app_id로 접근 차단 확인 쿼리 실행
- `SELECT * FROM {table} WHERE app_id = 'wrong_id'` → 결과 0건이어야 함
- 주의: **read_only=false일 때만** 쓰기 작업 가능

### Flutter/Dart MCP (코드 작업 시)
- Riverpod 3.0 API 사용 전 → 최신 문서 확인
- 패키지 추가 시 → pub.dev에서 최신 안정 버전 확인
- 불확실한 API → Flutter MCP로 정확한 사용법 조회

## Boundaries

### Always
- 매 태스크 완료 후 `flutter test` 또는 `dart test` 실행
- 새 기능에는 반드시 테스트 추가
- git commit 메시지에 태스크 설명 포함

### Never
- git push 실행 금지
- rm -rf 실행 금지
- .env 파일 수정 금지
- 기존 테스트 삭제 금지
- 외부 API 직접 호출 금지
- DB 마이그레이션 실행 금지
- pub.dev publish 금지

### Ask First (이 항목은 건너뛰고 다음 태스크로)
- 새 외부 의존성이 필요한 경우
- Supabase 스키마 변경이 필요한 경우
