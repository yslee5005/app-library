<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/commands/slash-commands -->

# Claude Code 슬래시 명령어 완전 가이드

## 개요

슬래시 명령어는 Claude Code 세션 중 입력 프롬프트에서 `/`를 입력하여 활성화하는 명령들입니다.

**기본 구문:**
```
/command [arguments]
```

> Type `/help` at any time to see all commands available in the current session

---

## 명령어 빠른 참조표

| 명령어 | 설명 |
|--------|------|
| `/init` | 프로젝트용 CLAUDE.md 파일 생성 및 스킬/훅 선택적 생성 |
| `/memory` | Claude 메모리 파일 편집 (글로벌, 프로젝트, 로컬) |
| `/config` | 설정 패널 열기 |
| `/hooks` | 도구 이벤트용 훅 설정 확인 |
| `/mcp` | MCP 서버 관리 (활성화, 비활성화, 재연결) |
| `/permissions` | 도구별 허용/거부 규칙 관리 |
| `/plan` | 계획 모드 활성화 또는 세션 계획 확인 |
| `/model` | 현재 세션의 AI 모델 설정 |
| `/commit` | AI가 생성한 메시지로 깃 커밋 생성 |
| `/review` | 풀 리퀘스트 리뷰 |
| `/skills` | 사용 가능한 스킬 목록 |
| `/compact` | 대화 기록 요약하여 컨텍스트 사용량 감소 |
| `/clear` | 대화 기록 삭제 및 컨텍스트 해제 |
| `/help` | 도움말 및 사용 가능한 명령어 표시 |
| `/login` | Anthropic 계정 로그인 또는 전환 |
| `/logout` | Anthropic 계정 로그아웃 |

---

## 프로젝트 및 메모리 명령어

### /init

**구문:** `/init`

코드베이스를 분석하고 CLAUDE.md 파일, 선택적으로 스킬과 훅을 설정합니다.

**설정 내용:**

- **프로젝트 CLAUDE.md** - 소스 제어에 체크인되는 팀 공유 지침. 빌드/테스트/린트 명령, 코딩 규칙, 아키텍처 참고사항 포함
- **개인 CLAUDE.local.md** - 이 프로젝트용 개인 설정 (gitignore됨). 역할, 샌드박스 URL, 통신 선호도 포함
- **스킬** - `.claude/skills/<name>/SKILL.md`에 정의된 온디맨드 워크플로우
- **훅** - `.claude/settings.json`의 결정적 셸 명령어로 도구 이벤트(예: 모든 편집 시 포맷팅)에 자동 실행

**예시:**
```
/init
```

> Run `/init` again at any time. If `CLAUDE.md` already exists, Claude will propose specific changes

---

### /memory

**구문:** `/memory`

Claude의 메모리 파일을 편집하기 위한 대화형 편집기를 엽니다. 메모리 파일은 모든 세션에 로드되고 대화 간 지속됩니다.

**메모리 범위:**

| 범위 | 파일 | 적용 대상 |
|------|------|----------|
| 글로벌 | `~/.claude/CLAUDE.md` | 모든 프로젝트에서의 개인 설정 |
| 프로젝트 | 프로젝트 루트의 `CLAUDE.md` | 팀의 모든 구성원 |
| 로컬 | 프로젝트 루트의 `CLAUDE.local.md` | 이 프로젝트만 (gitignore됨) |

**예시:**
```
/memory
```

---

## 설정 명령어

### /config

**구문:** `/config`

**별칭:** `/settings`

모델 선호도, 테마, 상세 모드 등을 포함한 Claude Code 설정을 보고 편집할 수 있는 설정 패널을 엽니다.

**예시:**
```
/config
```

---

### /hooks

**구문:** `/hooks`

현재 세션에 대해 활성화된 훅 설정을 표시합니다. 훅은 도구 이벤트 발생 시 자동으로 실행되는 셸 명령어입니다(예: 모든 파일 편집 후, Bash 명령어 전).

**예시:**
```
/hooks
```

> To create or edit hooks, use `/init` or edit `.claude/settings.json` directly

---

### /mcp

**구문:** `/mcp [enable|disable [server-name]]`

현재 세션에서 MCP(Model Context Protocol) 서버를 관리합니다.

**인수:**

| 인수 | 효과 |
|------|------|
| *(없음)* | MCP 관리 패널 열기 |
| `enable` | 비활성화된 모든 MCP 서버 활성화 |
| `enable <server-name>` | 특정 서버를 이름으로 활성화 |
| `disable` | 활성화된 모든 MCP 서버 비활성화 |
| `disable <server-name>` | 특정 서버 비활성화 |
| `reconnect <server-name>` | 특정 서버 재연결 |

**예시:**
```
/mcp
/mcp enable
/mcp enable my-database-server
/mcp disable analytics-server
/mcp reconnect filesystem
```

> Changes made with `/mcp enable`/`disable` apply for the current session only

---

### /permissions

**구문:** `/permissions`

**별칭:** `/allowed-tools`

도구에 대한 허용 및 거부 규칙을 보고 관리할 수 있는 권한 패널을 엽니다.

**규칙 예시:**
```
Bash(git:*)         # 모든 git 명령어 허용
Bash(npm:*)         # 모든 npm 명령어 허용
Edit(src/**/*.ts)   # src/의 TypeScript 파일 편집 허용
```

---

### /model

**구문:** `/model [model]`

세션의 나머지 부분에서 사용할 AI 모델을 설정합니다.

**인수:**

| 인수 | 효과 |
|------|------|
| *(없음)* | 대화형 모델 선택기 열기 |
| `sonnet` | 최신 Claude Sonnet으로 전환 |
| `opus` | 최신 Claude Opus로 전환 |
| `haiku` | 최신 Claude Haiku로 전환 |
| `claude-sonnet-4-6` | 전체 ID로 특정 모델로 전환 |

**예시:**
```
/model
/model sonnet
/model claude-opus-4-5
```

---

## 세션 관리 명령어

### /plan

**구문:** `/plan [open|<description>]`

계획 모드를 활성화하거나 현재 세션 계획을 관리합니다. 계획 모드에서는 Claude가 조치를 취하기 전에 작성된 계획을 생성하고 승인을 기다립니다.

**인수:**

| 인수 | 효과 |
|------|------|
| *(없음)* | 계획 모드 켜기/끄기 전환 |
| `open` | 현재 계획 열기 및 표시 |
| `<description>` | 주어진 설명으로 새 계획 생성 |

**예시:**
```
/plan
/plan open
/plan refactor the auth module to use JWT
```

> Plan mode is equivalent to `--permission-mode plan` at launch

---

### /compact

**구문:** `/compact [instructions]`

대화 기록을 요약하고 압축된 버전으로 컨텍스트에 대체합니다. 컨텍스트 윈도우가 채워지고 있고 새 세션을 시작하지 않고 계속 작업하려는 경우 사용합니다.

**예시:**
```
/compact
/compact focus only on the database schema changes
/compact summarize the last three completed tasks
```

---

### /clear

**구문:** `/clear`

**별칭:** `/reset`, `/new`

전체 대화 기록을 삭제하고 컨텍스트를 해제하여 같은 작업 디렉토리에서 새 세션을 시작합니다.

**예시:**
```
/clear
```

---

### /skills

**구문:** `/skills`

현재 세션에서 사용 가능한 모든 스킬을 나열합니다. 스킬은 `.claude/skills/`에 정의된 온디맨드 기능으로 `/<skill-name>`으로 호출할 수 있습니다.

**예시:**
```
/skills
```

---

## 깃 명령어

### /commit

**구문:** `/commit`

AI가 생성한 커밋 메시지로 깃 커밋을 생성합니다. Claude는 현재 깃 상태와 diff를 읽고 staged 및 unstaged 변경 사항을 분석하여 "무엇"보다 "왜"에 초점을 맞춘 간결한 커밋 메시지를 작성합니다.

**안전 규칙:**

- 기존 커밋을 절대 수정하지 않음 (항상 새 커밋 생성)
- 훅을 건너뛰지 않음 (`--no-verify` 미사용)
- 비밀 가능성이 있는 파일을 커밋하지 않음 (`.env`, 자격증명 파일)
- 변경 사항이 없을 때 빈 커밋 생성 않음

**예시:**
```
/commit
```

> `/commit` only has access to `git add`, `git status`, and `git commit`

---

### /review

**구문:** `/review [PR-number]`

GitHub CLI (`gh`)를 사용하여 풀 리퀘스트에 대한 AI 코드 리뷰를 실행합니다.

**검토 포함 사항:**

- PR이 수행하는 작업의 개요
- 코드 품질 및 스타일 분석
- 구체적인 개선 제안
- 잠재적 문제 또는 위험
- 성능, 테스트 커버리지, 보안 고려 사항

**예시:**
```
/review
/review 142
```

> `/review` requires the GitHub CLI (`gh`) to be installed and authenticated

---

## 계정 및 도움말 명령어

### /help

**구문:** `/help`

도움말을 표시하고 현재 세션에서 사용 가능한 모든 슬래시 명령어를 나열합니다(내장 명령어, 스킬 명령어, 설치된 플러그인이 추가한 명령어 포함).

**예시:**
```
/help
```

---

### /login

**구문:** `/login`

Anthropic 계정에 로그인하거나 계정 간 전환합니다. 아직 인증되지 않은 경우 브라우저 기반 OAuth 흐름을 열거나, 이미 인증된 경우 계정 전환기를 제시합니다.

**예시:**
```
/login
```

---

### /logout

**구문:** `/logout`

Anthropic 계정에서 로그아웃합니다. 로그아웃 후 다음 세션에서 Claude Code는 다시 인증하라는 메시지를 표시합니다.

**예시:**
```
/logout
```

---

## 사용자 정의 스킬 명령어

`.claude/skills/<skill-name>/SKILL.md`에서 스킬을 생성하면 해당 스킬이 로드된 세션에서 `/<skill-name>`으로 사용 가능해집니다.

**예시:**
```
/verify
/deploy staging
/fix-issue 123
```

`/skills`를 실행하여 로드된 모든 스킬과 해당 설명을 확인할 수 있습니다.
