# LAUNCH_CHECKLIST.md — Abba 출시 남은 작업

> 2026-04-20 기준. Sandbox 결제 검증까지 완료.
> 출시 전 반드시 체크해야 하는 항목 + 출시 후 개선 항목.

---

## 🔴 BLOCKER — 심사 제출 필수

### 1. App Store Connect 메타데이터

- [ ] 앱 이름 확정 (`Abba — Prayer & Quiet Time` 권장)
- [ ] 앱 아이콘 1024×1024 디자인 (Morning Garden 스타일, 올리브잎 + Abba 텍스트)
- [ ] 스크린샷 5-10장 제작 (6.7" iPhone 기준, 최소 EN/KO)
- [ ] 앱 설명 (최대 4000자, EN/KO 최소)
- [ ] 키워드 100자 (prayer, christian, bible, QT, devotional, scripture 등)
- [ ] 개인정보 처리방침 페이지 URL (Notion/GitHub Pages/간단 HTML)
- [ ] 지원 URL (이메일도 OK)
- [ ] 연령 등급: 4+ (종교 콘텐츠)
- [ ] 카테고리: Lifestyle > Religion & Spirituality
- [ ] **AI 기능 공시 (Apple 2026 신규 가이드라인)** — 설명에 "AI" 사용 명시

### 2. 앱 빌드 + 업로드

- [ ] `flutter build ios --release --obfuscate --split-debug-info=build/debug-info`
- [ ] Xcode Archive → App Store Connect Upload
- [ ] 업로드 처리 완료 확인 (10-30분)
- [ ] TestFlight 내부 테스트 1회 이상

### 3. Version에 구독 attach

- [ ] App Store Connect > Distribution > 1.0 > In-App Purchases and Subscriptions
- [ ] ☑️ Abba Pro Monthly attach
- [ ] ☑️ Abba Pro Yearly attach
- [ ] Missing Metadata → Ready to Submit 전환 확인

---

## 🟠 MUST — 출시 전 반드시

### 4. 코드 품질 (Phase 5)

- [ ] `flutter analyze` 0 경고 (현재 2 info 경고 — `recording_overlay.dart`, 사전 이슈)
- [x] 하드코딩 문자열 0개 — `settings_view.dart:402` `'Coming soon'` → `l10n.comingSoon` (2026-04-22 `ff6a700`)
- [x] `scripts/check_hardcoded_strings.sh` 통과
- [x] 35개 ARB 파일 동기화 — 312 keys × 35 locale 완벽 일치 (Python JSON 검증 통과). `scripts/check_l10n_sync.sh`는 naive regex false positive 버그 있음 (ARB 값 영어를 키로 오탐)
- [ ] Sentry 마스킹 동작 확인 (기도 텍스트 / 이메일) — 수동 검증
- [ ] RLS 전 테이블 활성화 + COALESCE NULL 방어 — 수동 검증

### 5. 성능

- [ ] 앱 시작 시간 < 3초
- [ ] Supabase 쿼리 응답 < 500ms
- [ ] AI API 응답 < 5초
- [ ] 커뮤니티 피드 스크롤 60fps
- [ ] 메모리 누수 검사 (dispose 패턴 확인)

### 6. 접근성 (시니어 타겟)

- [ ] 모든 버튼 56dp+
- [ ] Body 텍스트 18pt+
- [ ] 색상 대비 WCAG AA (4.5:1)
- [ ] Semantics 라벨 모든 인터랙티브 요소
- [ ] 시스템 폰트 크기 변경 시 UI 안 깨짐

### 7. ~~STT Locale 매핑 보완~~ (폐기)

- [x] ~~현재 5개 → 35개 locale 매핑 추가 (`home_view.dart`)~~ — **`speech_to_text` 미사용, Gemini 오디오 분석으로 대체** (`analyzePrayerFromAudio` — 다국어 자동)

### 8. 결제 UX 보완

- [x] Restore Purchase 버튼 UX 개선 — `_restore()`: 3-state loading + 30s timeout + 4분기(success/nothing/timeout/failed) + in-progress snackbar
- [x] Cancel Subscription 진입점 — `_manageSubscription` RevenueCat Customer Center → App Store fallback
- [x] Monthly ↔ Yearly 업그레이드/다운그레이드 UX — `_upgradeToYearly` 메서드 + active card 내부 upgrade 버튼
- [x] 결제 실패 에러 메시지 개선 — `_handlePurchaseError`: cancelled 무음 / networkError 전용 / generic fallback
- [x] Loading state 개선 (3-state 패턴) — `_purchasing` / `_restoring` flags + mounted guards + finally setState

---

## 🟡 SHOULD — 출시 전 권장

### 9. Apple Guideline 3.1.2 준수

- [ ] Terms of Service + Privacy Policy 링크 **구매 버튼 바로 아래**
- [ ] `Cancel anytime` 문구 확인 (이미 있음)

### 10. Welcome 화면 첫 실행 감지

- [x] 첫 실행 시 `/welcome` 자동 표시 (`initialLocation` 로직) — `main.dart:225-238` SharedPreferences `has_seen_welcome` 체크, `welcome_view.dart:14`에서 완료 시 `true` 저장

### 11. 프로모션

- [ ] Launch Promo $3.99/3개월 — Introductory Offer 설정 (App Store Connect)

### 12. Subscription Group App Display Name (선택)

- [ ] 필요 시 31개 언어로 그룹 표시명 (대부분 생략 가능)

---

## 🟢 NICE — 출시 후 개선

### 13. FCM 푸시 알림

- [ ] Firebase 프로젝트 생성
- [ ] `GoogleService-Info.plist` iOS 추가
- [ ] 아침 알림 (5-6시 "오늘의 기도 시간입니다")
- [ ] 스트릭 celebration notifications

### 14. ~~QT Cronjob~~ (폐기)

- [x] ~~Supabase Edge Function (매일 5개 QT 말씀 자동 생성)~~ — **on-demand Gemini 생성으로 대체** (commit `ae8bac3`)
- [x] ~~JSON mock → DB 기반 전환~~ — 불필요 (on-demand 생성 방식)

### 15. 동적 가격 (RevenueCat)

- [x] 35개 ARB 하드코딩 가격 → `package.storeProduct.priceString` 동적 가격 마이그레이션 (monthly/yearly 핵심 가격, ARB fallback 유지) — 2026-04-21

### 16. Android 출시

- [ ] Google Play Console 등록
- [ ] Android RevenueCat 키 추가 (`.env.client` `REVENUECAT_ANDROID_KEY`)
- [ ] Play Store 자산 (스크린샷, 아이콘 512×512, feature graphic 1024×500)
- [ ] 콘텐츠 등급 신청

### 17. 결제 견고성

- [x] `completePurchase()` try-catch 강화 — RevenueCatSubscriptionService 전 메서드 try-catch 커버 (2026-04-22 검증)
- [ ] Webhook JWS 디코딩 에러 핸들러 — 서버사이드 Edge Function 작업 (앱 범위 외)
- [x] 30초 복원 타임아웃 — `membership_view.dart:698` 구현 완료
- [x] Grace Period 만료 후 자동 다운그레이드 UX — Membership 페이지에 billing-issue 배너 + 결제수단 업데이트 CTA 구현 (`membership_view.dart` `_buildGraceBanner`, 35 locale l10n, 2026-04-21)

---

## 📊 총계

| 카테고리 | 항목 수 | 추정 시간 |
|---------|---------|----------|
| 🔴 BLOCKER | 14 | 1-2주 (디자인 포함) |
| 🟠 MUST | 25+ | 3-5일 |
| 🟡 SHOULD | 6 | 1일 |
| 🟢 NICE | 다수 | 출시 후 |

---

## 참고

- `specs/SUBSCRIPTION.md` — 결제 시스템 상세
- `specs/SPEC-L10N-35.md` — 35개 언어 localization
- `.claude/rules/learned-pitfalls.md` §2 — Subscription/Payment Crash 방지
- `QA_CHECKLIST.md` — 화면별 QA 283 항목
