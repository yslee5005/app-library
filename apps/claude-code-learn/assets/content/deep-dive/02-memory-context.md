# Deep Dive #02: 메모리, 컨텍스트 & 설정 시스템 완전 분석

## TL;DR

Claude Code는 **4단계 계층형 메모리 구조**(관리형 -> 사용자 -> 프로젝트 -> 로컬)를 통해 지시사항을 관리한다. `CLAUDE.md` 파일이 핵심이며, `@include` 디렉티브로 외부 파일을 참조하고, `.claude/rules/*.md`로 규칙을 모듈화할 수 있다. 설정은 `settings.json`으로, 런타임 동작은 환경 변수로 제어한다. 현재 작업 디렉토리(CWD)에 가까울수록 우선순위가 높고, **Managed(관리형) 설정만은 항상 최고 우선순위**를 유지하여 재정의가 불가능하다.

---

## 목차

1. [CLAUDE.md 4단계 계층 구조](#1-claudemd-4단계-계층-구조)
2. [@include 디렉티브와 파일 참조 시스템](#2-include-디렉티브와-파일-참조-시스템)
3. [Rules 파일 시스템](#3-rules-파일-시스템)
4. [설정 파일 구조 (settings.json)](#4-설정-파일-구조-settingsjson)
5. [환경 변수 전체 정리](#5-환경-변수-전체-정리)
6. [컨텍스트 윈도우 관리와 컴팩션](#6-컨텍스트-윈도우-관리와-컴팩션)
7. [메모이제이션 최적화](#7-메모이제이션-최적화)
8. [실무 활용: 효과적인 설정 전략](#8-실무-활용-효과적인-설정-전략)

---

## 1. CLAUDE.md 4단계 계층 구조

Claude Code의 메모리 시스템은 프로젝트별, 사용자별 맞춤형 지시사항을 제공하기 위해 **4단계 계층형 구조**를 채택하고 있다.

### 계층 다이어그램

```
우선순위 낮음                                            우선순위 높음
     |                                                        |
     v                                                        v

 [1단계]           [2단계]          [3단계]           [4단계]
 관리형 메모리  ->  사용자 메모리  ->  프로젝트 메모리  ->  로컬 메모리
 (Managed)        (User)           (Project)          (Local)
 재정의 불가       개인 전역         팀 공유             개인 비공개
```

> **핵심 원칙**: 현재 작업 디렉토리(CWD)에 가까울수록 우선순위가 높다. 단, 관리형 메모리의 **정책**은 어느 단계에서도 재정의할 수 없다.

### 1단계: 관리형 메모리 (Managed) -- 조직 정책

| 항목 | 내용 |
|------|------|
| **경로** | `/etc/claude-code/CLAUDE.md` (또는 조직 설정 경로) |
| **범위** | 머신의 모든 사용자 |
| **특징** | 사용자/프로젝트 파일로 재정의 **불가능** |
| **용도** | 조직 보안 정책, 배포 설정, 컴플라이언스 규칙 |

- 시스템 관리자가 설정하며, 항상 로드되고 제외할 수 없다.
- 엔터프라이즈 환경에서 일관된 정책 적용에 핵심적인 역할을 한다.

### 2단계: 사용자 메모리 (User) -- 개인 전역 설정

| 항목 | 내용 |
|------|------|
| **경로** | `~/.claude/CLAUDE.md` 및 `~/.claude/rules/*.md` |
| **범위** | 해당 사용자의 모든 프로젝트 |
| **특징** | 저장소에 커밋되지 않음 (개인용) |
| **용도** | 코딩 스타일, 응답 언어, 커밋 스타일, 개인 단축키 |

```markdown
# 예시: ~/.claude/CLAUDE.md

- 응답은 항상 한국어로
- 커밋 메시지는 Conventional Commits 형식
- 2칸 들여쓰기 사용
- console.log 대신 logger 사용
```

### 3단계: 프로젝트 메모리 (Project) -- 팀 공유 지침

| 항목 | 내용 |
|------|------|
| **경로** | `CLAUDE.md`, `.claude/CLAUDE.md`, `.claude/rules/*.md` |
| **검색 방식** | CWD부터 파일시스템 루트까지 상위 디렉토리 탐색 |
| **범위** | 해당 프로젝트의 모든 협업자 |
| **특징** | 버전 관리에 포함 (Git 커밋 대상) |
| **용도** | 아키텍처 노트, 테스트 명령어, 네이밍 규칙, 프로젝트 규칙 |

```markdown
# 예시: 프로젝트 루트 CLAUDE.md

## 명령어
- 빌드: `bun run build`
- 테스트: `bun test`
- 린트: `bun run lint`
- 타입 체크: `bun run typecheck`

## 아키텍처
모노레포. 핵심 로직은 `packages/core`. CLI 진입점은 `src/index.ts`.

## 규칙
- `zod/v4` 스키마 검증 필수
- `any` 금지, `unknown` + 타입 가드 사용
- 비동기 함수는 명시적 에러 처리 필수
- 테스트는 `__tests__/` 디렉토리 (같은 수준)

## Git
- 브랜치: `feat/<ticket>-설명`
- 커밋 전 `bun test && bun run typecheck` 실행
- `console.log` 포함 금지

@./docs/api-conventions.md
```

### 4단계: 로컬 메모리 (Local) -- 개인 비공개 설정 (최고 우선순위)

| 항목 | 내용 |
|------|------|
| **경로** | `CLAUDE.local.md` (상위 디렉토리 모두 검색) |
| **범위** | 해당 개인의 해당 프로젝트 환경 |
| **특징** | `.gitignore`에 포함 필수 |
| **용도** | 환경 경로, 개인 디버깅 노트, 팀 설정 오버라이드 |

```markdown
# 예시: CLAUDE.local.md

- 내 로컬 DB 포트: 5433 (기본 5432가 아님)
- 테스트 시 --verbose 플래그 추가
- API 서버는 localhost:8081에서 실행 중
```

### 파일 발견 알고리즘

```
실행 순서:
1. 관리형 메모리 로드 (/etc/claude-code/)
2. 사용자 메모리 로드 (~/.claude/)
3. 프로젝트/로컬 메모리 (파일시스템 루트 -> CWD 순서로 순회)
   - 루트에서 시작해서 현재 디렉토리까지 내려오므로
   - CWD에 가까운 파일이 나중에 로드 = 더 높은 우선순위
```

내부 구현은 `utils/claudemd.ts`의 `getMemoryFiles()` 함수에서 처리한다.

### 각 단계별 활용 가이드

| 메모리 레벨 | 넣어야 할 것 | 넣지 말아야 할 것 |
|------------|------------|----------------|
| **관리형** | 보안 정책, 컴플라이언스, 배포 설정 | 개인 선호도 |
| **사용자** | 응답 언어, 커밋 스타일, 개인 단축키 | 프로젝트별 규칙 |
| **프로젝트** | 테스트 명령어, 아키텍처, 네이밍 규칙 | API 키, 비밀번호 |
| **로컬** | 환경 경로, 디버깅 노트, 팀 설정 오버라이드 | 팀 전체가 알아야 할 규칙 |

---

## 2. @include 디렉티브와 파일 참조 시스템

`CLAUDE.md` 파일이 커지면 관리가 어려워진다. `@include` 디렉티브를 사용하면 외부 파일을 참조하여 모듈화할 수 있다.

### 구문 형식

| 구문 | 해석 | 사용 예 |
|------|------|--------|
| `@filename` | 포함 파일의 디렉토리 기준 상대 경로 | `@conventions.md` |
| `@./relative/path` | 명시적 상대 경로 | `@./docs/architecture.md` |
| `@~/home/path` | 홈 디렉토리 기준 경로 | `@~/shared-rules/style.md` |
| `@/absolute/path` | 절대 경로 | `@/etc/company/coding-standards.md` |

### 동작 규칙

| 규칙 | 설명 |
|------|------|
| **코드 블록 내 무시** | 펜스 코드 블록(\`\`\`)과 인라인 코드(\`) 내 `@` 경로는 처리하지 않음 |
| **순환 참조 차단** | 자동 감지 후 스킵 (A -> B -> A 같은 경우) |
| **누락된 파일** | 존재하지 않는 파일은 에러 없이 자동 무시 |
| **최대 깊이** | 5단계까지 중첩 가능 |
| **지원 파일 형식** | 텍스트 기반만 (`.md`, `.ts`, `.py`, `.json` 등) |
| **보안** | 프로젝트 외부 경로는 명시적 승인 필요 |

### 실전 예시: 모노레포에서의 활용

```markdown
# 프로젝트 루트 CLAUDE.md

## 공통 규칙
@./docs/conventions/typescript.md
@./docs/conventions/testing.md
@./docs/architecture.md

## 패키지별 안내
@./packages/api/CLAUDE.md
@./packages/web/CLAUDE.md
@./packages/shared/CLAUDE.md

커밋 전 `pnpm test && pnpm typecheck` 실행 필수
```

이렇게 하면 각 패키지의 규칙을 독립적으로 관리하면서 루트에서 통합할 수 있다.

### 실무 팁: @include 활용

- **문서 재사용**: 이미 존재하는 `docs/` 디렉토리의 문서를 그대로 참조할 수 있다. 중복 작성이 불필요하다.
- **팀원별 커스텀**: `CLAUDE.local.md`에서 개인 추가 규칙 파일을 `@include`로 참조할 수 있다.
- **깊이 제한 주의**: 5단계 이상 중첩하면 무시되므로, 구조를 평탄하게 유지하는 것이 좋다.

---

## 3. Rules 파일 시스템

단일 `CLAUDE.md`가 너무 길어지면 `.claude/rules/` 디렉토리를 활용해 규칙을 모듈화할 수 있다.

### 디렉토리 구조

```
프로젝트/
├── CLAUDE.md                    # 메인 지침 (간략하게)
├── CLAUDE.local.md              # 개인 비공개 (.gitignore)
└── .claude/
    ├── settings.json            # 프로젝트 설정 (팀 공유)
    ├── settings.local.json      # 로컬 설정 (.gitignore)
    └── rules/
        ├── testing.md           # 테스트 관련 규칙
        ├── typescript-style.md  # TypeScript 코딩 스타일
        ├── git-workflow.md      # Git 워크플로우
        └── api-design.md       # API 설계 규칙
```

사용자 레벨에서도 동일한 구조를 사용할 수 있다:

```
~/.claude/
├── CLAUDE.md                    # 사용자 전역 지침
├── settings.json                # 사용자 전역 설정
└── rules/
    ├── language.md              # 응답 언어 설정
    └── personal-style.md       # 개인 코딩 스타일
```

### Frontmatter 경로 타겟팅

`.claude/rules/` 내의 파일은 YAML frontmatter를 사용해 **특정 파일 경로에만 조건부로 적용**할 수 있다.

```markdown
---
paths:
  - "src/api/**"
  - "src/services/**"
---

## API/서비스 규칙
- 의존성 주입 항상 사용
- 구현체 직접 임포트 금지
- 모든 서비스 메서드에 에러 핸들링 필수
- Response DTO는 `dto/` 디렉토리에 정의
```

```markdown
---
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---

## 테스트 규칙
- describe/it 패턴 사용
- mock은 최소한으로
- 테스트 파일당 하나의 주요 기능 테스트
- AAA 패턴 (Arrange-Act-Assert) 준수
```

### Glob 패턴 매칭 규칙

| 패턴 | 매칭 대상 |
|------|----------|
| `src/api/**` | src/api 하위 모든 파일 |
| `*.graphql` | 루트의 모든 .graphql 파일 |
| `**/*.test.ts` | 모든 하위 디렉토리의 .test.ts 파일 |
| `packages/core/**` | packages/core 하위 모든 파일 |

### 실무 팁: Rules 파일 활용

- **대규모 프로젝트에서 컨텍스트 최소화**: 경로 타겟팅을 사용하면 해당 파일 작업 시에만 관련 규칙이 로드되어 컨텍스트 낭비를 줄인다.
- **팀 온보딩 간소화**: 새 팀원이 어떤 규칙이 적용되는지 파일 구조만 보면 파악할 수 있다.
- **독립적 관리**: 테스트 규칙 변경이 스타일 규칙 파일에 영향을 주지 않아 PR 리뷰가 깔끔하다.

---

## 4. 설정 파일 구조 (settings.json)

### 설정 파일 위치와 우선순위

```
Plugin defaults -> User settings -> Project settings -> Local settings -> Managed settings
     (최저)                                                                    (최고)
```

| 레벨 | 경로 | 버전 관리 | 용도 |
|------|------|---------|------|
| **User (전역)** | `~/.claude/settings.json` | X | 모델 선택, 테마, 개인 선호도 |
| **Project (공유)** | `.claude/settings.json` | O (Git) | 권한 규칙, 훅, MCP 서버 |
| **Local (개인)** | `.claude/settings.local.json` | X (.gitignore) | 프로젝트 내 개인 재정의 |
| **Managed (기업)** | 시스템 경로 (플랫폼별) | MDM/레지스트리 | 최고 우선순위, 재정의 불가 |

### 전체 설정 키 참조

#### 핵심 설정 (Core)

```json
{
  "$schema": "https://schemas.anthropic.com/claude-code/settings.json",
  "model": "claude-opus-4-5",
  "cleanupPeriodDays": 30,
  "env": {
    "DISABLE_AUTO_COMPACT": "1",
    "BASH_MAX_OUTPUT_LENGTH": "30000"
  }
}
```

| 키 | 타입 | 기본값 | 설명 |
|----|------|-------|------|
| `model` | `string` | - | 기본 모델 ID 재정의 |
| `cleanupPeriodDays` | `integer` | `30` | 채팅 기록 보존 기간. `0`이면 세션 비활성화 |
| `env` | `object` | - | 세션에 주입되는 환경 변수 |

#### 권한 설정 (Permissions)

```json
{
  "permissions": {
    "allow": ["Read", "Glob", "Grep"],
    "deny": ["Bash(rm -rf *)"],
    "ask": ["Write", "Edit"],
    "defaultMode": "default",
    "additionalDirectories": ["/shared/docs"]
  }
}
```

| 필드 | 설명 |
|------|------|
| `allow` | 자동 허용할 도구 규칙 배열 |
| `deny` | 완전 차단할 도구 규칙 배열 |
| `ask` | 실행 전 확인 요청할 도구 규칙 배열 |
| `defaultMode` | `"default"`, `"acceptEdits"`, `"plan"`, `"bypassPermissions"` |
| `additionalDirectories` | 추가 접근 허용 디렉토리 |

#### 훅 설정 (Hooks)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "command": "echo 'Bash 실행 전 체크'"
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write",
        "command": "prettier --write $CLAUDE_FILE_PATH"
      }
    ]
  }
}
```

지원 이벤트:
- `PreToolUse` / `PostToolUse`: 도구 실행 전/후
- `Notification`: 알림 발생 시
- `UserPromptSubmit`: 사용자 입력 제출 시
- `SessionStart` / `SessionEnd`: 세션 시작/종료 시
- `Stop` / `SubagentStop`: 에이전트 중지 시
- `PreCompact` / `PostCompact`: 컴팩션 전/후

#### 모델 & 접근 제어

| 키 | 타입 | Scope | 설명 |
|----|------|-------|------|
| `availableModels` | `string[]` | Managed 전용 | 엔터프라이즈 모델 허용 목록 |
| `allowedMcpServers` | `object[]` | 모든 scope | MCP 서버 허용 목록 |
| `deniedMcpServers` | `object[]` | 모든 scope | MCP 서버 거부 목록 (우선) |

#### 커스터마이징 옵션

| 키 | 타입 | 설명 |
|----|------|------|
| `attribution.commit` | `string` | Git 커밋 트레일러 텍스트 |
| `attribution.pr` | `string` | PR 설명 텍스트 |
| `language` | `string` | 응답/딕테이션 언어 |
| `defaultShell` | `"bash"` \| `"powershell"` | 기본 셸 |

#### 고급 기능

| 키 | 타입 | 기본값 | 설명 |
|----|------|-------|------|
| `alwaysThinkingEnabled` | `boolean` | `true` | 확장 사고 기능 |
| `effortLevel` | `"low"` \| `"medium"` \| `"high"` | - | 사고 예산 수준 |
| `autoMemoryEnabled` | `boolean` | - | 자동 메모리 읽기/쓰기 |
| `autoMemoryDirectory` | `string` | `~/.claude/projects/<cwd>/memory/` | 메모리 저장 경로 |
| `claudeMdExcludes` | `string[]` | - | CLAUDE.md 로딩 제외 패턴 |

#### 운영 제어

| 키 | 타입 | 기본값 | 설명 |
|----|------|-------|------|
| `disableAllHooks` | `boolean` | - | 모든 훅 비활성화 |
| `respectGitignore` | `boolean` | `true` | .gitignore 존중 여부 |
| `sandbox` | `object` | - | 도구 실행 격리 |
| `syntaxHighlightingDisabled` | `boolean` | - | 구문 강조 비활성화 |
| `prefersReducedMotion` | `boolean` | - | 접근성 애니메이션 감소 |

#### 엔터프라이즈 잠금 설정 (Managed Only)

| 키 | 기능 |
|----|------|
| `allowManagedHooksOnly` | 훅 실행을 managed 설정으로만 제한 |
| `allowManagedPermissionRulesOnly` | managed 권한 규칙만 시행 |
| `allowManagedMcpServersOnly` | MCP 서버를 managed 목록으로 제한 |
| `strictPluginOnlyCustomization` | 커스터마이징을 플러그인 전용 소스로 잠금 |
| `forceLoginMethod` | `"claudeai"` 또는 `"console"` 로그인 강제 |
| `apiKeyHelper` | 동적 인증 제공 스크립트 경로 |

### Managed Settings 배포 방법

| 플랫폼 | 방법 |
|--------|------|
| **macOS** | plist를 `/Library/Preferences/`에 배포, MDM(Jamf, Kandji) 활용 |
| **Windows** | 레지스트리 `HKLM\Software\Anthropic\Claude Code` (시스템) 또는 `HKCU\...` (사용자) |
| **File-Based** | `managed-settings.json` 또는 `managed-settings.d/` 디렉토리 (알파벳순, 나중 파일 우선) |

### 실무 팁: settings.json 활용

- **`$schema` 추가**: 에디터 자동완성과 검증을 받을 수 있다.
- **프로젝트 settings.json은 반드시 커밋**: 팀 일관성을 위해 `.claude/settings.json`은 Git에 포함한다.
- **로컬 오버라이드**: `.claude/settings.local.json`으로 개인적 설정을 팀 설정 위에 덮어쓴다.
- **`/config` 명령어**: 세션 중 설정 UI를 열어 실시간으로 확인하고 편집할 수 있다.

---

## 5. 환경 변수 전체 정리

Claude Code의 환경 변수를 카테고리별로 정리한다.

### 카테고리 1: 인증 (Authentication)

| 변수 | 용도 | 예시 |
|------|------|------|
| `ANTHROPIC_API_KEY` | Anthropic API 직접 인증 (OAuth보다 우선) | `sk-ant-...` |
| `ANTHROPIC_AUTH_TOKEN` | API_KEY가 적용 안 될 때 대체 인증 토큰 | - |
| `CLAUDE_CODE_OAUTH_TOKEN` | 대화형 로그인 우회용 OAuth 토큰 | - |
| `ANTHROPIC_BASE_URL` | 프록시/스테이징/타사 엔드포인트 지정 | `https://my-proxy.example.com` |
| `CLAUDE_CODE_API_BASE_URL` | ANTHROPIC_BASE_URL보다 높은 우선순위 | - |

### 카테고리 2: 클라우드 제공자 (Cloud Providers)

| 변수 | 용도 |
|------|------|
| `CLAUDE_CODE_USE_BEDROCK` | AWS Bedrock API 제공자 활성화 (`1` 또는 `true`) |
| `CLAUDE_CODE_USE_FOUNDRY` | Anthropic Foundry API 제공자 활성화 |
| `ANTHROPIC_BEDROCK_BASE_URL` | Bedrock API 엔드포인트 |
| `ANTHROPIC_VERTEX_PROJECT_ID` | Google Cloud Vertex AI 프로젝트 ID (필수) |
| `AWS_REGION` / `AWS_DEFAULT_REGION` | Bedrock API 호출용 AWS 지역 (기본: us-east-1) |
| `CLOUD_ML_REGION` | Vertex AI 기본 지역 (기본: us-east5) |
| `VERTEX_REGION_CLAUDE_*` | 모델별 Vertex AI 지역 재정의 |

**Vertex AI 모델별 지역 매핑:**

```bash
# 예시: 모델별 지역 설정
export VERTEX_REGION_CLAUDE_4_0_OPUS="us-central1"
export VERTEX_REGION_CLAUDE_4_5_SONNET="europe-west1"
export VERTEX_REGION_CLAUDE_HAIKU_4_5="asia-northeast1"
```

### 카테고리 3: 모델 선택 (Model Selection)

| 변수 | 용도 | 재정의 가능 여부 |
|------|------|----------------|
| `ANTHROPIC_MODEL` | 기본 모델 설정 | settings.json, --model 플래그로 재정의 가능 |
| `CLAUDE_CODE_SUBAGENT_MODEL` | 하위 에이전트 작업용 모델 | - |
| `CLAUDE_CODE_AUTO_MODE_MODEL` | 자동 모드 실행 시 모델 | 미설정 시 주 세션 모델 사용 |

### 카테고리 4: 동작 제어 (Behavior Toggles)

| 변수 | 기능 | 기본값 |
|------|------|-------|
| `CLAUDE_CODE_REMOTE` | 원격/컨테이너 모드 (타임아웃 확장, 대화형 프롬프트 억제) | 비활성 |
| `CLAUDE_CODE_SIMPLE` | 베어 모드 (훅, LSP, 플러그인 스킵) | 비활성 |
| `DISABLE_AUTO_COMPACT` | 자동 컨텍스트 압축 비활성화 | 비활성 |
| `CLAUDE_CODE_DISABLE_BACKGROUND_TASKS` | 백그라운드 프로세스 비활성화 | 비활성 |
| `CLAUDE_CODE_DISABLE_THINKING` | 확장 사고 비활성화 | 비활성 |
| `CLAUDE_CODE_DISABLE_AUTO_MEMORY` | 자동 메모리 읽기/쓰기 비활성화 | 비활성 |
| `CLAUDE_CODE_DISABLE_CLAUDE_MDS` | 모든 CLAUDE.md 로딩 완전 비활성화 | 비활성 |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | 분석/원격 측정 억제 | 비활성 |
| `CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD` | --add-dir 디렉토리에서 CLAUDE.md 로드 | 비활성 |
| `CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR` | Bash 명령 후 프로젝트 루트로 CWD 재설정 | 비활성 |

### 카테고리 5: 리소스 제한 (Resource Limits)

| 변수 | 타입 | 기본값 | 용도 |
|------|------|-------|------|
| `CLAUDE_CODE_MAX_OUTPUT_TOKENS` | 숫자 | - | API 응답당 최대 출력 토큰 수 |
| `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | 숫자 | - | 최대 컨텍스트 윈도우 크기 |
| `BASH_MAX_OUTPUT_LENGTH` | 숫자 | - | Bash 명령 출력 최대 문자 수 |
| `API_TIMEOUT_MS` | 숫자 (ms) | 표준 300,000 / 원격 120,000 | API 호출 타임아웃 |

### 카테고리 6: 구성 경로 (Configuration Paths)

| 변수 | 기본값 | 용도 |
|------|-------|------|
| `CLAUDE_CONFIG_DIR` | `~/.claude` | 구성/설정/기록 저장 디렉토리 재정의 |
| `CLAUDE_CODE_MANAGED_SETTINGS_PATH` | 플랫폼별 | 관리 설정 파일 경로 재정의 (엔터프라이즈) |

### 카테고리 7: 원격 측정 & 관찰성 (Telemetry)

| 변수 | 용도 |
|------|------|
| `CLAUDE_CODE_ENABLE_TELEMETRY` | OpenTelemetry 내보내기 활성화 |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OTLP 엔드포인트 (텔레메트리 활성화 시 필요) |
| `CLAUDE_CODE_JSONL_TRANSCRIPT` | 세션 JSONL 기록 파일 경로 |

### 카테고리 8: 런타임 & 플랫폼 (Runtime)

| 변수 | 용도 |
|------|------|
| `NODE_OPTIONS` | Node.js 런타임 플래그 (예: `--max-old-space-size=4096`) |
| `CLAUDE_CODE_HOST_PLATFORM` | 호스트 플랫폼 재정의 (`"win32"`, `"darwin"`, `"linux"`) |

### 설정 파일로 환경 변수 고정하기

매번 `export`하지 않고 settings.json의 `env` 필드로 고정할 수 있다:

```json
// ~/.claude/settings.json
{
  "env": {
    "DISABLE_AUTO_COMPACT": "1",
    "BASH_MAX_OUTPUT_LENGTH": "30000",
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "4096"
  }
}
```

### 실무 팁: 환경 변수 활용

- **CI/CD에서는 `CLAUDE_CODE_REMOTE=1`**: 타임아웃 확장과 대화형 프롬프트 억제가 자동화에 필수적이다.
- **비용 제어**: `CLAUDE_CODE_MAX_OUTPUT_TOKENS`로 응답 길이를 제한하면 비용을 관리할 수 있다.
- **디버깅**: `CLAUDE_CODE_JSONL_TRANSCRIPT`로 세션 기록을 남겨 문제 추적에 활용한다.
- **프라이버시**: `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1`로 불필요한 네트워크 요청을 차단한다.

---

## 6. 컨텍스트 윈도우 관리와 컴팩션

### 컨텍스트 윈도우란?

Claude가 한 번에 처리할 수 있는 토큰의 총량이다. 메모리 파일, 대화 기록, 도구 출력이 모두 이 윈도우 안에 들어가야 한다.

### 자동 컴팩션 (Auto Compaction)

컨텍스트 윈도우가 가득 차면 Claude Code는 자동으로 **컴팩션(압축)**을 실행한다:

1. 이전 대화 내용을 요약
2. 핵심 정보만 남기고 세부 내용 제거
3. 메모리 파일(CLAUDE.md)은 항상 유지

```
[세션 시작] -> [대화 진행] -> [컨텍스트 95% 도달] -> [자동 컴팩션] -> [요약본 + 계속 진행]
```

### 관련 설정과 환경 변수

| 제어 방법 | 설명 |
|----------|------|
| `DISABLE_AUTO_COMPACT=1` | 자동 컴팩션 비활성화 (수동 관리) |
| `CLAUDE_CODE_MAX_CONTEXT_TOKENS` | 컨텍스트 윈도우 크기 직접 제한 |
| 훅: `PreCompact` / `PostCompact` | 컴팩션 전/후 커스텀 로직 실행 |

### 파일 크기 제한

| 항목 | 값 |
|------|---|
| CLAUDE.md 권장 최대 크기 | **40,000자** (`MAX_MEMORY_CHARACTER_COUNT`) |
| 초과 시 | 경고 표시, 전체 내용이 읽히지 않을 가능성 |

### 실무 팁: 컨텍스트 관리

- **CLAUDE.md는 간결하게**: 40,000자 미만을 유지한다. 길어지면 `@include`로 분리한다.
- **경로 타겟팅 활용**: `.claude/rules/`의 frontmatter 경로 지정으로 불필요한 규칙 로딩을 방지한다.
- **긴 세션 주의**: 대화가 길어지면 컴팩션으로 초기 맥락이 손실될 수 있다. 중요한 지시는 CLAUDE.md에 넣어야 항상 유지된다.
- **자동 컴팩션 비활성화 주의**: `DISABLE_AUTO_COMPACT=1`을 사용하면 컨텍스트 초과 시 에러가 발생할 수 있다.

---

## 7. 메모이제이션 최적화

### 메모리 파일 캐싱

Claude Code는 세션 동안 발견된 메모리 파일 목록을 **메모이제이션(캐시)**한다:

```
[세션 시작]
    |
    v
[getMemoryFiles() 호출] --> 파일 시스템 탐색 --> 결과 캐시
    |
    v
[이후 참조] --> 캐시에서 즉시 반환 (파일 시스템 재탐색 없음)
```

### 캐시 갱신 방법

| 방법 | 설명 |
|------|------|
| `/memory` 명령어 | 메모리 에디터를 열고, 저장 시 자동 리로드 |
| 세션 재시작 | 새 세션에서 전체 재탐색 |
| 파일 편집 요청 | "CLAUDE.md에 ~~ 추가해줘"라고 하면 Claude가 적절한 파일을 찾아 작성 |

### 메모이제이션이 중요한 이유

- 매 도구 호출마다 파일 시스템을 탐색하면 성능이 저하된다.
- 특히 깊은 디렉토리 구조나 네트워크 마운트된 파일 시스템에서 효과가 크다.
- 세션 중 CLAUDE.md 파일을 추가/삭제하면 `/memory` 또는 세션 재시작이 필요하다.

### 어셈블된 메모리의 동작 방식

로드된 모든 메모리 파일은 하나의 블록으로 어셈블되며, 다음 접두사가 붙는다:

> "지침은 기본 동작을 **재정의**하며 정확히 따라야 함"

이 의미는:
- CLAUDE.md에 작성된 내용은 Claude의 기본 동작보다 우선한다.
- 프로젝트 규칙을 강제할 수 있다.
- 특정 작업을 제한하거나 도메인 지식을 주입할 수 있다.

---

## 8. 실무 활용: 효과적인 설정 전략

### 효과적인 CLAUDE.md 작성법

#### 포함해야 할 것

```markdown
# 좋은 CLAUDE.md 예시

## 명령어 (정확한 전체 호출)
- 빌드: `pnpm run build`
- 테스트 (전체): `pnpm test`
- 테스트 (단일): `pnpm test -- --grep "테스트명"`
- 린트: `pnpm run lint --fix`
- 타입 체크: `pnpm run typecheck`

## 아키텍처 결정사항
- 모노레포 (pnpm workspace)
- packages/core: 비즈니스 로직
- packages/api: REST API (Express)
- packages/web: 프론트엔드 (Next.js App Router)
- packages/shared: 공유 타입 & 유틸리티

## 코딩 컨벤션
- 네이밍: camelCase (변수/함수), PascalCase (타입/클래스)
- 파일명: kebab-case
- 임포트 순서: 외부 -> 내부 -> 상대경로
- Zod 스키마로 런타임 검증 필수

## 회피할 패턴
- `any` 타입 사용 금지 -> `unknown` + 타입 가드
- `console.log` 금지 -> logger 라이브러리 사용
- 직접 DB 쿼리 금지 -> Repository 패턴 사용

## 환경 요구사항
- Node.js 20+
- pnpm 9+
- Docker (로컬 DB용)
- .env.local 파일 필요 (템플릿: .env.example)
```

#### 포함하지 말아야 할 것

```markdown
# 나쁜 CLAUDE.md 예시 (이렇게 하지 말 것)

- TypeScript의 기본 문법을 설명하는 내용
- "깨끗한 코드를 작성해주세요" (너무 모호하고 당연함)
- API_KEY=sk-abc123... (보안 위험!)
- 매일 변경되는 배포 버전 정보
```

### 프로젝트 설정 전략: 단계별 가이드

#### Step 1: 프로젝트 초기화

```bash
# /init 명령어로 자동 생성하거나 수동으로 구성
mkdir -p .claude/rules
touch CLAUDE.md
touch .claude/settings.json
```

#### Step 2: 계층 분리 설계

```
CLAUDE.md                          # 핵심만 (명령어, 아키텍처, 기본 규칙)
├── @./docs/architecture.md        # 상세 아키텍처 (include)
└── .claude/
    ├── settings.json              # 팀 공유 설정
    ├── settings.local.json        # 개인 설정 (.gitignore)
    └── rules/
        ├── api-rules.md           # paths: ["src/api/**"]
        ├── frontend-rules.md      # paths: ["src/web/**", "*.tsx"]
        ├── testing-rules.md       # paths: ["**/*.test.*"]
        └── git-workflow.md        # 전체 적용 (paths 없음)
```

#### Step 3: .gitignore 설정

```gitignore
# Claude Code 개인 파일
CLAUDE.local.md
.claude/settings.local.json
```

#### Step 4: 팀 온보딩 문서화

프로젝트 README에 다음을 추가:

```markdown
## Claude Code 설정
1. 개인 설정이 필요하면 `CLAUDE.local.md`를 생성하세요 (.gitignore 대상)
2. 프로젝트 규칙은 `.claude/rules/`에서 확인하세요
3. 개인 설정 재정의: `.claude/settings.local.json`
```

### 종합 설정 체크리스트

```
[ ] CLAUDE.md 작성 (40,000자 미만)
[ ] .claude/rules/ 디렉토리 구성 (필요 시)
[ ] .claude/settings.json 작성 (팀 공유)
[ ] .gitignore에 CLAUDE.local.md, settings.local.json 추가
[ ] @include로 기존 문서 참조 (중복 제거)
[ ] Frontmatter 경로 타겟팅 설정 (대규모 프로젝트)
[ ] 환경 변수 env 필드 설정 (반복 export 제거)
[ ] /init 또는 /memory 명령어로 초기 설정 검증
```

---

## 부록: 명령어 빠른 참조

| 명령어 | 기능 |
|--------|------|
| `/init` | 프로젝트 CLAUDE.md 자동 생성 |
| `/memory` | 메모리 에디터 열기 (로드된 파일 목록 및 편집) |
| `/config` | 설정 UI 열기 (모든 범위의 활성 설정 표시) |
| `--bare` 플래그 | 자동 발견 스킵, `--add-dir`만 사용 |

## 부록: 메모리 로딩 비활성화 옵션

| 방법 | 효과 |
|------|------|
| `CLAUDE_CODE_DISABLE_CLAUDE_MDS=1` | 모든 메모리 파일 로딩 비활성화 |
| `--bare` 플래그 | 자동 발견 스킵, `--add-dir`만 사용 |
| `claudeMdExcludes` 설정 | Glob 패턴으로 특정 파일만 제외 |

---

> **문서 작성일**: 2026-03-31
> **소스**: Claude Code 공식 문서 (concepts/memory-context, configuration/claudemd, configuration/settings, configuration/environment-variables)
