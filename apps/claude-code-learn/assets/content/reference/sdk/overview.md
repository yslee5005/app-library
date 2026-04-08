<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/sdk/overview -->

# Claude Code SDK 개요

## 1. 소개 및 기본 개념

**Claude Code SDK**는 다른 애플리케이션에 Claude Code를 내장하기 위한 제어 프로토콜입니다. IDE, 자동화 스크립트, CI/CD 파이프라인, 또는 서브프로세스를 실행하고 stdin/stdout으로 통신할 수 있는 모든 호스트에서 사용할 수 있습니다.

라이브러리 API를 직접 노출하는 대신, SDK는 실행 중인 `claude` 프로세스와 구조화된 JSON 메시지 스트림으로 통신합니다. 호스트 프로세스는 사용자 메시지와 제어 요청을 전송하고, CLI 프로세스는 어시스턴트 메시지, 도구 진행 이벤트, 결과 페이로드를 스트리밍합니다.

**TypeScript 타입**: `@anthropic-ai/claude-code` 패키지의 `agentSdkTypes` 진입점에서 내보내집니다. 제어 프로토콜 타입(접두사 `SDKControl`)은 `@alpha`이며 변경될 수 있습니다.

---

## 2. 동작 방식 (4단계)

### 단계 1: Claude Code 프로세스 시작

`--output-format stream-json`과 `--print` 플래그(비대화형 모드)와 함께 `claude`를 시작합니다. 해당 stdin과 stdout을 호스트 프로세스로 파이프합니다.

```bash
claude --output-format stream-json --print --verbose
```

여러 프롬프트를 시간에 따라 허용하는 지속적인 세션의 경우, `--print`를 생략하고 세션이 초기화된 후 stdin으로 `SDKUserMessage` 객체를 전송합니다.

### 단계 2: 초기화 요청 전송

`subtype: "initialize"`를 포함한 `control_request`를 stdin으로 작성합니다. CLI는 사용 가능한 명령어, 모델, 에이전트 및 계정 정보를 포함한 `SDKControlInitializeResponse`로 응답합니다.

```json
{
  "type": "control_request",
  "request_id": "init-1",
  "request": {
    "subtype": "initialize",
    "systemPrompt": "You are a code reviewer.",
    "appendSystemPrompt": "Always suggest tests."
  }
}
```

### 단계 3: stdout에서 메시지 스트리밍

stdout에서 줄 구분 JSON을 읽습니다. 각 줄은 `SDKMessage` 합집합 타입 중 하나입니다(어시스턴트 턴, 도구 진행 상황, 시스템 이벤트, 결과 요약).

### 단계 4: 사용자 메시지 전송

stdin으로 `SDKUserMessage` 객체를 작성하여 대화를 계속합니다. 각 메시지에는 Anthropic API 호환 `message` 페이로드가 포함됩니다.

---

## 3. 출력 형식

`--output-format` 전달하여 Claude Code가 stdout으로 작성하는 내용을 제어합니다.

| 형식 | 설명 |
|------|------|
| `text` | 일반 텍스트 응답만. 대화형 모드의 기본값 |
| `json` | 완료 시 작성된 단일 JSON 객체. 일회성 스크립트에 적합 |
| `stream-json` | 줄 구분 JSON 스트림. 줄당 하나의 메시지, 이벤트 발생 시 내보내짐. SDK 사용에 필수 |

**팁**: 점진적으로 진행 상황을 렌더링하거나 도구 이벤트를 처리해야 할 때는 `stream-json`을 사용하세요. 최종 결과만 신경 쓸 때는 `json`을 사용하세요.

---

## 4. 제어 프로토콜 메시지

제어 프로토콜은 stdin/stdout을 통해 양방향으로 흐르는 두 가지 최상위 봉투 타입을 사용합니다.

### 4.1 `SDKControlRequest`

CLI 프로세스에 **전송되어** 세션을 구성하거나 명령을 실행합니다.

```json
{
  "type": "control_request",
  "request_id": "<unique-string>",
  "request": { "subtype": "...", ...payload }
}
```

**필드:**
- **type** (필수, 리터럴: `'control_request'`): 항상 `"control_request"`
- **request_id** (필수, 문자열): 이 요청에 대한 고유 식별자. CLI는 해당 `control_response`에서 반향합니다
- **request** (필수, `SDKControlRequestInner`): 요청 페이로드. `subtype`이 수행할 작업을 식별합니다

### 4.2 `SDKControlResponse`

CLI 프로세스에서 **내보내져** `control_request`에 응답합니다.

```json
{
  "type": "control_response",
  "response": {
    "subtype": "success",
    "request_id": "<echoed-id>",
    "response": { ...payload }
  }
}
```

오류 시, `subtype`은 `"error"`이고 `error` 필드에는 사람이 읽을 수 있는 메시지가 포함됩니다.

---

## 5. 초기화 요청 및 응답

`initialize` 요청은 보내야 하는 첫 번째 제어 메시지입니다. 세션을 구성하고 사용 가능한 기능을 반환합니다.

### 5.1 `SDKControlInitializeRequest`

```json
{
  "type": "control_request",
  "request_id": "init-1",
  "request": {
    "subtype": "initialize",
    "systemPrompt": "You are a CI automation agent.",
    "appendSystemPrompt": "Always add test coverage.",
    "hooks": {
      "PreToolUse": [
        {
          "matcher": "Bash",
          "hookCallbackIds": ["my-hook-id"]
        }
      ]
    },
    "agents": {
      "CodeReviewer": {
        "description": "Reviews code for quality and security.",
        "prompt": "You are an expert code reviewer...",
        "model": "opus"
      }
    }
  }
}
```

**필드:**
- **subtype** (필수, 리터럴: `'initialize'`): 이를 초기화 요청으로 식별합니다
- **systemPrompt** (문자열, 선택): 이 세션의 기본 시스템 프롬프트를 대체합니다
- **appendSystemPrompt** (문자열, 선택): 기본 동작을 유지하면서 시스템 프롬프트에 추가합니다
- **hooks** (레코드, 선택): SDK 측 후크 콜백을 등록합니다. CLI는 후크 이벤트가 발생할 때 SDK 프로세스로 콜백합니다
- **sdkMcpServers** (문자열 배열, 선택): 이 세션에 연결할 프로세스 내 SDK MCP 서버 이름
- **agents** (레코드, 선택): 이 세션 중 `Agent` 도구에서 사용 가능한 커스텀 서브에이전트 정의

#### AgentDefinition 필드:
- **description** (필수, 문자열): Claude가 이 에이전트를 언제 호출해야 하는지를 나타내는 자연어 설명
- **prompt** (필수, 문자열): 이 에이전트의 시스템 프롬프트
- **model** (문자열, 선택): 모델 별칭(`"sonnet"`, `"opus"`, `"haiku"`) 또는 전체 모델 ID. 기본값은 부모 모델 상속
- **tools** (문자열 배열, 선택): 도구 이름의 허용 목록. 생략하면 에이전트는 모든 도구를 상속합니다
- **disallowedTools** (문자열 배열, 선택): 이 에이전트에 대해 명시적으로 차단된 도구
- **maxTurns** (숫자, 선택): 에이전트가 중지되기 전의 최대 에이전트 턴
- **permissionMode** (PermissionMode, 선택): 이 에이전트의 권한 모드 재정의

### 5.2 `SDKControlInitializeResponse`

CLI는 세션의 현재 기능으로 응답합니다.

```json
{
  "type": "control_response",
  "response": {
    "subtype": "success",
    "request_id": "init-1",
    "response": {
      "commands": [...],
      "agents": [...],
      "output_style": "stream-json",
      "available_output_styles": ["text", "json", "stream-json"],
      "models": [...],
      "account": {
        "email": "user@example.com",
        "organization": "Acme Corp",
        "apiProvider": "firstParty"
      }
    }
  }
}
```

**필드:**
- **commands** (`SlashCommand[]`): 사용 가능한 슬래시 명령(예: `/compact`, `/cost`). 각 항목은 `name`, `description`, `argumentHint`를 포함합니다
- **agents** (`AgentInfo[]`): 사용 가능한 서브에이전트 타입. 각각 `name`, `description`, 선택적 `model`을 포함합니다
- **output_style** (문자열): 활성 출력 형식(`"stream-json"`, `"json"`, `"text"`)
- **models** (`ModelInfo[]`): 이 계정에서 사용 가능한 모델

#### ModelInfo 필드:
- **value** (문자열): API 호출을 위한 모델 식별자(예: `"claude-sonnet-4-6"`)
- **displayName** (문자열): 사람이 읽을 수 있는 이름(예: `"Claude Sonnet 4.6"`)
- **supportsEffort** (부울): 이 모델이 노력 수준을 지원하는지 여부
- **supportsAdaptiveThinking** (부울): 이 모델이 적응형 사고를 지원하는지 여부

- **account** (`AccountInfo`): 로그인한 계정 세부 정보

#### AccountInfo 필드:
- **email** (문자열): 계정 이메일 주소
- **organization** (문자열): 조직 이름
- **subscriptionType** (문자열): 구독 계층
- **apiProvider** (`'firstParty' | 'bedrock' | 'vertex' | 'foundry'`): 활성 API 백엔드. Anthropic OAuth는 `"firstParty"`일 때만 적용됩니다

---

## 6. 사용자 메시지

stdin으로 사용자 메시지를 전송하여 대화를 진행합니다.

### `SDKUserMessage`

```json
{
  "type": "user",
  "message": {
    "role": "user",
    "content": "Refactor this function to use async/await."
  },
  "parent_tool_use_id": null
}
```

**필드:**
- **type** (필수, 리터럴: `'user'`): 항상 `"user"`
- **message** (필수, `APIUserMessage`): Anthropic API 호환 사용자 메시지. `content`는 문자열 또는 콘텐츠 블록 배열(이미지 및 기타 미디어의 경우)일 수 있습니다
- **parent_tool_use_id** (필수, 문자열 | null): 이 메시지가 응답하는 도구 사용 ID, 또는 최상위 사용자 메시지의 경우 `null`
- **uuid** (문자열, 선택): 이 메시지를 추적하는 선택적 UUID. 관련 이벤트에서 반향합니다
- **priority** (`'now' | 'next' | 'later'`, 선택): 비동기 메시지 큐에 대한 스케줄링 힌트

---

## 7. SDK 메시지 스트림 타입

Claude Code는 stdout으로 JSON 메시지의 스트림을 내보냅니다. `type` 필드가 각 메시지를 식별합니다.

### 7.1 `system` -- 세션 초기화

세션 시작 시 `subtype: "init"`으로 한 번 내보내집니다. 활성 모델, 도구 목록, MCP 서버 상태, 권한 모드 및 세션 ID를 포함합니다.

```json
{
  "type": "system",
  "subtype": "init",
  "model": "claude-sonnet-4-6",
  "tools": ["Bash", "Read", "Write", "Edit", "Glob", "Grep"],
  "mcp_servers": [],
  "permissionMode": "default",
  "session_id": "abc123",
  "uuid": "..."
}
```

### 7.2 `assistant` -- 모델 응답

모델이 턴을 생성할 때 내보내집니다. 모든 Anthropic API 응답 객체(모든 `tool_use` 블록 포함)를 포함합니다.

```json
{
  "type": "assistant",
  "message": { "role": "assistant", "content": [...] },
  "parent_tool_use_id": null,
  "uuid": "...",
  "session_id": "abc123"
}
```

### 7.3 `stream_event` -- 부분 스트리밍 토큰

스트리밍 중 `RawMessageStreamEvent` 페이로드와 함께 내보내집니다. 이를 사용하여 점진적 출력을 렌더링합니다.

### 7.4 `tool_progress` -- 장시간 실행되는 도구 상태

몇 초 이상 걸리는 도구(예: Bash 명령)에 대해 주기적으로 내보내집니다. `tool_name`, `tool_use_id`, 경과 시간을 포함합니다.

### 7.5 `result` -- 최종 턴 요약

각 턴의 끝에 내보내집니다. `subtype`은 `"success"` 또는 오류 서브타입 중 하나입니다.

```json
{
  "type": "result",
  "subtype": "success",
  "result": "The function has been refactored.",
  "duration_ms": 4200,
  "total_cost_usd": 0.0042,
  "num_turns": 3,
  "is_error": false,
  "stop_reason": "end_turn",
  "session_id": "abc123",
  "uuid": "..."
}
```

**오류 서브타입:**
- `"error_during_execution"`
- `"error_max_turns"`
- `"error_max_budget_usd"`
- `"error_max_structured_output_retries"`

### 7.6 `system` -- 상태 업데이트

`subtype: "status"`와 함께 권한 모드 또는 세션 상태(예: `"compacting"`)가 변경될 때 내보내집니다.

---

## 8. 기타 제어 요청

`initialize` 외에, 제어 프로토콜은 다음 작업을 노출합니다:

| `subtype` | 방향 | 설명 |
|-----------|------|------|
| `interrupt` | 호스트 -> CLI | 현재 턴을 중단합니다 |
| `set_permission_mode` | 호스트 -> CLI | 활성 권한 모드를 변경합니다 |
| `set_model` | 호스트 -> CLI | 세션 중간에 다른 모델로 전환합니다 |
| `can_use_tool` | CLI -> 호스트 | 도구 호출에 대한 권한 요청(SDK 권한 처리기 필요) |
| `mcp_status` | 호스트 -> CLI | MCP 서버 연결 상태를 가져옵니다 |
| `mcp_set_servers` | 호스트 -> CLI | 동적으로 관리되는 MCP 서버를 대체합니다 |
| `get_context_usage` | 호스트 -> CLI | 컨텍스트 윈도우 사용량 분석을 가져옵니다 |
| `get_settings` | 호스트 -> CLI | 효과적인 병합 설정을 읽습니다 |
| `apply_flag_settings` | 호스트 -> CLI | 플래그 설정 계층에 설정을 병합합니다 |
| `rewind_files` | 호스트 -> CLI | 주어진 메시지 이후에 만들어진 파일 변경사항을 되돌립니다 |
| `hook_callback` | CLI -> 호스트 | SDK 등록된 후크 콜백에 후크 이벤트를 전달합니다 |
| `reload_plugins` | 호스트 -> CLI | 디스크에서 플러그인을 다시 로드합니다 |

---

## 9. 세션 관리 API

스크립팅 시나리오의 경우, SDK는 `~/.claude/`에 저장된 저장된 세션 트랜스크립트에 대해 작동하는 함수를 내보냅니다.

```typescript
import {
  query,
  listSessions,
  getSessionInfo,
  getSessionMessages,
  forkSession,
  renameSession,
  tagSession,
} from '@anthropic-ai/claude-code'
```

### 9.1 `query` -- 프롬프트 실행

기본 SDK 진입점입니다. `prompt` 문자열 또는 `AsyncIterable<SDKUserMessage>`를 받아들이고 `SDKMessage`의 비동기 반복 가능을 반환합니다.

```typescript
for await (const message of query({
  prompt: 'What files are in this directory?',
  options: { cwd: '/my/project' }
})) {
  if (message.type === 'result') {
    console.log(message.result)
  }
}
```

### 9.2 `listSessions` -- 저장된 세션 나열

프로젝트 디렉터리의 세션 메타데이터를 반환합니다. 특정 프로젝트로 범위를 지정하려면 `dir`을 전달하거나, 모든 세션을 나열하려면 생략합니다.

```typescript
const sessions = await listSessions({ dir: '/my/project', limit: 50 })
```

### 9.3 `getSessionMessages` -- 트랜스크립트 읽기

세션의 JSONL 트랜스크립트 파일을 구문 분석하고 메시지를 시간순으로 반환합니다.

```typescript
const messages = await getSessionMessages(sessionId, {
  dir: '/my/project',
  includeSystemMessages: false,
})
```

### 9.4 `forkSession` -- 대화 분기

세션의 트랜스크립트를 새 세션으로 복사하면서 UUID를 다시 매핑합니다. 특정 지점에서 분기하려면 `upToMessageId`를 지원합니다.

```typescript
const { sessionId: newId } = await forkSession(originalSessionId, {
  upToMessageId: 'msg-uuid',
  title: 'Experimental branch',
})
```

### 9.5 `renameSession` 및 `tagSession`

```typescript
await renameSession(sessionId, 'My refactor session')
await tagSession(sessionId, 'needs-review')
await tagSession(sessionId, null) // 태그 지우기
```

---

## 10. 사용 사례

### 10.1 IDE 통합

IDE는 지속적인 Claude Code 프로세스를 시작하고 제어 프로토콜을 통해 메시지를 라우팅할 수 있습니다. IDE 컨텍스트를 설명하는 커스텀 `systemPrompt`와 함께 `initialize` 요청을 전송한 다음 편집기의 채팅 패널에서 사용자 메시지를 전달합니다. `PreToolUse` 후크 콜백을 사용하여 파일 편집을 가로채고 IDE의 네이티브 UI에서 디프를 표시한 후 적용합니다.

### 10.2 CI/CD 자동화

CI 파이프라인에서 일회성 작업을 위해 `--output-format json`과 `--print`를 사용합니다:

```bash
result=$(echo "Review the diff and output pass/fail" | \
  claude --output-format json --print \
         --permission-mode bypassPermissions)
```

JSON 출력에서 `result` 필드를 구문 분석하여 에이전트의 응답을 프로그래매틱하게 추출합니다.

### 10.3 헤드리스 에이전트

장기 실행 백그라운드 에이전트의 경우, TypeScript SDK에서 `query()`를 스트리밍 출력 형식과 함께 사용합니다. `watchScheduledTasks`(내부)와 결합하여 cron 스케줄에서 작업을 시작하면서 claude.ai에 대한 WebSocket 연결을 유지하는 지속적인 데몬 프로세스를 유지합니다.
