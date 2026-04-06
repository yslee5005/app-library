# PROMPT.md — Abba Phase 4: 배포 + 글로벌 + 폴리싱

> Ralph 자율 실행용 프롬프트
> Phase: 4 (앱스토어 제출, 런칭 프로모션, 다국어 확장, 성능 최적화)
> 선행 조건: Phase 3 완료 (커뮤니티, 결제, 푸시 알림, QT cronjob 동작)

---

## 실행 규칙 (모든 Phase 공통)

**각 체크리스트 항목을 실행하기 전에 반드시:**

1. **Sequential Thinking으로 최소 5단계 분석** — 구현할 항목을 분석하고, 필요시 WebSearch로 최신 패키지 사용법/베스트 프랙티스 확인
2. **분석 결과를 정리** — 아래 4가지 포맷으로:
   - **문제 정의**: 이 항목이 해결하는 것
   - **핵심 발견**: 구현 시 주의할 점, 의존성, 사전 조건
   - **실행 계획**: 구체적 코드 구조, 파일, 함수
   - **예상 결과**: 완료 후 동작해야 하는 것
3. **분석 완료 후 즉시 실행** — 분석 → 구현 → 검증을 하나의 사이클로
4. **검증 후 다음 항목으로** — `flutter analyze` + 동작 확인 후 다음 체크리스트 진행

---

## 목표

앱을 **앱스토어에 출시**하고 **글로벌 확장** 준비를 한다.
- 앱스토어 제출 요건 충족
- 성능/접근성 최적화
- 추가 언어 지원
- 런칭 마케팅 자산 준비

---

## Phase 4 체크리스트

### 1. 앱스토어 제출 준비

#### 1.1 iOS (App Store Connect)
- [ ] Bundle ID: `com.ystech.abba`
- [ ] 앱 이름: "Abba — Prayer & Quiet Time"
- [ ] 카테고리: Lifestyle > Religion & Spirituality
- [ ] 연령 등급: 4+ (종교 콘텐츠)
- [ ] 앱 아이콘: 1024x1024 (Morning Garden 스타일, 올리브 잎 + Abba 텍스트)
- [ ] 스크린샷 생성:
  - iPhone 6.7" (1290x2796) — 5장
  - iPhone 6.5" (1284x2778) — 5장
  - iPad 12.9" (2048x2732) — 5장 (선택)
  - 스크린샷 내용: Welcome, Home, Recording, Dashboard, Calendar
- [ ] 앱 설명 (영어 + 한국어):
  - 한 줄: "Pray, and God will answer through Scripture"
  - 설명: 핵심 기능 5가지 bullet points
  - 키워드: prayer, bible, devotional, QT, quiet time, christian, ai
- [ ] 개인정보 처리방침 URL (필수)
- [ ] 지원 URL
- [ ] AI 기능 명시 (Apple 2026 가이드라인): "이 앱은 AI를 사용하여 기도 분석 및 기도문 생성을 합니다"
- [ ] 구독 설명: 가격, 갱신 주기, 해지 방법 명시
- [ ] 빌드: `flutter build ios --obfuscate --split-debug-info=build/debug-info`
- [ ] TestFlight 배포 → 내부 테스트 → 심사 제출

#### 1.2 Android (Google Play Console)
- [ ] Package: `com.ystech.abba`
- [ ] 앱 이름: "Abba — Prayer & Quiet Time"
- [ ] 카테고리: Lifestyle
- [ ] 콘텐츠 등급: Everyone
- [ ] 앱 아이콘: 512x512
- [ ] Feature Graphic: 1024x500
- [ ] 스크린샷: phone (최소 2장), tablet (선택)
- [ ] 앱 설명 (영어 + 한국어) — iOS와 동일
- [ ] 개인정보 처리방침
- [ ] Data Safety 섹션: 수집하는 데이터 명시 (이메일, 기도 텍스트, 사용 데이터)
- [ ] 빌드:
  ```bash
  flutter build appbundle --obfuscate --split-debug-info=build/debug-info
  ```
- [ ] 내부 테스트 트랙 → 클로즈드 테스트 → 프로덕션

#### 1.3 공통 자산
- [ ] 앱 아이콘 생성 (flutter_launcher_icons 패키지)
- [ ] 스플래시 스크린 (flutter_native_splash 패키지) — Morning Garden 크림 배경 + Abba 로고
- [ ] 앱 서명 키 생성 + 안전 보관

### 2. 성능 최적화

#### 2.1 앱 크기
- [ ] 이미지 에셋 최적화 (WebP 또는 최적 PNG)
- [ ] Lottie 애니메이션 경량화
- [ ] 불필요 패키지 제거
- [ ] `flutter build` 시 tree-shaking 확인

#### 2.2 로딩 속도
- [ ] Supabase 쿼리 최적화 (인덱스 확인)
- [ ] 이미지 lazy loading (CachedNetworkImage)
- [ ] 커뮤니티 피드 페이지네이션 (20개씩)
- [ ] AI API 응답 캐싱 (같은 기도 재조회 시)

#### 2.3 오프라인 대응
- [ ] STT: 온디바이스라 오프라인 OK
- [ ] AI 결과: 오프라인 시 "인터넷 연결 후 다시 시도해주세요" 안내
- [ ] 기도 텍스트: 로컬 저장 후 온라인 시 싱크
- [ ] 커뮤니티: 오프라인 시 캐시된 피드 표시

#### 2.4 에러 핸들링
- [ ] 네트워크 에러 → 사용자 친화적 메시지 ("잠시 후 다시 시도해주세요 🌿")
- [ ] AI API 에러 → 기본 성경 구절 폴백
- [ ] STT 에러 → 텍스트 입력 모드로 자동 전환
- [ ] 결제 에러 → "결제에 문제가 있습니다. 설정에서 다시 시도해주세요"

### 3. 접근성 (시니어 최적화)

- [ ] 시맨틱 라벨: 모든 버튼, 아이콘에 Semantics 위젯
- [ ] 스크린 리더 (VoiceOver/TalkBack) 테스트
- [ ] 다이나믹 타입 지원: 시스템 폰트 크기 변경 시 앱 반영
- [ ] 색상 대비 WCAG AA (4.5:1) 이상 확인
- [ ] 터치 타겟: 모든 인터랙티브 요소 48dp+ 확인
- [ ] 애니메이션 감소 모드: `MediaQuery.disableAnimations` 대응

### 4. 다국어 확장

#### 4.1 추가 언어 ARB
- [ ] `app_ja.arb` — 일본어
- [ ] `app_es.arb` — 스페인어
- [ ] `app_zh.arb` — 중국어 (간체)
- [ ] 각 언어 네이티브 스피커 검수 (필수)

#### 4.2 AI 다국어
- [ ] AI 프롬프트에 locale 파라미터 전달
- [ ] 일본어/스페인어/중국어 AI 응답 품질 테스트
- [ ] QT cronjob: 각 언어별 말씀 생성 (또는 영어 생성 → AI 번역)

#### 4.3 앱스토어 다국어
- [ ] 각 언어별 앱 설명 + 키워드
- [ ] 각 언어별 스크린샷 (해당 언어 UI)

### 5. 런칭 마케팅 자산

#### 5.1 앱 소개 페이지
- [ ] 랜딩 페이지 (간단한 원페이지):
  - 앱 스크린샷 + 핵심 가치 3가지
  - App Store / Google Play 다운로드 링크
  - "기도하면, 하나님이 응답하십니다"

#### 5.2 공유 카드
- [ ] 마일스톤 공유 이미지 자동 생성 (30일 스트릭 등)
- [ ] 인스타 스토리 사이즈 (1080x1920)
- [ ] 카카오톡 공유 카드 (800x400)
- [ ] Morning Garden 스타일 일관

#### 5.3 교회 소그룹 기능 (MVP)
- [ ] 초대 링크 생성 (딥링크): "같이 기도해요" → 앱 다운로드
- [ ] 소그룹 목록: Settings에서 "내 그룹" 섹션
- [ ] 그룹 스트릭: "우리 소그룹 평균 5일 연속 기도" (Phase 5 확장)

### 6. 런칭 프로모션 설정

- [ ] RevenueCat: 프로모션 Offering 생성
  - 첫 3개월: $3.99/월 (런칭 특가)
  - 3개월 후: 자동으로 $6.99/월 정가
- [ ] 앱 내 프로모션 배너: Settings Premium 섹션에 "🌸 런칭 특가 3개월간 $3.99/월!"
- [ ] 프로모션 종료일 설정 → 배너 자동 제거

### 7. 보안 최종 점검

- [ ] `.env` 파일 git에 포함 안 됨 확인
- [ ] service_role 키 클라이언트 코드에 없음 확인
- [ ] RLS 모든 테이블 활성화 확인
- [ ] RLS NULL 방어 (COALESCE) 적용 확인
- [ ] `--obfuscate` 빌드 확인
- [ ] Supabase Dashboard에서 다른 app_id 데이터 접근 불가 확인
- [ ] 기도 음성 파일 서버 저장 안 함 확인 (텍스트만 전송)
- [ ] Sentry에 기도 텍스트 마스킹 확인

---

## 완료 조건

- [ ] iOS TestFlight 배포 → 내부 테스트 통과
- [ ] Android 내부 테스트 트랙 배포 → 테스트 통과
- [ ] 영어/한국어/일본어/스페인어 4개 언어 동작
- [ ] 앱스토어 심사 제출 → 승인
- [ ] Google Play 심사 제출 → 승인
- [ ] 런칭 프로모션 활성 ($3.99/월)
- [ ] 보안 체크리스트 100% 통과
- [ ] 랜딩 페이지 라이브
- [ ] VoiceOver/TalkBack 기본 동작 확인

---

## 출시 후 모니터링

- [ ] Sentry 대시보드: crash-free rate 99%+ 유지
- [ ] RevenueCat 대시보드: 구독 전환율 추적
- [ ] Supabase 대시보드: API 사용량, DB 크기 모니터링
- [ ] 앱스토어 리뷰 모니터링 → 빠른 대응
- [ ] QT cronjob 정상 실행 확인 (매일)
