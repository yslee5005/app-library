# LAUNCH_CHECKLIST.md — Abba 출시 남은 작업

> 2026-04-22 기준. 세션 누적 코드 작업 반영.
> 출시 전 반드시 체크해야 하는 항목 + 출시 후 개선 항목.

---

## 🚨 CRITICAL — 가장 먼저 해야 할 것 (출시 불가 블로커)

### 0. AI 하드코딩 응답 플래그 전환

- [x] **`_useHardcodedResponse` const 제거 → `AppConfig.useMockAi` ENV 토글로 전환** (`8cd014e`)
  - 7개 메서드 전부 `AppConfig.useMockAi` 분기 사용 — analyzePrayer / analyzePrayerCore / analyzePrayerFromAudio / analyzePrayerPremium / analyzeMeditation / analyzePrayerCoaching / analyzeQtCoaching
  - `ENABLE_MOCK_AI` env 미설정 시 default `true` (안전 — 실수로 API 비용 발생 방지)
  - `_hardcoded*` mock 함수는 **유지** (fallback 자산 + dev 모드 용도)
  - Sentry 에러 태깅 Pattern A 준수 확인 완료 (learned-pitfalls §17)
- [ ] **실기기 E2E 테스트** — `.env.client` 에 `ENABLE_MOCK_AI=false` 추가 → `prepare_env.sh` 재생성 → Gemini 실응답 확인
  - 테스트 케이스: ko / en / ja 각 1회씩 최소 (35 locale 대표)
  - 응답 시간 실측 (<5초 목표, §5 성능 항목과 연동)
  - JSON 스키마 일치 검증 (hallucination / 필드 누락 여부)
  - Google Cloud Console → Gemini API billing 활성화 선행 필수

### 0-1. Xcode GUI 수동 작업 — ✅ 모두 완료 (`c6fa63c` + `e1aec39`)

- [x] **PrivacyInfo.xcprivacy를 Runner 타겟에 추가** — Ruby `xcodeproj` 스크립트로
  project.pbxproj 직접 등록. PBXBuildFile + PBXFileReference + Group membership +
  Copy Bundle Resources 4곳 모두 wired. `grep "PrivacyInfo.xcprivacy"` 4건 확인.
- [x] **Runner 프로젝트 Localizations 섹션에 35 locale 추가** — `knownRegions` 배열에
  en + Base + 34 locale 등록 (총 36 entries). 35개 `.lproj/InfoPlist.strings` 파일
  전부 variant group으로 등록됨. `grep "InfoPlist.strings"` 40+건 확인.
- **Xcode GUI 수동 작업 불필요** — 사용자는 이 섹션을 skip하고 실 Gemini 테스트로
  바로 진행 가능.

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

### 2. 앱 빌드 + 업로드 (§0 완료 후)

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

### 4. 코드 품질

- [x] 하드코딩 문자열 0개 — UI 레이어 전수 정리 완료 (Ralph #1 `b7e6b8b`)
  - `settings_view.dart:402` `'Coming soon'` → `l10n.comingSoon` (`ff6a700`)
  - `settings_view.dart:155` `'Coming soon'` → `l10n.comingSoon` (`b7e6b8b`)
  - `settings_view.dart:529` `.split(' ')` 해킹 → `l10n.cancel` (`6c4f8d4`)
  - `prayer_heatmap.dart:322/338` `'Less'`/`'More'` → `l10n.heatmapLegendLess/More` (`b7e6b8b`)
- [x] `scripts/check_hardcoded_strings.sh` 통과
- [x] 35개 ARB 파일 동기화 — 312+ keys × 35 locale 완벽 일치 (Python JSON 검증 통과)
  - ⚠️ `scripts/check_l10n_sync.sh`는 naive regex false positive 버그 (Python 검증 사용 권장)
- [ ] `flutter analyze` 0 경고 (현재 2 info — `recording_overlay.dart` pre-existing)
- [x] **테스트 통과율 대폭 개선**: 130 pass / 28 fail → **183 pass / 2 fail** (+53, 남은 2건 E2E)
  - Ralph #4 ~ #6에서 pre-existing 실패 26건 해결
  - 신규 테스트: CachedAiService (10) / ProBlur (3) / Dashboard widgets 4개 (13)
- [ ] Sentry 마스킹 런타임 동작 확인 (기도 텍스트 / 이메일) — 수동 검증
- [ ] RLS 전 테이블 활성화 + COALESCE NULL 방어 — 수동 검증

### 4-1. AI Pending/Retry 아키텍처 (2026-04-23 신규 출시 블로커)

**배경**: AI 실패 시 하드코딩 fallback → 유저 기도 원본 소실 + DB 가짜 데이터 오염. REQUIREMENTS §11 재정의 + DESIGN §10 Pending Flow 구현.

#### Phase 2 — DB Schema Migration
- [ ] `supabase/migrations/20260423_prayers_pending_status.sql` 작성
  - `prayers.ai_status` TEXT 컬럼 (pending/processing/completed/failed)
  - `prayers.last_retry_at` TIMESTAMPTZ
  - `prayers.audio_storage_path` TEXT (기존 있으면 skip)
  - `idx_prayers_pending_per_user` 인덱스
- [ ] `prayer-audio` Storage bucket 생성 SQL + RLS (본인 파일만)
- [ ] **사용자 승인 후** `supabase db push --linked` (DATABASE PROTECTION)

#### Phase 3 — 클라이언트 저장 로직 + 에러 처리
- [ ] `lib/services/ai_analysis_exception.dart` 신규
- [ ] `gemini_service.dart` 4개 catch block: fallback 반환 → throw
- [ ] `prayer_repository.dart`: AI 호출 **전** 즉시 INSERT (ai_status='pending')
- [ ] `ai_loading_view.dart`: `_setErrorState` + 클라 세션 3회 재시도 카운터
- [ ] 에러 뷰 UI (Morning Garden 톤, 56dp+ 버튼)
- [ ] ARB 키 추가 (en + ko): `aiErrorNetwork`, `aiErrorAiService`, `aiErrorRetry`, `aiErrorWaitAndCheck`, `aiErrorHome`
- [ ] 기존 테스트 수정 (`gemini_service_test.dart` — malformed JSON throw 기대)

#### Phase 4 — Edge Function (process_pending_prayer)
- [ ] `supabase/functions/process_pending_prayer/index.ts` 작성
  - JWT 인증 (본인 기도만)
  - 10분 cooldown 체크
  - Gemini API 호출 + status 업데이트
  - 10회 초과 시 `failed` 확정
- [ ] **사용자 승인 후** `supabase functions deploy process_pending_prayer`

#### Phase 5 — Pending UX + 재방문 트리거
- [ ] `home_view.dart`: 진입 시 pending 기도 감지 → Edge Function 호출 → Realtime subscribe
- [ ] 환영 모달: "기다리던 기도 분석이 완성됐어요 🌸 [보기]"
- [ ] `calendar_view.dart`: pending 기도 🌸 표시 (스트릭 유지)
- [ ] 상세 뷰 status별 분기 (completed=read-only, pending/failed=재시도 버튼)
- [ ] ARB: `pendingAnalysisReady`, `pendingAnalyzing`, `viewAnalysisResult`

#### Phase 6 — 음성 재생 + 기도 삭제 UI
- [ ] `prayer_detail_view.dart`: `just_audio` 통합 (큰 재생 버튼)
- [ ] Signed URL로 Storage 접근
- [ ] 상세 뷰 하단 [🗑 삭제] + confirm dialog
- [ ] `settings_view.dart`: "데이터 관리" 섹션 → "내 모든 기도 삭제"
- [ ] ARB: `deletePrayer`, `deleteConfirm`, `dataManagement`, `deleteAllPrayers`

#### Phase 7 — Privacy Policy + App Store Privacy Label
- [ ] Privacy Policy 페이지 (GitHub Pages) 업데이트
  - "음성 녹음 영구 저장 (AI 분석 + 유저 회고)" 섹션 추가
  - "유저 삭제 권한" 명시
- [ ] App Store Connect Privacy Label 변경
  - Audio Data: **Linked to You** (기존 "Not Linked" → 변경)
  - Used for App Functionality
- [ ] 기존 유저에게 정책 변경 고지 (앱 업데이트 후 1회 모달 — 필요시)

#### Phase 8 — 통합 테스트
- [ ] `flutter analyze` 0 issues
- [ ] `flutter test` 통과
- [ ] 실기기 시나리오:
  - 정상 기도 플로우
  - 비행기 모드 → 에러 뷰 + [재시도] 버튼
  - 3회 실패 → "나중에 다시" 메시지
  - 앱 재진입 → Edge Function 자동 호출 + 환영 모달
  - 완성된 기도 상세 뷰에 재시도 버튼 **없음** 확인
  - 기도 삭제 → Storage 파일도 삭제 확인

### 5. 성능

- [ ] 앱 시작 시간 < 3초
- [ ] Supabase 쿼리 응답 < 500ms
- [ ] AI API 응답 < 5초 (§0 전환 후 실측)
- [ ] 커뮤니티 피드 스크롤 60fps
- [ ] 메모리 누수 검사 (dispose 패턴 확인)

### 6. 접근성 (시니어 타겟)

- [ ] 모든 버튼 56dp+
- [ ] Body 텍스트 18pt+
- [ ] 색상 대비 WCAG AA (4.5:1)
- [ ] Semantics 라벨 모든 인터랙티브 요소
- [ ] 시스템 폰트 크기 변경 시 UI 안 깨짐

### 7. ~~STT Locale 매핑 보완~~ (폐기)

- [x] ~~현재 5개 → 35개 locale 매핑 추가 (`home_view.dart`)~~ — **`speech_to_text` 미사용, Gemini 오디오 분석으로 대체** (`analyzePrayerFromAudio` — 35 locale 자동)

### 8. 결제 UX 보완

- [x] Restore Purchase 버튼 UX 개선 — 3-state loading + 30s timeout + 4분기(success/nothing/timeout/failed) + in-progress snackbar
- [x] Cancel Subscription 진입점 — `_manageSubscription` RevenueCat Customer Center → App Store fallback
- [x] Monthly ↔ Yearly 업그레이드/다운그레이드 UX — `_upgradeToYearly` 메서드 + active card 내부 upgrade 버튼
- [x] 결제 실패 에러 메시지 개선 — `_handlePurchaseError`: cancelled 무음 / networkError 전용 / generic fallback
- [x] Loading state 개선 (3-state 패턴) — `_purchasing` / `_restoring` flags + mounted guards + finally setState

---

## 🟡 SHOULD — 출시 전 권장

### 9. Apple Guideline 3.1.2 준수

- [x] Terms of Service + Privacy Policy 링크 **구매 버튼 바로 아래** (`AppConfig.termsUrl` / `AppConfig.privacyUrl` 연결, `membership_view.dart:619, 630`) — 2026-04-22
- [x] `Cancel anytime` 문구 (membership_view.dart:310, 652)
- [x] Help/Terms/Privacy URL을 `AppConfig` getter로 추출 → `.env` 기반 교체 가능 (settings_view.dart + membership_view.dart), 기본값 GitHub Pages fallback — 2026-04-22

### 10. Welcome 화면 첫 실행 감지

- [x] 첫 실행 시 `/welcome` 자동 표시 (`initialLocation` 로직) — `main.dart:225-238` SharedPreferences `has_seen_welcome` 체크

### 11. 프로모션

- [ ] Launch Promo $3.99/3개월 — Introductory Offer 설정 (App Store Connect)

### 12. Subscription Group App Display Name (선택)

- [ ] 필요 시 31개 언어로 그룹 표시명 (대부분 생략 가능)

### 13. iOS 권한 다국어 (Ralph #1 완료)

- [x] `InfoPlist.strings` 35 locale 파일 생성 (`ios/Runner/{locale}.lproj/`)
- [x] `NSMicrophoneUsageDescription` 중립적 영문 + 35 locale 번역
- [x] `NSSpeechRecognitionUsageDescription` 삭제 (speech_to_text 미사용)
- [x] `CFBundleLocalizations` 배열 35 locale 선언
- [ ] **Xcode GUI**: Localizations 섹션에 35 locale 등록 (§0-1 참조)

### 14. iOS Privacy (Ralph #2 완료)

- [x] `PrivacyInfo.xcprivacy` 생성 — NSPrivacyTracking=false, Accessed APIs 4종, Collected Data 6종 (`ios/Runner/PrivacyInfo.xcprivacy`)
- [x] `plutil -lint` 통과
- [ ] **Xcode GUI**: Runner 타겟에 Add Files (§0-1 참조)

---

## 🟢 NICE — 출시 후 개선

### 15. FCM 푸시 알림

- [ ] Firebase 프로젝트 생성
- [ ] `GoogleService-Info.plist` iOS 추가
- [ ] `google-services.json` Android 추가
- [ ] APNs 인증 키 Apple Developer → Firebase 업로드
- [ ] FCM 발송 Edge Function 작성 (맞춤 AI 알림, 커뮤니티 소셜 알림)

**참고**: 로컬 알림(아침/저녁/스트릭)은 이미 35 locale 대응 완료 (`915ff5b`).

### 16. ~~QT Cronjob~~ (폐기)

- [x] ~~Supabase Edge Function (매일 5개 QT 말씀 자동 생성)~~ — **on-demand Gemini 생성으로 대체** (`ae8bac3`)
- [x] ~~JSON mock → DB 기반 전환~~ — 불필요 (on-demand 생성 방식)

### 17. 동적 가격 (RevenueCat)

- [x] 35개 ARB 하드코딩 가격 → `package.storeProduct.priceString` 동적 가격 마이그레이션 (monthly/yearly 핵심 가격, ARB fallback 유지) — `ab34054`

### 18. Android 출시

- [x] **`android/app/build.gradle.kts` release signingConfig 설정** — key.properties 조건부 로드 + debug fallback 구현
- [x] **`android/key.properties.template` 생성** — keytool 명령 + 작성 가이드 포함
- [x] **`.gitignore` 검증** — `key.properties`, `*.keystore`, `*.jks` 이미 포함됨 (android/.gitignore)
- [ ] **Android keystore 생성** (사용자):
  ```bash
  keytool -genkey -v \
    -keystore ~/.android/abba-release.keystore \
    -alias abba \
    -keyalg RSA -keysize 2048 -validity 10000
  ```
- [ ] **`apps/abba/android/key.properties` 작성** (사용자):
  ```bash
  cp apps/abba/android/key.properties.template apps/abba/android/key.properties
  # CHANGE_ME 값을 실제 keystore 암호로 변경
  ```
- [ ] `flutter build appbundle --release` 테스트 (서명 확인)
- [ ] **Keystore 백업** — 1Password/iCloud Keychain 필수 (분실 시 Play Store 업데이트 영원히 불가)
- [ ] Google Play Console 등록
- [ ] Android RevenueCat 키 추가 (`.env.client` `REVENUECAT_ANDROID_KEY`)
  - ⚠️ `AppConfig`는 platform 분기로 이미 대응 (`a538f6b`)
- [ ] Play Store 자산 (스크린샷, 아이콘 512×512, feature graphic 1024×500)
- [ ] 콘텐츠 등급 신청
- [ ] **(권장) Google Play App Signing 활성화** (Play Console > Setup > App signing) — upload key 분실해도 복구 가능

### 19. 결제 견고성 (전부 완료)

- [x] `completePurchase()` try-catch 강화 — RevenueCatSubscriptionService 전 메서드 try-catch 커버 (2026-04-22 검증)
- [x] ~~Webhook JWS 디코딩 에러 핸들러~~ — **Abba에 불필요**. SDK `CustomerInfo.entitlement.isActive`로 직접 조회, 서버 DB 동기화(`public.subscriptions`) 미사용
- [x] 30초 복원 타임아웃 — `membership_view.dart:776` 구현 완료
- [x] Grace Period 만료 후 자동 다운그레이드 UX — billing-issue 배너 + 결제수단 업데이트 CTA (`f1a1376`)

### 20. Config / env 강화 (Ralph #2 완료)

- [x] `AppConfig.validate()` 확장 — RevenueCat/Google/Sentry 키 검증 추가 (`a538f6b`)
- [x] `AppConfig.revenueCatApiKey` platform 분기 (iOS/Android) — `kIsWeb` 체크 포함
- [x] Legacy `REVENUECAT_API_KEY` fallback 유지 (로컬 세팅 호환)

### 21. 스펙 문서 sync (Ralph #3 완료)

- [x] REQUIREMENTS.md / DESIGN.md / IDEA.md speech_to_text 언급 → Gemini 전환 반영 (`15f1409`)
- [x] stale 주석 정리 (bible_text_service.dart:71 "Extended in Phase 3") (`b7e6b8b`)

### 22. 테스트 커버리지 후속 (TEST_BACKLOG 참조)

- [ ] `apps/abba/specs/TEST_BACKLOG.md` 참조
- 🔴 중요 & 테스트 미작성: `recording_overlay`, `gemini_service`, `ai_loading_view`, supabase repos 3개, real_notification_service 등 11건
- 🟡 Dashboard widgets 남은 9개 (Ralph #6에서 4개 완료)

### 23. 기타 기술 부채

- [ ] `scripts/check_l10n_sync.sh` Python 기반으로 재작성 (naive regex false positive)
- [ ] E2E integration test 환경 설정 (남은 2건 fail)

### 24. Phase 4.1 — Section-Based AI + Cached Rubrics (진행)

참조: `apps/abba/specs/phase_4_1_section_based_ai/SPEC.md`

**완료 (2026-04-23 ~ 2026-04-24 세션)**
- [x] Spec + 10 _details 문서 (`7704f9c`)
- [x] INT-001~013 Rubric 12 + DB migration SQL (`b6fb8a4`)
- [x] INT-015~019, 025 core infra: cache manager, TierResult, repo (`6cf9d4b`)
- [x] INT-020~024 tier analyzers + GeminiService streamed API (`22cebde`)
- [x] INT-026 PrayerSectionsNotifier (`2cf9ff7`)
- [x] INT-027 ai_loading_view Stream refactor (`b63237b`)
- [x] INT-028 Dashboard progressive rendering (`4a99425`)
- [x] INT-032 VisibilityDetector T3 trigger (`0a991ca`)
- [x] INT-033 Day-1 template fallback service + 6 bundled templates (`a3f832d`)
- [x] INT-034/035 19 new ARB keys (en + ko) (`7503cd5`)
- [x] INT-040/043 notifier + template service tests (`88f5cad`)

**사용자 action 필요**
- [ ] **INT-014**: `supabase db push --linked` 로 `20260423000004_section_based_ai.sql`
      적용 (section_status 컬럼, system_config, update_prayer_tier RPC)
- [ ] 12 rubric 문서 신학적 검토 (`apps/abba/assets/prompts/prayer/*.md`,
      `apps/abba/assets/prompts/qt/*.md`)
- [ ] 실기기 E2E — T1 즉시 등장 / T2 background / T3 scroll trigger
- [ ] Supabase Studio 에서 `section_status` JSONB 수동 inspect

**Deferred (Phase 2 / 후속)**
- INT-029 QT Dashboard progressive (QT tier analyzers 미구현)
- INT-030/031 True SSE token-level rendering (`generateContentStream` 체인 정비 후)
- INT-036~039/041/042 tier / cache / RPC / 위젯 통합 테스트 (Gemini SDK 모킹 필요)
- INT-047/048 항목은 이 체크리스트 업데이트로 대응 (`88f5cad` 이후)

**Phase 2 후속 최적화 (출시 후 데이터 기반)**
- [ ] Batch API for T3 — 월 $110 절감
- [ ] Flash-Lite T2 routing — 월 $90 절감 (A/B test 후)
- [ ] Output token tuning 2000 → 1400 — 월 $140 절감
- [ ] 저자원 locale per-locale cache (아랍어/히브리어 필요 시)

---

## 📊 총계 (2026-04-22 업데이트)

| 카테고리 | 항목 수 | 완료 | 추정 남은 시간 |
|---------|---------|------|---------------|
| 🚨 CRITICAL | 3 | 1 | 반나절 (실기 E2E + Xcode GUI) |
| 🔴 BLOCKER | 14 | 0 | 1-2주 (디자인 포함) |
| 🟠 MUST | 11 | 6 | 2-3일 |
| 🟡 SHOULD | 14 | 8 | 1일 |
| 🟢 NICE | 다수 | 대부분 완료 | 출시 후 |

### 2026-04-22 세션 완료 commit 목록 (참고)

| Commit | 내용 |
|---|---|
| `ee557ec ~ c8e5a13` | qt_output_redesign Phase 1-5 전체 |
| `ab34054` | RevenueCat 동적 가격 |
| `f1a1376` | Grace Period 배너 UX |
| `915ff5b` | 로컬 알림 35 locale |
| `342924f` | UI 하드코딩 일괄 (milestone_modal 등) |
| `11774bb` | Sentry 마스킹 확장 + catch 정비 |
| `9d7fb3c` | prayer_heatmap 요일/월 locale |
| `e477350` | QT passage Retry UX |
| `89bef38` | OpenAI dead code 제거 (-677 lines) |
| `6c4f8d4` | cancel l10n 해킹 제거 |
| `b7e6b8b` | UI 하드코딩 + iOS 권한 다국어 + stale 주석 |
| `a538f6b` | AppConfig + PrivacyInfo.xcprivacy |
| `15f1409` | speech_to_text 스펙 sync |
| `b953079` / `8d9d31e` | Pre-existing 테스트 수정 + MockDataService.fromData |
| `02b207b` | CachedAiService + ProBlur 테스트 + TEST_BACKLOG |
| `7925b63` | Dashboard widgets 4개 테스트 |
| `8cd014e` | Gemini 동적화 — `_useHardcodedResponse` 제거 + `AppConfig.useMockAi` ENV 토글 |

---

## 참고

- `specs/SUBSCRIPTION.md` — 결제 시스템 상세
- `specs/SPEC-L10N-35.md` — 35개 언어 localization
- `specs/TEST_BACKLOG.md` — 테스트 커버리지 후속 작업 목록
- `.claude/rules/learned-pitfalls.md` §2/§17/§18 — Subscription/Payment, Sentry, Git 멀티계정
- `QA_CHECKLIST.md` — 화면별 QA 283 항목
