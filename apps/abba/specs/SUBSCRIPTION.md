# SUBSCRIPTION.md — Abba Pro 결제 시스템

> Abba Pro 구독의 **가격, 결제 흐름, Apple/RevenueCat 설정, 코드 레퍼런스** 단일 소스.
> Version 1.0 · Last updated 2026-04-20

---

## 1. 가격 체계

| 플랜 | US 가격 | 월 환산 | 절약 | 비고 |
|------|---------|--------|------|------|
| **Monthly** | $6.99 / mo | $6.99 | - | 정가 |
| **Yearly** | $49.99 / yr | $4.17 | **40%** | Save 40% 메시지 |
| 런칭 프로모션 | $3.99 / mo (3개월) | - | 43% | 출시 후 3개월 한정 |

### 1.1 글로벌 가격

- **기준 통화**: USD (US 가격이 Apple tier 결정 기준)
- **자동 PPP 매핑**: Apple이 175+ 국가에 PPP(구매력평가) 기반 자동 가격 조정
- **앱 UI 표시 가격**: ARB 파일에 하드코딩 (35개 언어)
  - 로컬 통화 값은 Apple tier 근사값 (오차 ~$0.10)
  - 실제 결제 시 Apple 결제 시트가 정확한 tier 가격 표시

### 1.2 Product ID (App Store Connect)

| 플랜 | Product ID | Apple ID |
|------|-----------|----------|
| Monthly | `com.ystech.abba.monthly` | 6762689920 |
| Yearly | `com.ystech.abba.yearly` | (등록 후 확인) |

### 1.3 Subscription Group

- **Name**: `Abba Pro`
- **Group ID**: `22043701`
- Monthly/Yearly 동일 그룹 → 유저가 Monthly↔Yearly 업/다운그레이드 가능

---

## 2. App Store Connect 설정

### 2.1 Subscription Group — Billing Grace Period

| 항목 | 값 | 이유 |
|------|-----|------|
| **Grace Period Duration** | **16 days** | Apple 추천, 시니어 대응 시간 확보 |
| **Eligible Subscribers** | All Renewals | free→paid + paid→paid 모두 커버 |
| **Server Environments** | **Production and Sandbox** | 실 유저 + 테스트 모두 적용 |

**효과:** 자동 갱신 결제 실패 시 16일간 Apple이 자동 재결제 시도, 유저는 계속 Premium 기능 사용 가능 → 이탈 방지.

### 2.2 Tax Category

- **Match to parent app** (기본값 유지) — Abba는 종교/라이프스타일 앱이라 특수 카테고리 없음

### 2.3 Localization (Monthly/Yearly 각 31개 언어)

- Display Name: `Abba Pro Monthly` / `Abba Pro Yearly` + 언어별 현지 표기
- Description: `기도 · 성경 · 묵상` 축 SEO 키워드 중심
- 전체 localization 값은 `specs/SPEC-L10N-35.md` 참고

### 2.4 Availability

- **All countries or regions selected** (175+)
- Remove from Sale 사용 X (전 세계 출시)

### 2.5 Review Information

**Monthly Review Notes:**
```
Abba Pro Monthly unlocks unlimited prayer recordings with matched 
scripture responses, guided daily devotionals (QT), and original 
Hebrew/Greek word insights for deeper Bible study. 
Renews monthly at $6.99.

Product ID: com.ystech.abba.monthly

Note: Sign-in is optional (for cross-device sync only). 
The subscription purchase flow does NOT require sign-in.

How to test:
1. Launch the app (opens directly to Home — no account creation needed)
2. Tap Settings tab (bottom right)
3. Tap "Membership"
4. Tap "Monthly" tab
5. Tap "Get Started" button
6. Sandbox purchase sheet will appear
```

**Yearly Review Notes:**
```
Abba Pro Yearly unlocks unlimited prayer recordings with matched 
scripture responses, guided daily devotionals (QT), and original 
Hebrew/Greek word insights for deeper Bible study.
Renews yearly at $49.99 (~$4.17/month, 40% savings vs monthly).

Product ID: com.ystech.abba.yearly

Note: Sign-in is optional (for cross-device sync only).
The subscription purchase flow does NOT require sign-in.

How to test:
1. Launch the app (opens directly to Home — no account creation needed)
2. Tap Settings tab (bottom right)
3. Tap "Membership"
4. Tap "Yearly" tab
5. Tap "Get Started" button
6. Sandbox purchase sheet will appear
```

**Review Screenshots:**
- Monthly: `~/Desktop/abba_review_monthly.png` (1290×2796, Monthly 탭 활성)
- Yearly: `~/Desktop/abba_review_membership.png` (1290×2796, Yearly 탭 활성)

---

## 3. RevenueCat 설정

### 3.1 프로젝트

- **Project**: Abba (단일 프로젝트, 프로덕션/샌드박스 자동 분기)
- **Apps**: iOS (`com.ystech.abba`) + Android (`com.ystech.abba` 추후)
- **Entitlement ID**: `abba_pro` (Monthly/Yearly 둘 다 이 entitlement에 연결)

### 3.2 API Keys

- **iOS Key**: `appl_*` (`.env.client` > `REVENUECAT_API_KEY`)
- **Android Key**: `goog_*` (추후)
- **저장 위치**: `apps/abba/.env.client` (gitignored) → `scripts/prepare_env.sh`로 `.env.runtime` 생성

### 3.3 Offerings

- **Current Offering**: `default`
- **Packages**:
  - `$rc_monthly` → `com.ystech.abba.monthly`
  - `$rc_annual` → `com.ystech.abba.yearly`

---

## 4. 결제 흐름 (유저 관점)

### 4.1 구매 시나리오

```
[Home 화면]
  ↓ Settings 탭 (우하단)
[Settings]
  ↓ "Membership" 항목
[Membership 페이지]
  ↓ Monthly/Yearly 탭 선택 (기본: Yearly)
  ↓ "Get Started" 버튼 탭
[Apple 결제 시트]  ← sandbox 또는 production (빌드 환경에 따라 자동)
  ↓ Face ID / 암호 인증
[결제 완료]
  ↓ RevenueCat webhook → customerInfo 업데이트
  ↓ isPremiumProvider invalidate
[Membership 페이지 — Active 상태로 전환]
  ✅ "Membership Active" 표시
  ✅ Unlimited Prayer & QT 해제
  ✅ Premium 블러 해제 (AI 조언, 기도문, 원어 해석)
```

### 4.2 갱신 흐름

- **정상 갱신**: Apple 자동 결제 성공 → RevenueCat이 새 만료일 반영 → 유저 영향 없음
- **결제 실패 (Grace Period 활성)**:
  1. Apple이 자동 재결제 시도 시작 (최대 16일)
  2. 유저는 **계속 Premium 기능 사용 가능**
  3. `entitlement.isActive` → `true` 유지
  4. 성공 시 → 정상 갱신
  5. 16일 후에도 실패 → `isActive` → `false`, Free 플랜 전환
- **Restore Purchases**: Membership 페이지에서 `Restore purchase` 탭 → RevenueCat이 Apple ID로 기존 구독 복원

### 4.3 구독 변경 (Monthly ↔ Yearly)

- 동일 Subscription Group 내이므로 **즉시 전환 가능**
- Monthly → Yearly 업그레이드: 즉시 Yearly 전환, 남은 Monthly 일수는 환불 (Apple 처리)
- Yearly → Monthly 다운그레이드: 현재 Yearly 만료 시점에 Monthly로 전환

### 4.4 Grace Period UX (billing-issue 배너)

결제 실패 → Grace Period 진입 시 유저가 **아무 경고 없이 16일 뒤 Free 전환**되던 문제 대응 (LAUNCH_CHECKLIST §17):

- **감지**: `RevenueCatSubscriptionService.getActiveSubscription()`이 `entitlement.billingIssueDetectedAt`(ISO string) 를 파싱해 `ActiveSubscriptionInfo.billingIssueDetectedAt: DateTime?` 로 노출
- **판정**: `ActiveSubscriptionInfo.isInGracePeriod == (billingIssueDetectedAt != null && willRenew)` — `willRenew == false`는 명시적 취소 → 기존 "Cancellation notice" 분기가 담당
- **카운터**: `gracePeriodDaysRemaining = billingGracePeriodDays(=16) - elapsedDays` (0으로 클램프)
- **UI**: `apps/abba/lib/features/settings/view/membership_view.dart` `_buildGraceBanner` — Active 카드 안, plan/billing 라인 바로 아래. 톤은 기존 Expired 배너와 동일 팔레트 (softPeach 배경 + softGold 테두리, ⚠️ 이모지). 본문은 `billingIssueBody(days)` (35 locale). CTA `billingIssueAction` 버튼은 `_manageSubscription()` 재사용 → RevenueCat Customer Center → Apple 구독 관리 시트로 이동해 결제수단 교체 가능
- **자동 해제**: 결제 해결 시 RevenueCat가 다음 CustomerInfo 업데이트에서 `billingIssueDetectedAt`을 `null`로 보내므로 배너가 자연스럽게 사라짐
- **백엔드**: SDK 자동 재시도 16일 + `_updateStatus()`의 `isActive` 평가는 그대로 → 서버사이드 변경 불필요
- **회귀 테스트**: `packages/subscriptions/test/active_subscription_info_test.dart` (getter 경계값) + `apps/abba/test/features/membership_grace_banner_test.dart` (배너 렌더/숨김)

---

## 5. 코드 레퍼런스

### 5.1 초기화

`apps/abba/lib/main.dart` — 익명 로그인 직후 RevenueCat configure:
```dart
final subscriptionService =
    RevenueCatSubscriptionService(apiKey: AppConfig.revenueCatApiKey);
// ... overrides ...
await authRepo.signInAnonymously();
final userId = Supabase.instance.client.auth.currentUser?.id;
if (userId != null) {
  await subscriptionService.initialize(userId);  // Purchases.configure() 호출됨
}
```

### 5.2 구매 실행

`apps/abba/lib/features/settings/view/membership_view.dart:395-417` — `_purchase()`:
```dart
final success = _selectedPlan == 1
    ? await service.purchaseYearly()
    : await service.purchaseMonthly();
if (success) {
  ref.invalidate(isPremiumProvider);
}
```

### 5.3 RevenueCat Service

`packages/subscriptions/lib/src/revenuecat_subscription_service.dart`:
- `initialize(userId)` — `Purchases.configure()` 호출 + customer info listener 등록
- `purchaseMonthly()` / `purchaseYearly()` — Offerings에서 해당 package 가져와 `Purchases.purchase()` 호출
- `_updateStatus(info)` — entitlement.isActive 체크로 `SubscriptionStatus` 갱신 (Grace Period 자동 지원)
- `restorePurchases()` — `Purchases.restorePurchases()` 래퍼

### 5.4 UI Premium Gate

`apps/abba/lib/widgets/premium_blur.dart` — 블러 처리 + Pro 잠금 CTA
`apps/abba/lib/widgets/premium_modal.dart` — Pro 소개 모달 + Start Pro 버튼

### 5.5 가격 표시 (동적, RevenueCat)

**구현 완료 (2026-04-21):** 핵심 가격 4개 (`monthlyPrice`, `yearlyPrice`)는 RevenueCat `storeProduct.priceString` 기반 동적 값으로 표시.

- `packages/subscriptions/lib/src/offering_prices.dart` — `OfferingPrices` 모델 (monthly/yearly/yearly-per-month/savings%/currencyCode)
- `packages/subscriptions/lib/src/revenuecat_subscription_service.dart` — `getOfferingPrices()` 구현. `Purchases.getOfferings()` → `current.monthly/annual.storeProduct`에서 가격/통화 추출, yearly-per-month는 `NumberFormat.simpleCurrency` 포맷.
- `apps/abba/lib/providers/providers.dart` — `offeringPricesProvider` (autoDispose FutureProvider)
- `apps/abba/lib/features/settings/view/membership_view.dart` `_buildPlanCard` + `apps/abba/lib/widgets/pro_modal.dart` — `ref.watch(offeringPricesProvider).value` 우선, null 시 ARB fallback

**Fallback 정책:**
- Offering unavailable (네트워크/설정 실패) → `null` 반환 → UI는 ARB 하드코딩 가격(`l10n.monthlyPrice` / `l10n.yearlyPrice`) 표시
- ARB 35-locale 가격 키는 **삭제하지 않고 유지** (fallback 전용)
- `yearlySave`, `yearlySavings`, `launchPromo`, `yearlyPriceMonthly` ARB 키는 현 상태 유지 (Phase 2 대상)

**범위 밖 (향후 Phase):**
- `savingsPercent` 동적 표시 (현재는 `l10n.yearlySave` "Save 40%" 문자열 유지)
- `yearlyPriceMonthlyString` UI 노출 (현재 `OfferingPrices`에 포함되지만 아직 위젯에서 소비 안 함)
- Launch promo 가격 (App Store Connect Introductory Offer로 별도 관리)

---

## 6. 테스트 방법

### 6.1 Sandbox Tester 계정

1. **App Store Connect > Users and Access > Sandbox > Testers > +**
2. 가짜 이메일 + 비밀번호 + Region (US 권장)
3. **iPhone > 설정 > App Store > Sandbox Account** 에 로그인 (실 Apple ID는 로그아웃 X)

### 6.2 실기기 테스트 (iOS 26 JIT 제약)

```bash
cd /Users/yonghunjeong/Documents/ys/app-library
flutter run --profile apps/abba  # 실기기 (JIT 안 쓰므로 profile 사용)
```

테스트 플로우:
1. 앱 실행 → Settings → Membership
2. Monthly/Yearly 탭 선택 → Get Started
3. Apple 결제 시트 뜨면 **`[Environment: Sandbox]`** 표시 확인
4. Sandbox tester로 결제
5. 로그에서 `[SUBSCRIPTION] yearly purchase completed, status=SubscriptionStatus.premium` 확인
6. Membership 페이지가 `Membership Active` 상태로 전환되는지 확인

### 6.3 Grace Period 테스트

Sandbox에서 Grace Period 시뮬레이션:
- App Store Connect Sandbox 설정에서 **Subscription Renewal Rate** 단축 (5분 = 1달)
- 결제 실패 시나리오: Sandbox tester의 결제 카드를 **Declined**로 설정
- 5분 후 자동 갱신 시도 실패 → Grace Period 진입 → 16일 (실제로는 ~8-16분 시뮬레이션) 동안 유저 상태 확인

---

## 7. 모니터링

### 7.1 필수 모니터링 지표

| 지표 | 확인 위치 | 주기 |
|------|---------|------|
| 구매 성공률 | RevenueCat Dashboard > Charts | 일간 |
| MRR / ARR | RevenueCat Dashboard | 주간 |
| Churn rate | RevenueCat Dashboard | 월간 |
| Grace Period 진입률 | RevenueCat Dashboard > Subscribers | 월간 |
| 결제 실패 로그 | Sentry (`LogCategory.subscription`) | 실시간 알림 |

### 7.2 주요 이벤트 로그

`prayerLog`/`appLogger.subscription`에서 추적:
```
🟢 Purchase initiated: yearly
🟢 yearly purchase completed, status=SubscriptionStatus.premium
🔴 yearly purchase failed (Sentry 보고)
🟢 RevenueCat initialized, status=SubscriptionStatus.free
🟡 Restore purchase initiated
```

### 7.3 알려진 이슈 / Pitfall

- **Purchases has not been configured 크래시**: `initialize()` 호출 누락 시 발생 → `main.dart`에서 사인인 후 반드시 호출 (learned-pitfalls #2)
- **Apple Guideline 3.1.2**: 약관/링크가 구매 버튼 바로 아래에 위치해야 함 (`membership_view.dart`의 `Cancel anytime` 문구 유지)
- **구독 만료 16일 후 Grace Period**: Grace Period 종료 후 group read-only 전환 필요 (learned-pitfalls #2)

---

## 8. 변경 이력

| 날짜 | 변경 | 이유 |
|------|------|------|
| 2026-04-20 | Monthly $7.99 → $6.99, Yearly $59.99 → $49.99 | 시니어 진입 장벽 완화 + "Save 40%" 메시지 정합성 |
| 2026-04-20 | Billing Grace Period 16 days (Production + Sandbox) 활성화 | 결제 실패 유저 이탈 방지 |
| 2026-04-20 | Premium 브랜딩 → Pro 전면 rename (ARB 35개 + Dart 11곳) | App Store "Abba Pro" 메타데이터와 정합성 |
| 2026-04-20 | `RevenueCatSubscriptionService.initialize(userId)` 호출 추가 | Purchases.configure 누락 크래시 수정 |

---

## 9. 참고 링크

- `specs/REQUIREMENTS.md` — 제품 요구사항 (가격 정책 원안)
- `specs/SPEC-L10N-35.md` — 35개 언어 localization 스펙
- `.claude/rules/learned-pitfalls.md` §2 — Subscription / Payment Crash 방지 16항목
- RevenueCat Dashboard: https://app.revenuecat.com
- App Store Connect: https://appstoreconnect.apple.com
