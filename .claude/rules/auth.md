---
paths: ["apps/**", "**/auth*"]
---

# Anonymous-First 인증

모든 앱은 로그인 없이 시작. 클라우드 저장은 Supabase 익명 계정으로 자동 처리.

## 원칙
1. 로그인 화면 없음 — Welcome → 바로 Home
2. `signInAnonymously()` 앱 시작 시 자동 호출
3. 익명 UUID로 Supabase 저장 (RLS 정상)
4. 구독: RevenueCat anonymous ID (앱 계정 불필요)
5. Settings에서 Apple/Google/Email 연결 (선택)
6. `linkIdentity()` 시 익명 데이터 → 실제 계정 자동 병합

## 로그인이 필요한 유일한 순간
- 기기 변경 시 데이터 이전
