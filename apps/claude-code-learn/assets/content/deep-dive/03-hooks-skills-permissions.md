# Deep Dive #03: Hooks, Skills, Permissions 완전 분석

> **문서 범위**: Claude Code의 자동화(Hooks), 워크플로우 재사용(Skills), MCP 연동, 권한 시스템 전체를 심층 분석한다.

---

## TL;DR

- **Hooks**: 20개 이상의 이벤트에 바인딩되는 자동화 메커니즘. 셸 명령어, HTTP 요청, LLM 프롬프트, Agent 4가지 타입으로 도구 호출 전후, 세션 생명주기, 파일 변경 등을 가로챈다. 종료 코드 `0`(성공), `2`(차단/주입), 기타(사용자 표시)로 흐름을 제어한다.
- **Skills**: `.claude/skills/` 디렉토리의 마크다운 파일로 정의하는 재사용 가능한 워크플로우. `/skill-name` 으로 호출하며, lazy loading이므로 많이 만들어도 성능에 영향 없음.
- **MCP 서버**: Model Context Protocol로 외부 데이터 소스(DB, API, 파일시스템)를 Claude Code에 연결. Stdio/HTTP/SSE 3가지 전송 방식을 지원하며, 도구 호출 시 권한 승인 필요.
- **권한 시스템**: 5가지 모드(`default`, `acceptEdits`, `plan`, `bypassPermissions`, `dontAsk`) + Allow/Deny 규칙으로 도구 실행을 세밀하게 제어. 결정 파이프라인은 Deny 규칙 -> Ask 규칙 -> 도구 자체 권한 -> 안전 확인 -> 모드 -> Allow 규칙 -> 기본 동작 순서로 평가.
- **실무 핵심**: 자동 포매팅은 `PostToolUse` Hook, 위험 명령어 차단은 `PreToolUse` Hook, 반복 워크플로우는 Skills, 외부 서비스 연동은 MCP로 해결한다.

---

## 목차

1. [훅(Hooks) 시스템 완전 분석](#1-훅hooks-시스템-완전-분석)
2. [스킬(Skills) 시스템](#2-스킬skills-시스템)
3. [MCP 서버 연동](#3-mcp-서버-연동)
4. [권한 시스템](#4-권한-시스템)
5. [권한 API와 결정 파이프라인](#5-권한-api와-결정-파이프라인)
6. [실무 활용 시나리오](#6-실무-활용-시나리오)

---

## 1. 훅(Hooks) 시스템 완전 분석

### 1.1 Hooks란 무엇인가

Hooks는 Claude가 도구를 사용하거나 세션 마일스톤에 도달할 때 **자동으로 실행**되는 자동화 메커니즘이다. 셸 명령어, HTTP 요청, LLM 프롬프트, 또는 Agent를 특정 이벤트에 바인딩하여 다음과 같은 작업을 수행한다:

- 코드 스타일 강제 (포매팅, 린팅)
- 테스트 자동 실행
- 도구 사용 로깅 및 감사
- 위험한 작업 차단
- 권한 프로그래밍 방식 제어

### 1.2 핵심 개념: 종료 코드 의미 체계

모든 Hook의 동작은 종료 코드로 결정된다:

| 종료 코드 | 의미 | 동작 |
|-----------|------|------|
| `0` | 성공 | stdout은 이벤트에 따라 Claude에 표시되거나 숨김 |
| `2` | 차단/주입 | stderr을 Claude에 표시. `PreToolUse`에서는 도구 호출 방지 |
| 기타 | 오류 | stderr을 사용자에게만 표시, 실행은 계속 |

> **실무 팁**: 종료 코드 `2`는 단순 오류가 아니라 "Claude에게 피드백을 주는" 신호다. `Stop` 이벤트에서 exit 2를 반환하면 Claude가 추가 턴을 얻어 미완성 작업을 계속할 수 있다.

### 1.3 4가지 Hook 타입

#### 타입 1: 셸 명령어 (Command)

가장 기본적이고 많이 사용되는 타입. 셸 스크립트를 직접 실행한다.

```json
{
  "type": "command",
  "command": "npm test",
  "timeout": 60,
  "shell": "bash",
  "async": false,
  "once": false,
  "if": "Bash(git *)",
  "statusMessage": "테스트 실행 중..."
}
```

**주요 필드 설명:**

| 필드 | 필수 | 설명 |
|------|------|------|
| `command` | O | 실행할 셸 명령어 |
| `timeout` | X | 시간 제한(초). 기본값: 제한 없음 |
| `shell` | X | `"bash"` (기본) 또는 `"powershell"` |
| `async` | X | `true`이면 백그라운드 실행, Claude를 blocking하지 않음 |
| `asyncRewake` | X | async이지만 exit 2에서 모델을 깨움 |
| `once` | X | 한 번 실행 후 자동 제거 |
| `if` | X | 권한 규칙 문법으로 조건부 실행 (예: `"Bash(git *)"`) |
| `statusMessage` | X | Hook 실행 중 표시할 커스텀 스피너 텍스트 |

**환경 변수:**
- `CLAUDE_TOOL_NAME`: 현재 도구 이름
- `CLAUDE_TOOL_INPUT`: 도구 입력 JSON
- `CLAUDE_FILE_PATH`: 파일 경로 (파일 관련 도구)
- `CLAUDE_ENV_FILE`: `CwdChanged`/`FileChanged`에서 환경 변수 주입용 파일 경로

#### 타입 2: HTTP 요청

외부 엔드포인트에 이벤트 데이터를 POST로 전송한다.

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

- `url`: POST 엔드포인트 (필수)
- `headers`: HTTP 헤더. `$VAR` 확장 지원
- `allowedEnvVars`: 헤더 값에서 확장을 허용할 환경 변수 목록
- Hook 입력 JSON이 요청 본문으로 전송됨

> **실무 팁**: 외부 감사 시스템, Slack/Discord 웹훅, 사내 로깅 서비스 등과 연동할 때 유용하다.

#### 타입 3: LLM 프롬프트 (Prompt)

별도의 LLM에게 Hook 데이터를 평가하게 한다.

```json
{
  "type": "prompt",
  "prompt": "Check whether this bash command is safe: $ARGUMENTS",
  "model": "claude-haiku-4-5",
  "timeout": 30
}
```

- `prompt`: LLM에 보낼 메시지. `$ARGUMENTS`가 Hook 입력 JSON으로 대체됨
- `model`: 사용할 LLM (기본값: 빠른 소형 모델)
- LLM 응답이 Hook 출력이 됨

#### 타입 4: Agent Hook

프롬프트 Hook과 유사하지만, 도구 접근 권한이 있는 **완전한 Agent**로 실행된다.

```json
{
  "type": "agent",
  "prompt": "Verify that unit tests ran and passed.",
  "model": "claude-haiku-4-5",
  "timeout": 120
}
```

파일을 읽거나 명령어를 실행해야 하는 검증 작업에 특히 유용하다. 예: 테스트 결과 검증, 코드 품질 확인.

### 1.4 전체 이벤트 목록 (20+ 이벤트)

아래 표는 모든 Hook 이벤트를 기능별로 분류한 것이다.

#### 도구 생명주기 이벤트

| 이벤트 | 시점 | Matcher 대상 | exit 2 동작 |
|--------|------|-------------|-------------|
| `PreToolUse` | 도구 호출 전 | `tool_name` | 도구 호출 차단 |
| `PostToolUse` | 도구 성공 후 | `tool_name` | stderr을 Claude에 표시 |
| `PostToolUseFailure` | 도구 오류 후 | `tool_name` | stderr을 Claude에 표시 |

**PreToolUse 입력 필드:**
```json
{
  "tool_name": "Bash",
  "tool_input": { "command": "rm -rf /" },
  "tool_use_id": "unique-id"
}
```

**PreToolUse hookSpecificOutput 필드:**
- `permissionDecision`: `allow|deny|ask`로 권한 오버라이드
- `updatedInput`: 대체 도구 입력 객체
- `additionalContext`: Claude 컨텍스트에 주입할 텍스트

**PostToolUse 입력 필드:**
```json
{
  "tool_name": "Write",
  "tool_input": { "file_path": "src/app.ts" },
  "tool_response": { "status": "success" },
  "tool_use_id": "unique-id"
}
```

#### 세션 생명주기 이벤트

| 이벤트 | 시점 | Matcher 대상 | exit 2 동작 |
|--------|------|-------------|-------------|
| `SessionStart` | 세션 시작 | `source` (`startup|resume|clear|compact`) | N/A (blocking 무시) |
| `SessionEnd` | 세션 종료 | `reason` (`clear|logout|prompt_input_exit|other`) | N/A |
| `Stop` | Claude 턴 종료 전 | 없음 | Claude 추가 턴 획득 |
| `StopFailure` | API 오류로 턴 종료 | 없음 | 무시됨 (fire-and-forget) |

**Stop 이벤트 입력 필드:**
```json
{
  "stop_hook_active": false,
  "last_assistant_message": "작업을 완료했습니다."
}
```

> **핵심**: `Stop` Hook에서 exit 2를 반환하면 Claude가 멈추지 않고 계속 진행한다. 테스트 실패 확인, 필수 작업 완료 확인 등에 활용.

#### Subagent 이벤트

| 이벤트 | 시점 | Matcher 대상 | exit 2 동작 |
|--------|------|-------------|-------------|
| `SubagentStart` | Subagent 시작 | `agent_type` | N/A |
| `SubagentStop` | Subagent 종료 전 | `agent_type` | Subagent 계속 진행 |

#### 사용자 입력 이벤트

| 이벤트 | 시점 | exit 2 동작 |
|--------|------|-------------|
| `UserPromptSubmit` | 프롬프트 제출 시 | 프롬프트 차단 |

#### 압축(Compaction) 이벤트

| 이벤트 | 시점 | Matcher 대상 | exit 2 동작 |
|--------|------|-------------|-------------|
| `PreCompact` | 대화 압축 전 | `trigger` (`manual|auto`) | 압축 차단 |
| `PostCompact` | 압축 완료 후 | `trigger` | N/A |

#### 권한 이벤트

| 이벤트 | 시점 | 특수 출력 |
|--------|------|----------|
| `PermissionRequest` | 권한 대화 표시 시 | `hookSpecificOutput.decision`으로 승인/거부 |
| `PermissionDenied` | 자동 모드 거부 후 | `retry: true`로 재시도 허용 |

**PermissionRequest - Allow 결정:**
```json
{
  "hookSpecificOutput": {
    "decision": {
      "behavior": "allow",
      "updatedInput": {},
      "updatedPermissions": []
    }
  }
}
```

**PermissionRequest - Deny 결정:**
```json
{
  "hookSpecificOutput": {
    "decision": {
      "behavior": "deny",
      "message": "Blocked by security policy.",
      "interrupt": false
    }
  }
}
```

#### 파일/디렉토리 이벤트

| 이벤트 | 시점 | 특수 기능 |
|--------|------|----------|
| `CwdChanged` | 작업 디렉토리 변경 후 | `CLAUDE_ENV_FILE`로 환경 변수 주입 |
| `FileChanged` | 감시 파일 변경 시 | Matcher로 파일명 패턴 지정 |

#### 설정/설치 이벤트

| 이벤트 | 시점 | Matcher 대상 |
|--------|------|-------------|
| `Setup` | 저장소 설정/유지 | `trigger` (`init|maintenance`) |
| `ConfigChange` | 설정 파일 변경 시 | `source` (settings 종류) |
| `InstructionsLoaded` | CLAUDE.md 로드 시 | 관찰 전용 (blocking 불가) |

#### 알림 이벤트

| 이벤트 | 시점 | Matcher 대상 |
|--------|------|-------------|
| `Notification` | 알림 전송 시 | `notification_type` |

#### Worktree 이벤트

| 이벤트 | 시점 | 동작 |
|--------|------|------|
| `WorktreeCreate` | Worktree 생성 필요 시 | stdout에 절대 경로 출력 |
| `WorktreeRemove` | Worktree 정리 필요 시 | exit 0이면 성공 |

#### Task 이벤트

| 이벤트 | 시점 | exit 2 동작 |
|--------|------|-------------|
| `TaskCreated` | 작업 생성 시 | 상태 변경 방지 |
| `TaskCompleted` | 작업 완료 시 | 상태 변경 방지 |
| `TeammateIdle` | Teammate 유휴 예정 시 | 유휴 전환 방지 |

#### MCP 수집 이벤트

| 이벤트 | 시점 | 동작 |
|--------|------|------|
| `Elicitation` | MCP 서버가 사용자 입력 요청 시 | 프로그래밍 방식으로 응답 제공 |
| `ElicitationResult` | 사용자 응답 후 | 응답 수정/차단 가능 |

### 1.5 Hook 실행 흐름

```
이벤트 발생
    |
    v
설정 파일에서 해당 이벤트의 Hook 목록 조회
    |
    v
각 Matcher 객체에 대해:
    ├── matcher 패턴이 있으면 -> 이벤트 데이터와 비교
    │       ├── 일치 -> hooks 배열의 각 Hook 실행
    │       └── 불일치 -> 건너뜀
    └── matcher 없으면 -> 모든 입력에 대해 hooks 실행
            |
            v
    Hook 입력 JSON을 stdin으로 전달
            |
            v
    종료 코드 확인:
        ├── 0: 성공 처리 (이벤트별 동작)
        ├── 2: 차단/주입 (stderr -> Claude)
        └── 기타: 오류 표시 (stderr -> 사용자)
```

### 1.6 Universal Hook 입력 스키마

모든 Hook은 다음 기본 필드를 포함하는 JSON을 받는다:

```json
{
  "hook_event_name": "PreToolUse",
  "session_id": "session-abc-123",
  "transcript_path": "/absolute/path/to/transcript.jsonl",
  "cwd": "/Users/user/project",
  "permission_mode": "default",
  "agent_id": "agent-xyz",
  "agent_type": "main"
}
```

### 1.7 Hook 출력 스키마 (Sync)

Blocking Hook은 stdout에 JSON을 출력할 수 있다:

```json
{
  "continue": true,
  "suppressOutput": false,
  "decision": "approve",
  "reason": "Security check passed",
  "systemMessage": "Claude 컨텍스트에 주입할 텍스트",
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "additionalContext": "이벤트별 추가 컨텍스트"
  }
}
```

| 필드 | 설명 |
|------|------|
| `continue` | `false`이면 현재 턴 즉시 중단 |
| `suppressOutput` | `true`이면 transcript 모드에서 출력 숨김 |
| `decision` | 명시적 승인/거부 |
| `reason` | 차단 시 표시할 설명 |
| `systemMessage` | Claude 컨텍스트에 시스템 턴으로 주입 |
| `hookSpecificOutput` | 이벤트별 전용 필드 |

### 1.8 구성 파일 위치 및 우선순위

| 범위 | 위치 | 우선순위 | 용도 |
|------|------|---------|------|
| User | `~/.claude/settings.json` | 낮음 | 모든 프로젝트에 적용 |
| Project | `.claude/settings.json` | 중간 | 팀 공유용 |
| Local | `.claude/settings.local.json` | 높음 | 개인용, VCS 제외 |

**중요**: 모든 파일의 Hook이 실행된다. 높은 우선순위 파일이 낮은 우선순위를 덮어쓰지 않고, 모두 합산되어 실행된다.

### 1.9 Matcher 패턴 정리

| 이벤트 유형 | Matcher 대상 | 예시 |
|------------|-------------|------|
| 도구 이벤트 | `tool_name` | `"Bash"`, `"Write"`, `"Read"` |
| 세션 이벤트 | `source` | `"startup"`, `"resume"`, `"clear"`, `"compact"` |
| Setup | `trigger` | `"init"`, `"maintenance"` |
| Compaction | `trigger` | `"manual"`, `"auto"` |
| FileChanged | 파일명 패턴 | `".envrc\|.env"` |
| Notification | `notification_type` | `"permission_prompt"`, `"idle_prompt"` |
| Subagent | `agent_type` | Agent 타입 이름 |
| SessionEnd | `reason` | `"clear"`, `"logout"`, `"prompt_input_exit"` |
| ConfigChange | `source` | `"user_settings"`, `"project_settings"`, `"skills"` |

> **실무 팁**: Matcher가 비어있거나 생략되면 해당 이벤트의 **모든** 인스턴스에서 실행된다. 범위를 좁히려면 반드시 matcher를 지정하라.

---

## 2. 스킬(Skills) 시스템

### 2.1 Skills란 무엇인가

Skills는 마크다운 파일(`SKILL.md`)로 정의되는 **재사용 가능한 프롬프트와 워크플로우**다. 사용자가 `/skill-name` 명령을 입력하면 Claude가 해당 Skill의 지시사항을 로드하고 실행한다.

**핵심 특성:**
- **Lazy Loading**: 호출될 때만 로드되므로 많은 Skill을 정의해도 시작 시간이나 컨텍스트 크기에 영향 없음
- **마크다운 기반**: 별도의 프로그래밍 언어 불필요
- **인자 치환**: `$ARGUMENTS` 또는 명명된 인자 지원
- **인라인 셸 실행**: `!`백틱`` 구문으로 호출 시점에 셸 명령어 실행

### 2.2 디렉토리 구조

```
.claude/skills/                   # 프로젝트 레벨
  my-skill/
    SKILL.md                      # Skill 정의
  deployment/
    SKILL.md                      # /deployment
  database/
    migrate/
      SKILL.md                    # /database:migrate
    seed/
      SKILL.md                    # /database:seed

~/.claude/skills/                 # 사용자 레벨 (모든 프로젝트)
  standup/
    SKILL.md                      # /standup
```

하위 디렉토리는 콜론(`:`)으로 네임스페이스된다.

### 2.3 SKILL.md 작성법

#### Frontmatter 필드 완전 정리

```yaml
---
description: /skills에 표시되는 짧은 설명
argument-hint: 인자 설명 (자동완성에 표시)
allowed-tools: Bash, Write, Read
when_to_use: Skill 사용 시기 설명 (Claude 자동 호출 기준)
model: claude-sonnet-4-6
user-invocable: true
context: fork
paths: "**/*.py"
version: "1.0.0"
hooks: {}
arguments: [name, directory]
---
```

| 필드 | 기본값 | 설명 |
|------|--------|------|
| `description` | - | slash command 목록에 표시 |
| `argument-hint` | - | 자동완성에서 보여줄 인자 힌트 |
| `allowed-tools` | 모두 | 쉼표로 구분된 허용 도구 목록 |
| `when_to_use` | - | Claude가 능동적으로 Skill을 사용할 시기 |
| `model` | 세션 모델 | 이 Skill에 사용할 모델 |
| `user-invocable` | `true` | `false`이면 slash command 목록에서 숨김 |
| `context` | - | `fork`이면 격리된 하위에이전트 컨텍스트에서 실행 |
| `paths` | - | glob 패턴; 매칭 파일 수정 시에만 활성화 |
| `version` | - | Skill 버전 문자열 |
| `hooks` | - | 이 Skill 실행에 범위가 지정된 Hooks |
| `arguments` | - | 명명된 인자 목록 |

#### 인자 치환

**단순 인자** (`$ARGUMENTS`):
```markdown
Create a new React component named $ARGUMENTS following conventions.
```
호출: `/new-component UserProfile`

**명명된 인자**:
```yaml
---
arguments: [name, directory]
---
```
본문에서 `$name`, `$directory`로 참조.

#### 인라인 셸 명령어

`!` 접두사 + 백틱으로 호출 시점에 셸 명령어를 실행하고 출력을 프롬프트에 삽입한다:

```markdown
---
description: Review recent changes
---

Here are the recent commits for context:

!`git log --oneline -20`

Review the changes above and summarize what was accomplished.
```

> **주의**: 인라인 셸 명령어는 셸과 동일한 권한으로 실행되며, Skill 로드 시가 아닌 **호출 시점**에 실행된다.

### 2.4 조건부 Skill (경로 기반 활성화)

`paths` frontmatter로 특정 파일 작업 시에만 자동 활성화:

```yaml
---
description: Django model review
paths: "**/*.py"
when_to_use: Use when editing Django model files
---
```

매칭 파일을 읽거나 쓸 때 Skill이 Claude 컨텍스트에 자동 로드된다.

### 2.5 Skill 활용 예시

#### 예시 1: React 컴포넌트 생성기

```markdown
---
description: Generate a new React component with tests
argument-hint: ComponentName
allowed-tools: Write, Bash
---

Create a new React component named $ARGUMENTS.

1. Create `src/components/$ARGUMENTS/$ARGUMENTS.tsx` with:
   - Functional component using TypeScript
   - Props interface named `$ARGUMENTSProps`
   - JSDoc comment
   - Default export

2. Create test file `src/components/$ARGUMENTS/$ARGUMENTS.test.tsx`:
   - Rendering test using React Testing Library
   - Snapshot test

3. Create `src/components/$ARGUMENTS/index.ts` re-exporting component

4. Run `npx tsc --noEmit` to confirm no type errors
```

호출: `/new-component Button`

#### 예시 2: 릴리스 워크플로우

```markdown
---
description: Run the full release process for this project
argument-hint: version number (e.g. 1.2.3)
---

Release the project at version $ARGUMENTS.

Steps:
1. Update the version in `package.json` to $ARGUMENTS
2. Update CHANGELOG.md with a new section for this version
3. Run `npm test` and confirm all tests pass
4. Commit with message "chore: release v$ARGUMENTS"
5. Create a git tag `v$ARGUMENTS`
```

호출: `/release 1.2.3`

#### 예시 3: 스탠드업 요약 (사용자 레벨)

```markdown
---
description: Summarize today's work for standup
---

Look at today's git commits and summarize in standup format.
```

호출: `/standup`

### 2.6 Skills vs Hooks 비교

| 기준 | Skills | Hooks |
|------|--------|-------|
| **호출** | 명시적 (`/skill-name`) 또는 Claude 자동 | 자동 (도구 이벤트 발생 시) |
| **목적** | 온디맨드 반복 워크플로우 | 부작용, 게이팅, 관찰 |
| **설정** | `.claude/skills/`의 `SKILL.md` | 설정 JSON의 `hooks` 필드 |
| **입력** | 사용자가 전달하는 인수 | 이벤트 JSON (도구 이름, 입력, 응답) |
| **컨텍스트** | 파일, 셸 출력, 상세 지시사항 포함 | 이벤트 JSON 수신, 종료 코드/출력 반환 |

> **실무 팁**: "매번 자동으로" -> Hook, "필요할 때만" -> Skill. 예를 들어 "파일 저장 시 항상 포매팅" -> Hook, "릴리스 프로세스 실행" -> Skill.

---

## 3. MCP 서버 연동

### 3.1 MCP란 무엇인가

MCP(Model Context Protocol)는 Claude Code를 외부 데이터 소스와 연결하는 **개방형 표준**이다. 데이터베이스 쿼리, Jira 티켓, Slack 워크스페이스, 파일시스템 등 다양한 서비스를 Claude의 도구로 사용할 수 있게 해준다.

### 3.2 서버 추가 방법

#### CLI 방식

```bash
# 기본 추가
claude mcp add <name> -- <command> [args...]

# 파일시스템 서버
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /tmp

# 프로젝트 스코프 (팀 공유)
claude mcp add --scope project filesystem -- npx -y @modelcontextprotocol/server-filesystem /tmp

# 사용자 스코프 (개인, 글로벌)
claude mcp add --scope user my-db -- npx -y @my-org/mcp-server-postgres
```

#### 설정 파일 플래그

```bash
claude --mcp-config ./my-mcp-config.json
```

CI 환경이나 자체 포함 구성에 권장.

### 3.3 3가지 전송 방식

#### Stdio (로컬 프로세스) - 가장 일반적

stdin/stdout을 통한 로컬 서브프로세스 통신:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
```

#### HTTP (원격 서버)

```json
{
  "mcpServers": {
    "my-api": {
      "type": "http",
      "url": "https://mcp.example.com/v1",
      "headers": {
        "Authorization": "Bearer $MY_API_TOKEN"
      }
    }
  }
}
```

#### SSE (Server-Sent Events)

```json
{
  "mcpServers": {
    "events-server": {
      "type": "sse",
      "url": "https://mcp.example.com/sse"
    }
  }
}
```

### 3.4 설정 스코프 및 우선순위

| Scope | 위치 | 용도 |
|-------|------|------|
| `local` | `.claude/settings.local.json` | 프로젝트별 개인 오버라이드, VCS 제외 |
| `project` | `.mcp.json` (프로젝트 루트) | 팀 공유 서버 구성 |
| `user` | `~/.claude.json` | 모든 프로젝트에서 사용 |

**우선순위**: local > project > user. 동일 서버 이름이 여러 스코프에 존재하면 로컬 버전이 우선.

### 3.5 서버 관리 명령어

```
/mcp                          # 관리 패널 열기 (상태 확인)
/mcp enable <server-name>     # 서버 활성화
/mcp disable <server-name>    # 서버 비활성화
/mcp enable all               # 모든 서버 활성화
/mcp disable all              # 모든 서버 비활성화
/mcp reconnect <server-name>  # 재연결 강제
```

**서버 상태:**

| 상태 | 의미 |
|------|------|
| `connected` | 실행 중 및 작동 중 |
| `pending` | 초기화 중 |
| `failed` | 연결 오류 |
| `needs-auth` | OAuth 인증 필요 |
| `disabled` | 구성되었지만 비활성 |

### 3.6 도구 호출 승인

MCP 도구 실행 전, Claude는 권한 프롬프트를 표시한다:

- **Allow once**: 단일 호출 승인
- **Allow always**: 세션 내 해당 도구의 모든 호출 승인
- **Deny**: 호출 차단

**자동 모드에서 사전 승인:**
```bash
--allowedTools "mcp__<server-name>__<tool-name>"
```

### 3.7 보안 고려사항

1. **환경 변수 확장**: `$VAR` 및 `${VAR}` 구문은 시작 시 프로세스 환경에서 확장됨. 누락된 변수는 경고만 표시하고 연결 시도는 계속됨
2. **인증**: HTTP 서버의 `headers`에 Bearer 토큰 등을 설정. `allowedEnvVars`로 허용 변수 제한
3. **MCP 도구 권한**: `mcp__servername` 형식으로 전체 서버 차단 또는 `mcp__servername__toolname`으로 개별 도구 제어 가능

### 3.8 실전 예시: PostgreSQL 연동

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "$DATABASE_URL"
      }
    }
  }
}
```

Claude Code 실행 전 `DATABASE_URL` 환경 변수를 설정하면 서버가 자동으로 수신한다.

### 3.9 트러블슈팅

| 문제 | 해결 방법 |
|------|---------|
| Failed 상태 | `which npx` 확인, 명령어 수동 테스트, 환경 변수 확인, `claude --debug` 실행 |
| 도구 누락 | `/mcp`에서 `needs-auth` 상태 확인, OAuth 인증 완료 |
| 환경 변수 미확장 | `claude` 실행 전 같은 터미널에서 `echo $YOUR_VAR`로 변수 확인 |
| Windows npx 실패 | `cmd /c` 래퍼 사용 |
| CI 문제 | `--mcp-config`로 명시적 구성, 환경 변수 및 PATH 확인 |

---

## 4. 권한 시스템

### 4.1 권한이 적용되는 3가지 영역

1. **파일 작업**: `Read`, `Edit`, `Write` 도구를 통한 파일시스템 접근
2. **Bash 명령어**: 셸 명령어 실행 (설치, 빌드, git, 임의 스크립트)
3. **MCP 도구 호출**: 연결된 MCP 서버의 도구 (DB 쿼리, API 호출 등)

### 4.2 5가지 권한 모드

| 모드 | 동작 | 추천 시나리오 |
|------|------|-------------|
| `default` | 위험 작업은 승인 요청, 읽기 전용은 자동 | 일상적 사용 |
| `acceptEdits` | 파일 편집 자동 승인, Bash는 확인 | 파일 변경은 신뢰, 셸은 검토 |
| `plan` | 읽기 전용, 모든 변경 차단 | 낯선 코드베이스 탐색, 대규모 변경 설계 |
| `bypassPermissions` | 모든 확인 제거 | 격리된 환경(컨테이너, CI)만 |
| `dontAsk` | 사전 승인 규칙만 실행, 나머지 거부 | 스크립트/비대화형 시나리오 |

추가로 **auto** 모드(실험용)가 있다: 보조 AI 분류기가 대화 기록에 비추어 도구 호출을 평가하여 자동 승인 또는 인간 프롬프트로 확대한다. `TRANSCRIPT_CLASSIFIER` 플래그 활성화 시에만 사용 가능.

### 4.3 권한 모드 설정 방법

```bash
# CLI 플래그
claude --permission-mode acceptEdits
claude --permission-mode bypassPermissions --dangerously-skip-permissions
claude --permission-mode plan

# 세션 중 변경
/permissions

# settings.json (지속적 기본값)
{
  "defaultPermissionMode": "acceptEdits"
}

# SDK 제어 요청
{
  "type": "control_request",
  "request_id": "pm-1",
  "request": {
    "subtype": "set_permission_mode",
    "mode": "acceptEdits"
  }
}
```

### 4.4 Allow/Deny 규칙 시스템

#### 규칙 구성 요소

| 필드 | 설명 | 예시 |
|------|------|------|
| `toolName` | 도구 이름 | `"Bash"`, `"Edit"`, `"mcp__myserver"` |
| `ruleContent` | 도구 입력과 매칭될 패턴 | Bash 명령어 접두사, 파일 경로 glob |
| `behavior` | 결정 | `"allow"`, `"deny"`, `"ask"` |

**평가 순서**: 규칙 먼저 평가 -> 매칭되면 즉시 적용 -> 그 후 권한 모드

#### 규칙 문법

```
# 도구명만
Read
Write
Edit
Bash

# 도구명 + 내용 패턴
Bash(git *)           # 모든 git 하위명령어
Bash(npm run *)       # 모든 npm run 스크립트
Write(src/*)          # src/ 아래 파일 쓰기
Edit(*.ts)            # TypeScript 파일 편집

# MCP 서버
mcp__myserver                    # 서버의 모든 도구
mcp__myserver__*                 # 서버의 모든 도구 (와일드카드)
mcp__myserver__query_database    # 특정 도구만

# Agent 타입
Agent(Explore)
Agent(CodeReviewer)
```

#### 설정 예시

```json
{
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Bash(npm run *)",
      "Read(*)",
      "Write(src/**)",
      "Write(tests/**)",
      "mcp__myserver__read_database"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)",
      "Bash(* | sh)",
      "Write(/etc/**)",
      "Write(~/.ssh/**)",
      "Edit(.env*)",
      "mcp__myserver"
    ]
  }
}
```

**중요**: 거부 규칙이 허용 규칙보다 우선된다.

#### 규칙 저장소

| 출처 | 위치 | 범위 |
|------|------|------|
| `policySettings` | 관리 정책 레이어 | 편집 불가 |
| `flagSettings` | CLI 플래그, SDK 요청 | 세션별 |
| `userSettings` | `~/.claude/settings.json` | 현재 사용자의 모든 프로젝트 |
| `projectSettings` | `.claude/settings.json` | 이 프로젝트의 모든 사용자 |
| `localSettings` | `.claude/settings.local.json` | 현재 사용자, 이 프로젝트만 |
| `cliArg` | CLI 플래그 | 현재 호출만 |
| `session` | `/permissions` 명령 | 현재 세션만 |

### 4.5 Bash 권한 시스템 상세

#### 패턴 매칭

| 패턴 | 매칭 대상 |
|------|---------|
| `git status` | 정확한 일치만 |
| `git *` | 모든 git 하위명령어 |
| `npm run *` | 모든 npm run 스크립트 |
| `*` | 모든 bash 명령어 (**극도로 주의**) |

#### 복합 명령어 처리

`&&`, `||`, `;`, `|`로 연결된 명령어:
- 각 하위명령어가 **독립적으로** 검사됨
- 최종 권한은 **가장 제한적** 결과 (한 개라도 거부되면 전체 거부)

#### 추가 검사 대상 연산자

1. **출력 리다이렉션** (`>`, `>>`) - 프로젝트 디렉토리 외부로의 리다이렉션
2. **디렉토리 변경** (`cd`) - 작업 트리 외부로의 이동
3. **제자리 편집** (`sed -i`) - 파일 수정 추적용 특별 처리

#### 항상 차단되는 작업 (권한 모드와 무관)

- `.claude/`, `.git/` 설정 디렉토리 대상 명령어
- 셸 설정 파일 수정 (`.bashrc`, `.zshrc` 등)
- 경로 제한 우회 시도 (크로스플랫폼 경로 트릭)

### 4.6 MCP 도구 권한

```json
{
  "permissions": {
    "deny": [
      "mcp__myserver"
    ],
    "allow": [
      "mcp__myserver__read_database"
    ]
  }
}
```

- `mcp__servername`: 서버의 **모든** 도구 차단/허용
- `mcp__servername__toolname`: **개별** 도구만 차단/허용
- 거부가 허용보다 우선하므로, 위 예시에서 `read_database`만 허용하려면 deny 규칙을 더 구체적으로 작성해야 함

> **실무 팁**: MCP 서버에서 읽기 전용 도구만 허용하고 쓰기 도구는 차단하는 패턴이 가장 안전하다.

---

## 5. 권한 API와 결정 파이프라인

### 5.1 권한 결정 3가지

| 결정 | 의미 |
|------|------|
| `allow` | 즉시 실행 |
| `ask` | 사용자 확인 요청 |
| `deny` | 차단 |

### 5.2 결정 파이프라인 (7단계)

권한 요청이 발생하면 다음 순서로 평가된다:

```
1. 거부(Deny) 규칙 검사
   └── 매칭 -> 차단 (즉시 종료)
       |
2. Ask 규칙 검사
   └── 매칭 -> 확인 대화 표시
       |
3. 도구 자체 권한 확인
   └── 도구별 기본 안전 수준 평가
       |
4. 안전 확인
   └── .git/, .claude/, .vscode/ 등은 항상 확인 요청
       |
5. 모드 확인
   └── 현재 권한 모드에 따른 결정
       |
6. 허용(Allow) 규칙 검사
   └── 매칭 -> 즉시 실행
       |
7. 기본 동작
   └── 사용자에게 확인 요청
```

> **핵심**: Deny가 가장 먼저, Allow가 거의 마지막에 평가된다. 이는 보안 우선 설계(deny-first)다.

### 5.3 SDK를 통한 권한 업데이트

#### PermissionUpdate 객체

```json
{
  "type": "addRules",
  "rules": [
    { "toolName": "Bash", "ruleContent": "git *" }
  ],
  "behavior": "allow",
  "destination": "userSettings"
}
```

**type 종류:**
- `addRules` / `replaceRules` / `removeRules`: 규칙 추가/교체/제거
- `setMode`: 권한 모드 변경
- `addDirectories` / `removeDirectories`: 작업 디렉토리 추가/제거

**destination:**
- `userSettings` / `projectSettings` / `localSettings` / `session` / `cliArg`

#### 작업 디렉토리 확장

```bash
# CLI
claude --add-dir /path/to/extra/dir

# settings.json
{
  "permissions": {
    "additionalDirectories": [
      "/shared/data",
      "/home/user/configs"
    ]
  }
}

# SDK
{
  "type": "control_request",
  "request_id": "dirs-1",
  "request": {
    "subtype": "apply_flag_settings",
    "settings": {
      "permissions": {
        "additionalDirectories": ["/shared/data"]
      }
    }
  }
}
```

### 5.4 CLI 플래그로 권한 제어

```bash
# 허용 도구 명시
claude --allowedTools "Bash(git *),Read,Write" --print "Run the tests"

# 차단 도구 명시
claude --disallowedTools "Bash,Write" --print "Summarize this project"
```

### 5.5 Hooks와 권한 통합

`PreToolUse`와 `PermissionRequest` Hook으로 **프로그래밍 방식 권한 결정**이 가능하다. 헤드리스 에이전트에 특히 유용.

**PreToolUse에서 권한 오버라이드:**
```json
{
  "hookSpecificOutput": {
    "hookEventName": "PreToolUse",
    "permissionDecision": "deny",
    "permissionDecisionReason": "This command is not allowed in production"
  }
}
```

**PermissionRequest에서 프로그래밍 방식 승인:**
```json
{
  "hookSpecificOutput": {
    "decision": {
      "behavior": "allow",
      "updatedInput": {},
      "updatedPermissions": [
        {
          "type": "addRules",
          "rules": [{ "toolName": "Bash", "ruleContent": "git *" }],
          "behavior": "allow",
          "destination": "session"
        }
      ]
    }
  }
}
```

---

## 6. 실무 활용 시나리오

### 6.1 자동화 Hook 설정 레시피

#### 레시피 1: 파일 편집 후 자동 포매팅

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

#### 레시피 2: TypeScript 변경 후 자동 테스트

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

#### 레시피 3: 모든 도구 사용 로깅

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

#### 레시피 4: 위험한 명령어 차단

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

#### 레시피 5: 디렉토리 변경 시 환경 변수 자동 로드

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

#### 레시피 6: LLM으로 Bash 명령어 안전성 검사

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Check whether this bash command is safe: $ARGUMENTS. If it could delete important files, access sensitive data, or make irreversible changes, output an explanation and exit with code 2.",
            "model": "claude-haiku-4-5",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

#### 레시피 7: 작업 완료 조건 확인 (Stop Hook)

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "if ! npm test 2>/dev/null; then echo 'Tests are still failing. Please fix them before stopping.' >&2; exit 2; fi"
          }
        ]
      }
    ]
  }
}
```

> exit 2를 반환하면 Claude가 멈추지 않고 테스트를 고치기 위해 계속 작업한다.

#### 레시피 8: HTTP 웹훅으로 외부 알림

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "http",
            "url": "https://hooks.slack.com/services/YOUR/WEBHOOK/URL",
            "timeout": 10,
            "async": true
          }
        ]
      }
    ]
  }
}
```

### 6.2 커스텀 Skill 만들기 가이드

#### 단계별 진행

```bash
# 1. 디렉토리 생성
mkdir -p .claude/skills/deploy

# 2. SKILL.md 작성
cat > .claude/skills/deploy/SKILL.md << 'SKILLEOF'
---
description: Deploy the application to staging or production
argument-hint: environment (staging|production)
allowed-tools: Bash, Read
---

Deploy the application to $ARGUMENTS environment.

Current git status for context:
!`git status --short`

Current branch:
!`git branch --show-current`

Steps:
1. Verify we're on the correct branch (main for production, develop for staging)
2. Run `npm test` to ensure all tests pass
3. Run `npm run build` to create production build
4. Execute `./scripts/deploy.sh $ARGUMENTS`
5. Verify deployment with `curl -s https://$ARGUMENTS.example.com/health`
6. Report deployment status
SKILLEOF

# 3. 호출
# /deploy staging
```

#### Flutter 프로젝트용 Skill 예시

```markdown
---
description: Create a new Flutter feature with BLoC pattern
argument-hint: feature_name
allowed-tools: Write, Bash, Read
arguments: [feature_name]
---

Create a new Flutter feature module for $feature_name using BLoC pattern.

Directory structure:
```
lib/features/$feature_name/
  bloc/
    ${feature_name}_bloc.dart
    ${feature_name}_event.dart
    ${feature_name}_state.dart
  view/
    ${feature_name}_page.dart
    ${feature_name}_view.dart
  widgets/
  $feature_name.dart (barrel file)
```

Follow these conventions:
1. BLoC uses freezed for events and states
2. Page wraps View with BlocProvider
3. Barrel file exports all public APIs
4. Add route to app_router.dart
5. Run `dart run build_runner build` after creation
```

### 6.3 MCP 활용 시나리오

#### 시나리오 1: 개발 환경 통합

`.mcp.json` (프로젝트 루트):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "./"],
      "env": {}
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "POSTGRES_CONNECTION_STRING": "$DATABASE_URL"
      }
    }
  }
}
```

#### 시나리오 2: 안전한 DB 접근 설정

```json
{
  "permissions": {
    "allow": [
      "mcp__postgres__query"
    ],
    "deny": [
      "mcp__postgres__execute",
      "mcp__postgres__drop_table"
    ]
  }
}
```

읽기 쿼리만 허용하고 변경 작업은 차단.

#### 시나리오 3: CI/CD 환경에서 MCP 사용

```bash
# CI 스크립트
export DATABASE_URL="$CI_DATABASE_URL"
export MY_API_TOKEN="$CI_API_TOKEN"

claude --mcp-config ./ci-mcp-config.json \
       --permission-mode bypassPermissions \
       --dangerously-skip-permissions \
       --allowedTools "mcp__postgres__query,Read,Bash(npm test)" \
       --print "Run integration tests and report results"
```

### 6.4 통합 설정 예시: 프로덕션 레벨 구성

아래는 Hooks, 권한 규칙, MCP를 모두 조합한 실전 `.claude/settings.json` 예시다:

```json
{
  "defaultPermissionMode": "default",
  "permissions": {
    "allow": [
      "Read",
      "Glob",
      "Grep",
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(git diff *)",
      "Bash(npm run *)",
      "Bash(flutter test *)",
      "Bash(dart analyze *)",
      "mcp__postgres__query"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)",
      "Write(/etc/**)",
      "Write(~/.ssh/**)",
      "Edit(.env*)",
      "mcp__postgres__execute"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "if echo \"$CLAUDE_TOOL_INPUT\" | grep -qE 'rm -rf|sudo|chmod 777'; then echo 'Dangerous command blocked' >&2; exit 2; fi"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "prettier --write \"$CLAUDE_FILE_PATH\" 2>/dev/null || true",
            "statusMessage": "Formatting..."
          }
        ]
      },
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo \"$(date -u +%Y-%m-%dT%H:%M:%SZ) $CLAUDE_TOOL_NAME\" >> ~/.claude-tool-log.txt",
            "async": true
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo 'Session activity logged' >> ~/.claude-sessions.txt",
            "async": true
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [
          {
            "type": "command",
            "command": "echo \"Project: $(basename $(pwd)), Node: $(node -v 2>/dev/null || echo 'N/A'), Flutter: $(flutter --version 2>/dev/null | head -1 || echo 'N/A')\""
          }
        ]
      }
    ]
  }
}
```

---

## 부록: 핵심 체크리스트

### Hook 설정 체크리스트

- [ ] 적절한 이벤트 선택 (Pre vs Post, 도구 vs 세션)
- [ ] Matcher로 범위 제한 (불필요한 실행 방지)
- [ ] 타임아웃 설정 (blocking 방지)
- [ ] 장시간 실행은 `async: true` 사용
- [ ] 종료 코드 의미 이해 (0, 2, 기타)
- [ ] 테스트: 수동으로 Hook 트리거하여 동작 확인

### 권한 설정 체크리스트

- [ ] 적절한 모드 선택 (대화형 -> default, CI -> bypassPermissions)
- [ ] Deny 규칙에 위험 명령어 포함 (rm -rf, sudo, curl|bash)
- [ ] Allow 규칙은 세부적으로 (Bash(git *) O, Bash(*) X)
- [ ] MCP 도구는 읽기만 허용, 쓰기는 명시적 승인
- [ ] 클론한 저장소의 `.claude/settings.json` 반드시 검토

### Skill 작성 체크리스트

- [ ] 명확한 `description` 작성
- [ ] `argument-hint`로 사용법 안내
- [ ] `allowed-tools`로 필요한 도구만 허용
- [ ] `when_to_use`로 Claude 자동 호출 기준 명시
- [ ] 인라인 셸 명령어의 보안 영향 검토
- [ ] 팀 공유 Skill은 프로젝트 레벨, 개인용은 사용자 레벨에 배치

---

> **참고 문서**: 이 분석은 Claude Code 공식 문서(hooks, skills, mcp-servers, permissions, hooks-reference, permissions-api)를 기반으로 작성되었다. 최신 변경사항은 https://vineetagarwal-code-claude-code.mintlify.app/llms.txt 에서 확인.
