# Chapter 4: CLI와 도구 마스터하기

> **난이도**: 중급 입문 | **예상 학습 시간**: 50분
> **선수 지식**: Claude Code 기본 설치 완료, Chapter 3까지 학습
> **이 챕터를 마치면**: 터미널에서 Claude Code를 자유자재로 다루고, 자동화 파이프라인을 구축할 수 있습니다.

---

## 목차

- [4.1 이 챕터의 큰 그림](#41-이-챕터의-큰-그림)
- [4.2 설치와 첫 실행](#42-설치와-첫-실행)
- [4.3 인증 -- Claude에게 신분증 보여주기](#43-인증----claude에게-신분증-보여주기)
- [4.4 CLI 플래그 마스터하기](#44-cli-플래그-마스터하기)
- [4.5 슬래시 명령어 16개 실전 활용](#45-슬래시-명령어-16개-실전-활용)
- [4.6 내장 도구 5종 완벽 가이드](#46-내장-도구-5종-완벽-가이드)
- [4.7 대화형 vs 비대화형 모드](#47-대화형-vs-비대화형-모드)
- [4.8 키보드 단축키와 생산성 팁](#48-키보드-단축키와-생산성-팁)
- [4.9 실전 자동화 시나리오](#49-실전-자동화-시나리오)
- [4.10 자주 묻는 질문](#410-자주-묻는-질문)
- [4.11 핵심 포인트 정리](#411-핵심-포인트-정리)

---

## 4.1 이 챕터의 큰 그림

Claude Code는 **터미널에서 동작하는 AI 코딩 에이전트**입니다. GUI 없이 터미널만으로 AI와 협업하는 게 낯설 수 있지만, 익숙해지면 어떤 IDE 플러그인보다 빠르고 강력합니다.

```
┌────────────────────────────────────────────────────┐
│                 당신의 터미널                        │
│                                                     │
│  $ claude                                           │
│                                                     │
│  ┌─────────────────────────────────────────────┐   │
│  │            Claude Code REPL                  │   │
│  │                                              │   │
│  │  CLI 플래그 ──── 시작 시 옵션 설정            │   │
│  │  슬래시 명령어 ── 세션 중 기능 호출            │   │
│  │  내장 도구 ───── Claude가 사용하는 도구들      │   │
│  │  키보드 단축키 ── 빠른 조작                    │   │
│  └─────────────────────────────────────────────┘   │
│                                                     │
│  $ claude -p "비대화형 모드"                        │
│  → 결과 출력 후 즉시 종료 (스크립트/CI용)           │
└────────────────────────────────────────────────────┘
```

**이번 챕터의 비유**: Claude Code는 **스위스 아미 나이프**입니다. 기본 칼날(대화 모드)만 써도 되지만, 가위(CLI 플래그), 드라이버(슬래시 명령어), 병따개(내장 도구)까지 알면 할 수 있는 일이 비교할 수 없이 많아집니다.

---

## 4.2 설치와 첫 실행

### 시스템 요구사항

| 항목 | 요구사항 |
|------|---------|
| Node.js | **18 이상** (필수) |
| OS | macOS, Linux, Windows(WSL) |

```bash
# 버전 확인부터
node --version   # v18.0.0 이상이어야 합니다
```

### 설치 명령어

```bash
# macOS / Linux
npm install -g @anthropic-ai/claude-code

# 권한 에러가 나면? (sudo 절대 쓰지 마세요!)
mkdir -p ~/.npm-global
npm config set prefix ~/.npm-global
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc  # 또는 ~/.bashrc
source ~/.zshrc
npm install -g @anthropic-ai/claude-code
```

> 💡 **초보자 팁**: Windows 사용자는 반드시 **WSL(Windows Subsystem for Linux)**을 설치한 후, WSL 터미널 안에서 작업하세요. PowerShell에서 직접 실행하면 문제가 발생합니다.

### 첫 실행

```bash
claude              # 대화형 모드 시작
claude --version    # 버전 확인
claude update       # 최신 버전으로 업데이트
```

### 설치 문제 해결

| 문제 | 원인 | 해결 |
|------|------|------|
| `claude` 명령어 못 찾음 | PATH 설정 안 됨 | `npm config get prefix` 후 PATH에 추가 |
| Node.js 버전 에러 | 18 미만 | `nvm install --lts && nvm use --lts` |
| 권한 거부 | sudo로 설치 시도 | npm 접두사 수정 (위 방법 참고) |

### 한줄 요약

> `npm install -g @anthropic-ai/claude-code` 한 줄이면 설치 끝. Node.js 18 이상만 있으면 됩니다.

---

## 4.3 인증 -- Claude에게 신분증 보여주기

### 인증 방식 4가지

Claude Code를 사용하려면 먼저 "나 정당한 사용자야"라고 증명해야 합니다.

```
카페 비유:

1. 회원카드 (OAuth)     → 카페 앱으로 자동 로그인. 가장 편함
2. 일회용 쿠폰 (API키)  → 코드 하나로 바로 사용. 간단함
3. 법인카드 A (Bedrock) → 회사 AWS 계정으로 결제
4. 법인카드 B (Vertex)  → 회사 GCP 계정으로 결제
```

#### 방법 1: OAuth (가장 추천)

```bash
claude    # 첫 실행 시 브라우저가 열리고 claude.ai 로그인
```

토큰이 자동 저장되고, 만료되면 자동 갱신됩니다. 가장 편한 방법입니다.

#### 방법 2: API 키 (개발/CI에 추천)

```bash
export ANTHROPIC_API_KEY=sk-ant-your-key-here
claude
```

또는 설정 파일로 키를 관리할 수도 있습니다.

```json
// ~/.claude/settings.json
{
  "apiKeyHelper": "cat ~/.anthropic/api-key"
}
```

#### 방법 3: AWS Bedrock

```bash
export CLAUDE_CODE_USE_BEDROCK=1
export AWS_REGION=us-east-1
claude
```

#### 방법 4: GCP Vertex AI

```bash
export CLAUDE_CODE_USE_VERTEX=1
export ANTHROPIC_VERTEX_PROJECT_ID=my-gcp-project
claude
```

### 인증 우선순위 (높은 순)

여러 인증이 동시에 설정되어 있으면, 다음 순서로 사용됩니다.

```
1위  ANTHROPIC_AUTH_TOKEN 환경변수      ← 최우선
2위  CLAUDE_CODE_OAUTH_TOKEN 환경변수   ← CI/자동화용
3위  OAuth 토큰 (내부)
4위  apiKeyHelper 설정
5위  저장된 OAuth 토큰                  ← 일반 대화형
6위  ANTHROPIC_API_KEY 환경변수         ← 가장 간단한 방법
```

> 💡 **초보자 팁**: 처음 시작할 때는 **OAuth (방법 1)**를 추천합니다. 그냥 `claude`를 실행하면 브라우저가 열리고, 로그인하면 끝입니다. API 키는 CI/CD나 스크립트에서 사용할 때 설정하세요.

### 한줄 요약

> OAuth로 시작하면 가장 편합니다. CI/자동화에서는 API 키를, 회사 클라우드에서는 Bedrock/Vertex를 사용하세요.

---

## 4.4 CLI 플래그 마스터하기

### CLI 플래그란?

`claude` 명령어 뒤에 붙이는 옵션들입니다. 자동차의 기어, 에어컨, 와이퍼 같은 것으로, 어떻게 실행할지를 세밀하게 조절합니다.

```bash
claude [플래그들] [프롬프트]

# 예시
claude --model opus --permission-mode acceptEdits "이 코드를 리뷰해줘"
```

### 핵심 플래그 -- 이것만 알면 80% 해결

#### 가장 많이 쓰는 5개 플래그

```bash
# 1. -p (비대화형 모드) -- 스크립트/CI의 핵심
claude -p "이 코드베이스를 설명해줘"

# 2. --model (모델 선택)
claude --model opus          # 가장 강력한 모델
claude --model sonnet        # 균형잡힌 모델 (기본)
claude --model haiku         # 빠르고 경제적

# 3. --permission-mode (권한 모드)
claude --permission-mode plan           # 읽기 전용
claude --permission-mode acceptEdits    # 편집 자동 승인

# 4. -c (이전 세션 이어서)
claude -c "아까 만들던 테스트 이어서 해줘"

# 5. --output-format (출력 형식)
claude -p "함수 목록" --output-format json
```

> 💡 **초보자 팁**: `-p`와 `--model`만 알아도 일상 작업의 대부분을 처리할 수 있습니다. 나머지는 필요할 때 하나씩 익히세요.

### 전체 플래그 카테고리별 정리

#### 카테고리 1: 핵심 (Core)

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--print` | `-p` | 비대화형 실행 | `claude -p "explain main"` |
| `--output-format` | - | 출력 형식 (`text`/`json`/`stream-json`) | `claude -p "list" --output-format json` |
| `--verbose` | - | 상세 출력 | `claude --verbose` |
| `--version` | `-v` | 버전 출력 | `claude -v` |

#### 카테고리 2: 세션 관리

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--continue` | `-c` | 마지막 대화 이어서 | `claude -c "테스트 추가해줘"` |
| `--resume` | `-r` | 특정 세션 재개 | `claude -r "auth refactor"` |
| `--fork-session` | - | 기존 대화 분기 | `claude -r <id> --fork-session` |
| `--name` | `-n` | 세션에 이름 부여 | `claude -n "auth-작업"` |

**세션 재개 흐름:**

```
  세션 A          세션 B (분기)
     │
     ├─ 작업 1
     ├─ 작업 2
     ├─ 작업 3 ──── claude -r <A> --fork-session
     │              │
     ├─ 작업 4      ├─ 대안 시도 1
     │              └─ 대안 시도 2
     └─ 완료
                 원본(A)은 그대로 유지!
```

#### 카테고리 3: 모델과 성능

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--model` | 모델 선택 | `claude --model opus` |
| `--effort` | 응답 깊이 (`low`/`medium`/`high`/`max`) | `claude --effort high "리뷰해줘"` |
| `--fallback-model` | 과부하 시 대체 모델 | `claude -p "분석" --model opus --fallback-model sonnet` |

```
effort 레벨 비유 (커피 주문):

low    = 아메리카노        → 빠르고 가볍게
medium = 카페라떼 (기본)   → 균형잡힌 답변
high   = 핸드드립          → 깊이 있는 분석
max    = 스페셜티 풀코스   → 최대 깊이, 시간 소요
```

#### 카테고리 4: 권한과 안전

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--permission-mode` | 권한 모드 | `claude --permission-mode plan` |
| `--allowed-tools` | 허용 도구 목록 | `claude --allowed-tools "Bash(git:*) Read"` |
| `--disallowed-tools` | 차단 도구 목록 | `claude --disallowed-tools "Bash(rm:*)"` |
| `--dangerously-skip-permissions` | 모든 권한 우회 (CI 전용!) | Docker 컨테이너에서만 사용 |

#### 카테고리 5: 컨텍스트와 프롬프트

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--add-dir` | 추가 디렉토리 등록 | `claude --add-dir /shared/libs` |
| `--system-prompt` | 시스템 프롬프트 교체 | `claude --system-prompt "보안 감사자입니다"` |
| `--append-system-prompt` | 시스템 프롬프트에 추가 | `claude --append-system-prompt "TypeScript로 출력"` |
| `--mcp-config` | MCP 서버 설정 파일 | `claude --mcp-config ./mcp.json` |

#### 카테고리 6: 출력 제어

| 플래그 | 설명 | 예시 |
|--------|------|------|
| `--max-turns` | 에이전트 턴 수 제한 | `claude -p "리팩토링" --max-turns 10` |
| `--max-budget-usd` | API 비용 제한 | `claude -p "분석" --max-budget-usd 2.50` |
| `--json-schema` | 출력 JSON 스키마 검증 | 아래 예시 참고 |

```bash
# 구조화된 출력 예시 -- API 엔드포인트 추출
claude -p "extract API endpoints" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"endpoints":{"type":"array"}}}'
```

#### 카테고리 7: 디버그와 기타

| 플래그 | 짧은 형태 | 설명 | 예시 |
|--------|:---------:|------|------|
| `--worktree` | `-w` | git 워크트리 생성 | `claude -w feature-auth` |
| `--debug` | `-d` | 디버그 모드 | `claude -d "api,hooks"` |
| `--bare` | - | 최소 모드 (빠른 시작) | `claude --bare -p "분석"` |

> 💡 **초보자 팁**: `--bare` 모드는 훅, CLAUDE.md 로딩 등을 모두 건너뛰어 시작 시간을 최소화합니다. 간단한 일회성 질문에 유용합니다.

### 한줄 요약

> CLI 플래그는 Claude Code의 동작을 세밀하게 조절하는 스위치입니다. `-p`, `--model`, `-c` 세 개만 알면 일상의 80%를 해결합니다.

---

## 4.5 슬래시 명령어 16개 실전 활용

### 슬래시 명령어란?

Claude Code 세션 안에서 `/`를 입력하면 나타나는 **내장 명령어**입니다. 자판기의 버튼처럼, 특정 기능을 바로 실행합니다.

```
  ┌─────────────────────────────────────┐
  │        슬래시 명령어 자판기           │
  │                                      │
  │  [/init]     프로젝트 초기화          │
  │  [/commit]   AI 커밋                  │
  │  [/compact]  컨텍스트 압축            │
  │  [/model]    모델 전환                │
  │  [/plan]     계획 모드                │
  │  [/mcp]      MCP 관리                 │
  │  [/hooks]    훅 확인                  │
  │  [/review]   PR 리뷰                 │
  │  ...                                 │
  │                                      │
  │  Tab 키로 자동완성!                   │
  └─────────────────────────────────────┘
```

### 빠른 참조표

| 명령어 | 카테고리 | 한줄 설명 |
|--------|---------|----------|
| `/init` | 프로젝트 | CLAUDE.md, 스킬, 훅 초기 설정 |
| `/memory` | 프로젝트 | 메모리 파일 편집 |
| `/config` | 설정 | 설정 패널 열기 |
| `/hooks` | 설정 | 훅 설정 확인 |
| `/mcp` | 설정 | MCP 서버 관리 |
| `/permissions` | 설정 | 권한 규칙 관리 |
| `/model` | 설정 | AI 모델 전환 |
| `/plan` | 세션 | 계획 모드 관리 |
| `/compact` | 세션 | 대화 기록 압축 |
| `/clear` | 세션 | 대화 초기화 |
| `/skills` | 세션 | 스킬 목록 보기 |
| `/commit` | Git | AI 커밋 메시지 생성 |
| `/review` | Git | PR 코드 리뷰 |
| `/help` | 도움말 | 모든 명령어 보기 |
| `/login` | 계정 | 로그인/계정 전환 |
| `/logout` | 계정 | 로그아웃 |

### 가장 많이 쓰는 명령어 TOP 5 상세 가이드

#### TOP 1: `/init` -- 새 프로젝트의 첫 번째 명령어

프로젝트를 분석하고 필요한 설정 파일들을 자동 생성합니다.

```
/init
```

생성되는 것들:
- **CLAUDE.md** -- 팀 공유 지침 (빌드 명령, 코딩 규칙, 아키텍처)
- **CLAUDE.local.md** -- 개인 설정 (gitignore됨)
- **스킬** -- `.claude/skills/`에 워크플로우 정의
- **훅** -- `.claude/settings.json`에 자동화 규칙

> 💡 **초보자 팁**: 새 프로젝트에서 `claude`를 시작하면 **무조건 `/init`부터** 실행하세요. Claude가 프로젝트를 이해하는 데 큰 도움이 됩니다. 이미 CLAUDE.md가 있어도 재실행하면 개선 사항을 제안합니다.

#### TOP 2: `/commit` -- AI가 쓰는 커밋 메시지

```
/commit
```

Claude가 `git status`와 `git diff`를 분석하고 "무엇"보다 **"왜"**에 초점을 맞춘 커밋 메시지를 작성합니다.

**안전 규칙 (자동 적용):**
- 기존 커밋 수정 안 함 (항상 새 커밋)
- `--no-verify` 사용 안 함 (훅 존중)
- `.env` 같은 비밀 파일 커밋 안 함
- 변경사항 없으면 빈 커밋 생성 안 함

#### TOP 3: `/compact` -- 긴 대화 압축하기

대화가 길어져서 컨텍스트 윈도우가 차면, 새 세션을 시작하지 않고 대화를 요약합니다.

```
/compact                                          # 기본 압축
/compact DB 스키마 변경 부분에만 집중해줘           # 포커스 압축
/compact 마지막 세 개 작업만 요약해줘               # 선택적 요약
```

**언제 사용?**

```
  대화 길이 ██████████████████████████████░░░░ 80% 채워짐

  옵션 1: /clear → 처음부터 다시 (컨텍스트 손실!)
  옵션 2: /compact → 요약 후 계속 (컨텍스트 유지!)  ← 추천
```

#### TOP 4: `/model` -- 상황에 맞는 모델 선택

```
/model              # 대화형 선택기 열기
/model sonnet       # 균형잡힌 모델 (일상용)
/model opus         # 최강 모델 (복잡한 분석)
/model haiku        # 빠른 모델 (간단한 질문)
```

**모델 선택 가이드:**

```
  간단한 질문, 빠른 수정       → haiku   (빠르고 저렴)
  일반 코딩, 리팩토링          → sonnet  (기본, 균형)
  복잡한 아키텍처 분석, 리뷰   → opus    (강력, 비쌈)
```

#### TOP 5: `/plan` -- 큰 작업 전에 계획 세우기

```
/plan                                          # 계획 모드 켜기/끄기
/plan open                                     # 현재 계획 보기
/plan 인증 모듈을 JWT로 리팩토링해줘            # 설명으로 계획 생성
```

계획 모드에서는 Claude가 바로 코드를 수정하지 않고, 먼저 계획을 작성하여 승인을 기다립니다. 대규모 리팩토링 전에 유용합니다.

### 나머지 명령어 빠른 가이드

#### 설정 관련

```bash
/config            # 전체 설정 패널 (테마, 모델 선호도 등)
/hooks             # 현재 훅 설정 확인
/mcp               # MCP 서버 관리 패널
/mcp enable mydb   # 특정 MCP 서버 활성화
/permissions       # 권한 규칙 관리
/memory            # 메모리 파일 편집 (글로벌/프로젝트/로컬)
```

#### 세션 관련

```bash
/clear             # 대화 기록 완전 삭제 (별칭: /reset, /new)
/skills            # 사용 가능한 스킬 목록
```

#### Git 관련

```bash
/review            # 현재 브랜치 PR 리뷰
/review 142        # PR #142 리뷰 (gh CLI 필요)
```

#### 계정 관련

```bash
/login             # 로그인 또는 계정 전환
/logout            # 로그아웃
/help              # 모든 명령어 도움말
```

### 사용자 정의 명령어 (스킬)

Chapter 3에서 배운 스킬을 만들면, 그것도 슬래시 명령어로 사용할 수 있습니다.

```bash
/deploy staging    # 커스텀 스킬 호출
/new-component Button
/database:migrate
```

### 한줄 요약

> 16개의 슬래시 명령어 중 `/init`, `/commit`, `/compact`, `/model`, `/plan` 5개가 핵심입니다. Tab 키로 자동완성됩니다.

---

## 4.6 내장 도구 5종 완벽 가이드

### 내장 도구란?

Claude가 당신의 컴퓨터에서 **직접 실행하는 기능들**입니다. 당신이 "이 파일 읽어봐"라고 하면 Claude가 내부적으로 `Read` 도구를 사용합니다.

```
┌──────────────────────────────────────────────────┐
│                 Claude의 도구상자                  │
│                                                   │
│  ┌─────────┐  ┌──────────────┐  ┌─────────────┐ │
│  │  Bash   │  │ Read/Edit/   │  │ Glob/Grep   │ │
│  │ (셸실행) │  │ Write (파일) │  │ (검색)      │ │
│  └─────────┘  └──────────────┘  └─────────────┘ │
│                                                   │
│  ┌────────────────────────────┐  ┌────────────┐  │
│  │ WebFetch/WebSearch (웹)    │  │ Task (서브  │  │
│  │                            │  │  에이전트)  │  │
│  └────────────────────────────┘  └────────────┘  │
└──────────────────────────────────────────────────┘
```

### 도구 1: Bash -- 셸 명령어 실행

**목적**: 터미널 명령어를 실행합니다. 빌드, 테스트, git 작업 등에 사용합니다.

```
당신: "테스트 실행해줘"
Claude: (내부적으로 Bash 도구 사용)
        → npm test 실행
        → 결과 분석
        → "3개 테스트 중 1개 실패했습니다. auth.test.ts의..."
```

**핵심 특성:**

| 항목 | 설명 |
|------|------|
| 타임아웃 | 기본 2분, 최대 10분 |
| 백그라운드 | `run_in_background: true`로 가능 |
| 작업 디렉토리 | 호출 간에 유지됨 |
| 셸 상태 | 매 호출마다 초기화 (변수, 별칭 사라짐) |

**중요한 규칙 -- Bash 대신 전용 도구 사용:**

```
  ❌ Bash로 하지 마세요          ✅ 전용 도구를 쓰세요

  find . -name "*.ts"    →     Glob("**/*.ts")
  grep -r "TODO" .       →     Grep("TODO")
  cat src/app.ts         →     Read("src/app.ts")
  sed -i 's/old/new/'    →     Edit(old → new)
  echo "내용" > file.ts  →     Write(file.ts, "내용")
```

> 💡 **초보자 팁**: Claude에게 "이 파일 읽어줘"라고 하면 알아서 Read 도구를 사용합니다. 하지만 "cat으로 이 파일 읽어줘"라고 하면 Bash로 실행합니다. 자연스럽게 요청하면 Claude가 최적의 도구를 선택합니다.

### 도구 2: Read -- 파일 읽기

**목적**: 파일 내용을 읽어옵니다. 최대 2,000줄까지 읽을 수 있고, 이미지/PDF/Jupyter 노트북도 지원합니다.

```bash
# Claude 내부 동작
Read(file_path="/Users/me/project/src/app.ts")
Read(file_path="/Users/me/project/data.pdf", pages="1-5")
```

**지원 파일 유형:**

| 유형 | 동작 |
|------|------|
| 텍스트 파일 | 줄 번호 + 내용 표시 |
| 이미지 (PNG, JPG) | 시각적으로 분석 (멀티모달) |
| PDF | `pages` 파라미터로 범위 지정 (최대 20페이지/요청) |
| Jupyter (.ipynb) | 모든 셀 + 출력 + 시각화 표시 |

### 도구 3: Edit -- 파일 편집

**목적**: 파일의 특정 부분을 찾아서 교체합니다.

```
Claude 내부 동작:
Edit(
  file_path = "src/app.ts",
  old_string = "const port = 3000;",    ← 이 부분을 찾아서
  new_string = "const port = 8080;"     ← 이것으로 교체
)
```

**핵심 규칙:**
- Edit 전에 반드시 Read를 먼저 해야 함 (안전장치)
- `old_string`이 파일에서 유일해야 함 (여러 곳이면 실패)
- 여러 곳을 동시에 바꾸려면 `replace_all: true` 사용

### 도구 4: Write -- 파일 생성/덮어쓰기

**목적**: 새 파일을 만들거나 기존 파일을 완전히 다시 씁니다.

```
사용 기준:

  기존 파일의 일부만 수정  → Edit 사용
  변수/기호 이름 일괄 변경 → Edit (replace_all)
  새 파일 처음부터 생성    → Write 사용
  파일 전체 재작성         → Write 사용
```

### 도구 5: Glob & Grep -- 검색의 양대 산맥

#### Glob -- 파일 이름으로 찾기

"이름이 이런 파일이 어디 있지?"

```
패턴 예시:
  **/*.ts           → 모든 TypeScript 파일
  src/**/*.test.js  → src/ 아래 테스트 파일
  **/package.json   → 모든 깊이의 package.json
```

#### Grep -- 파일 내용에서 찾기

"이 단어가 들어있는 파일은 어디?"

```
사용 예시:
  "TODO"              → TODO 주석이 있는 파일 찾기
  "function\s+\w+"    → 함수 선언 패턴 검색 (정규식)
  "import.*firebase"  → Firebase import 찾기
```

**Grep 출력 모드 3가지:**

| 모드 | 반환 | 활용 |
|------|------|------|
| `files_with_matches` | 파일 경로만 | "어디에 있지?" |
| `content` | 매칭 줄 + 전후 컨텍스트 | "어떤 내용이지?" |
| `count` | 파일별 매칭 횟수 | "얼마나 많지?" |

### 보너스 도구: WebFetch & WebSearch -- 웹 접근

#### WebFetch -- URL 내용 가져오기

```
"https://docs.example.com/api" 페이지를 읽고 인증 방식을 알려줘
```

- HTML을 마크다운으로 변환
- 15분 캐시 (같은 URL 재요청 시 빠름)
- HTTP를 HTTPS로 자동 업그레이드

#### WebSearch -- 웹 검색

```
"React Server Components 최신 동향"을 검색해줘
```

- 호출당 최대 8회 검색 수행
- Claude가 자동으로 쿼리 최적화
- 출처(Sources) 명시

### 보너스 도구: Task -- 서브 에이전트

복잡한 작업을 분리된 컨텍스트에서 병렬로 처리합니다.

```
당신: "이 프로젝트의 성능 이슈와 보안 이슈를 동시에 분석해줘"
Claude: Task 1 → 성능 분석 (별도 에이전트)
        Task 2 → 보안 분석 (별도 에이전트)
        → 결과 종합
```

### 한줄 요약

> Bash(실행), Read/Edit/Write(파일), Glob/Grep(검색), Web(웹) -- Claude가 컴퓨터를 직접 다루는 5종 도구입니다. 자연어로 요청하면 Claude가 최적의 도구를 알아서 선택합니다.

---

## 4.7 대화형 vs 비대화형 모드

### 두 가지 사용 방식

Claude Code는 크게 **두 가지 방식**으로 사용할 수 있습니다.

```
┌────────────────────────┐  ┌──────────────────────────┐
│   대화형 모드 (REPL)    │  │   비대화형 모드 (-p)      │
│                         │  │                           │
│  $ claude               │  │  $ claude -p "분석해줘"   │
│  > 대화 시작...          │  │  → 결과 출력              │
│  > 이어서 작업...        │  │  → 즉시 종료              │
│  > /compact              │  │                           │
│  > 계속 작업...          │  │  스크립트에서 호출 가능     │
│  > exit                  │  │  CI/CD 파이프라인 연동     │
│                         │  │                           │
│  사람과 대화하는 느낌     │  │  명령어 실행하는 느낌      │
└────────────────────────┘  └──────────────────────────┘
```

### 대화형 모드 (Interactive / REPL)

```bash
claude                          # 기본 시작
claude --model opus             # 모델 지정
claude --permission-mode plan   # 계획 모드로 시작
```

**특징:**
- 지속적인 대화 (컨텍스트 유지)
- 변경사항 승인/거절 가능
- 슬래시 명령어 사용 가능
- 세션 자동 저장 (`--resume`으로 재개)
- CLAUDE.md 자동 로드

**적합한 상황**: 코드 탐색, 리팩토링, 디버깅, 학습

### 비대화형 모드 (Non-interactive / Print Mode)

```bash
claude -p "이 코드베이스를 설명해줘"
claude -p "TODO 주석 목록" --output-format json
echo "분석해줘" | claude -p
```

**특징:**
- 프롬프트 처리 후 출력하고 **즉시 종료**
- REPL 미시작
- 파이프라인 입출력 가능
- `--output-format json`으로 구조화 출력

**적합한 상황**: CI/CD, 스크립트, 자동화, 일회성 질문

### 세션 재개 패턴

```bash
# 마지막 세션 이어서
claude -c "아까 만든 테스트 이어서 해줘"

# 특정 세션 재개
claude -r "auth refactor"

# 세션 분기 (원본 보존하면서 실험)
claude -r <session-id> --fork-session

# 비대화형으로 이전 세션 이어서
claude -c -p "아까 논의한 테스트를 작성해줘"
```

### 한줄 요약

> 사람처럼 대화하려면 `claude`, 스크립트처럼 실행하려면 `claude -p`. 상황에 맞게 골라 쓰세요.

---

## 4.8 키보드 단축키와 생산성 팁

### 필수 키보드 단축키

| 단축키 | 기능 | 비고 |
|--------|------|------|
| `Ctrl+C` | 현재 응답 중단 | 대화는 유지됨 |
| `Ctrl+D` | Claude Code 종료 | 세션 종료 |
| `Ctrl+L` | 터미널 화면 초기화 | 컨텍스트는 유지 |
| `Up/Down` | 입력 기록 탐색 | 이전 프롬프트 재사용 |
| `Tab` | 슬래시 명령어 자동완성 | `/co` -> `/commit` |
| `Escape` | 권한 프롬프트 취소 | 승인/거부 대화에서 |

### 생산성 팁 모음

#### 팁 1: CLAUDE.md 활용하기

```bash
/init    # 새 프로젝트에서 반드시 첫 번째로 실행!
```

CLAUDE.md에 기록해야 할 것들:
- 비표준 빌드 명령어 (`yarn workspace` 등)
- 테스트 실행 특수성
- 코딩 컨벤션 (네이밍, 파일 구조)
- 아키텍처 참고사항

#### 팁 2: 컨텍스트 관리

```bash
/compact                                     # 대화가 길어지면 압축
/compact DB 스키마 변경에만 집중             # 특정 주제만 유지
/clear                                       # 완전히 새로운 작업 시작 시
```

#### 팁 3: 계획 모드로 대규모 변경

```bash
claude --permission-mode plan "결제 모듈 리팩토링"   # CLI에서
/plan 인증 모듈을 JWT로 리팩토링                     # 세션 중
/plan open                                           # 계획 확인
```

#### 팁 4: 비용과 성능 관리

```bash
# 간단한 질문 -- 빠르고 저렴하게
claude --effort low -p "이 함수가 뭐 하는 거야?"

# 복잡한 분석 -- 최대 깊이
claude --effort max -p "이 아키텍처를 리뷰해줘"

# 비용 제한
claude -p "대규모 분석" --max-budget-usd 2.50

# 턴 수 제한
claude -p "리팩토링" --max-turns 10
```

#### 팁 5: 빠른 시작이 필요할 때

```bash
# --bare: 훅, CLAUDE.md 등 모두 건너뛰기
claude --bare -p "이 에러 메시지가 무슨 뜻이야?"
```

#### 팁 6: 도구 접근 제한으로 안전하게

```bash
# git 명령만 허용
claude --allowed-tools "Bash(git:*) Edit Read"

# 삭제 명령 차단
claude --disallowed-tools "Bash(rm:*)"

# 완전한 읽기 전용 세션
claude --tools "Read Glob Grep"
```

### 한줄 요약

> `Ctrl+C`(중단), `Tab`(자동완성), `/compact`(압축) 세 가지만 기억해도 생산성이 크게 올라갑니다.

---

## 4.9 실전 자동화 시나리오

### 시나리오 1: CI/CD에서 자동 코드 리뷰

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
          claude -p "이 PR의 변경사항에서 버그와 보안 이슈를 찾아줘" \
            --dangerously-skip-permissions \
            --output-format json \
            --max-turns 5
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```

### 시나리오 2: 테스트 자동 수정

```bash
claude -p "테스트를 실행하고 실패한 것들을 수정해줘" \
  --dangerously-skip-permissions \
  --max-turns 10 \
  --max-budget-usd 2.50
```

### 시나리오 3: JSON 출력으로 후처리

```bash
# 함수 목록 추출
RESULT=$(claude -p "src/ 폴더의 exported 함수 목록" --output-format json)
echo "$RESULT" | jq '.result'

# 구조화된 출력 + 스키마 검증
claude -p "API 엔드포인트 추출" \
  --output-format json \
  --json-schema '{"type":"object","properties":{"endpoints":{"type":"array","items":{"type":"object","properties":{"method":{"type":"string"},"path":{"type":"string"}}}}}}'
```

### 시나리오 4: 코드 분석 자동화 스크립트

```bash
#!/bin/bash
# analyze-codebase.sh

# 사용하지 않는 export 검사
claude -p "src/에서 사용하지 않는 export를 찾아줘" \
  --no-session-persistence --output-format text

# TODO 목록 추출
claude -p "모든 TODO 주석과 파일 위치를 나열해줘" \
  --output-format json | jq '.result'

# 보안 감사
claude -p "이 코드베이스의 보안 취약점을 감사해줘" \
  --system-prompt "당신은 보안 감사관입니다." \
  --max-budget-usd 1.00
```

### 시나리오 5: 모델 폴백 전략

```bash
# Opus 우선, 과부하 시 Sonnet으로 자동 전환
claude -p "복잡한 아키텍처 리뷰" \
  --model opus \
  --fallback-model sonnet \
  --effort high
```

### 주요 플래그 조합 치트시트

| 시나리오 | 명령어 |
|---------|--------|
| 일회성 코드 설명 | `claude -p "이 코드베이스 설명해줘"` |
| JSON 출력 | `claude -p "타입 나열" --output-format json` |
| CI 테스트 수정 | `claude -p "테스트 실행 후 수정" --dangerously-skip-permissions --max-turns 10` |
| 이전 세션 이어서 | `claude -c "테스트 추가해줘"` |
| 모델 + 폴백 | `claude -p "분석" --model opus --fallback-model sonnet` |
| 비용 제한 | `claude -p "작업" --max-budget-usd 2.50 --max-turns 10` |
| 읽기 전용 분석 | `claude --tools "Read Glob Grep" -p "구조 분석"` |

### 한줄 요약

> `-p` + `--output-format json`이 자동화의 핵심입니다. CI/CD, 스크립트, 파이프라인에 Claude Code를 통합하세요.

---

## 4.10 자주 묻는 질문

### 🤔 대화형 모드와 비대화형 모드, 언제 뭘 써야 하나요?

| 상황 | 모드 | 이유 |
|------|------|------|
| 코드 탐색하면서 질문 | 대화형 (`claude`) | 맥락 유지하면서 이어서 질문 |
| CI/CD 파이프라인 | 비대화형 (`claude -p`) | 자동 실행 후 종료 필요 |
| 빠른 일회성 질문 | 비대화형 (`claude -p`) | 결과만 받고 끝 |
| 리팩토링 작업 | 대화형 (`claude`) | 변경사항 확인하면서 진행 |

### 🤔 `--effort` 레벨은 비용에 영향을 미치나요?

네. `high`/`max`로 올리면 Claude가 더 많이 생각하므로 토큰 사용량과 비용이 증가합니다. 간단한 질문에는 `low`를, 복잡한 분석에는 `high`를 사용하세요.

### 🤔 `--bare` 모드는 언제 쓰나요?

훅, CLAUDE.md, LSP 등 모든 부가 기능을 건너뛰고 **가장 빠르게** 시작해야 할 때 사용합니다. 주로 스크립트에서 빠른 실행이 필요할 때 유용합니다.

### 🤔 세션은 자동으로 저장되나요?

네. 대화형 모드의 세션은 자동 저장됩니다. `claude -c`로 마지막 세션을, `claude -r "키워드"`로 특정 세션을 재개할 수 있습니다. `--no-session-persistence`를 사용하면 저장하지 않습니다.

### 🤔 `--dangerously-skip-permissions`는 정말 위험한가요?

이름에 "dangerously"가 들어있을 만큼 주의가 필요합니다. **격리된 환경(Docker, CI 컨테이너)에서만** 사용하세요. 로컬 환경에서 사용하면 Claude가 시스템 파일을 수정하거나 위험한 명령을 실행할 수 있습니다.

### 🤔 `--max-budget-usd`를 넘으면 어떻게 되나요?

설정한 금액에 도달하면 Claude가 작업을 **중단**합니다. 작업 도중에 중단될 수 있으므로, 적절한 예산을 설정하는 것이 중요합니다.

---

## 4.11 핵심 포인트 정리

### 📌 설치와 인증

- **설치**: `npm install -g @anthropic-ai/claude-code` (Node.js 18+)
- **인증**: OAuth(가장 편함), API 키(CI/스크립트), Bedrock/Vertex(기업)
- **첫 실행**: `claude` -> 브라우저 로그인 -> 완료

### 📌 CLI 플래그 핵심 3개

- `-p` -- 비대화형 모드 (스크립트/자동화의 핵심)
- `--model` -- 모델 선택 (haiku/sonnet/opus)
- `-c` -- 이전 세션 이어서

### 📌 슬래시 명령어 핵심 5개

- `/init` -- 프로젝트 초기화 (처음에 반드시)
- `/commit` -- AI 커밋 메시지
- `/compact` -- 대화 압축 (긴 세션 유지)
- `/model` -- 모델 전환
- `/plan` -- 계획 모드

### 📌 내장 도구 5종

- **Bash** -- 셸 명령어 실행 (빌드, 테스트, git)
- **Read/Edit/Write** -- 파일 읽기/수정/생성
- **Glob** -- 파일 이름 패턴 검색
- **Grep** -- 파일 내용 검색 (ripgrep 기반)
- **WebFetch/WebSearch** -- 웹 페이지 읽기/검색

### 📌 두 가지 사용 모드

- **대화형** (`claude`) -- 코드 탐색, 리팩토링, 디버깅에 적합
- **비대화형** (`claude -p`) -- CI/CD, 스크립트, 일회성 작업에 적합

### 📌 자동화 공식

```
claude -p "프롬프트" \
  --output-format json \           # 구조화된 출력
  --max-turns 10 \                 # 턴 수 제한
  --max-budget-usd 2.50 \          # 비용 제한
  --dangerously-skip-permissions   # CI 컨테이너 전용!
```

### 📌 생산성 킬러 조합

```bash
# 새 프로젝트 시작
/init → /plan → 작업 → /commit

# 긴 세션 유지
작업 → /compact → 작업 → /compact → ...

# 모델 전환으로 비용 최적화
간단한 작업: /model haiku
복잡한 분석: /model opus
일상 코딩: /model sonnet
```

> 다음 챕터에서는 지금까지 배운 모든 것을 종합하여 **실전 프로젝트에 적용하는 워크플로우**를 다룹니다.
