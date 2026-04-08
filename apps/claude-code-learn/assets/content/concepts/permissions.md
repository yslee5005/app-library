<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/concepts/permissions -->

# Claude Code Permissions

## 개요
Claude Code는 로컬 머신에서 도구를 실행합니다. 권한 시스템은 어떤 작업이 자동으로 수행되고 어떤 작업이 승인을 요청할지를 제어합니다.

## 권한이 적용되는 영역

### 1. 파일 작업
파일 읽기, 편집, 작성 -- `Read`, `Edit`, `Write` 도구 통해 로컬 파일시스템 접근

### 2. Bash 명령어
셸 명령어 실행 -- 설치, 빌드, git 작업, 임의 스크립트 포함

### 3. MCP 도구 호출
연결된 MCP 서버의 도구 -- 데이터베이스 쿼리, API 호출, 브라우저 자동화 포함

---

## 권한 모드 상세 설명

### default (기본값)
- **동작**: "각 도구 호출 평가 후 부작용이 있는 작업은 확인 요청"
- **자동 승인**: 읽기 전용 작업 (파일 읽기, 검색)
- **확인 필요**: 셸 명령어, 파일 편집, 네트워크 요청
- **추천**: 일상적 사용

### acceptEdits
- **동작**: 파일 편집/작성 자동 승인, Bash 명령어는 확인 필요
- **추천**: 파일 변경은 신뢰하나 셸 명령어는 검토하고 싶을 때

### plan (읽기 전용 계획 모드)
- **동작**: 파일 읽기, 검색만 가능 -- 모든 변경 작업 차단
- **기능**: 문제 분석 및 계획 생성 가능, `ExitPlanMode` 도구로 권한 요청 가능
- **추천**: 낯선 코드베이스 탐색이나 대규모 변경 설계

### bypassPermissions (모든 권한 체크 제거)
- **동작**: 모든 도구 호출 즉시 실행, 확인 프롬프트 없음
- **경고**: 자동화된 스크립트 워크플로우에서만 사용 (미리 감사 완료)
- **금지**: 대화형 세션에서의 사용

### dontAsk
- **동작**: `bypassPermissions`와 유사하지만 다른 내부 경로 사용
- **추천**: 스크립트/비대화형 시나리오

### auto (실험용 - feature-gated)
- **동작**: 보조 AI 분류기가 대화 기록에 비추어 도구 호출 평가
- **결과**: 자동 승인 또는 인간 프롬프트로 확대
- **가용성**: `TRANSCRIPT_CLASSIFIER` 플래그 활성화 시에만

---

## 권한 모드 설정 방법

### 1. CLI 플래그
```bash
claude --permission-mode acceptEdits
claude --permission-mode bypassPermissions
claude --permission-mode plan
```

### 2. /permissions 명령어
세션 중간에 변경 (재시작 불필요):
```
/permissions
```
대화형 메뉴에서 새 모드 선택 -> 남은 세션에 적용

### 3. settings.json (지속적 기본값)
```json
{
  "defaultMode": "acceptEdits"
}
```
유효한 값: `"default"`, `"acceptEdits"`, `"bypassPermissions"`, `"plan"`, `"dontAsk"`

---

## 세부 권한 규칙 (Allow/Deny 목록)

### 규칙 구성 요소

| 필드 | 설명 |
|------|------|
| `toolName` | 도구 이름 (예: `"Bash"`, `"Edit"`, `"mcp__myserver"`) |
| `ruleContent` | 도구 입력과 매칭될 패턴 (예: Bash 명령어 접두사) |
| `behavior` | `"allow"`, `"deny"`, 또는 `"ask"` |

**평가 순서**: 규칙이 먼저 평가됨 -> 매칭되면 즉시 적용 -> 그 후 권한 모드

### 규칙 출처 및 저장소

| 출처 | 저장 위치 | 범위 |
|------|---------|------|
| `userSettings` | `~/.claude/settings.json` | 현재 사용자의 모든 프로젝트 |
| `projectSettings` | `.claude/settings.json` | 이 프로젝트의 모든 사용자 |
| `localSettings` | `.claude/settings.local.json` | 현재 사용자, 이 프로젝트만 |
| `session` | 메모리 | 현재 세션만 |
| `cliArg` | CLI 플래그 | 현재 호출만 |

### 규칙 예시: 특정 Git 명령어 항상 허용

```json
{
  "permissions": {
    "allow": [
      "Bash(git status)",
      "Bash(git diff *)",
      "Bash(git log *)",
      "Read(*)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)"
    ]
  }
}
```

---

## Bash 권한 시스템 상세

### 패턴 매칭

| 패턴 | 매칭 대상 |
|------|---------|
| `git status` | 정확한 일치만 |
| `git *` | 모든 git 하위명령어 |
| `npm run *` | 모든 npm run 스크립트 |
| `*` | 모든 bash 명령어 (극도로 주의) |

### 복합 명령어
`&&`, `||`, `;`, `|`로 연결된 명령어:
- 각 하위명령어 독립 검사
- 최종 권한은 가장 제한적 결과 (한 개라도 거부되면 전체 거부)

### 연산자 제한사항 (추가 검사 대상)

1. **출력 리다이렉션** (`>`, `>>`) -- 프로젝트 디렉토리 외부로의 리다이렉션
2. **디렉토리 변경** (`cd`) -- 작업 트리 외부로의 이동
3. **제자리 편집** (`sed -i`) -- 파일 수정 추적용 특별 처리

### 항상 차단되는 작업 (권한 모드와 무관)

- `.claude/`, `.git/` 설정 디렉토리 대상 명령어
- 셸 설정 파일 수정 (`.bashrc`, `.zshrc` 등)
- 경로 제한 우회 시도 (크로스플랫폼 경로 트릭)

**참고**: `auto` 모드에서 `classifierApprovable: true`로 표시된 안전 검사는 분류기로 전송됨 (전체 대화 문맥 고려)

---

## MCP 도구 권한

규칙 시스템 적용:
- 전체 MCP 서버 차단 또는 개별 도구만 차단 가능
- `mcp__servername` 사용 시 서버의 모든 도구 차단

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

---

## 안전 권장사항

### 모드 선택 원칙
1. **대화형 세션**: `default` 모드로 시작
2. **새로운 코드베이스 탐색**: `plan` 모드 (분석 후 변경 승인)
3. **신뢰하는 파일 편집**: `acceptEdits` 모드
4. **자동화 워크플로우**: 격리된 환경(컨테이너, CI)에서만 `bypassPermissions` 사용

### 규칙 구성 베스트 프랙티스
- 세부적 allow 규칙 선호 (예: `Bash(git *)`)
- 광범위 모드 확대 피하기
- deny 규칙은 좁게 범위 지정
- `Bash(*)` 같은 무분별한 차단 피하기
- 낯선 저장소 클론 시 `.claude/settings.json` 검토
