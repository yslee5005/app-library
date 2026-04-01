# PROMPT.md — {앱 이름} 앱 생성

## 컨텍스트
CLAUDE.md를 읽고 따를 것.
apps/{app_name}/specs/IDEA.md를 읽을 것.
apps/{app_name}/specs/REQUIREMENTS.md를 읽을 것.
specs/design/DESIGN.md를 참조할 것.

## 체크리스트
- [ ] apps/{app_name}/ 스캐폴딩 (template_app 복사)
- [ ] app_config.dart 수정 (appId: '{app_name}')
- [ ] pubspec.yaml 구성 (필요한 패키지만)
- [ ] 테마 설정 (시드 컬러: {color})
- [ ] 라우터 설정 (go_router)
- [ ] {기능 1} ViewModel + View 구현
- [ ] {기능 2} ViewModel + View 구현
- [ ] {기능 N} ViewModel + View 구현
- [ ] Supabase 테이블 마이그레이션 SQL 생성 (실행은 사용자가)
- [ ] 전체 테스트 실행
- [ ] melos run analyze 통과

## 수락 기준
- 앱 실행 시 크래시 없음
- 모든 화면 네비게이션 동작
- 공유 패키지 Provider 연동 확인
- 테스트 전체 통과

## MCP 도구 활용

### Supabase MCP
- 앱 고유 테이블 필요 시 → SQL 작성 후 Supabase MCP로 dev에서 테스트
- RLS 정책 검증: `app_id` 격리 확인 쿼리 실행
- 기존 공통 테이블(comments, profiles 등)은 SQL 작성 불필요 (이미 존재)

### Flutter/Dart MCP
- 앱 고유 패키지 추가 시 → 최신 버전 확인
- Riverpod 3.0 Provider 작성 시 → 올바른 API 패턴 확인

### Figma MCP (디자인 있을 때)
- Figma 링크가 있으면 → 디자인 토큰 추출 (컬러, 스페이싱)
- ThemeConfig에 자동 반영

## Boundaries

### Always
- 매 태스크 완료 후 테스트 실행
- 새 기능에 테스트 추가
- 공유 패키지의 Provider를 ref.watch로 사용

### Never
- git push, rm -rf, .env 수정
- 공유 패키지 코드 직접 수정 (패키지 내부 건드리지 말 것)
- 기존 테스트 삭제
- DB 마이그레이션 직접 실행
