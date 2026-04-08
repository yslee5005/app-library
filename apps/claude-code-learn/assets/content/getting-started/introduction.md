<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/introduction -->

# Claude Code 소개

## 개요

Claude Code는 터미널에서 실행되는 AI 코딩 에이전트로, 파일시스템, 셸, 도구에 직접 접근하여 자연어 지시사항을 코드 구현으로 변환합니다.

## 주요 기능

**파일 읽기/편집**: Claude가 소스 파일을 읽고 쓰며 변경사항을 diff로 표시합니다.

**셸 명령 실행**: 테스트, 빌드 스크립트, git 작업을 권한 제어와 함께 실행합니다.

**코드베이스 검색**: glob 패턴과 정규표현식으로 파일을 찾습니다.

**웹 데이터 수집**: 문서, API 스펙 조회 또는 웹 검색이 터미널에서 가능합니다.

**다중 에이전트**: 복잡한 작업을 병렬 작업 흐름으로 분할합니다.

**MCP 서버 연결**: 데이터베이스, API, 내부 도구 확장이 가능합니다.

## 권한 시스템

| 모드 | 동작 |
|------|------|
| `default` | 셸 명령과 편집 전 승인 필요 |
| `acceptEdits` | 파일 편집 자동 적용, 명령은 승인 필요 |
| `plan` | 대규모 변경 전 계획 검토 요청 |
| `bypassPermissions` | 모든 작업 자동 실행 (샌드박스 환경용) |

플래그: `claude --permission-mode acceptEdits`

## CLAUDE.md 메모리 시스템

세 가지 범위:
- **프로젝트** (루트): 팀 공유, 소스 제어 포함
- **개인** (`CLAUDE.local.md`): 개인 설정, gitignore 처리
- **하위디렉토리**: 모노레포 모듈별 자동 로드

`/init` 명령으로 자동 생성 가능합니다.

## 인증

OAuth (Anthropic 계정) 또는 `ANTHROPIC_API_KEY` 환경변수 지원합니다.
