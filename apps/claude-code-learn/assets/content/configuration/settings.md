<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/configuration/settings -->

# Claude Code Settings

## Overview
Claude Code의 동작을 JSON 설정 파일을 통해 다양한 범위(scope)에서 계층적 우선순위로 구성하는 방법을 설명합니다.

## Settings 파일 위치

### Global (User Level)
**경로:** `~/.claude/settings.json`

모든 Claude Code 세션과 프로젝트에 보편적으로 적용됩니다. 모델 선택, 테마, 정리 정책 등 개인 선호도를 위한 설정입니다.

### Project Level (Shared)
**경로:** `.claude/settings.json` (프로젝트 루트)

버전 관리에 체크인하여 팀 전체 일관성을 유지합니다. 권한 규칙, 훅 구성, MCP 서버, 환경 변수 등 모든 프로젝트 협업자에게 적용되어야 할 설정을 관리합니다.

### Local Level (Personal Project)
**경로:** `.claude/settings.local.json` (프로젝트 루트)

버전 관리에서 제외됩니다 (`.gitignore`에 자동 추가). 특정 프로젝트 내에서 설정을 공유하지 않고 개인적으로 재정의할 수 있습니다.

### Managed Level (Enterprise)
**경로:** 플랫폼별 시스템 위치

MDM, Windows 레지스트리 또는 macOS plist 파일을 통해 관리됩니다. 최고 우선순위를 가지며 사용자나 프로젝트가 재정의할 수 없습니다.

## 설정 접근

Claude Code 세션 중 `/config`를 실행하여 설정 UI Config 탭에 접근할 수 있습니다. 인터페이스는 모든 범위의 활성 설정을 표시하고 편집을 허용합니다. 파일이 변경되면 설정이 자동으로 다시 로드됩니다.

## Settings 우선순위 계층

설정은 병합되며 나중 소스가 이전 소스를 재정의합니다:

```
Plugin defaults → User settings → Project settings → Local settings → Managed settings
```

Managed settings는 항상 최종 우선순위를 가지며 재정의할 수 없습니다.

## 전체 Settings 참조

### Core Settings

#### model
- **유형**: `string` | 모든 scope에서 사용 가능
- 기본 모델을 지원되는 provider 모델 ID로 재정의
- **예시**: `"claude-opus-4-5"`

#### permissions
- **유형**: `object` | 모든 scope에서 사용 가능
- 도구 접근 및 상호작용 모드 제어
- **필드**: `allow`, `deny`, `ask` (규칙 배열), `defaultMode` (문자열), `disableBypassPermissionsMode`, `additionalDirectories`
- **모드**: `"default"`, `"acceptEdits"`, `"plan"`, `"bypassPermissions"`

#### hooks
- **유형**: `object` | 모든 scope에서 사용 가능
- 도구 작업 전/후에 사용자 정의 셸 명령 실행
- **지원 이벤트**: `PreToolUse`, `PostToolUse`, `Notification`, `UserPromptSubmit`, `SessionStart`, `SessionEnd`, `Stop`, `SubagentStop`, `PreCompact`, `PostCompact`
- matcher 패턴 및 명령 사양 포함

#### cleanupPeriodDays
- **유형**: `integer` (음이 아닌 정수) | **기본값**: `30` | 모든 scope
- 채팅 기록 보존 기간
- `0`으로 설정하면 세션 지속성을 완전히 비활성화

#### env
- **유형**: `object` | 모든 scope
- 세션에 주입되는 환경 변수
- 값은 문자열로 변환됨

### Model & Access Control

#### availableModels
- **유형**: `string[]` | Managed scope 전용
- 패밀리 별칭, 버전 접두사 또는 전체 ID를 지원하는 엔터프라이즈 허용 목록
- 빈 배열은 기본 모델로만 제한

#### allowedMcpServers / deniedMcpServers
- **유형**: `object[]` | 모든 scope
- MCP 서버용 엔터프라이즈 허용/거부 목록
- 각 항목은 `serverName`, `serverCommand` 또는 `serverUrl` 지정
- 거부 목록이 우선

### Worktree 구성

#### worktree
- **유형**: `object` | 모든 scope
- **필드**: `symlinkDirectories` (`"node_modules"` 같은 디렉토리 배열) 및 `sparsePaths` (더 빠른 모노레포 worktree용)

### 커스터마이징 옵션

#### attribution
- **유형**: `object` | 모든 scope
- **필드**: `commit` (git trailer 텍스트) 및 `pr` (PR 설명 텍스트)
- 빈 문자열은 attribution 제거

#### language
- **유형**: `string` | 모든 scope
- 응답 및 음성 딕테이션의 선호 언어
- 일반 언어 이름 허용

#### defaultShell
- **유형**: `"bash" | "powershell"` | **기본값**: `"bash"` | 모든 scope
- 입력 상자 명령의 기본 셸

### Advanced Features

#### alwaysThinkingEnabled
- **유형**: `boolean` | **기본값**: `true` | 모든 scope
- 확장 사고 기능 제어

#### effortLevel
- **유형**: `"low" | "medium" | "high"` | 모든 scope
- 지원되는 모델의 지속적 사고 예산 수준

#### autoMemoryEnabled
- **유형**: `boolean` | User 및 local scope
- 자동 메모리 읽기/쓰기 활성화/비활성화

#### autoMemoryDirectory
- **유형**: `string` | User 및 local scope
- `~/` 지원하는 사용자 정의 메모리 저장 경로
- 보안상 project settings에서 설정하면 무시됨
- **기본값**: `~/.claude/projects/<sanitized-cwd>/memory/`

#### claudeMdExcludes
- **유형**: `string[]` | 모든 scope
- `CLAUDE.md` 파일 로딩에서 제외할 glob 패턴
- picomatch를 사용하여 절대 경로에 대해 매칭

### Operational Controls

#### disableAllHooks
- **유형**: `boolean` | 모든 scope
- `true`일 때 모든 훅 및 statusLine 실행 비활성화

#### respectGitignore
- **유형**: `boolean` | **기본값**: `true` | 모든 scope
- 파일 선택기가 `.gitignore` 파일을 존중하는지 여부
- `.ignore` 파일은 항상 존중됨

#### sandbox
- **유형**: `object` | 모든 scope
- 도구 실행을 격리; 관리자 설정 필요

#### syntaxHighlightingDisabled
- **유형**: `boolean` | 모든 scope
- diff에서 구문 강조 비활성화

#### prefersReducedMotion
- **유형**: `boolean` | 모든 scope
- 접근성을 위한 애니메이션 감소

### Authentication & Enterprise

#### forceLoginMethod
- **유형**: `"claudeai" | "console"` | Managed scope 전용
- 특정 로그인 방법 강제 (Claude Pro/Max 또는 Console 빌링)

#### apiKeyHelper
- **유형**: `string` | User 및 managed scope
- 정적 키 대신 동적 인증을 제공하는 스크립트 경로

## Managed Settings 배포

### macOS
plist를 `/Library/Preferences/`에 배포하거나 MDM (Jamf, Kandji)을 통해 `com.anthropic.claudecode` 대상으로 배포합니다.

### Windows
레지스트리 키 `HKLM\Software\Anthropic\Claude Code` (시스템 전체) 또는 `HKCU\Software\Anthropic\Claude Code` (사용자별, 낮은 우선순위)에 작성합니다.

### File-Based
플랫폼별 managed 경로에 `managed-settings.json`을 배치합니다. 알파벳순으로 정렬되는 드롭인 구성 프래그먼트를 위해 `managed-settings.d/` 디렉토리를 생성하며, 나중 파일 이름이 우선순위를 가집니다.

## Enterprise-Only Lock Settings

| Setting | 기능 |
|---------|------|
| `allowManagedHooksOnly` | 훅 실행을 managed settings로만 제한 |
| `allowManagedPermissionRulesOnly` | managed 권한 규칙만 시행 |
| `allowManagedMcpServersOnly` | MCP 서버 허용 목록을 managed settings로 제한 |
| `strictPluginOnlyCustomization` | 커스터마이징 표면을 플러그인 전용 소스로 잠금 |

**경고:** 제한 기반 정책을 활성화하기 전에 managed 규칙이 포괄적인지 확인하세요.

## Schema 구성

에디터 자동완성을 위해 settings 파일에 `$schema`를 추가합니다:

```json
{
  "$schema": "https://schemas.anthropic.com/claude-code/settings.json"
}
```
