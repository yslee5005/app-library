<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/guides/hooks -->

# Claude Code Hooks - 완전한 가이드

## 개요

Hooks는 Claude가 도구를 사용하거나 세션 마일스톤에 도달할 때 자동으로 실행되는 자동화 메커니즘입니다. 셸 명령어, HTTP 요청 또는 LLM 프롬프트를 특정 이벤트에 바인딩하여 코드 스타일 강제, 테스트 실행, 도구 사용 로깅, Claude의 작업 제한 등을 수행합니다.

## 작동 방식

Hook은 특정 **이벤트**에 바인딩된 명령어(셸 스크립트, HTTP 엔드포인트 또는 LLM 프롬프트)입니다. 이벤트가 발생하면 구성된 모든 matching hooks가 실행되며, 종료 코드와 출력을 통해 다음 동작이 결정됩니다.

각 hook의 입력은 발생한 상황을 설명하는 JSON 객체(stdin)입니다. 예를 들어 `PreToolUse`의 경우 도구 이름과 인수를 포함합니다.

### 종료 코드 의미 체계

| 종료 코드 | 의미 |
|---------|------|
| `0` | 성공. Stdout은 이벤트별로 Claude에 표시될 수 있음 |
| `2` | 차단 또는 주입. Claude에 stderr 표시, `PreToolUse`의 경우 도구 호출 방지 |
| 기타 | stderr을 사용자에게만 표시, 실행 계속 |

## Hook 이벤트 상세

### PreToolUse -- 도구 실행 전

모든 도구 호출 전에 실행됩니다. Hook 입력에는 도구 이름과 인수(JSON)가 포함됩니다.

**종료 코드:**
- `0`: 도구 정상 진행 (stdout 표시 안 함)
- `2`: 도구 호출 차단, stderr을 Claude에 표시하여 대응 가능
- 기타: stderr을 사용자에게만 표시, 도구 호출 계속 진행

Matcher를 사용하여 특정 도구(예: `Bash`, `Write`)로 제한할 수 있습니다.

### PostToolUse -- 도구 실행 후

모든 성공적 도구 호출 후 실행됩니다. Hook 입력에는 `inputs`(도구 인수)와 `response`(도구 결과)가 포함됩니다.

**종료 코드:**
- `0`: stdout은 Transcript 모드(Ctrl+O)에서 표시됨
- `2`: stderr을 Claude에 즉시 표시 (Claude가 대응 가능)
- 기타: stderr을 사용자에게만 표시

파일 편집 후 포매터, 린터 또는 테스트 러너 실행에 사용됩니다.

### PostToolUseFailure -- 도구 오류 후

도구 호출이 오류 결과로 끝났을 때 실행됩니다. 입력에는 `tool_name`, `tool_input`, `error`, `error_type`, `is_interrupt`, `is_timeout`이 포함됩니다.

`PostToolUse`와 동일한 종료 코드 의미 체계를 가집니다.

### Stop -- Claude의 응답 결론 전

Claude의 턴이 끝나기 직전 실행됩니다. Matcher 미지원.

**종료 코드:**
- `0`: 출력 표시 없음
- `2`: Claude에 stderr 표시, 대화 계속 진행 (Claude가 추가 턴 획득)
- 기타: stderr을 사용자에게만 표시

필수 작업 완료 확인에 사용합니다.

### SubagentStop -- Subagent 결론 전

`Stop`과 유사하지만 Subagent(Agent 도구로 시작됨)가 완료될 때 실행됩니다. 입력에 `agent_id`, `agent_type`, `agent_transcript_path`가 포함됩니다. `Stop`과 동일한 종료 코드 의미 체계.

### SubagentStart -- Subagent 시작 시

새 Subagent가 시작될 때 실행됩니다. 입력에 `agent_id`와 `agent_type`이 포함됩니다.

**종료 코드:**
- `0`: stdout이 Subagent의 초기 프롬프트에 표시됨
- 기타: stderr을 사용자에게만 표시

### SessionStart -- 세션 시작 시

모든 세션 시작 시 실행됩니다(시작, 재개, `/clear`, `/compact`). 입력에 시작 `source`가 포함됩니다.

**종료 코드:**
- `0`: stdout이 Claude에 표시됨
- 기타: stderr을 사용자에게만 표시 (blocking 오류는 무시됨)

**Matcher 값:** `startup`, `resume`, `clear`, `compact`

### UserPromptSubmit -- 프롬프트 제출 시

프롬프트 입력 후 Enter 키를 누를 때 실행됩니다. 입력에 원본 프롬프트 텍스트가 포함됩니다.

**종료 코드:**
- `0`: stdout이 Claude에 표시됨 (컨텍스트 추가 가능)
- `2`: 프롬프트 차단, stderr을 사용자에게만 표시
- 기타: stderr을 사용자에게만 표시

### PreCompact -- 대화 압축 전

Claude Code가 대화를 압축할 때 실행됩니다(자동 또는 수동). 입력에 압축 세부 정보가 포함됩니다.

**종료 코드:**
- `0`: stdout이 custom compact 지침으로 추가됨
- `2`: 압축 차단
- 기타: stderr을 사용자에게 표시하고 진행

**Matcher:** `manual` 또는 `auto` (`trigger`로 매칭)

### PostCompact -- 대화 압축 후

압축 완료 후 실행됩니다. 입력에 압축 세부 정보와 요약이 포함됩니다.

**종료 코드:**
- `0`: stdout이 사용자에게 표시됨
- 기타: stderr을 사용자에게만 표시

### Setup -- 저장소 설정 및 유지

`trigger: init`(프로젝트 온보딩) 또는 `trigger: maintenance`(주기적)로 실행됩니다. 일회성 설정 스크립트 또는 주기적 유지 작업에 사용합니다.

**종료 코드:**
- `0`: stdout이 Claude에 표시됨
- 기타: stderr을 사용자에게만 표시

### PermissionRequest -- 권한 대화 표시 시

Claude Code가 권한 프롬프트를 표시할 때 실행됩니다. `hookSpecificOutput.decision`으로 JSON을 출력하여 프로그래밍 방식으로 승인/거부합니다.

**종료 코드:**
- `0`: 제공된 경우 Hook의 결정 사용
- 기타: stderr을 사용자에게만 표시

### PermissionDenied -- 자동 모드 거부 후

자동 모드 분류기가 도구 호출을 거부할 때 실행됩니다. `{"hookSpecificOutput":{"hookEventName":"PermissionDenied","retry":true}}`를 반환하여 Claude가 재시도 가능하게 합니다.

### Notification -- 알림 전송 시

권한 프롬프트, 유휴 프롬프트, 인증 성공, 수집 이벤트에 대해 실행됩니다. `notification_type`로 매칭합니다.

**종료 코드:**
- `0`: 출력 표시 없음
- 기타: stderr을 사용자에게만 표시

### CwdChanged -- 작업 디렉토리 변경 후

작업 디렉토리가 변경된 후 실행됩니다. 입력에 `old_cwd`와 `new_cwd`가 포함됩니다. `CLAUDE_ENV_FILE` 환경 변수가 설정되어 있으며, 해당 파일에 bash export 라인을 작성하여 이후 Bash 도구 호출에 새 환경 변수를 적용할 수 있습니다.

### FileChanged -- 감시 파일 변경 시

Hook의 `matcher` 패턴과 일치하는 파일이 디스크에서 변경될 때 실행됩니다. Matcher는 감시할 파일명 패턴을 지정합니다(예: `.envrc|.env`). `CwdChanged`처럼 `CLAUDE_ENV_FILE`로 환경 주입을 지원합니다.

### SessionEnd -- 세션 종료 시

세션이 종료될 때 실행됩니다(clear, logout, exit). `reason`으로 매칭합니다: `clear`, `logout`, `prompt_input_exit`, `other`.

### ConfigChange -- 설정 파일 변경 시

세션 중 설정 파일이 변경될 때 실행됩니다. `source`로 매칭합니다: `user_settings`, `project_settings`, `local_settings`, `policy_settings`, `skills`.

**종료 코드:**
- `0`: 변경 허용
- `2`: 변경이 적용되는 것을 차단

### InstructionsLoaded -- CLAUDE.md 파일 로드 시

명령어 파일(CLAUDE.md 또는 규칙)이 로드될 때 실행됩니다. 관찰 목적으로만 사용되며, Blocking을 지원하지 않습니다.

### WorktreeCreate / WorktreeRemove -- Worktree 생명주기

`WorktreeCreate`는 격리된 Worktree가 생성되어야 할 때 실행됩니다. Stdout은 생성된 Worktree의 절대 경로를 포함해야 합니다. `WorktreeRemove`는 Worktree를 정리해야 할 때 실행됩니다.

### Task events -- 작업 생명주기

`TaskCreated`와 `TaskCompleted`는 작업이 생성되거나 완료로 표시될 때 실행됩니다. 입력에 `task_id`, `task_subject`, `task_description`, `teammate_name`, `team_name`이 포함됩니다. Exit `2`는 상태 변경을 방지합니다.

### TeammateIdle -- Teammate 유휴 예정 시

Teammate가 유휴 상태가 되기 전에 실행됩니다. Exit `2`로 stderr을 Teammate에 보내고 유휴 상태 전환을 방지합니다.

### Elicitation / ElicitationResult -- MCP 수집

`Elicitation`은 MCP 서버가 사용자 입력을 요청할 때 실행됩니다. `hookSpecificOutput`에 JSON을 반환하여 프로그래밍 방식으로 응답을 제공합니다. `ElicitationResult`는 사용자가 응답한 후 실행되어 응답을 수정하거나 차단할 수 있습니다.

## Hook 구성

Claude Code 내에서 `/hooks`를 실행하여 Hook 구성 메뉴를 엽니다. 메뉴는 이벤트별로 그룹화된 모든 구성된 Hook을 표시하며 대화형으로 추가, 편집, 제거할 수 있습니다.

Hook은 설정 파일의 `hooks` 필드에 저장됩니다:

- `~/.claude/settings.json` -- 사용자 수준 Hook (모든 곳에 적용)
- `.claude/settings.json` -- 프로젝트 수준 Hook (이 프로젝트에만 적용)
- `.claude/settings.local.json` -- 로컬 Hook (VCS에 체크인되지 않음)

### 구성 형식

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write $CLAUDE_FILE_PATH"
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session complete' >> ~/.claude-log.txt"
          }
        ]
      }
    ]
  }
}
```

각 이벤트는 **Matcher 객체** 배열로 매핑됩니다. 각 Matcher 객체는 다음을 포함합니다:

- `matcher` (선택 사항) -- 이벤트의 매칭 가능 필드와 비교할 문자열 패턴 (예: `PreToolUse`/`PostToolUse`의 `tool_name`, `Setup`의 `trigger`, `SessionStart`의 `source`)
- `hooks` -- Matcher가 일치할 때 실행할 Hook 명령어 배열

### Hook 명령어 유형

#### 1. 셸 명령어

```json
{
  "type": "command",
  "command": "npm test",
  "timeout": 60,
  "shell": "bash"
}
```

필드:

- `command` -- 실행할 셸 명령어 (필수)
- `timeout` -- 시간 제한(초) (기본값: 제한 없음)
- `shell` -- `"bash"` (기본값) 또는 `"powershell"`
- `statusMessage` -- Hook 실행 중에 표시될 custom spinner 텍스트
- `async` -- background에서 실행하여 blocking하지 않음 (true/false)
- `once` -- 한 번 실행한 후 Hook 자동 제거
- `if` -- 권한 규칙 문법으로 조건부로 Hook을 건너뜀 (예: `"Bash(git *)"`)

#### 2. HTTP 요청

```json
{
  "type": "http",
  "url": "https://hooks.example.com/claude-event",
  "headers": {
    "Authorization": "Bearer $MY_TOKEN"
  },
  "allowedEnvVars": ["MY_TOKEN"],
  "timeout": 10
}
```

Claude Code는 Hook 입력 JSON을 URL에 POST합니다. Headers는 `allowedEnvVars`에 나열된 변수에 대한 `$VAR` 확장을 지원합니다.

#### 3. LLM 프롬프트

```json
{
  "type": "prompt",
  "prompt": "Review this tool call for security issues: $ARGUMENTS. If you find a problem, output an explanation and exit with code 2.",
  "model": "claude-haiku-4-5",
  "timeout": 30
}
```

Hook 프롬프트는 LLM에 의해 평가됩니다. `$ARGUMENTS`는 Hook 입력 JSON으로 대체됩니다. LLM의 응답이 Hook 출력이 됩니다.

#### 4. Agent Hook

```json
{
  "type": "agent",
  "prompt": "Verify that the unit tests in $ARGUMENTS passed and all assertions are meaningful.",
  "timeout": 60
}
```

프롬프트 Hook과 유사하지만 도구 접근 권한이 있는 완전한 Agent로 실행됩니다. 파일 읽기 또는 명령어 실행이 필요한 검증 작업에 유용합니다.

## Matcher 패턴

`PreToolUse`, `PostToolUse`, `SessionStart` 같은 매칭을 지원하는 이벤트에서 `matcher` 필드는 Hook을 트리거하는 입력을 필터링합니다.

- 비어있거나 없는 `matcher`는 해당 이벤트의 모든 입력과 일치합니다.
- 도구 이벤트의 경우 `matcher`는 `tool_name`과 비교됩니다 (예: `"Bash"`, `"Write"`, `"Read"`).
- `SessionStart`의 경우 `source`와 일치합니다 (예: `"startup"`, `"compact"`).
- `Setup`의 경우 `trigger`와 일치합니다 (예: `"init"`, `"maintenance"`).
- `FileChanged`의 경우 `matcher`는 감시할 파일명 패턴을 지정합니다 (예: `".envrc|.env"`).

## 예제 Hook

### 파일 편집 후 자동 포매팅

모든 파일 쓰기 후 Prettier 실행:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true"
          }
        ]
      }
    ]
  }
}
```

### Bash 명령어 후 테스트 실행

소스 파일을 건드리는 bash 명령어 후 테스트 스위트 실행:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if git diff --name-only HEAD | grep -q '\\.ts$'; then npm test; fi",
            "timeout": 120,
            "async": true
          }
        ]
      }
    ]
  }
}
```

### 모든 도구 사용 로깅

모든 도구 호출을 로그 파일에 추가:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date -u +%Y-%m-%dT%H:%M:%SZ) $CLAUDE_TOOL_NAME\" >> ~/.claude-tool-log.txt",
            "async": true
          }
        ]
      }
    ]
  }
}
```

### 위험한 명령어 차단

`PreToolUse`를 사용하여 `rm -rf` 호출 방지:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$CLAUDE_TOOL_INPUT\" | grep -q 'rm -rf'; then echo 'Blocked: rm -rf is not allowed' >&2; exit 2; fi"
          }
        ]
      }
    ]
  }
}
```

### 디렉토리 변경 시 환경 주입

`CwdChanged`를 `CLAUDE_ENV_FILE`과 함께 사용하여 디렉토리 변경 시 `.envrc` 로드:

```json
{
  "hooks": {
    "CwdChanged": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if [ -f .envrc ]; then grep '^export ' .envrc >> \"$CLAUDE_ENV_FILE\"; fi"
          }
        ]
      }
    ]
  }
}
```

## Hook 타임아웃 구성

`timeout` 필드(초 단위)를 사용하여 Hook별 타임아웃을 설정합니다:

```json
{
  "type": "command",
  "command": "npm run integration-tests",
  "timeout": 300
}
```

`timeout` 없는 Hook은 자연적으로 종료될 때까지 실행됩니다. Claude를 blocking하지 않아야 하는 장시간 실행 Hook의 경우 `"async": true`를 사용합니다.

## Hooks vs. Skills 비교

| 기능 | Hooks | Skills |
|------|-------|--------|
| 실행 시점 | 도구 이벤트에서 자동으로 실행 | Claude 또는 사용자가 `/skill-name` 명시적 호출 시 |
| 목적 | 부작용, Gating, 관찰 | 온디맨드 워크플로우 및 기능 |
| 구성 | 설정 JSON | `.claude/skills/`의 마크다운 파일 |
| 입력 | 도구 이벤트로부터의 JSON | Skill에 전달하는 인수 |

매번 자동으로 발생해야 하는 것(포매팅, 로깅, 강제)에 Hook을 사용합니다. 온디맨드로 트리거하려는 반복 가능한 워크플로우에 Skills를 사용합니다.

---

**문서 출처 및 추가 정보:**

완전한 documentation index는 https://vineetagarwal-code-claude-code.mintlify.app/llms.txt에서 확인할 수 있습니다.
