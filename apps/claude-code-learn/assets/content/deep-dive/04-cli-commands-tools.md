# Deep Dive #4: Claude Code CLI 명령어 & 내장 도구 완전 분석

> **작성일**: 2026-03-31
> **범위**: 설치/인증, CLI 플래그, 슬래시 명령어, 내장 도구(Bash, File Ops, Search, Web), 키보드 단축키, 실무 자동화
> **소스**: Claude Code 공식 문서 (introduction, installation, quickstart, commands, tools, authentication)

---

## TL;DR

- **설치**: `npm install -g @anthropic-ai/claude-code` (Node.js 18+). macOS/Linux/Windows(WSL) 지원.
- **인증**: OAuth(기본) > API 키 > AWS Bedrock > GCP Vertex AI. 우선순위 6단계 체인 존재.
- **CLI 플래그**: 7개 카테고리, 30+ 플래그. `-p`(비대화형), `--model`, `--permission-mode`, `--output-format`이 핵심.
- **슬래시 명령어**: 16개. `/init`, `/commit`, `/compact`, `/model`을 가장 자주 사용.
- **내장 도구 5종**: Bash(셸 실행), Read/Edit/Write(파일), Glob(파일 검색), Grep(내용 검색), WebFetch/WebSearch(웹).
- **자동화 핵심**: `-p` + `--output-format json` + `--dangerously-skip-permissions`로 CI/CD 파이프라인 통합.
- **생산성 팁**: `--bare`로 시작 지연 제거, `--max-budget-usd`로 비용 관리, `--effort`로 응답 깊이 조절.

---

## 목차

1. [설치와 환경 구성](#1-설치와-환경-구성)
2. [인증 체계 완전 정리](#2-인증-체계-완전-정리)
3. [CLI 플래그 전체 레퍼런스](#3-cli-플래그-전체-레퍼런스)
4. [슬래시 명령어 16개 상세](#4-슬래시-명령어-16개-상세)
5. [내장 도구 완전 분석](#5-내장-도구-완전-분석)
6. [키보드 단축키](#6-키보드-단축키)
7. [대화형 vs 비대화형 모드](#7-대화형-vs-비대화형-모드)
8. [실무 팁: 자동화와 생산성 극대화](#8-실무-팁-자동화와-생산성-극대화)

---

## 1. 설치와 환경 구성

### 1.1 시스템 요구사항

| 항목 | 요구사항 |
|------|---------|
| **Node.js** | 18 이상 (시작 시 버전 검증, 미만이면 오류 종료) |
| **npm** | Node.js와 함께 포함 |
| **OS** | macOS, Linux, Windows (WSL 경유) |

```bash
# 버전 확인
node --version   # v18.0.0 이상
npm --version
```

### 1.2 플랫폼별 설치

#### macOS

```bash
# 기본 설치
npm install -g @anthropic-ai/claude-code

# 권한 오류 시 -- 방법 A: npm 접두사 수정 (권장)
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
# ~/.zshrc 또는 ~/.bash_profile에 추가:
export PATH=~/.npm-global/bin:$PATH
source ~/.zshrc
npm install -g @anthropic-ai/claude-code

# 방법 B: nvm 사용
nvm install --lts && nvm use --lts
npm install -g @anthropic-ai/claude-code
```

#### Linux

```bash
# 권장: nvm으로 Node.js 관리
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
nvm install --lts && nvm use --lts
npm install -g @anthropic-ai/claude-code

# 대안: npm 전역 접두사 수정
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
npm install -g @anthropic-ai/claude-code
```

> **주의**: `sudo npm install -g`는 절대 사용하지 말 것.

#### Windows (WSL)

```powershell
# 1단계: 관리자 PowerShell에서 WSL 설치
wsl --install
```

```bash
# 2단계: WSL 터미널(Ubuntu)에서 실행
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install --lts && nvm use --lts

# 3단계: Claude Code 설치
npm install -g @anthropic-ai/claude-code
```

> **핵심**: 항상 WSL 터미널 내에서 `claude`를 실행하고, 프로젝트 파일은 WSL 파일시스템(`/home/user/...`)에 위치해야 최적 성능.

### 1.3 업데이트/제거

```bash
# 업데이트
npm update -g @anthropic-ai/claude-code
# 또는
claude update

# 버전 확인
claude --version

# 제거
npm uninstall -g @anthropic-ai/claude-code
rm -rf ~/.claude    # 설정 파일 삭제
```

### 1.4 설치 문제 해결

| 문제 | 원인 | 해결 |
|------|------|------|
| `claude` 명령어를 찾을 수 없음 | npm 전역 bin이 PATH에 없음 | `npm config get prefix` 확인 후 PATH에 추가 |
| Node.js 버전 미달 | 18 미만 | `nvm install --lts && nvm use --lts` |
| 권한 거부 | root 권한으로 설치 시도 | npm 접두사 수정 또는 nvm 사용 |
| 인증 실패 | OAuth 브라우저 흐름 실패 | `export ANTHROPIC_API_KEY=sk-ant-...` |
| CI/Docker 실행 | 비대화형 환경 | API 키 + `-p` + `--dangerously-skip-permissions` |

---

## 2. 인증 체계 완전 정리

### 2.1 인증 방식 4가지

#### (1) Claude.ai OAuth (기본값)

첫 실행 시 API 키가 없으면 자동으로 OAuth 흐름 시작.

```bash
claude    # 브라우저가 열리고 claude.ai 로그인 후 승인
```

- 토큰은 macOS Keychain 또는 자격증명 파일에 저장
- **자동 갱신**: 만료 전 갱신 토큰으로 자동 교체, 명시적 재인증 불필요
- 여러 인스턴스가 동시 실행 시 잠금 파일로 중복 갱신 방지
- 갱신 실패 시 `/login` 실행 안내

#### (2) API 키 인증

```bash
# 환경 변수 방식
export ANTHROPIC_API_KEY=sk-ant-...
claude

# 설정 파일 방식 (~/.claude/settings.json)
{
  "apiKeyHelper": "cat ~/.anthropic/api-key"
}
```

- `apiKeyHelper`: stdout으로 키만 출력하는 명령어 (종료 코드 0 필수)
- 캐시 기본 5분 (TTL 환경변수로 조정)
- **주의**: apiKeyHelper 사용 시 OAuth 비활성화됨

#### (3) AWS Bedrock

```bash
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1           # 선택

# 자격증명: ~/.aws/credentials, 환경변수, IAM 역할, AWS SSO 중 택일
```

자동 갱신 설정:
```json
{
  "awsAuthRefresh": "aws sso login --profile my-profile"
}
```

역할 전환:
```json
{
  "awsCredentialExport": "aws sts assume-role --role-arn arn:aws:iam::123456789012:role/MyRole --role-session-name claude-code --query Credentials --output json"
}
```

#### (4) GCP Vertex AI

```bash
export CLAUDE_CODE_USE_VERTEX=1
export ANTHROPIC_VERTEX_PROJECT_ID=my-gcp-project   # 선택
export CLOUD_ML_REGION=us-central1                    # 선택

# ADC 설정
gcloud auth application-default login
```

자동 갱신:
```json
{
  "gcpAuthRefresh": "gcloud auth application-default login"
}
```

### 2.2 인증 우선순위 (높은 순)

| 순위 | 소스 | 용도 |
|:----:|------|------|
| 1 | `ANTHROPIC_AUTH_TOKEN` 환경변수 | 최우선 오버라이드 |
| 2 | `CLAUDE_CODE_OAUTH_TOKEN` 환경변수 | CI/자동화 전용 |
| 3 | OAuth 토큰 (파일 디스크립터) | 내부 메커니즘 |
| 4 | `apiKeyHelper` 설정 | 키 관리 도구 연동 |
| 5 | 저장된 claude.ai OAuth 토큰 | 일반 대화형 사용 |
| 6 | `ANTHROPIC_API_KEY` 환경변수 | 가장 간단한 방식 |

> **CI/자동화 환경 권장**: API 키 또는 `CLAUDE_CODE_OAUTH_TOKEN` 사용.

### 2.3 계정 전환

```
/login    # 새 OAuth 흐름 시작, 기존 토큰 교체
/logout   # 저장된 자격증명 제거, 다음 실행 시 재인증
```

---

## 3. CLI 플래그 전체 레퍼런스

기본 구조: `claude [flags] [prompt]`

### 3.1 핵심 플래그 (Core)

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--print` | `-p` | 비대화형 실행: 프롬프트 처리 후 응답 출력하고 종료 | `claude -p "explain main"` |
| `--output-format <fmt>` | - | 출력 형식: `text`(기본), `json`, `stream-json` | `claude -p "list types" --output-format json` |
| `--input-format <fmt>` | - | stdin 입력 형식: `text`(기본), `stream-json` | `cat msgs.jsonl \| claude -p --input-format stream-json --output-format stream-json` |
| `--verbose` | - | 상세 출력 활성화 | `claude --verbose` |
| `--version` | `-v` | 버전 출력 후 종료 | `claude -v` |
| `--help` | `-h` | 도움말 표시 | `claude --help` |

### 3.2 세션 지속 플래그 (Session Continuation)

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--continue` | `-c` | 가장 최근 대화 재개 | `claude -c "now add tests"` |
| `--resume [id]` | `-r` | 세션 ID로 대화 재개 (없으면 선택기) | `claude -r "auth refactor"` |
| `--fork-session` | - | 기존 대화를 분기하여 새 세션 생성 | `claude -r <id> --fork-session` |
| `--name <name>` | `-n` | 세션에 표시 이름 부여 | `claude -n "auth-refactor"` |
| `--session-id <uuid>` | - | 특정 UUID를 세션 ID로 사용 | `claude --session-id 550e8400-...` |
| `--no-session-persistence` | - | 세션 저장 안 함 (일회성 작업) | `claude -p "one-off task" --no-session-persistence` |

### 3.3 모델 및 성능 플래그 (Model & Capability)

| 플래그 | 설명 | 값 | 예시 |
|--------|------|-----|------|
| `--model <model>` | 모델 선택 | `sonnet`, `opus`, `haiku`, `claude-sonnet-4-6` 등 | `claude --model opus` |
| `--effort <level>` | 계산 강도 제어 | `low`, `medium`(기본), `high`, `max` | `claude --effort high "review this"` |
| `--fallback-model <model>` | 주 모델 과부하 시 대체 모델 (`-p` 전용) | 모델 별칭 또는 ID | `claude -p "analyze" --model opus --fallback-model sonnet` |

### 3.4 권한 및 안전 플래그 (Permission & Safety)

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--permission-mode <mode>` | 권한 모드 설정 | `claude --permission-mode acceptEdits` |
| `--dangerously-skip-permissions` | 모든 권한 확인 우회 (격리 환경 전용) | `claude --dangerously-skip-permissions -p "run tests"` |
| `--allow-dangerously-skip-permissions` | 세션 중 권한 우회 옵션 활성화 | `claude --allow-dangerously-skip-permissions -p "..."` |
| `--allowed-tools <tools>` | 허용 도구 목록 (글로브 패턴 지원) | `claude --allowed-tools "Bash(git:*) Edit Read"` |
| `--disallowed-tools <tools>` | 차단 도구 목록 | `claude --disallowed-tools "Bash(rm:*)"` |
| `--tools <tools>` | 정확한 도구 집합 지정 | `claude --tools "Bash Read"` |

**권한 모드 상세:**

| 모드 | 파일 편집 | 셸 명령 | 적합한 상황 |
|------|:---------:|:-------:|-------------|
| `default` | 승인 필요 | 승인 필요 | 일반 대화형 사용 |
| `acceptEdits` | **자동 적용** | 승인 필요 | 신뢰하는 프로젝트에서 빠른 편집 |
| `plan` | 계획 후 승인 | 계획 후 승인 | 대규모 리팩토링 전 검토 |
| `bypassPermissions` | **자동 실행** | **자동 실행** | Docker/CI 샌드박스 전용 |

> **`--dangerously-skip-permissions` 제약**: 루트/sudo 실행 거부, Docker/bubblewrap 컨테이너 외부 거부, 인터넷 액세스 없는 샌드박스 권장.

### 3.5 컨텍스트 및 프롬프트 플래그 (Context & Prompt)

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--add-dir <dirs>` | 추가 디렉토리 컨텍스트 등록 | `claude --add-dir /shared/libs --add-dir /shared/config` |
| `--system-prompt <text>` | 시스템 프롬프트 교체 | `claude --system-prompt "You are a security auditor."` |
| `--append-system-prompt <text>` | 기본 시스템 프롬프트에 추가 | `claude --append-system-prompt "Always output TypeScript."` |
| `--mcp-config <configs>` | MCP 서버 설정 파일/JSON 로드 | `claude --mcp-config ./mcp-servers.json` |
| `--strict-mcp-config` | 지정된 MCP 설정만 사용 | `claude --mcp-config ./ci-mcp.json --strict-mcp-config` |
| `--settings <file-or-json>` | 추가 설정 로드 | `claude --settings ./team-settings.json` |
| `--setting-sources <src>` | 로드할 설정 소스 제어 (`user`, `project`, `local`) | `claude --setting-sources user,project` |
| `--agents <json>` | 사용자 정의 에이전트 정의 | 아래 예시 참조 |

```bash
# 사용자 정의 에이전트
claude --agents '{"reviewer":{"description":"Security reviewer","prompt":"You are a security-focused code reviewer."}}'
```

### 3.6 출력 제어 플래그 (Output Control)

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--include-hook-events` | 훅 이벤트를 stream-json에 포함 | `claude -p "task" --output-format stream-json --include-hook-events` |
| `--max-turns <n>` | 에이전트 턴 수 제한 (`-p` 전용) | `claude -p "refactor" --max-turns 10` |
| `--max-budget-usd <amt>` | API 호출 최대 예산 (`-p` 전용) | `claude -p "analysis" --max-budget-usd 2.50` |
| `--json-schema <schema>` | 구조화된 출력 검증용 JSON Schema | 아래 예시 참조 |

```bash
# 구조화된 출력 예시
claude -p "extract function names" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"functions":{"type":"array","items":{"type":"string"}}},"required":["functions"]}'
```

### 3.7 워크트리/디버그/기타 플래그

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--worktree [name]` | `-w` | git 워크트리 생성 (PR 번호/URL 지원) | `claude -w feature-auth` |
| `--tmux` | - | 워크트리와 함께 tmux 세션 생성 | `claude -w feature-auth --tmux` |
| `--debug [filter]` | `-d` | 디버그 모드 (범주 필터링 가능) | `claude -d "api,hooks"` |
| `--debug-file <path>` | - | 디버그 로그를 파일로 출력 | `claude --debug-file /tmp/debug.log` |
| `--bare` | - | 최소 모드 (훅, LSP, CLAUDE.md 등 건너뜀) | `claude --bare -p "analyze"` |

> **`--bare` 모드**: 훅, LSP, 플러그인 동기화, CLAUDE.md 자동 발견 등을 모두 건너뛰어 시작 시간을 최소화. 인증은 `ANTHROPIC_API_KEY` 또는 `apiKeyHelper`만 사용.

---

## 4. 슬래시 명령어 16개 상세

### 4.1 빠른 참조표

| 명령어 | 카테고리 | 인자 | 설명 |
|--------|---------|------|------|
| `/init` | 프로젝트 | 없음 | CLAUDE.md, 스킬, 훅 생성/갱신 |
| `/memory` | 프로젝트 | 없음 | 메모리 파일 편집 (글로벌/프로젝트/로컬) |
| `/config` | 설정 | 없음 | 설정 패널 열기 |
| `/hooks` | 설정 | 없음 | 훅 설정 확인 |
| `/mcp` | 설정 | `[enable\|disable [server]]` | MCP 서버 관리 |
| `/permissions` | 설정 | 없음 | 도구 허용/거부 규칙 관리 |
| `/model` | 설정 | `[model]` | AI 모델 전환 |
| `/plan` | 세션 | `[open\|description]` | 계획 모드 관리 |
| `/compact` | 세션 | `[instructions]` | 대화 기록 요약/압축 |
| `/clear` | 세션 | 없음 | 대화 기록 삭제, 컨텍스트 해제 |
| `/skills` | 세션 | 없음 | 사용 가능한 스킬 목록 |
| `/commit` | Git | 없음 | AI 커밋 메시지로 git 커밋 |
| `/review` | Git | `[PR-number]` | PR 코드 리뷰 |
| `/help` | 도움말 | 없음 | 도움말 및 명령어 목록 |
| `/login` | 계정 | 없음 | 로그인/계정 전환 |
| `/logout` | 계정 | 없음 | 로그아웃 |

### 4.2 프로젝트 및 메모리 명령어

#### `/init` -- 프로젝트 초기화

코드베이스를 분석하고 다음을 설정한다:

- **CLAUDE.md**: 팀 공유 지침 (빌드/테스트/린트 명령, 코딩 규칙, 아키텍처)
- **CLAUDE.local.md**: 개인 설정 (gitignore됨)
- **스킬**: `.claude/skills/<name>/SKILL.md`에 정의된 워크플로우
- **훅**: `.claude/settings.json`의 도구 이벤트 자동 실행 셸 명령어

```
/init
```

> 이미 CLAUDE.md가 있으면 재실행 시 변경사항을 제안한다.

#### `/memory` -- 메모리 파일 편집

| 범위 | 파일 | 적용 대상 |
|------|------|----------|
| 글로벌 | `~/.claude/CLAUDE.md` | 모든 프로젝트의 개인 설정 |
| 프로젝트 | 프로젝트 루트 `CLAUDE.md` | 팀 전체 |
| 로컬 | 프로젝트 루트 `CLAUDE.local.md` | 이 프로젝트만 (gitignore) |

```
/memory
```

### 4.3 설정 명령어

#### `/config` (별칭: `/settings`)

모델 선호도, 테마, 상세 모드 등 전체 설정을 편집하는 패널을 연다.

#### `/hooks`

현재 세션의 활성 훅 설정을 표시한다. 훅 생성/편집은 `/init` 또는 `.claude/settings.json` 직접 편집으로 수행.

#### `/mcp` -- MCP 서버 관리

```
/mcp                           # 관리 패널 열기
/mcp enable                    # 모든 MCP 서버 활성화
/mcp enable my-database-server # 특정 서버 활성화
/mcp disable analytics-server  # 특정 서버 비활성화
/mcp reconnect filesystem      # 서버 재연결
```

> 변경사항은 현재 세션에만 적용.

#### `/permissions` (별칭: `/allowed-tools`)

도구별 허용/거부 규칙을 관리하는 패널:

```
Bash(git:*)         # 모든 git 명령어 허용
Bash(npm:*)         # 모든 npm 명령어 허용
Edit(src/**/*.ts)   # src/ TypeScript 파일 편집 허용
```

#### `/model` -- 모델 전환

```
/model              # 대화형 모델 선택기
/model sonnet       # 최신 Sonnet으로 전환
/model opus         # 최신 Opus로 전환
/model haiku        # 최신 Haiku로 전환
/model claude-opus-4-5  # 전체 ID로 지정
```

### 4.4 세션 관리 명령어

#### `/plan` -- 계획 모드

```
/plan                                      # 계획 모드 토글
/plan open                                 # 현재 계획 표시
/plan refactor the auth module to use JWT  # 설명으로 새 계획 생성
```

> `--permission-mode plan`과 동일한 효과.

#### `/compact` -- 컨텍스트 압축

컨텍스트 윈도우가 채워질 때 대화 기록을 요약하여 세션을 유지한다.

```
/compact                                         # 기본 압축
/compact focus only on the database schema changes  # 포커스 지정
/compact summarize the last three completed tasks   # 요약 지시
```

#### `/clear` (별칭: `/reset`, `/new`)

전체 대화 기록을 삭제하고 같은 작업 디렉토리에서 새 세션을 시작한다.

#### `/skills`

현재 세션에서 사용 가능한 모든 스킬 목록을 표시. `.claude/skills/`에 정의된 스킬은 `/<skill-name>`으로 호출 가능.

### 4.5 Git 명령어

#### `/commit` -- AI 커밋

Claude가 git status와 diff를 분석하여 "왜"에 초점을 맞춘 커밋 메시지를 생성.

**안전 규칙:**
- 기존 커밋 수정 안 함 (항상 새 커밋)
- 훅 건너뛰기 안 함 (`--no-verify` 미사용)
- 비밀 파일(`.env`, 자격증명) 커밋 안 함
- 변경사항 없으면 빈 커밋 생성 안 함

> `/commit`은 `git add`, `git status`, `git commit`에만 접근 가능.

#### `/review` -- PR 리뷰

```
/review        # 현재 브랜치의 PR 리뷰
/review 142    # PR #142 리뷰
```

검토 내용: PR 개요, 코드 품질/스타일, 개선 제안, 잠재적 위험, 성능/테스트/보안 고려사항.

> `gh` CLI 설치 및 인증 필요.

### 4.6 계정 및 도움말

```
/help     # 도움말 및 모든 명령어 목록 (내장 + 스킬 + 플러그인)
/login    # 로그인 또는 계정 전환 (OAuth 흐름)
/logout   # 로그아웃 (다음 실행 시 재인증)
```

### 4.7 사용자 정의 스킬 명령어

`.claude/skills/<skill-name>/SKILL.md`에 스킬을 생성하면 `/<skill-name>`으로 호출 가능:

```
/verify
/deploy staging
/fix-issue 123
```

---

## 5. 내장 도구 완전 분석

Claude Code는 5종의 내장 도구를 제공하며, 각각 특화된 역할이 있다.

### 5.1 Bash 도구

**목적**: 지속적인 셸 세션에서 명령어를 실행한다.

#### 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `command` | string | O | 셸 명령어 (파이프, 리다이렉션, `&&`, `\|\|`, `;` 포함 가능) |
| `timeout` | number | - | 실행 제한 시간(ms). 기본: 120,000 (2분), 최대: 600,000 (10분) |
| `description` | string | - | 명령어 동작 설명 |
| `run_in_background` | boolean | - | 백그라운드 실행 (`&` 불필요) |

#### 세션 동작

| 지속됨 | 초기화됨 |
|--------|---------|
| 작업 디렉토리 | 셸 변수, 별칭, 함수 |

> 각 호출은 사용자 셸 프로필(bash/zsh)에서 초기화. **절대경로 사용 권장**.

#### 권한 모델

| 결과 | 조건 |
|------|------|
| **Allow** | 허용 규칙 일치 또는 읽기 전용 명령어 (`ls`, `cat`, `git log`, `grep`) |
| **Ask** | 사용자 승인 필요 |
| **Deny** | 거부 규칙 일치로 차단 |

#### 보안 제한 -- 명시적 승인 필요 패턴

- 명령어 치환: `` `...` ``, `$()`, `${}`
- 프로세스 치환: `<()`, `>()`
- 의심스러운 리다이렉션
- Zsh 구성요소: `zmodload`, `emulate` 등
- ANSI-C 인용법 (`$'...'`), IFS 조작
- `/proc/*/environ` 접근

#### 도구 선호도

Bash 대신 전용 도구를 우선 사용해야 하는 경우:

| 작업 | 전용 도구 | Bash 사용 X |
|------|----------|------------|
| 파일 검색 | Glob | `find` |
| 내용 검색 | Grep | `grep`, `rg` |
| 파일 읽기 | Read | `cat`, `head`, `tail` |
| 파일 편집 | Edit | `sed`, `awk` |
| 파일 쓰기 | Write | `echo >`, `cat <<EOF` |

> Bash는 전용 도구가 없는 빌드, 테스트, 셸 작업에 사용.

### 5.2 파일 작업 도구 (Read, Edit, Write)

#### Read -- 파일 읽기

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `file_path` | string | O | **절대 경로** |
| `offset` | number | - | 읽기 시작 줄 번호 |
| `limit` | number | - | 최대 줄 수 (기본 2,000) |

**출력 형식** (`cat -n` 스타일):
```
   1  import { z } from 'zod'
   2
   3  export const schema = z.object({
   4    name: z.string(),
   5  })
```

**지원 파일 유형:**

| 유형 | 동작 |
|------|------|
| 텍스트 | 줄 번호 + 원본 텍스트 |
| 이미지 (PNG, JPG) | 시각적 표시 (멀티모달) |
| PDF | `pages` 파라미터 사용. 10페이지 초과 시 필수 (예: `"1-5"`). 최대 20페이지/요청 |
| Jupyter (.ipynb) | 모든 셀 + 출력 + 시각화 |

> Read는 디렉토리 나열 불가. 디렉토리 탐색은 `Bash: ls` 사용.

#### Edit -- 파일 편집

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `file_path` | string | O | **절대 경로** |
| `old_string` | string | O | 찾을 정확한 문자열 (공백/들여쓰기 포함) |
| `new_string` | string | O | 대체 문자열 (빈 문자열 = 삭제) |
| `replace_all` | boolean | - | 모든 출현 부분 교체 (기본 false) |

**핵심 특성:**
- 정규식 해석 없음 -- 순수 문자열 비교
- `old_string`이 파일에서 고유하지 않으면 실패 (더 많은 컨텍스트를 포함하거나 `replace_all: true` 사용)
- **필수 전제**: Edit 전에 반드시 해당 파일을 Read로 읽어야 함

#### Write -- 파일 작성

| 파라미터 | 타입 | 필수 | 설명 |
|---------|------|:----:|------|
| `file_path` | string | O | **절대 경로** |
| `content` | string | O | 작성할 완전한 내용 |

**사용 기준:**

| 상황 | 사용 도구 |
|------|----------|
| 기존 파일의 일부 수정 | Edit |
| 변수/기호 이름 변경 | Edit (`replace_all`) |
| 새 파일 처음부터 생성 | Write |
| 파일 완전 재작성 | Write |

> 기존 파일 덮어쓰기 시 먼저 Read 호출 필수.

### 5.3 검색 도구 (Glob, Grep)

#### Glob -- 파일 이름 패턴 검색

| 파라미터 | 필수 | 설명 |
|---------|:----:|------|
| `pattern` | O | 글로브 패턴 (`*`, `**`, `?` 와일드카드 지원) |
| `path` | - | 검색 디렉토리 (기본: cwd) |

**출력**: 수정 시간 기준 정렬, 최대 100개 결과.

**패턴 예시:**

| 패턴 | 매칭 대상 |
|------|----------|
| `**/*.ts` | 전체 트리의 모든 TypeScript 파일 |
| `src/**/*.tsx` | src/ 하위의 TSX 파일 |
| `*.json` | 현재 디렉토리의 JSON 파일 |
| `**/{package,tsconfig}.json` | 모든 깊이의 package.json, tsconfig.json |
| `tools/*/prompt.ts` | tools/ 한 단계 하위의 prompt.ts |

#### Grep -- 파일 내용 정규식 검색 (ripgrep 기반)

| 파라미터 | 필수 | 설명 |
|---------|:----:|------|
| `pattern` | O | 정규표현식 패턴 |
| `path` | - | 검색 대상 파일/디렉토리 |
| `glob` | - | 파일 필터링 글로브 (예: `"*.js"`) |
| `type` | - | ripgrep 파일 타입 (`js`, `py`, `rust`, `go`, `java` 등) |
| `output_mode` | - | `files_with_matches`(기본), `content`, `count` |
| `-i` | - | 대소문자 무시 |
| `-n` | - | 줄 번호 표시 (기본 true) |
| `-A` / `-B` | - | 매칭 후/전 컨텍스트 줄 수 |
| `context` | - | 전후 컨텍스트 줄 수 |
| `multiline` | - | 개행 포함 매칭 |
| `head_limit` | - | 출력 제한 (기본 250) |
| `offset` | - | 페이지네이션용 스킵 수 |

**출력 모드:**

| 모드 | 반환 내용 |
|------|----------|
| `files_with_matches` | 매칭 파일 경로만 |
| `content` | 매칭 줄 + 선택적 컨텍스트 |
| `count` | 파일별 매칭 횟수 |

**자동 제외**: `.git`, `.svn`, `.hg`, `.bzr`, `.jj`, `.sl` 디렉토리.

### 5.4 웹 도구 (WebFetch, WebSearch)

#### WebFetch -- URL 페칭 및 분석

| 파라미터 | 필수 | 설명 |
|---------|:----:|------|
| `url` | O | 완전한 URL (HTTP는 HTTPS로 자동 업그레이드) |
| `prompt` | O | 페이지에서 추출할 내용을 설명하는 자연어 |

**작동 방식:**
1. URL 페칭 + HTML --> 마크다운 변환
2. 마크다운과 프롬프트를 보조 모델에 전송
3. 합성된 응답 반환

**특징:**
- 15분 메모리 내 캐시 (반복 호출 시 네트워크 요청 방지)
- 다른 호스트로의 리디렉션은 추종하지 않고 메시지 반환
- 읽기 전용 (폼 제출 불가, 인증 필요 페이지 미지원)
- GitHub 리소스는 `gh` CLI 우선

```bash
# 사용 시나리오
"https://docs.example.com/api/auth" -> "어떤 인증 방식이 지원되는가?"
"https://github.com/org/lib/blob/main/CHANGELOG.md" -> "최신 버전 변경사항은?"
```

#### WebSearch -- 웹 검색

| 파라미터 | 필수 | 설명 |
|---------|:----:|------|
| `query` | O | 검색 쿼리 (최소 2자) |
| `allowed_domains` | - | 특정 도메인만 결과 포함 |
| `blocked_domains` | - | 특정 도메인 제외 |

> `allowed_domains`와 `blocked_domains`는 동시 사용 불가.

**특징:**
- 호출당 최대 8회 개별 웹 검색 수행
- Claude가 자동으로 쿼리 정제
- 최신 정보 검색 시 현재 연도 자동 포함
- 출력에 `Sources:` 섹션으로 출처 명시
- **가용성**: 미국 내에서만 지원 (Anthropic, Vertex AI, Foundry API)

```bash
# 도메인 필터링 예시
{"query": "Python asyncio 모범 사례", "allowed_domains": ["docs.python.org", "realpython.com"]}
{"query": "React 서버 컴포넌트", "blocked_domains": ["medium.com"]}
```

---

## 6. 키보드 단축키

| 단축키 | 기능 | 비고 |
|--------|------|------|
| `Ctrl+C` | 현재 응답 중단 | 대화는 유지됨 |
| `Ctrl+D` | Claude Code 종료 | 세션 종료 |
| `Ctrl+L` | 터미널 화면 초기화 | 대화 컨텍스트는 유지 |
| `Up` / `Down` | 입력 기록 탐색 | 이전 프롬프트 재사용 |
| `Tab` | 슬래시 명령어 자동완성 | `/co` --> `/commit` 등 |
| `Escape` | 진행 중인 권한 프롬프트 취소 | 승인/거부 대화상자에서 |

---

## 7. 대화형 vs 비대화형 모드

### 7.1 대화형 모드 (Interactive / REPL)

```bash
claude                    # 기본 시작
claude --model opus       # 모델 지정 시작
claude --permission-mode acceptEdits  # 편집 자동 승인 모드
```

**특징:**
- REPL 세션 유지 (지속적 대화)
- 변경사항 승인/거절 가능
- 슬래시 명령어 사용 가능
- 세션 자동 저장 (`--resume`으로 재개)
- CLAUDE.md 자동 로드

**적합한 상황:** 코드 탐색, 리팩토링, 디버깅, 학습

### 7.2 비대화형 모드 (Non-interactive / Print Mode)

```bash
claude -p "explain this codebase"
claude -p "list all TODO comments" --output-format json
echo "analyze this" | claude -p
```

**특징:**
- 프롬프트 처리 후 응답 출력하고 즉시 종료
- REPL 미시작
- 워크스페이스 신뢰 대화 건너뜀
- `--output-format`으로 json/stream-json 출력 지원
- 파이프라인 입출력 가능

**호환 옵션:** `--output-format`, `--model`, `--system-prompt`, `--permission-mode`, `--max-turns`, `--allowed-tools`, `--max-budget-usd`, `--json-schema`, `--no-session-persistence`, `--fallback-model`

**적합한 상황:** CI/CD, 스크립트, 자동화, 일회성 질의

### 7.3 세션 재개 패턴

```bash
# 마지막 세션 이어서
claude --continue
claude -c "now add tests for that"

# 특정 세션 재개
claude --resume 550e8400-e29b-41d4-a716-446655440000

# 검색으로 세션 찾기
claude --resume "auth refactor"

# 세션 분기 (원본 보존)
claude --resume <session-id> --fork-session

# 비대화형으로 이전 세션 이어서 실행
claude --continue -p "now write the tests for that"
```

---

## 8. 실무 팁: 자동화와 생산성 극대화

### 8.1 CI/CD 파이프라인 통합

#### 기본 패턴: 테스트 실행 및 수정

```bash
export ANTHROPIC_API_KEY=sk-ant-...
claude -p "run the full test suite and fix failures" \
  --dangerously-skip-permissions \
  --max-turns 10 \
  --max-budget-usd 2.50
```

#### JSON 출력으로 후처리

```bash
# 함수 목록 추출
RESULT=$(claude -p "list all exported functions in src/" --output-format json)
echo "$RESULT" | jq '.result'

# 구조화된 출력 + 스키마 검증
claude -p "extract API endpoints" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"endpoints":{"type":"array","items":{"type":"object","properties":{"method":{"type":"string"},"path":{"type":"string"}}}}}}'
```

#### GitHub Actions 예시

```yaml
# .github/workflows/claude-review.yml
name: Claude Code Review
on: [pull_request]
jobs:
  review:
    runs-on: ubuntu-latest
    container:
      image: node:20
    steps:
      - uses: actions/checkout@v4
      - run: npm install -g @anthropic-ai/claude-code
      - run: |
          claude -p "review the changes in this PR for bugs and security issues" \
            --dangerously-skip-permissions \
            --output-format json \
            --max-turns 5
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

#### 스트리밍 JSON으로 실시간 처리

```bash
claude -p "refactor this file" --output-format stream-json | while read -r line; do
  event_type=$(echo "$line" | jq -r '.type // empty')
  case "$event_type" in
    "content") echo "진행중..." ;;
    "result")  echo "완료!" ;;
  esac
done
```

### 8.2 자동화 스크립트 패턴

#### 코드 분석 자동화

```bash
#!/bin/bash
# analyze-codebase.sh

# 사용하지 않는 export 검사
claude -p "check for unused exports in src/" \
  --no-session-persistence \
  --output-format text

# TODO 목록 추출
claude -p "list all TODO comments and the files they appear in" \
  --output-format json | jq '.result'

# 보안 감사
claude -p "audit this codebase for security vulnerabilities" \
  --system-prompt "You are a security auditor. Focus only on vulnerabilities." \
  --max-budget-usd 1.00
```

#### 다중 디렉토리 작업

```bash
claude --add-dir /shared/libs --add-dir /shared/config \
  -p "find inconsistencies between the shared config and lib usage"
```

#### 모델 폴백 전략

```bash
# Opus 우선, 과부하 시 Sonnet으로 자동 전환
claude -p "complex architecture review" \
  --model opus \
  --fallback-model sonnet \
  --effort high
```

### 8.3 생산성 극대화 팁

#### CLAUDE.md 활용

```bash
# 프로젝트 초기화 -- 첫 세션에서 반드시 실행
/init

# CLAUDE.md에 기록할 내용:
# - 비표준 빌드 명령어
# - 테스트 실행 특수성
# - 코딩 컨벤션
# - 아키텍처 참고사항
```

#### 컨텍스트 관리

```bash
# 컨텍스트가 커지면 압축
/compact

# 특정 주제에 집중하며 압축
/compact focus only on the database schema changes

# 새로운 작업 시작 시
/clear
```

#### 계획 모드로 대규모 변경 안전하게

```bash
# CLI에서 계획 모드 시작
claude --permission-mode plan "refactor the payment module"

# 세션 중 계획 모드 전환
/plan refactor the auth module to use JWT
/plan open    # 현재 계획 확인
```

#### 비용 및 성능 관리

```bash
# 간단한 질문 -- 저비용/빠른 응답
claude --effort low -p "what does this function do?"

# 복잡한 분석 -- 최대 깊이
claude --effort max -p "review this architecture"

# 비용 제한
claude -p "large analysis task" --max-budget-usd 2.50

# 턴 수 제한
claude -p "refactor this module" --max-turns 10
```

#### 빠른 시작이 필요한 스크립트

```bash
# --bare 모드: 훅, LSP, CLAUDE.md 등 모두 건너뛰어 최소 지연
claude --bare \
  --system-prompt "$(cat context.md)" \
  --add-dir /project/libs \
  --mcp-config ./tools.json \
  -p "perform the analysis"
```

#### 도구 접근 제한으로 안전한 실행

```bash
# git 명령만 허용
claude --allowed-tools "Bash(git:*) Edit Read"

# 삭제 명령 차단
claude --disallowed-tools "Bash(rm:*)"

# 읽기 전용 세션
claude --tools "Read Glob Grep"
```

### 8.4 서브명령어 활용

```bash
claude mcp              # MCP 서버 구성 관리
claude mcp serve        # Claude Code를 MCP 서버로 실행
claude doctor           # 설치/구성 문제 진단
claude update           # 최신 버전으로 업데이트
```

---

## 부록: 주요 플래그 조합 치트시트

| 시나리오 | 명령어 |
|---------|--------|
| 코드 설명 (일회성) | `claude -p "explain this codebase"` |
| JSON 출력 | `claude -p "list types" --output-format json` |
| CI 테스트 자동 수정 | `claude -p "run tests and fix" --dangerously-skip-permissions --max-turns 10` |
| 이전 세션 이어서 | `claude -c "now add tests"` |
| 모델 + 폴백 | `claude -p "analyze" --model opus --fallback-model sonnet` |
| MCP 격리 실행 | `claude --mcp-config ./ci-mcp.json --strict-mcp-config -p "analyze schema"` |
| 시스템 프롬프트 추가 | `claude --append-system-prompt "Always output TypeScript."` |
| 비용 제한 실행 | `claude -p "task" --max-budget-usd 2.50 --max-turns 10` |
| 최소 지연 스크립트 | `claude --bare -p "quick task"` |
| 세션 이름 지정 | `claude -n "auth-refactor"` |
| 구조화된 출력 | `claude -p "extract data" --output-format json --json-schema '{...}'` |
| 워크트리 + tmux | `claude -w feature-auth --tmux` |

---

> **참고**: 이 문서는 Claude Code 공식 문서를 기반으로 작성되었습니다. 최신 변경사항은 `claude --help` 또는 공식 문서를 확인하세요.
