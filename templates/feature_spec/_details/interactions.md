# Interaction Matrix

> Ralph가 한 줄씩 구현. **Pitfall Tags**는 코드 작성 전 `learned-pitfalls.md`에서 해당 카테고리 필독.

## 매트릭스

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-001 | `<screen>` | `[<widget_id>]` | `onTap` | `push('/<route>')` | `analytics.log('event')` | `riverpod-lifecycle` | pending |
| INT-002 | `<screen>` | `[<widget_id>]` | `onChanged` | `notifier.update(value)` | none | `riverpod-lifecycle, optimistic-ui` | pending |
| INT-003 | `<screen>` | `[<widget_id>]` | `onTap` | `ProGate.run(...)` | `invalidate(isPremiumProvider)` | `subscription-crash, riverpod-lifecycle` | pending |

## 컬럼 가이드

- **ID**: `INT-NNN` (3자리 zero-pad, 순서대로)
- **Screen**: 화면 이름 (snake_case)
- **Widget**: 위젯 식별자 — Key 또는 의미적 이름 (`[pray_button]`)
- **Trigger**: `onTap` / `onLongPress` / `onChanged` / `onSubmitted` / `appLifecycle:resume` 등
- **Action**: 어떤 함수/네비게이션 호출
- **Side Effect**: 상태 변경, provider invalidate, analytics, log 등
- **Pitfall Tags**: `learned-pitfalls.md`의 카테고리 (`riverpod-lifecycle`, `subscription-crash`, `i18n`, `multi-tenant` 등)
- **Status**: `pending` / `in_progress` / `done` / `verified`

## Ralph 실행 가이드

1. 매 행 구현 전 Pitfall Tags 카테고리 다시 읽기
2. 구현 → widget test 작성 → 통과 시 status `done`
3. 모든 INT-XXX 완료 → `flutter analyze` + `harness_check.sh`
4. 모두 통과 → status `verified`
