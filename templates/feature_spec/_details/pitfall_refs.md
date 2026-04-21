# 이 Feature 관련 함정 체크리스트

> `.claude/rules/learned-pitfalls.md`에서 이 feature와 관련된 카테고리만 link.
> 매 INT-XXX 구현 전 해당 카테고리 다시 읽기.

## 관련 카테고리 (해당 항목만 ✅)

전체 16 카테고리 중 이 feature 작업에 관련된 것:

- [ ] **§1 Riverpod 라이프사이클** — async/dispose/invalidate 사용 시
- [ ] **§2 Subscription / Payment Crash** — 결제, Pro 게이트, RevenueCat 사용 시
- [ ] **§3 Multi-tenant (Supabase)** — 새 테이블, RLS, app_id 스코핑 사용 시
- [ ] **§4 i18n** — 새 텍스트 추가 시 (사실상 항상)
- [ ] **§5 Auth Lifecycle** — 로그인/약관/리프레시 토큰 사용 시
- [ ] **§6 DateTime / Timezone** — 시간/날짜 표시 또는 비교 시
- [ ] **§7 iOS Privacy / Compliance** — 새 권한/SDK 추가 시
- [ ] **§8 Navigation** — go_router 라우트 추가/수정 시
- [ ] **§9 FCM / Webhook** — 알림 또는 Edge Function 사용 시
- [ ] **§10 Optimistic UI** — 좋아요/북마크 같은 즉시성 액션
- [ ] **§11 성능** — 리스트/그룹 쿼리, 비동기 후처리
- [ ] **§12 Color / Design Token** — 새 색상 사용 시
- [ ] **§13 Dead Code Sweep** — 작업 종료 시 항상
- [ ] **§14 Layer Violation** — Repository 패턴 미사용 시
- [ ] **§15 Web 함정** — Next.js 작업 시
- [ ] **§16 Code Generation** — pubspec/freezed/l10n/Pod 변경 시

## 추가 메모

<이 feature 특유의 주의사항 — 위 카테고리에 없는 것만>

## 전체 룰 참조

- `.claude/rules/learned-pitfalls.md` (전체)
- `.claude/rules/multi-tenant-review.md`
- `.claude/rules/error-handling.md`
- `.claude/rules/responsive.md`
