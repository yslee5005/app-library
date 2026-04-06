# PROMPT.md — Abba Phase 5: QA + 테스트 + 전체 리뷰

> Ralph 자율 실행용 프롬프트
> Phase: 5 (전체 코드 리뷰, Unit Test, Widget Test, Integration Test, 버그 수정)
> 선행 조건: Phase 4 완료 (앱스토어 제출 준비 완료)
> 실행 시점: 매 Phase 완료 후 + 최종 배포 전

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

앱이 **실제로 제대로 작동하는지** 검증한다.
- 전체 코드 리뷰 (아키텍처, 보안, 성능)
- Unit Test (서비스, 모델, 프로바이더)
- Widget Test (각 화면 렌더링 + 인터랙션)
- Integration Test (E2E 플로우)
- 버그 수정 + 리팩토링

---

## Phase 5 체크리스트

### 1. 전체 코드 리뷰

#### 1.1 아키텍처 점검
- [ ] Feature-first 구조 일관성 확인
- [ ] 순환 의존 없음 확인
- [ ] 모든 서비스에 인터페이스(추상 클래스) 있음 확인
- [ ] Provider에서 직접 API 호출 안 함 (Service를 통해서만)
- [ ] 하드코딩 문자열 0개 확인 (전부 ARB 키)
- [ ] `flutter analyze` — 0 에러, 0 경고

#### 1.2 보안 점검
- [ ] `.env` 파일 git에 없음
- [ ] API 키 코드에 하드코딩 없음
- [ ] service_role 키 클라이언트 코드에 없음
- [ ] 기도 음성 파일 서버 전송 없음 (텍스트만)
- [ ] Sentry에 기도 텍스트/이메일 마스킹 동작 확인
- [ ] Supabase RLS 모든 테이블 활성화 + NULL 방어 확인
- [ ] SharedPreferences에 민감 데이터 없음
- [ ] `--obfuscate` 빌드 동작 확인

#### 1.3 성능 점검
- [ ] 앱 시작 시간 측정 (3초 이내 목표)
- [ ] 메모리 누수 확인 (dispose 패턴)
- [ ] 이미지/애니메이션 메모리 사용량
- [ ] Supabase 쿼리 응답 시간 (500ms 이내)
- [ ] AI API 응답 시간 (5초 이내)
- [ ] 커뮤니티 피드 스크롤 성능 (60fps)

#### 1.4 접근성 점검
- [ ] 모든 버튼 56dp+ 확인
- [ ] 모든 body 텍스트 18pt+ 확인
- [ ] 색상 대비 WCAG AA (4.5:1) 확인
- [ ] Semantics 라벨 모든 인터랙티브 요소에 적용
- [ ] 시스템 폰트 크기 변경 시 UI 깨지지 않음

---

### 2. Unit Test

#### 2.1 Models
```
test/models/
├── prayer_test.dart
├── qt_passage_test.dart
├── post_test.dart
└── user_profile_test.dart
```

- [ ] Prayer: JSON 직렬화/역직렬화
- [ ] PrayerResult: 모든 필드 파싱 + null 처리
- [ ] QTPassage: JSON 파싱 + isCompleted 로직
- [ ] CommunityPost: JSON 파싱 + 익명 처리
- [ ] Comment: 리플라이 (parentCommentId) 로직
- [ ] UserProfile: SubscriptionStatus enum 변환
- [ ] Scripture/BibleStory/Guidance/AiPrayer/OriginalLanguage: 각 하위 모델

#### 2.2 Services
```
test/services/
├── mock_data_service_test.dart
├── ai_service_test.dart
├── stt_service_test.dart
├── tts_service_test.dart
└── auth_service_test.dart
```

- [ ] MockDataService: JSON 로드 + 파싱 정상 동작
- [ ] AiService: API 호출 mock + 응답 파싱 + 에러 처리
  - 정상 응답 → PrayerResult 반환
  - API 에러 → 재시도 1회 → 폴백 반환
  - 잘못된 JSON → 에러 처리
  - locale별 프롬프트 변경 확인
- [ ] SttService: 권한 체크 + 녹음 상태 전환 로직
  - 시작 → 녹음중 → 일시정지 → 재개 → 완료
  - 1분 세션 재시작 로직
- [ ] TtsService: 목소리 매핑 + 오디오 URL 생성 + 에러 처리
- [ ] AuthService: 로그인/로그아웃 상태 전환

#### 2.3 Providers
```
test/providers/
├── auth_provider_test.dart
├── prayer_provider_test.dart
├── qt_provider_test.dart
├── community_provider_test.dart
├── calendar_provider_test.dart
└── subscription_provider_test.dart
```

- [ ] AuthProvider: 로그인 → authenticated, 로그아웃 → unauthenticated
- [ ] PrayerProvider:
  - 기도 저장 → 목록에 추가
  - 오늘 기도 횟수 카운트
  - Free 유저 1회 제한 로직
- [ ] QtProvider: 오늘 말씀 5개 로드 + 완료 마킹
- [ ] CommunityProvider:
  - 글 목록 로드 + 필터 (전체/간증/기도요청)
  - 좋아요 토글 → count 변경
  - 저장 토글
- [ ] CalendarProvider:
  - 월별 기도 기록 로드
  - 스트릭 계산 (현재/최장)
  - 은혜 복구 (24시간 이내)
- [ ] SubscriptionProvider:
  - Free/Premium/Trial 상태 전환
  - isPremium 체크 → Dashboard 블러 on/off

#### 2.4 유틸리티
- [ ] 스트릭 계산 로직:
  - 매일 기도 → streak++
  - 하루 빠짐 → streak reset (단, 24시간 이내 은혜 복구)
  - best_streak 갱신
- [ ] 시간대별 인사말: morning/afternoon/evening
- [ ] 날짜 포맷: 로케일별 (en: "April 6", ko: "4월 6일")

---

### 3. Widget Test

```
test/features/
├── welcome/welcome_view_test.dart
├── login/login_view_test.dart
├── home/home_view_test.dart
├── recording/recording_overlay_test.dart
├── ai_loading/ai_loading_view_test.dart
├── dashboard/dashboard_view_test.dart
├── dashboard/widgets/
│   ├── scripture_card_test.dart
│   ├── premium_blur_test.dart
│   └── ai_prayer_card_test.dart
├── qt/qt_view_test.dart
├── community/community_view_test.dart
├── community/write_post_view_test.dart
├── calendar/calendar_view_test.dart
└── settings/settings_view_test.dart
```

#### 3.1 각 화면 렌더링 테스트
- [ ] WelcomeView: 로고 + 시작 버튼 렌더링
- [ ] LoginView: 3개 로그인 버튼 렌더링
- [ ] HomeView: 기도/QT 버튼 2개 + 스트릭 카드 + 탭바 4개
- [ ] RecordingOverlay: 타이머 + 완료 버튼 + 취소 버튼
- [ ] AiLoadingView: 애니메이션 + 로딩 텍스트
- [ ] DashboardView: 6개 카드 렌더링 + 홈 버튼
- [ ] QtView: 5개 말씀 카드 렌더링
- [ ] CommunityView: 필터 칩 + 글 카드 + FAB
- [ ] WritePostView: 익명 토글 + 카테고리 + 텍스트 입력 + 공유 버튼
- [ ] CalendarView: 달력 그리드 + 스트릭 카드
- [ ] SettingsView: 프로필 + Premium 카드 + 설정 리스트

#### 3.2 인터랙션 테스트
- [ ] Home [기도하기] 탭 → Recording 오버레이 열림
- [ ] Home [QT하기] 탭 → QT Page 네비게이션
- [ ] Recording [완료] → AI Loading 전환
- [ ] Dashboard [홈으로] → Home 돌아감
- [ ] Dashboard [공유] → 동작 확인
- [ ] QT 카드 탭 → 확장 + 본문 표시
- [ ] Community FAB → WritePost 네비게이션
- [ ] Community 필터 칩 → 목록 필터링
- [ ] Calendar 날짜 탭 → 기도 목록 표시
- [ ] Settings 언어 변경 → 앱 언어 즉시 전환

#### 3.3 Premium 블러 테스트
- [ ] Free 유저: 카드 4,5,6 → 타이틀 보임 + 내용 블러 + CTA 버튼
- [ ] Premium 유저: 카드 4,5,6 → 전체 내용 표시 + 블러 없음
- [ ] CTA 버튼 탭 → Premium 유도 모달 (또는 결제 시트)

#### 3.4 다국어 테스트
- [ ] 영어 로케일 → 모든 텍스트 영어
- [ ] 한국어 로케일 → 모든 텍스트 한국어
- [ ] 누락된 ARB 키 없음 확인

---

### 4. Integration Test (E2E)

```
integration_test/
├── prayer_flow_test.dart
├── qt_flow_test.dart
├── community_flow_test.dart
├── subscription_flow_test.dart
└── full_flow_test.dart
```

#### 4.1 기도 플로우 E2E
- [ ] Home → [기도하기] → Recording → [완료] → AI Loading → Dashboard → [홈으로]
- [ ] Dashboard 6개 카드 데이터 표시 확인
- [ ] Free 유저: Premium 카드 블러 확인
- [ ] 두 번째 기도 시도 → 제한 모달 표시

#### 4.2 QT 플로우 E2E
- [ ] Home → [QT하기] → 카드 선택 → 본문 확인 → [묵상 시작] → Recording → Dashboard
- [ ] QT 완료 후 카드 ✅ 체크마크 표시

#### 4.3 커뮤니티 플로우 E2E
- [ ] Community 탭 → 글 목록 → 글 탭 → 댓글 보기
- [ ] FAB → 글 작성 → [공유] → 피드에 새 글 표시
- [ ] 좋아요 탭 → count 변경
- [ ] 필터 전환 (전체→간증→기도요청)

#### 4.4 구독 플로우 E2E
- [ ] Settings → Premium 카드 → [구독 시작] → 결제 시트
- [ ] 구독 완료 → Dashboard 블러 해제 확인
- [ ] 기도 횟수 무제한 확인

#### 4.5 전체 플로우 (Critical Path)
- [ ] Welcome → Login → Home → 기도 → Dashboard → Community → Calendar → Settings
- [ ] 전체 네비게이션 깨지지 않음 확인
- [ ] 뒤로가기 (물리 버튼 / iOS 스와이프) 정상 동작
- [ ] 탭 간 이동 시 상태 유지

---

### 5. 버그 수정 + 리팩토링

- [ ] 테스트에서 발견된 버그 수정
- [ ] Dead code 제거
- [ ] 미사용 import 제거
- [ ] 코드 포매팅 (`dart format`)
- [ ] 린트 경고 0 (`flutter analyze`)
- [ ] TODO/FIXME 주석 해결
- [ ] 중복 코드 위젯 추출
- [ ] Provider dispose 확인 (메모리 누수 방지)

---

## 테스트 실행 명령어

```bash
# Unit + Widget Test
flutter test

# 특정 파일
flutter test test/models/prayer_test.dart

# Coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Integration Test (에뮬레이터 필요)
flutter test integration_test/full_flow_test.dart
```

---

## 완료 조건

- [ ] `flutter analyze` — 0 에러, 0 경고
- [ ] `flutter test` — **전체 통과** (Unit + Widget)
- [ ] Integration Test — Critical Path 통과
- [ ] 코드 커버리지: 최소 70% (models 90%+, services 80%+, providers 80%+)
- [ ] 보안 체크리스트 100% 통과
- [ ] 접근성 체크리스트 통과
- [ ] 성능: 앱 시작 3초 이내, 스크롤 60fps, AI 5초 이내
- [ ] 영어/한국어 전체 플로우 수동 테스트 통과
- [ ] iOS + Android 모두 빌드 성공
