<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/commands/overview -->

# Claude Code 명령어 개요

## 명령어 두 가지 범주

Claude Code는 두 종류의 명령어를 지원합니다:

**CLI 플래그**: 터미널에서 Claude 시작 시 전달하는 옵션 (예: `claude --model sonnet`)
- 세션 시작 전에 설정을 구성합니다

**슬래시 명령어**: 활성 세션 중에 입력하는 텍스트 명령어 (예: `/help`)
- 실행 중인 세션의 동작을 제어합니다

## 도움말 표시

```bash
# 모든 CLI 플래그 확인
claude --help

# 세션 중 슬래시 명령어 목록
/help
```

## 명령어 유형 비교

| 유형 | 사용 시점 | 예시 |
|------|---------|------|
| CLI 플래그 | 세션 시작 시 모델/권한 설정 | `claude --permission-mode acceptEdits "fix the tests"` |
| 슬래시 명령어 | 실행 중 메모리/모델/코드 커밋 관리 | `/commit` |

## CLI 플래그 사용법

```bash
claude [flags] [prompt]
```

**사용 예시:**
- 비대화형 모드: `claude -p "summarize this file" < README.md`
- 모델 설정: `claude --model opus`
- 자동 편집 승인: `claude --permission-mode acceptEdits`

## 키보드 단축키

| 단축키 | 기능 |
|--------|------|
| `Ctrl+C` | 현재 응답 중단 (대화 유지) |
| `Ctrl+D` | Claude Code 종료 |
| `Ctrl+L` | 터미널 화면 초기화 |
| `Up`/`Down` | 입력 기록 탐색 |
| `Tab` | 슬래시 명령어 자동완성 |
| `Escape` | 진행 중인 권한 프롬프트 취소 |

## 부가 서브명령어

```bash
claude mcp              # MCP 서버 구성 관리
claude mcp serve        # Claude Code를 MCP 서버로 실행
claude doctor           # 설치/구성 문제 진단
claude update           # 최신 버전으로 업데이트
```
