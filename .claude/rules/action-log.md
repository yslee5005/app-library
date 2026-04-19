---
paths: ["**"]
---

# Action Log Rule

Every session, log all significant requests and actions to the memory action log.

## When to Log
- Feature design/implementation
- Architecture changes (service swap, model change)
- Infrastructure changes (.env, scripts, deploy)
- Bug fixes with root cause
- Refactoring

## What to Log (per action)
1. **요청**: What the user asked (1 line)
2. **카테고리**: Feature / Architecture / Infrastructure / Bugfix / Refactor
3. **패턴**: The workflow pattern used (e.g., "서비스 교체 체인", "MoAI 분석→실행")
4. **파일 수**: Files created/modified/deleted
5. **자동화 가능성**: Could this be automated? How?

## Where to Log
- File: `memory/action_log.md` (append new entries under date header)
- Update pattern summary table if new patterns emerge

## Do NOT Log
- Simple questions/answers
- File reads without changes
- Git operations (commit, push)
