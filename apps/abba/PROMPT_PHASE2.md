# PROMPT.md — Abba Phase 2: Core 기능 연결

> Ralph 자율 실행용 프롬프트
> Phase: 2 (실제 기능 연동 — STT, AI API, TTS, Supabase)
> 선행 조건: Phase 1 완료 (11페이지 UI Shell + JSON mock 동작)

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

Phase 1에서 만든 UI Shell에 **실제 기능을 연결**한다.
- JSON mock → 실제 AI API 호출
- 가짜 타이머 → 실제 음성 녹음 (STT)
- 가짜 오디오 플레이어 → 실제 TTS 재생
- mock 로그인 → Supabase Auth
- mock 데이터 → Supabase DB 저장/조회

## 필수 읽기

- `apps/abba/specs/REQUIREMENTS.md` — 전체 기능 정의
- `apps/abba/specs/DESIGN.md` — 아키텍처, 데이터 모델, Supabase 스키마, AI 프롬프트

---

## Phase 2 체크리스트

### 1. Supabase 연동

#### 1.1 환경 설정
- [ ] `.env` 파일 생성 (APP_ID=abba, SUPABASE_URL, SUPABASE_ANON_KEY, SENTRY_DSN)
- [ ] `supabase_flutter` 패키지 추가 + 초기화 (main.dart)
- [ ] AppConfig에서 `.env` 로드 (flutter_dotenv)

#### 1.2 인증
- [ ] Supabase Auth 연동 — Google Sign-In
- [ ] Supabase Auth 연동 — Apple Sign-In
- [ ] Supabase Auth 연동 — Email/Password
- [ ] LoginView: mock 제거 → 실제 소셜 로그인 동작
- [ ] 로그인 성공 → profiles 테이블에 사용자 프로필 자동 생성
- [ ] 로그아웃 동작 (Settings)
- [ ] AuthState 관리 (Riverpod StateNotifier)
- [ ] 미인증 시 Welcome으로 리다이렉트 (go_router redirect)

#### 1.3 DB 테이블 생성
- [ ] Supabase 마이그레이션 SQL 작성 (DESIGN.md 섹션 7 참고):
  - prayers 테이블
  - qt_passages 테이블
  - community_posts 테이블
  - post_comments 테이블
  - post_likes 테이블
  - post_saves 테이블
  - prayer_streaks 테이블
- [ ] 모든 테이블 RLS 활성화 + app_id 정책
- [ ] RLS NULL 방어 (COALESCE)

#### 1.4 기도 기록 저장
- [ ] 기도 완료 시 → prayers 테이블에 저장 (transcript, mode, result JSON)
- [ ] Dashboard에서 저장된 기도 조회
- [ ] Calendar에서 날짜별 기도 목록 조회
- [ ] prayer_streaks 테이블 자동 업데이트 (기도 완료 시)
- [ ] 스트릭 로직: 오늘 기도 → current_streak++, 어제 안 했으면 reset to 1, best_streak 갱신

### 2. 음성 녹음 (Gemini 멀티모달 오디오 분석)

> ~~(구 계획: `speech_to_text` 온디바이스)~~ Gemini 멀티모달(`analyzePrayerFromAudio`)로 전환 (2026-04-22, 35 locale 자동 지원)

- [ ] 마이크 권한 요청 (iOS Info.plist + Android manifest)
- [ ] RecordingOverlay: 가짜 타이머 → 실제 오디오 캡처
  - `record` 패키지로 오디오 파일 저장 (m4a/AAC)
  - 무음 감지 자동 종료 (pauseFor 파라미터 조정)
- [ ] 텍스트 입력 모드: TextField (이미 Phase 1에서 UI 있음) → 실제 입력값 사용
- [ ] 녹음 완료 → 오디오 파일을 `analyzePrayerFromAudio`에 업로드 → transcribe + 분석 결과 1-call 수신

### 3. AI API 연동 (GPT-4o-mini)

#### 3.1 서비스 구현
- [ ] AiService 클래스 구현 (http 패키지)
- [ ] API 키 .env에서 로드 (GEMINI_API_KEY — OpenAI 경로는 2026-04-21 폐기)
- [ ] 기도 분석 API 호출:
  - Input: transcript (기도 텍스트) + locale (사용자 언어)
  - System prompt: DESIGN.md 섹션 8 참고
  - Output: JSON (scripture, bible_story, testimony, guidance, ai_prayer, original_language)
  - 사용자 언어에 맞춰 응답 생성 (locale 전달)
- [ ] JSON 파싱 → PrayerResult 모델 매핑
- [ ] 에러 처리: API 실패 시 → 재시도 1회 → 실패 시 기본 성경 구절 표시
- [ ] Rate limiting: Free 유저 1일 1회 체크 (로컬 SharedPreferences + 서버 검증)

#### 3.2 Dashboard 연동
- [ ] MockDataService 호출 → AiService 호출로 교체
- [ ] AI Loading 화면: 실제 API 응답 대기 (최소 3초 보장, 빨리 오면 3초까지 대기)
- [ ] 각 카드에 실제 AI 데이터 바인딩
- [ ] Premium 체크: subscription_provider에서 상태 확인 → 블러 on/off

#### 3.3 QT 말씀 연동
- [ ] QT 말씀은 Phase 3 cronjob에서 생성 → Phase 2에서는 Supabase에 수동으로 5개 시드 데이터 삽입
- [ ] QT Page: mock JSON → Supabase qt_passages 테이블 조회

### 4. TTS (AI 기도문 읽어주기)

- [ ] OpenAI TTS API 연동 (tts-1 모델)
- [ ] 목소리 옵션 3개 매핑:
  - 따뜻한 (Warm) → `alloy`
  - 차분한 (Calm) → `nova`
  - 힘있는 (Strong) → `onyx`
- [ ] AiPrayerCard: 재생 버튼 탭 → TTS API 호출 → 오디오 스트리밍 재생
- [ ] `just_audio` 패키지로 오디오 재생
- [ ] 재생/일시정지/정지 컨트롤
- [ ] 프로그레스 바 (현재 위치 / 전체 길이)
- [ ] Settings에서 목소리 변경 → 다음 기도부터 반영
- [ ] 오디오 캐싱: 같은 기도 결과 재생 시 API 재호출 방지

### 5. 에러 로깅 (Sentry)

- [ ] `sentry_flutter` 패키지 추가
- [ ] main.dart에서 Sentry 초기화 (DSN from .env)
- [ ] 민감 정보 필터링: 기도 텍스트, 이메일 마스킹
- [ ] AI API 에러, STT 에러, Auth 에러 자동 보고
- [ ] breadcrumb: 화면 이동, 기도 시작/완료 이벤트

### 6. 무료 1회 제한

- [ ] 오늘 기도 횟수 체크 (SharedPreferences: last_prayer_date + count)
- [ ] Free 유저 + 오늘 1회 사용 → 2번째 시도 시 Premium 유도 모달
- [ ] 모달: "오늘의 기도를 마쳤습니다 🌸" + [Premium 시작] + [다음에 하기]
- [ ] Premium 유저: 제한 없이 Recording 진입

---

## 완료 조건

- [ ] Google/Apple/Email 로그인 → 프로필 생성 → Home 진입
- [ ] 기도 녹음 (실제 음성) → STT 변환 → AI 분석 → Dashboard 표시
- [ ] QT 말씀 선택 → 묵상 녹음 → AI 분석 → Dashboard
- [ ] AI 기도문 TTS 재생 (3가지 목소리)
- [ ] 기도 기록 Supabase 저장 + Calendar 조회
- [ ] 스트릭 자동 업데이트
- [ ] Free 유저 1일 1회 제한 동작
- [ ] Premium 카드 블러/해제 동작 (mock subscription)
- [ ] Sentry 에러 보고 동작
- [ ] 영어/한국어 모드에서 AI 결과 해당 언어로 생성
