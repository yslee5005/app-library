<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/commands/cli-flags -->

# Claude Code CLI Flags

## 개요

이 페이지는 Claude Code를 터미널에서 실행할 때 전달할 수 있는 모든 CLI 플래그에 대한 참고 자료입니다.

기본 명령 구조:
```bash
claude [flags] [prompt]
```

모든 플래그 확인: `claude --help`

---

## 핵심 플래그 (Core Flags)

### -p, --print

**기능**: Claude processes the prompt (from the argument or stdin), prints the response, and exits

- 상호작용 없이 실행
- 응답 출력 후 종료
- REPL 미시작

예시:
```bash
claude -p "explain the main function in src/index.ts"
echo "what does this do?" | claude -p
```

> 신뢰할 수 있는 디렉토리에서만 사용 (워크스페이스 신뢰 대화 건너뜀)

호환 옵션: `--output-format`, `--model`, `--system-prompt`, `--permission-mode`, `--max-turns`, `--allowed-tools`

---

### --output-format <format>

**용도**: --print 모드에서만 작동

| 값 | 설명 |
|---|---|
| `text` | 일반 텍스트 (기본값) |
| `json` | 완전한 결과의 단일 JSON 객체 |
| `stream-json` | 실시간 이벤트의 개행 구분 JSON 스트림 |

예시:
```bash
claude -p "list the exported functions" --output-format json
claude -p "refactor this file" --output-format stream-json
```

**활용**: stream-json을 사용하여 Claude의 출력을 증분 방식으로 처리할 수 있음

---

### --input-format <format>

**용도**: stdin 입력 형식 설정 (--print 전용)

| 값 | 설명 |
|---|---|
| `text` | 일반 텍스트 (기본값) |
| `stream-json` | 개행 구분 JSON 스트림 |

제약: stream-json 입력에는 `--output-format stream-json` 필수

```bash
cat messages.jsonl | claude -p --input-format stream-json --output-format stream-json
```

---

### --verbose

출력 상세도 활성화 (설정 파일의 verbose 설정 재정의)

```bash
claude --verbose
claude -p "debug this" --verbose
```

---

### -v, --version

버전 번호 출력 후 종료

```bash
claude --version
claude -v
```

---

### -h, --help

명령 도움말 표시

```bash
claude --help
claude mcp --help
```

---

## 세션 지속 플래그 (Session Continuation Flags)

### -c, --continue

가장 최근 대화 재개 (선택 프롬프트 없음)

```bash
claude --continue
claude -c "now add tests for that"
```

---

### -r, --resume [session-id]

**기능**: 세션 ID로 대화 재개

옵션:
- 값 없음: 대화형 선택기 열기
- session ID: 특정 세션 재개
- 검색어: 필터링된 목록 표시

```bash
# 대화형 선택기
claude --resume

# ID로 직접 재개
claude --resume 550e8400-e29b-41d4-a716-446655440000

# 검색어로 필터링
claude --resume "auth refactor"
```

---

### --fork-session

`--continue` 또는 `--resume`와 함께 사용할 때, 기존 대화를 계속하는 대신 분기된 새 세션 생성

```bash
claude --resume <session-id> --fork-session
```

---

### -n, --name <name>

세션에 표시 이름 설정 (`/resume`와 터미널 제목에 표시)

```bash
claude --name "auth-refactor"
```

---

### --session-id <uuid>

생성된 ID 대신 특정 UUID를 세션 ID로 사용 (유효한 UUID 필수)

제약: `--continue` 또는 `--resume`과 함께 사용 불가 (`--fork-session` 필요)

```bash
claude --session-id 550e8400-e29b-41d4-a716-446655440000
```

---

### --no-session-persistence

**기능**: The session will not be saved to disk and cannot be resumed

--print 전용

```bash
claude -p "one-off task" --no-session-persistence
```

---

## 모델 및 성능 플래그 (Model and Capability Flags)

### --model <model>

**형식**: 별칭(sonnet, opus, haiku) 또는 전체 모델 ID(claude-sonnet-4-6)

```bash
claude --model sonnet
claude --model opus
claude --model claude-sonnet-4-6
```

**참고**: `/model` 슬래시 명령으로도 중간에 변경 가능

---

### --effort <level>

각 응답에 적용되는 계산 강도 제어

| 값 | 설명 |
|---|---|
| `low` | 빠르고 가벼운 응답 |
| `medium` | 균형잡힌 (기본값) |
| `high` | 더 철저한 추론 |
| `max` | 최대 강도 |

```bash
claude --effort high "review this architecture"
```

---

### --fallback-model <model>

주 모델이 과부하일 때 자동으로 다른 모델로 전환 (--print 전용)

```bash
claude -p "analyze this" --model opus --fallback-model sonnet
```

---

## 권한 및 안전 플래그 (Permission and Safety Flags)

### --permission-mode <mode>

세션의 권한 모드 설정

| 모드 | 동작 |
|---|---|
| `default` | 명령 실행 및 편집 전에 프롬프트 표시 |
| `acceptEdits` | 파일 편집은 자동 적용, 셸 명령은 승인 필요 |
| `plan` | 계획 제안 후 승인 대기 |
| `bypassPermissions` | 모든 작업 프롬프트 없이 실행 (격리된 환경 전용) |

```bash
claude --permission-mode acceptEdits
claude --permission-mode plan "refactor the payment module"
claude --permission-mode bypassPermissions
```

> **경고**: `bypassPermissions`는 Docker, CI 샌드박스 등 격리된 환경에서만 사용

---

### --dangerously-skip-permissions

모든 권한 확인 우회 (`--permission-mode bypassPermissions`와 동일)

```bash
claude --dangerously-skip-permissions -p "run the full test suite and fix failures"
```

**제약**:
- 루트/sudo 권한 실행 거부
- Docker/bubblewrap 컨테이너 외부 거부
- 인터넷 액세스 없는 샌드박스 권장

---

### --allow-dangerously-skip-permissions

Make bypassing all permission checks available as an option during the session

기본적으로 활성화하지 않되, 필요시 선택 가능하게 함 (자동화 파이프라인용)

```bash
claude --allow-dangerously-skip-permissions -p "..."
```

---

### --allowed-tools <tools...>

**별칭**: `--allowedTools`

Claude가 사용할 수 있는 도구 목록 (쉼표 또는 공백 구분)

```bash
claude --allowed-tools "Bash(git:*) Edit Read"
claude --allowed-tools Bash,Edit,Read
```

**글로브 패턴 지원**:
- `Bash(git:*)`: 모든 git 명령
- `Edit(src/**)`: src/ 하위 편집

---

### --disallowed-tools <tools...>

**별칭**: `--disallowedTools`

Claude가 사용할 수 없는 도구 목록

```bash
claude --disallowed-tools "Bash(rm:*)"
```

---

### --tools <tools...>

세션에서 사용 가능한 정확한 도구 집합 지정

```bash
# 모든 도구 비활성화
claude --tools ""

# Bash와 Read만 활성화
claude --tools "Bash Read"

# 기본 집합 활성화
claude --tools default
```

---

## 컨텍스트 및 프롬프트 플래그 (Context and Prompt Flags)

### --add-dir <directories...>

도구 액세스 컨텍스트에 디렉토리 추가 (현재 작업 디렉토리 외)

```bash
claude --add-dir /shared/libs --add-dir /shared/config
```

**용도**: 모노레포, 관련 코드가 디렉토리 외부에 있는 프로젝트

---

### --system-prompt <prompt>

기본 시스템 프롬프트 재정의 (`--system-prompt-file`과 함께 사용 불가)

```bash
claude --system-prompt "You are a security auditor. Focus only on vulnerabilities."
```

---

### --append-system-prompt <text>

기본 시스템 프롬프트에 텍스트 추가 (내장 지침 보존)

```bash
claude --append-system-prompt "Always suggest test cases for every function you write."
```

---

### --mcp-config <configs...>

하나 이상의 JSON 설정 파일 또는 인라인 JSON에서 MCP 서버 로드

```bash
# 파일에서
claude --mcp-config ./mcp-servers.json

# 여러 파일
claude --mcp-config ./local-tools.json ./db-tools.json

# 인라인 JSON
claude --mcp-config '{"mcpServers":{"filesystem":{"command":"npx","args":["@modelcontextprotocol/server-filesystem","/tmp"]}}}'
```

---

### --strict-mcp-config

`--mcp-config`의 MCP 서버만 사용 (다른 모든 MCP 설정 무시)

```bash
claude --mcp-config ./ci-mcp.json --strict-mcp-config
```

---

### --settings <file-or-json>

JSON 파일 또는 인라인 JSON에서 추가 설정 로드

```bash
# 파일에서
claude --settings ./team-settings.json

# 인라인 JSON
claude --settings '{"model":"claude-sonnet-4-6","verbose":true}'
```

---

### --setting-sources <sources>

시작시 로드할 설정 소스 제어 (쉼표 구분)

| 값 | 설명 |
|---|---|
| `user` | `~/.claude/settings.json` 로드 |
| `project` | 현재 디렉토리의 `.claude/settings.json` |
| `local` | 현재 디렉토리의 `.claude/settings.local.json` |

```bash
# 사용자 설정만 (프로젝트 설정 무시)
claude --setting-sources user

# 사용자 및 프로젝트 설정
claude --setting-sources user,project
```

---

### --agents <json>

인라인 JSON으로 사용자 정의 에이전트 정의

각 키는 에이전트 이름, 값은 `description`과 `prompt`를 포함한 객체

```bash
claude --agents '{"reviewer":{"description":"Reviews code for security issues","prompt":"You are a security-focused code reviewer."}}'
```

---

## 출력 제어 플래그 (Output Control Flags)

### --include-hook-events

모든 훅 라이프사이클 이벤트를 출력 스트림에 포함 (--output-format stream-json 전용)

```bash
claude -p "run task" --output-format stream-json --include-hook-events
```

---

### --max-turns <n>

비상호작용 모드에서 에이전트 턴 수 제한

작업이 미완료해도 지정된 턴 수 후 중지 (--print 전용)

```bash
claude -p "refactor this module" --max-turns 10
```

---

### --max-budget-usd <amount>

API 호출 최대 예산 설정 (달러, --print 전용)

```bash
claude -p "large analysis task" --max-budget-usd 2.50
```

---

### --json-schema <schema>

구조화된 출력 검증용 JSON Schema 제공

Claude의 응답이 스키마에 대해 검증됨

```bash
claude -p "extract the function names" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

---

## 워크트리 플래그 (Worktree Flags)

### -w, --worktree [name]

이 세션에 대한 새 git 워크트리 생성 (선택적으로 이름 지정)

PR 번호 또는 GitHub PR URL로도 지원

```bash
claude --worktree
claude --worktree feature-auth
claude --worktree "#142"
```

---

### --tmux

워크트리와 함께 tmux 세션 생성 (--worktree 필수)

iTerm2 네이티브 창 사용 가능, `--tmux=classic`으로 표준 tmux 강제

```bash
claude --worktree feature-auth --tmux
```

---

## 디버그 플래그 (Debug Flags)

### -d, --debug [filter]

디버그 모드 활성화 (선택적 필터로 범주 제한)

```bash
# 모든 디버그 출력
claude --debug

# api와 hooks 범주만
claude --debug "api,hooks"

# 특정 범주 제외
claude --debug "!file,!1p"
```

---

### --debug-file <path>

디버그 로그를 인라인 표시 대신 파일에 작성

암시적으로 디버그 모드 활성화

```bash
claude --debug-file /tmp/claude-debug.log
```

---

### --bare

최소 모드 - Skips hooks, LSP, plugin sync, attribution, auto-memory, background prefetches, keychain reads, and `CLAUDE.md` auto-discovery

`CLAUDE_CODE_SIMPLE=1` 설정

**인증**: `ANTHROPIC_API_KEY` 또는 `--settings`의 `apiKeyHelper` (OAuth, keychain 미사용)

**용도**: 시작 지연이 중요한 스크립트 파이프라인

```bash
claude --bare \
  --system-prompt "$(cat context.md)" \
  --add-dir /project/libs \
  --mcp-config ./tools.json \
  -p "perform the analysis"
```

---

## 플래그 조합 (Flag Combinations)

### 스크립팅 및 자동화 패턴

**비상호작용 JSON 출력**:
```bash
claude -p "list all exported types" --output-format json
```

**CI에서 권한 우회** (격리 환경):
```bash
claude -p "run full test suite and fix failures" --dangerously-skip-permissions
```

**마지막 세션 재개 후 비상호작용 계속**:
```bash
claude --continue -p "now write the tests for that"
```

**사용자 정의 MCP 설정 + 엄격한 격리**:
```bash
claude --mcp-config ./ci-mcp.json --strict-mcp-config -p "analyze the schema"
```

**시스템 프롬프트 추가 (교체 아님)**:
```bash
claude --append-system-prompt "Always output TypeScript, not JavaScript."
```

---

## 주요 특징 요약

| 플래그 | 주요 용도 |
|---|---|
| `-p` | 비상호작용 실행 |
| `--print` | 응답 출력 후 종료 |
| `--output-format` | json, stream-json 지원 |
| `--model` | 모델 선택/변경 |
| `--effort` | 계산 강도 제어 |
| `--permission-mode` | 자동화 수준 설정 |
| `--allowed-tools` | 도구 접근 제한 |
| `--system-prompt` | 기본 지침 재정의 |
| `--mcp-config` | 외부 도구 통합 |
| `--max-turns` | 턴 수 제한 |
| `--max-budget-usd` | 비용 제한 |
| `--debug` | 디버그 출력 |
| `--bare` | 최소화된 시작 |
