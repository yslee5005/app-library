<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/guides/multi-agent -->

# Multi-agent Workflows

## 개요
Claude Code는 서브 에이전트를 생성하여 복잡한 작업을 병렬화할 수 있습니다. "Parallelize complex tasks by having Claude spawn and coordinate sub-agents"라는 방식으로 독립적인 Claude 인스턴스들이 동시에 실행됩니다.

## 서브 에이전트 작동 원리

에이전트 도구 사용 시 새로운 Claude 인스턴스가 시작되며, 각 에이전트는:
- 독립적 컨텍스트 윈도우 제공
- 전문화된 시스템 프롬프트 할당
- 구성 가능한 도구 권한 보유
- 추가 서브 에이전트 생성 가능 (중첩 제한 있음)

## Agent 도구 매개변수

```
- description: 3-5단어 요약
- prompt: 완전한 작업 설명
- subagent_type: 특화된 에이전트 타입 (선택사항)
- run_in_background: 비동기 실행 여부
- isolation: "worktree" 옵션으로 git 격리 제공
```

## 사용 시점

다음과 같은 상황에서 에이전트 활용이 효과적입니다:
- **Independent parallel tasks**: 독립적으로 수행 가능한 병렬 작업
- **Specialized work**: 전문화된 작업
- **Long-running tasks**: 장시간 실행 작업
- **Isolated exploration**: 격리된 탐색

단순 작업에는 사용하지 않습니다.

## 포그라운드 vs 백그라운드

**포그라운드**: Claude가 결과 대기 후 진행
**백그라운드**: 비동기 실행, 다른 작업 동시 진행, 완료 시 알림 수신

## 컨텍스트 격리

각 서브 에이전트는 "clean context window"로 시작하며, 부모의 대화 기록 자동 상속 불가. 프롬프트에 충분한 맥락 제공 필수입니다.

## 지속적 메모리

에이전트 유형별 메모리 위치:
- 사용자 범위: `~/.claude/agent-memory/`
- 프로젝트 범위: `.claude/agent-memory/`
- 로컬 범위: `.claude/agent-memory-local/`

## Worktree 격리

`isolation: "worktree"` 설정 시 에이전트가 격리된 git worktree 사본에서 작업하며, 변경 사항 검토 후 병합 가능합니다.

## 제한사항

- 서브 에이전트는 독립적 권한 모드 사용
- 백그라운드 에이전트는 부모 abort controller 연결 불가
- 팀원 생성 불가 (평면 구조)
- 재귀적 포킹 방지
- 결과는 100,000자 제한
