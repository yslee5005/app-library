<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/guides/mcp-servers -->

# MCP Servers Documentation

## Overview

MCP (Model Context Protocol)는 Claude Code를 외부 데이터 소스와 연결할 수 있는 개방형 표준입니다. 데이터베이스 쿼리, Jira 티켓 읽기, Slack 워크스페이스 상호작용 등의 기능을 제공합니다.

### 주요 기능

1. **Capability Extension**: "Connect Claude to any service that exposes an MCP server: databases, APIs, file systems, and more."

2. **Configuration Scope**: 프로젝트별 `.mcp.json` 또는 글로벌 사용자 설정으로 저장 가능.

3. **Runtime Management**: `/mcp enable` 및 `/mcp disable` 명령으로 수동 파일 편집 없이 서버를 토글 가능.

4. **Permission Control**: "Claude Code prompts before calling any MCP tool, giving you control over what actions are taken."

---

## Adding Servers

### CLI 방식

기본 명령어 구조:
```bash
claude mcp add <name> -- <command> [args...]
```

파일시스템 서버 예시:
```bash
claude mcp add filesystem -- npx -y @modelcontextprotocol/server-filesystem /tmp
```

스코프 지정 옵션:
```bash
# Project scope (팀 공유)
claude mcp add --scope project filesystem -- npx -y @modelcontextprotocol/server-filesystem /tmp

# User scope (개인, 글로벌)
claude mcp add --scope user my-db -- npx -y @my-org/mcp-server-postgres
```

`/mcp` 명령은 서버의 활성화, 비활성화 및 재연결을 위한 관리 패널을 엽니다.

### 설정 파일 플래그

```bash
claude --mcp-config ./my-mcp-config.json
```

CI 환경이나 설정에 저장하지 않는 자체 포함 구성에 권장됩니다.

---

## 설정 파일 형식

### 구조 개요

모든 구성은 `mcpServers` 최상위 키를 포함하는 JSON을 사용하며, 이름이 지정된 서버 객체를 포함합니다.

### 전송 유형

#### 1. Stdio (로컬 프로세스)

stdin/stdout을 통한 로컬 서브프로세스 통신에 가장 일반적:

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

필수 및 선택 필드:
- `command` (필수): 실행 파일 이름
- `args`: 명령줄 인수 배열
- `env`: 환경 변수 객체

#### 2. HTTP (원격 서버)

HTTP 엔드포인트로 호스팅되는 서버:

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

주요 필드:
- `type`: `"http"`이어야 함
- `url` (필수): 서버 엔드포인트
- `headers`: `$VAR` 확장을 지원하는 HTTP 헤더

#### 3. SSE (Server-Sent Events)

SSE 전송 서버:

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

### 이름 규칙

서버 이름은 문자, 숫자, 하이픈, 밑줄만 허용됩니다.

### 환경 변수 확장

`command`, `args`, `url`, `headers`의 값은 `$VAR` 및 `${VAR}` 구문을 지원합니다. 시작 시 셸 환경에서 확장됩니다. 누락된 변수는 경고를 표시하지만 연결 시도는 계속됩니다.

---

## Configuration Scopes

| Scope | 위치 | 용도 |
|-------|------|------|
| `project` | 현재/상위 디렉토리의 `.mcp.json` | 팀 공유 서버 구성 |
| `user` | `~/.claude.json` (글로벌) | 모든 곳에서 사용 가능한 개인 서버 |
| `local` | `.claude/settings.local.json` (프로젝트별) | 프로젝트별 개인 오버라이드, 버전 관리 안 됨 |

**우선순위** (높은 순): local > project > user. 동일한 서버 이름이 여러 스코프에 존재하면 로컬 버전이 우선합니다.

---

## Managing Servers

### Enable/Disable 명령

```
/mcp enable <server-name>
/mcp disable <server-name>
/mcp enable all
/mcp disable all
```

비활성화된 서버는 구성은 유지되지만 시작 시 연결되지 않으며, 조건부 활성화에 유용합니다.

### 재연결

```
/mcp reconnect <server-name>
```

서버가 실패하거나 재설정이 필요할 때 재연결을 강제합니다.

### 상태 보기

`/mcp` 실행 시 모든 구성된 서버와 상태 표시기가 표시됩니다:

- **connected**: 서버 실행 중 및 작동 중
- **pending**: 서버 초기화 중
- **failed**: 연결 오류 (메시지 제공)
- **needs-auth**: OAuth 인증 필요
- **disabled**: 구성되었지만 비활성

---

## Tool Call Approval

MCP 도구 실행 전, Claude는 도구 이름과 입력 인수를 보여주는 권한 프롬프트를 표시합니다. 사용자는 다음을 선택할 수 있습니다:

- **Allow once**: 단일 호출 승인
- **Allow always**: 세션 내 해당 도구의 모든 호출 승인
- **Deny**: 호출 차단; Claude에 오류 알림

### Auto Mode 사전 승인

`--allowedTools`를 사용하는 자동 모드에서, 전체 이름 형식으로 도구를 사전 승인할 수 있습니다: `mcp__<server-name>__<tool-name>`

---

## Filesystem Server 예시

**Step 1 - 추가**:
```bash
claude mcp add --scope project filesystem -- npx -y @modelcontextprotocol/server-filesystem /home/user/projects
```

**Step 2 - 확인**:
`/mcp` 실행 후 filesystem이 **connected** 상태인지 확인.

**Step 3 - 사용**:
Claude가 지정된 디렉토리에 대해 `mcp__filesystem__read_file` 및 `mcp__filesystem__write_file` 도구에 접근 가능.

---

## Database Server 예시

PostgreSQL 서버 구성:

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

Claude Code 실행 전 `DATABASE_URL` 환경 변수를 설정하면 서버가 자동으로 수신합니다.

---

## Official Registry

Anthropic과 커뮤니티는 [modelcontextprotocol.io](https://modelcontextprotocol.io)에서 MCP 서버 레지스트리를 유지 관리하며, 데이터베이스, 생산성 도구, 클라우드 제공업체 등을 포함합니다.

---

## Troubleshooting

### 서버 상태가 Failed인 경우

진단:
- 명령어 존재 확인: `which npx`
- 명령어를 수동으로 테스트하여 시작 오류 확인
- 필수 환경 변수(API 키) 설정 확인
- `claude --debug`로 상세 연결 로그 확인

### MCP 도구가 누락된 경우

연결되었지만 인증되지 않은 서버는 도구를 노출하지 않습니다. `/mcp`에서 **needs-auth** 상태를 확인하고 OAuth 인증을 완료하세요.

### 환경 변수가 확장되지 않는 경우

변수는 시작 시 프로세스 환경에서 확장됩니다. `claude` 실행 전 같은 터미널에서 `echo $YOUR_VAR`로 변수 존재를 확인하세요.

### Windows npx 실패

Windows에서는 `cmd /c` 래퍼가 필요합니다:

```json
{
  "mcpServers": {
    "my-server": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@my-org/mcp-server"]
    }
  }
}
```

### CI 환경 문제

`--mcp-config`로 명시적으로 구성을 전달하고, 모든 환경 변수가 CI에서 설정되어 있는지 확인하며, CI PATH에서 명령어 사용 가능 여부를 확인하세요.

---

## 문서 탐색

전체 documentation index: https://vineetagarwal-code-claude-code.mintlify.app/llms.txt
