# PROMPT.md — Abba Phase 3: 소셜 + 결제 + 리텐션

> Ralph 자율 실행용 프롬프트
> Phase: 3 (커뮤니티 CRUD, RevenueCat 구독, 푸시 알림, QT cronjob, 리텐션 기능)
> 선행 조건: Phase 2 완료 (STT, AI API, TTS, Supabase 동작)

---

## 목표

앱을 **출시 가능한 상태**로 만든다.
- 커뮤니티: 실제 글/댓글/좋아요 CRUD (Supabase)
- 결제: RevenueCat 구독 (Free ↔ Premium 전환)
- 푸시 알림: FCM 기도 리마인더
- QT cronjob: 매일 5개 말씀 자동 생성
- 리텐션: 주간 요약, 은혜 스트릭, 시즌 챌린지 기반

## 필수 읽기

- `apps/abba/specs/REQUIREMENTS.md` — 섹션 8 (리텐션 전략)
- `apps/abba/specs/DESIGN.md` — 섹션 7 (Supabase 테이블)

---

## Phase 3 체크리스트

### 1. 커뮤니티 CRUD (Supabase)

#### 1.1 글 (Posts)
- [ ] 글 작성 (INSERT community_posts) — 익명/실명 + 카테고리
- [ ] 글 목록 조회 (SELECT + 페이지네이션, 커서 기반)
- [ ] 글 필터: 전체 / 간증 / 기도요청
- [ ] 글 상세 (댓글 포함)
- [ ] 내 글 삭제

#### 1.2 댓글 + 리플라이
- [ ] 댓글 작성 (INSERT post_comments)
- [ ] 리플라이 작성 (parent_comment_id 설정, 1 depth만)
- [ ] 댓글 목록 조회 (글별)
- [ ] 댓글 삭제 (본인 것만)

#### 1.3 좋아요 + 저장
- [ ] 좋아요 토글 (INSERT/DELETE post_likes + like_count 업데이트)
- [ ] 저장 토글 (INSERT/DELETE post_saves)
- [ ] 내가 저장한 글 목록 (Settings 또는 Profile에서)

#### 1.4 기도에서 가져오기
- [ ] WritePostView: [기도에서 가져오기] 탭 → 최근 기도의 testimony 텍스트 불러오기
- [ ] Dashboard: [↗ 공유] 탭 → WritePostView로 이동 (testimony 자동 채움)

#### 1.5 신고/모더레이션
- [ ] 글/댓글에 [🚫 신고] 옵션 (overflow menu)
- [ ] 신고 시 Supabase에 기록 (reports 테이블)
- [ ] 신고 3회 이상 → 자동 숨김 (is_hidden 플래그)

### 2. RevenueCat 구독

#### 2.1 설정
- [ ] `purchases_flutter` 패키지 추가
- [ ] RevenueCat 프로젝트 생성 (iOS + Android)
- [ ] Apple App Store Connect에 구독 상품 등록:
  - `abba_premium_monthly` — $6.99/월
  - `abba_premium_yearly` — $49.99/년
- [ ] Google Play Console에 동일 상품 등록
- [ ] RevenueCat API 키 .env에 추가

#### 2.2 구독 플로우
- [ ] SubscriptionProvider: RevenueCat에서 현재 구독 상태 조회
- [ ] Settings Premium 섹션:
  - [월간 $6.99] / [연간 $49.99 — Save 40%] 버튼
  - 탭 → RevenueCat 결제 시트 표시
  - 결제 성공 → SubscriptionStatus.premium 전환
  - 이미 구독 중 → "Premium 활성 ✅" + [구독 관리]
- [ ] 런칭 프로모션: RevenueCat Offering에 프로모션 가격 설정 ($3.99)
  - 프로모션 기간(3개월) 후 자동 정가 전환
- [ ] Premium 유도 모달 (2번째 기도 시도):
  - RevenueCat 결제 시트 연동
  - [다음에 하기] → 모달 닫기

#### 2.3 Premium 기능 게이팅
- [ ] Dashboard 카드 4,5,6: subscription_provider 상태로 블러 on/off
- [ ] 기도 횟수 제한: Free → 1일 1회, Premium → 무제한
- [ ] TTS 재생: Free → 잠금, Premium → 재생 가능
- [ ] 원어 해석: Free → 블러, Premium → 표시

#### 2.4 Day 7 무료 체험
- [ ] 첫 설치 후 7일째 되는 날 → "7일 축하! Premium 3일 무료 체험" 모달
- [ ] RevenueCat free trial 설정 (3일)
- [ ] 체험 종료 → 자동으로 Free 복귀 (사용자가 구독 안 하면)

### 3. 푸시 알림 (FCM)

#### 3.1 설정
- [ ] `firebase_messaging` + `firebase_core` 패키지 추가
- [ ] Firebase 프로젝트 생성 (iOS + Android)
- [ ] iOS: APNs 인증키 등록
- [ ] Android: google-services.json 추가
- [ ] FCM 토큰 → Supabase user_devices 테이블에 저장

#### 3.2 알림 종류
- [ ] 아침 기도 리마인더:
  - 사용자 설정 시간 (기본 06:00)
  - 내용: "{name}님, 오늘의 기도 시간입니다 🌿" + 오늘의 성경 구절 1절
  - 개인화: 이름 포함
- [ ] 저녁 감사 알림 (선택):
  - 기본 OFF, Settings에서 ON 가능
  - 시간: 21:00
  - 내용: "오늘 하루 감사한 것이 있으신가요? 🌙"
- [ ] 스트릭 위험 알림:
  - 오늘 아직 기도 안 했고 오후 8시 → "오늘 스트릭을 이어가세요 🔥"
  - 부드러운 톤 (죄책감 X)
- [ ] 주간 요약 (일요일):
  - "이번 주 5일 기도, 가장 많이 언급한 주제: 감사 📊"

#### 3.3 알림 설정 UI
- [ ] Settings: 아침 알림 토글 + 시간 선택
- [ ] Settings: 저녁 알림 토글
- [ ] 밤 9시 이후 알림 금지
- [ ] 하루 최대 2회

### 4. QT Cronjob (매일 말씀 생성)

#### 4.1 Supabase Edge Function
- [ ] Edge Function 생성: `generate-qt-passages`
- [ ] 매일 자정 (UTC) 실행 → GPT-4o-mini API 호출
- [ ] 5개 성경 구절 + 의역 본문 생성 (저작권 free):
  - 다양한 성경 책에서 (구약 2 + 신약 3 또는 랜덤)
  - 각 구절: reference, text_en, text_ko, icon, color_hex
  - 아이콘: 🌸🌿🐦☀️💧 중 랜덤 배정
  - 컬러: 5개 파스텔 중 순차 배정
- [ ] 생성 결과 → qt_passages 테이블에 INSERT (date = today)
- [ ] 중복 방지: 오늘 이미 생성됐으면 스킵
- [ ] 에러 시: Sentry 알림 + 어제 말씀 재사용

#### 4.2 Supabase Cron
- [ ] `pg_cron` 확장 활성화
- [ ] 매일 00:05 UTC에 Edge Function 호출
- [ ] 또는 GitHub Actions로 매일 실행

#### 4.3 앱 연동
- [ ] QT Page: Supabase에서 오늘 날짜 qt_passages 조회
- [ ] 없으면 (cronjob 실패): 기본 시편 23편 표시

### 5. 리텐션 기능

#### 5.1 은혜 스트릭
- [ ] 스트릭 깨졌을 때: "괜찮아요, 다시 시작하면 됩니다 🌱" 메시지
- [ ] 스트릭 복구: 24시간 내 → 자동 복구 (은혜 복구)
- [ ] Calendar: 복구된 날 = 🌼 (일반 기도 🌸과 구분)

#### 5.2 성장하는 정원
- [ ] Home 스트릭 카드 시각화:
  - 1-7일: 씨앗 🌱
  - 8-14일: 새싹 🌿
  - 15-30일: 꽃봉오리 🌷
  - 31일+: 만개 🌸
  - 60일+: 나무 🌳
- [ ] 시각적 성장 → 유저 동기부여

#### 5.3 주간 요약
- [ ] 일요일 푸시 알림으로 전송
- [ ] 내용: 이번 주 기도 횟수, 연속일, 주요 기도 주제 (AI 분석)
- [ ] Settings에서 on/off 토글

#### 5.4 마일스톤 축하
- [ ] 첫 기도 완료: "첫 기도를 올렸습니다! 🎉" 축하 모달
- [ ] 7일 연속: "7일 연속 기도! 🔥" + Premium 체험 유도
- [ ] 30일 연속: "30일! 당신의 정원이 꽃밭이 되었습니다 🌸" 공유 카드
- [ ] 100회 기도: "100번째 기도 🙏" 특별 배지
- [ ] 공유 가능 카드: 인스타/카카오톡 공유 이미지 자동 생성

---

## 완료 조건

- [ ] 커뮤니티: 글 작성 → 피드에 표시 → 댓글/리플라이 → 좋아요/저장
- [ ] RevenueCat: 구독 결제 → Premium 활성 → 블러 해제 → 기도 무제한
- [ ] 푸시 알림: 아침 리마인더 수신 → 탭 → 앱 열림
- [ ] QT: 매일 새로운 5개 말씀 자동 생성 + 앱에 표시
- [ ] 스트릭: 은혜 복구 동작, 성장 시각화 변경
- [ ] 마일스톤: 7일/30일/100회 축하 모달 표시
- [ ] 신고: 글/댓글 신고 → 3회 이상 자동 숨김
