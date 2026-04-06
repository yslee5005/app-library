# PROMPT.md — Abba Phase 1: UI Shell (JSON Mock)

> Ralph 자율 실행용 프롬프트
> Phase: 1 (UI Shell — JSON mock 데이터, 기능 연결 없음)

---

## 목표

Abba 기도/QT 앱의 **전체 UI를 Flutter로 구현**한다.
- 11개 화면 전부 구현
- JSON mock 데이터로 동작 (실제 AI/DB 연결 없음)
- 다국어 (영어/한국어) ARB 파일
- Morning Garden 테마 (시니어 친화)
- 프리미엄 블러 UI

## 필수 읽기

시작 전 반드시 읽을 것:
- `apps/abba/specs/REQUIREMENTS.md` — 기능 전체 정의
- `apps/abba/specs/DESIGN.md` — 아키텍처, 데이터 모델, 디자인 시스템

## 프로젝트 설정

```bash
# 독립 Flutter 프로젝트 (모노레포 아님)
flutter create abba --org com.ystech
cd abba
```

## 디렉토리 구조

DESIGN.md 섹션 1의 구조를 따를 것.

## Phase 1 체크리스트

### 1. 프로젝트 기초
- [ ] flutter create + pubspec.yaml 의존성 설정
- [ ] Morning Garden 테마 (AbbaColors, AbbaTypography, AbbaSpacing)
- [ ] go_router 설정 (11 routes)
- [ ] 다국어 설정 (flutter_localizations + app_en.arb + app_ko.arb)
- [ ] JSON mock 데이터 파일 4개 (assets/mock/)
- [ ] 데이터 모델 (Prayer, QTPassage, CommunityPost, UserProfile)
- [ ] Mock 데이터 서비스 (MockDataService — JSON 로드)

### 2. Welcome + Login
- [ ] WelcomeView: Morning Garden 배경 + 로고 + [시작하기] 버튼
- [ ] LoginView: Apple/Google/Email 3버튼 (탭 → 바로 Home으로, mock)
- [ ] 모든 텍스트 ARB 키 사용 (하드코딩 0)

### 3. Home (메인)
- [ ] 인사말 (시간대별: Good Morning/Afternoon/Evening + 이름)
- [ ] 큰 버튼 2개: [🎙️ 기도하기] [📖 QT하기] — 각 80dp 높이
- [ ] 스트릭 카드: "🔥 7일 연속 기도" (mock 데이터)
- [ ] Daily Verse 카드: 오늘의 성경 한 절 (mock)
- [ ] 4탭 탭바: Home(🌳), Calendar(📅), Community(🌻), Settings(⚙️)

### 4. Recording (녹음)
- [ ] 풀스크린 오버레이 (showModalBottomSheet fullscreen)
- [ ] 원형 파형 애니메이션 (CustomPainter 또는 간단한 pulse animation)
- [ ] 경과 시간 카운터 (36pt, Timer로 구현)
- [ ] [⏸ 일시정지] + [✅ 기도를 마칩니다] 버튼
- [ ] 우측 상단 [⌨️ 텍스트로 전환] — 탭하면 TextField 표시
- [ ] 완료 → AI Loading으로 네비게이션
- [ ] Phase 1에서는 실제 녹음 없음 (타이머만 동작)

### 5. AI Loading
- [ ] 씨앗→꽃 애니메이션 (Lottie 또는 AnimatedSwitcher로 3단계)
- [ ] "당신의 기도를 묵상하고 있습니다..." 텍스트
- [ ] 성경 구절 페이드인 (FadeTransition)
- [ ] 3초 후 자동으로 Dashboard 전환 (Future.delayed)

### 6. AI Dashboard
- [ ] 상단: [← 홈으로] + "기도 정원 🌸" + [↗ 공유]
- [ ] 6개 카드 (ListView 스크롤):
  - [ ] ScriptureCard: 성경 구절 (mock JSON)
  - [ ] BibleStoryCard: 성경 이야기 요약 (mock)
  - [ ] TestimonyCard: 기도 텍스트 (mock, 수정 아이콘)
  - [ ] GuidanceCard: AI 조언 — **PremiumBlur 래퍼** (타이틀 보임, 내용 블러)
  - [ ] AiPrayerCard: AI 기도문 — **PremiumBlur** + 오디오 플레이어 UI (재생 안 됨, mock)
  - [ ] OriginalLangCard: 원어 해석 — **PremiumBlur**
- [ ] 하단: [🏠 홈으로 돌아가기] 큰 버튼
- [ ] PremiumBlur 위젯: BackdropFilter(sigmaX: 10, sigmaY: 10) + CTA 버튼

### 7. QT Mode
- [ ] 상단: "아침 정원 🌱" + 날짜
- [ ] 5개 말씀 카드 (mock JSON):
  - 각각 다른 파스텔 배경색 + 자연 아이콘
  - 참조 (22pt) + 미리보기 (16pt)
  - 탭 → ExpansionTile 또는 Navigator push로 전문 표시
  - 전문 아래 [🎙️ 묵상 시작하기] → Recording 오버레이
- [ ] 완료된 카드: ✅ 체크마크

### 8. Community Feed
- [ ] 상단: "기도 정원 🌻" + 필터 칩 [전체] [간증] [기도요청]
- [ ] 글 카드 리스트 (mock JSON, 5-6개):
  - 프로필/익명 + 시간 + 내용(3줄) + [❤️ 좋아요] [💬 댓글] [🔖 저장]
  - 탭 → 인라인 확장 (댓글 표시)
  - 댓글에 [↩️ Reply] → 리플라이 (1 depth)
- [ ] FAB [✏️] → Write Post

### 9. Write Post
- [ ] [✕ Cancel] + "나누기 🌸" + [공유하기]
- [ ] 익명/실명 스위치 (큰 토글)
- [ ] 카테고리: [간증] [기도요청] 칩 2개
- [ ] 텍스트 입력 (18pt, 최소 200px)
- [ ] [🎙️ 기도에서 가져오기] 버튼 (mock: 미리 정의된 텍스트 삽입)
- [ ] [공유하기 🌱] 큰 버튼 (탭 → 피드로 돌아가기)

### 10. Prayer Calendar
- [ ] 월간 달력 (GridView, 7열)
- [ ] 기도한 날 = 🌸 (mock: 최근 7일)
- [ ] 오늘 = 골드 테두리
- [ ] 스트릭 카드: 현재 7일 / 최장 21일 (mock)
- [ ] 날짜 탭 → 해당 날 기도 목록 (인라인 확장)
- [ ] 월 이동 [◀ ▶] 버튼

### 11. Settings
- [ ] 프로필 섹션: 아바타 + 이름 + 이메일 + 통계 (mock)
- [ ] Premium 카드: Free vs Premium 비교 + 가격 (월 $6.99 / 연 $49.99)
  - 런칭 프로모션 배너 "🌸 3개월간 $3.99/월!"
  - [Premium 시작하기] 골드 버튼 (탭 → SnackBar "Coming soon")
- [ ] 설정 리스트:
  - 알림 (토글 + 시간 표시)
  - AI 목소리 (드롭다운: 따뜻한/차분한/힘있는)
  - 언어 (드롭다운: English/한국어) — **실제 로케일 변경 동작**
  - 다크모드 (토글 — Phase 1에서는 UI만)
- [ ] 기타: 도움말, 약관, 개인정보, 로그아웃, 버전

## 디자인 규칙 (Morning Garden)

### 절대 지킬 것
- 모든 버튼 최소 56dp 높이 (메인 버튼 80dp)
- 모든 body 텍스트 최소 18pt
- 모든 header 최소 24pt
- 크림(#FFF8F0) 배경 기본
- 세이지 그린(#8FBC8F) 주요 액센트
- 따뜻한 브라운(#5D4E37) 텍스트
- 골드(#D4A574) 프리미엄/액센트
- 폰트: Nunito (영어) + Noto Sans KR (한국어) via google_fonts
- 카드: 둥근 모서리 16px, 소프트 그림자
- 아이콘: 자연 모티프 (🌸🌿🐦☀️💧🌱)

### 절대 하지 말 것
- 16pt 미만 텍스트
- 44dp 미만 터치 타겟
- 5개 이상 탭
- 복잡한 제스처 (스와이프, 롱프레스 등)
- 화려한 전환 애니메이션 (단순한 페이드만)
- 하드코딩 한글/영어 문자열 (ARB 사용)

## 완료 조건

- [ ] `flutter analyze` — 0 에러
- [ ] `flutter test` — 기본 위젯 테스트 통과
- [ ] 영어 모드에서 전체 플로우 동작
- [ ] 한국어 모드에서 전체 플로우 동작
- [ ] Home → Recording → AI Loading → Dashboard 플로우 동작
- [ ] Home → QT → Recording → Dashboard 플로우 동작
- [ ] Community 피드 + 댓글 + 글쓰기 동작
- [ ] Calendar 달력 + 스트릭 표시 동작
- [ ] Settings 언어 변경 시 즉시 반영
- [ ] Premium 카드 블러 + CTA 버튼 동작
- [ ] 모든 화면 스크린샷 캡처
