<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/tools/agent -->

# Agent & Task Tools

## 개요

Claude Code는 복잡한 다단계 작업 관리를 위해 두 가지 메타 도구를 제공합니다: 독립적인 하위 에이전트를 실행하는 **Task** 도구와 세션 내 작업 추적용 **TodoWrite** 도구입니다.

---

## Task (Agent tool)

### 목적

전문화된 하위 에이전트를 실행하여 복잡한 작업을 자율적으로 처리합니다. 에이전트는 독립적으로 실행되며 자체 도구 세트를 사용하고 완료 후 단일 결과 메시지를 반환합니다.

### 필수 매개변수

| 매개변수 | 타입 | 설명 |
|---------|------|------|
| `prompt` | string | 자체 포함적 작업 설명 (파일 경로, 줄 번호, 컨텍스트 포함) |
| `description` | string | 3~5단어 레이블 (UI에 표시) |

### 선택 매개변수

| 매개변수 | 타입 | 설명 |
|---------|------|------|
| `subagent_type` | string | 전문화된 에이전트 유형 (예: "code-reviewer", "test-runner") |
| `model` | string | 모델 오버라이드: "sonnet", "opus", "haiku" |
| `run_in_background` | boolean | true 설정 시 백그라운드에서 실행 |
| `isolation` | string | 파일시스템 격리: "worktree" (임시 깃 워크트리) |
| `cwd` | string | 작업 디렉토리 경로 |
| `name` | string | 에이전트 이름 (SendMessage로 주소 지정 가능) |

### 하위 에이전트 작동 방식

1. 에이전트는 시스템 프롬프트와 제공된 프롬프트를 수신
2. subagent_type에 정의된 도구 세트에 접근
3. 작업 완료까지 자율적으로 실행
4. 단일 결과 메시지를 부모에 반환

> **주의**: "발견한 내용을 바탕으로 버그를 수정하세요" 같은 위임 표현은 피하세요. 구체적인 파일 경로, 줄 번호, 지시사항을 포함하세요.

### 적절한 사용 사례

**좋은 사례:**
- 여러 검색 및 읽기가 필요한 개방형 연구
- 코드 변경 후 테스트 스위트 실행 및 실패 분석
- 새로운 에이전트의 독립적 코드 리뷰
- 백그라운드에서 진행 가능한 장시간 작업
- 주 컨텍스트에 불필요한 중간 출력을 생성하는 작업

**부적절한 사례:**
- 특정 파일 읽기 (직접 Read 도구 사용)
- 클래스 정의 검색 (Grep 직접 사용)
- 2~3개 파일 내 검색 (Read 직접 사용)
- 에이전트 타입과 무관한 단순 작업

### 병렬 에이전트 실행

독립적인 작업은 동시 실행 가능:

```javascript
Task({ description: "Run tests", prompt: "Run the full test suite..." })
Task({ description: "Check types", prompt: "Run tsc --noEmit and report errors..." })
```

### 에이전트 재개

실행 중이거나 완료된 에이전트에 후속 메시지 전송:

```javascript
SendMessage({ to: agentName })
```

### 효과적인 프롬프트 작성

**핵심 원칙:**
- "달성 목표와 이유" 명확히
- "이미 시도했거나 배제한 사항" 설명
- "관련 파일, 함수, 시스템" 구체화
- "결과 형식" 지정 (예: "200단어 이내 보고서", "직접 수정")

**조회 vs. 조사:**
- **조회**: 정확한 명령어 제공
- **조사**: 과정이 아닌 질문 제공 (개방형 문제에서는 처방적 단계가 비효율)

---

## TodoWrite

### 목적

현재 세션의 구조화된 작업 목록을 유지관리합니다. Claude는 진행 상황 추적, 다단계 작업 조직화, 가시성 제공을 위해 주도적으로 사용합니다.

### 필수 매개변수

| 매개변수 | 타입 | 설명 |
|---------|------|------|
| `todos` | TodoItem[] | 전체 업데이트된 목록 (각 호출은 전체 목록 교체) |

### TodoItem 스키마

```json
{
  "content": "작업 설명 (명령형)",
  "activeForm": "현재 진행 중 표시 텍스트 (진행형)",
  "status": "pending | in_progress | completed"
}
```

### 상태 값

| 값 | 의미 |
|----|------|
| `pending` | 미시작 |
| `in_progress` | 진행 중 (한 번에 하나만) |
| `completed` | 완료 |

### Claude의 사용 시기

**TodoWrite 사용:**
- 3개 이상의 별개 단계 필요
- 비자명적 작업
- 사용자가 제공한 다중 목록
- 구현 중 발견된 새로운 하위 작업

**TodoWrite 미사용:**
- 단일 단계 작업
- 사소한 작업 (주석 추가, 단일 명령 실행)
- 순수 정보 또는 대화형 응답

### 작업 생명주기

**시작:**
시작 전이 아닌 작업 직후 `in_progress` 표시

**완료:**
즉시 표시 (배치 처리 없음):
- 구현 완료
- 테스트 통과
- 미해결 오류 없음

**블로커 처리:**
해결할 선행 작업을 새로운 `pending` 항목으로 생성

**목록 제거:**
모든 작업이 `completed`일 때 자동 정리

### 예시

```json
{
  "todos": [
    {
      "content": "Add dark mode CSS variables",
      "activeForm": "Adding dark mode CSS variables",
      "status": "completed"
    },
    {
      "content": "Implement theme context provider",
      "activeForm": "Implementing theme context provider",
      "status": "in_progress"
    },
    {
      "content": "Update existing components to use theme",
      "activeForm": "Updating existing components to use theme",
      "status": "pending"
    },
    {
      "content": "Run tests and build",
      "activeForm": "Running tests and build",
      "status": "pending"
    }
  ]
}
```
