# Screens

> 모든 화면은 4 상태(Empty / Loading / Error / Data) 명시 필수. happy path만 정의 시 fix commit 발생률 ↑.

## Screen 1: `<screen_name>`

| State | Visual | Notes |
|---|---|---|
| **Empty** | <설명 + CTA> | first-time UX, 가이드 메시지 포함 |
| **Loading** | `SkeletonLoader` 또는 `CircularProgressIndicator` | 1초 이내 표시 |
| **Error** | `ErrorStateView` + retry 버튼 | network/server fail, 한국어 + 영어 메시지 |
| **Data** | <main content 설명> | golden path |

### 라우팅
- 경로: `/<route>`
- 진입: `context.push('/<route>')` 또는 `context.go('/<route>')`
- 진입 분기: 익명/가입/Pro 별 처리

### Responsive
- compact (< 600): <레이아웃>
- medium (600-839): <레이아웃>
- expanded (≥ 840): <레이아웃>

## Screen 2: `<screen_name>`
<위 형식 반복>

## 참조
- `.claude/rules/responsive.md`
- `.claude/rules/error-handling.md`
- `.claude/rules/flutter-layout.md`
