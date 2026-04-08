<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/sdk/permissions-api -->

# Permissions API

## 개요

이 문서는 Claude Code의 권한 시스템에 관한 참고자료입니다. 권한 시스템은 어떤 도구를 즉시 실행할지, 승인을 요청할지, 차단할지를 제어합니다.

---

## 권한 모드 (Permission Modes)

5가지 기본 모드가 있습니다:

| 모드 | 동작 |
|------|------|
| `default` | 위험한 작업은 승인 요청, 안전한 읽기 도구는 자동 실행 |
| `acceptEdits` | 파일 편집 작업 자동 승인, Bash는 여전히 요청 |
| `bypassPermissions` | 모든 보안 확인 건너뜀 (샌드박스 환경 전용) |
| `plan` | 읽기 전용 모드, 실행 불가 |
| `dontAsk` | 사전 승인된 규칙만 실행, 나머지는 거부 |

---

## 권한 모드 설정 방법

### CLI 플래그
```bash
claude --permission-mode acceptEdits
claude --permission-mode bypassPermissions --dangerously-skip-permissions
claude --permission-mode plan
```

### 설정 파일
```json
{
  "defaultPermissionMode": "acceptEdits"
}
```

설정 파일 우선순위 (높은 순서부터):
1. `.claude/settings.local.json` - 로컬 오버라이드
2. `.claude/settings.json` - 프로젝트 레벨
3. `~/.claude/settings.json` - 사용자 레벨

### /permissions 명령
```
/permissions
```
세션 내에서 대화형 권한 패널 열기

### SDK 제어 요청
```json
{
  "type": "control_request",
  "request_id": "pm-1",
  "request": {
    "subtype": "set_permission_mode",
    "mode": "acceptEdits"
  }
}
```

---

## 권한 규칙 (Permission Rules)

특정 도구를 사전 승인하거나 차단할 수 있습니다.

### 설정 형식
```json
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm run *)",
      "Read",
      "Write(src/**)",
      "mcp__myserver"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(curl * | bash)",
      "Write(/etc/**)"
    ]
  }
}
```

**중요:** 거부 규칙이 허용 규칙보다 우선됩니다.

---

## 규칙 문법

### 도구명만 명시
```
Read
Write
Edit
Bash
```

### 도구명 + 내용 패턴
```
Bash(git *)
Bash(npm run *)
Write(src/*)
Edit(*.ts)
```

Bash의 경우 전체 명령어 문자열과 매칭, 파일 도구는 파일 경로와 매칭

### MCP 서버
```
mcp__myserver
mcp__myserver__*
mcp__myserver__query_database
```

### Agent 타입
```
Agent(Explore)
Agent(CodeReviewer)
```

---

## Bash 패턴 매칭

쉘 스타일 glob 패턴 사용:
```json
{
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git log *)",
      "Bash(npm run test*)",
      "Bash(make *)"
    ],
    "deny": [
      "Bash(rm *)",
      "Bash(sudo *)",
      "Bash(* | bash)",
      "Bash(* | sh)"
    ]
  }
}
```

---

## 파일 도구 패턴 매칭

절대 경로를 기준으로 매칭:
```json
{
  "permissions": {
    "allow": [
      "Write(src/**)",
      "Write(tests/**)",
      "Edit(*.md)",
      "Read"
    ],
    "deny": [
      "Write(/etc/**)",
      "Write(~/.ssh/**)",
      "Edit(.env*)"
    ]
  }
}
```

---

## 권한 규칙 출처 및 우선순위

| 출처 | 설정 위치 | 편집 가능 |
|------|----------|----------|
| `policySettings` | 관리 정책 레이어 | 아니오 |
| `flagSettings` | CLI 플래그, SDK 요청 | 세션별 |
| `userSettings` | `~/.claude/settings.json` | 예 |
| `projectSettings` | `.claude/settings.json` | 예 |
| `localSettings` | `.claude/settings.local.json` | 예 |
| `cliArg` | CLI 플래그 | 호출별 |
| `session` | `/permissions` 명령 | 세션별 |

### CLI 플래그
```bash
claude --allowedTools "Bash(git *),Read,Write" --print "Run the tests"
claude --disallowedTools "Bash,Write" --print "Summarize this project"
```

---

## 권한 결정 (Permission Decisions)

3가지 결과:

| 결정 | 의미 |
|------|------|
| `allow` | 즉시 실행 |
| `ask` | 사용자 확인 요청 |
| `deny` | 차단 |

### 결정 파이프라인

1. 거부 규칙 검사 -> 차단
2. Ask 규칙 검사 -> 확인 대화
3. 도구 자체 권한 확인
4. 안전 확인 (`.git/`, `.claude/`, `.vscode/` 등은 항상 확인 요청)
5. 모드 확인
6. 허용 규칙 검사
7. 기본 동작 (사용자에게 확인 요청)

---

## 작업 디렉토리 (Working Directories)

기본적으로 현재 디렉토리로 제한됩니다.

### CLI 플래그
```bash
claude --add-dir /path/to/extra/dir
```

### 설정 파일
```json
{
  "permissions": {
    "additionalDirectories": [
      "/shared/data",
      "/home/user/configs"
    ]
  }
}
```

### SDK 제어 요청
```json
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

---

## SDK를 통한 권한 업데이트

### PermissionUpdate 객체
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

**필드:**
- `type`: 'addRules' | 'replaceRules' | 'removeRules' | 'setMode' | 'addDirectories' | 'removeDirectories'
- `rules`: 규칙 배열
- `behavior`: 'allow' | 'deny' | 'ask'
- `destination`: 'userSettings' | 'projectSettings' | 'localSettings' | 'session' | 'cliArg'

### 권한 결정 응답
```json
{
  "type": "control_response",
  "response": {
    "subtype": "success",
    "request_id": "<request_id>",
    "response": {
      "behavior": "allow",
      "updatedPermissions": [
        {
          "type": "addRules",
          "rules": [{ "toolName": "Bash", "ruleContent": "git *" }],
          "behavior": "allow",
          "destination": "userSettings"
        }
      ],
      "decisionClassification": "user_permanent"
    }
  }
}
```

---

## 안전 권장사항

### CI/CD 파이프라인
격리된 환경에서만 `bypassPermissions` 사용:
```json
{
  "defaultPermissionMode": "bypassPermissions",
  "allowDangerouslySkipPermissions": true,
  "permissions": {
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash)"
    ]
  }
}
```

### IDE 및 대화형 사용
`default` 모드 + 안전한 작업 허용:
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
      "Bash(npm run *)",
      "Bash(make *)"
    ]
  }
}
```

### 코드 검토 및 읽기 전용 분석
```bash
claude --permission-mode plan "Explain the architecture of this codebase"
```

### 자동 에이전트 + 인간 승인
```json
{
  "defaultPermissionMode": "dontAsk",
  "permissions": {
    "allow": [
      "Read",
      "Bash(git *)"
    ]
  }
}
```

---

## 훅과 권한 (Hooks and Permissions)

`PreToolUse` 및 `PermissionRequest` 훅으로 프로그래밍 방식 권한 결정 가능. 헤드리스 에이전트에 유용합니다.
