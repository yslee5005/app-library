# REQUIREMENTS.md — Abba (기도/QT AI 동반자)

> Version: 1.0 | Created: 2026-04-06
> Status: Draft

---

## 1. 프로젝트 비전

"기도하면, AI가 성경으로 응답하고, 당신을 위한 기도를 들려줍니다."

60대 이상 시니어 기독교인이 **매일 기도/QT를 습관으로 만들고**, 기도에 대한 피드백과 성장을 경험하는 앱.

**핵심 가치:**
- 기도하면 끝이 아니라 → **AI가 성경으로 응답**
- 콘텐츠 소비가 아니라 → **내 기도에 대한 개인 맞춤 피드백**
- 복잡한 앱이 아니라 → **버튼 하나로 시작, 3탭으로 완료**

---

## 2. 타겟 사용자

| 항목 | 상세 |
|------|------|
| 1차 타겟 | 50~70대 기독교인 (전세계) |
| 2차 타겟 | 매일 기도/QT 습관을 만들고 싶은 모든 기독교인 |
| 언어 | 영어 (기본), 한국어 (동시 지원), 추후 확장 |
| 플랫폼 | iOS + Android (Flutter) |

### 사용자 페르소나

**김 집사님 (67세, 한국)**
- 매일 아침 5시 기상, 기도 후 QT
- 스마트폰은 카카오톡, 유튜브 정도 사용
- "기도하고 나면 허전한데, 뭔가 응답받는 느낌이 있으면 좋겠어"
- 글씨 작은 앱은 안 씀

**John (62세, 미국)**
- 교회 장로, 매일 기도하지만 기록이 안 됨
- "기도 내용을 돌아보고 싶은데 기억이 안 나"
- AI에 관심 있지만 복잡한 건 싫음

---

## 3. 핵심 플로우

### 3.1 기도 플로우 (매일 핵심 경로)

```
Home → [🎙️ 기도하기] 탭
  → Recording 오버레이 (바로 녹음 시작)
  → 기도 완료 [✅]
  → AI Loading (3초, 씨앗→꽃 애니메이션)
  → AI Dashboard (인사이트 + AI 기도문 재생)
```

**터치 수: 3번 (기도하기 → 완료 → 홈으로)**

### 3.2 QT 플로우

```
Home → [📖 QT하기] 탭
  → QT Page (오늘의 말씀 5개 중 선택)
  → 선택한 말씀 전문 읽기
  → [🎙️ 묵상 시작하기]
  → Recording → AI Loading → AI Dashboard
```

### 3.3 커뮤니티 플로우

```
탭바 [🌻 Community]
  → 피드 (간증/기도요청)
  → 글 탭 → 인라인 댓글/리플라이
  → [✏️ FAB] → Write Post
```

---

## 4. 화면별 상세 요구사항 (11페이지)

### 4.1 Welcome + Onboarding (1페이지)

| 항목 | 상세 |
|------|------|
| 목적 | 첫 진입, 앱 소개 |
| 요소 | Morning Garden 배경 + "Abba" 로고 + 한 줄 소개 + [시작하기] 버튼 |
| 동작 | 버튼 탭 → Login |
| 비고 | 1장으로 끝. 슬라이드 없음 (시니어 혼란 방지) |

### 4.2 Login

| 항목 | 상세 |
|------|------|
| 목적 | 최소한의 입력으로 가입/로그인 |
| 요소 | [Apple] [Google] [Email] 3개 큰 버튼 (각 64dp) |
| 동작 | 소셜 로그인 → Supabase Auth → Home |
| Phase 1 | 탭하면 바로 Home으로 (mock) |

### 4.3 Home (메인)

| 항목 | 상세 |
|------|------|
| 목적 | 매일 첫 화면, 즉시 행동 |
| 요소 | 인사말 + 큰 버튼 2개 (기도하기/QT하기) + 스트릭 카드 + Daily Verse 카드 |
| 동작 | [기도하기] → Recording 오버레이 / [QT하기] → QT Page |
| 탭바 | 🌳 Home / 📅 Calendar / 🌻 Community / ⚙️ Settings |
| 핵심 | 토글 없음. 큰 버튼 2개로 즉시 선택 |

### 4.4 Recording (녹음)

| 항목 | 상세 |
|------|------|
| 목적 | 기도/묵상 녹음 |
| 표시 방식 | 풀스크린 오버레이 (Home 위에) |
| 요소 | 파형 애니메이션 + 경과 시간 (36pt) + [일시정지] + [완료] 버튼 |
| 전환 옵션 | 우측 상단 [⌨️ 텍스트로 전환] — 텍스트 입력 모드 |
| 오디오 분석 | Gemini 2.0 Flash 멀티모달 (`analyzePrayerFromAudio`) — 오디오 업로드 → transcribe + 분석 1-call, 35 locale 자동 지원, ~$0.004/세션 <br> ~~(구 계획: speech_to_text 온디바이스)~~ Gemini 멀티모달로 전환 (2026-04-22, 35 locale 자동 지원) |
| 완료 시 | → AI Loading |

### 4.5 AI Loading

| 항목 | 상세 |
|------|------|
| 목적 | AI 분석 대기, 불안감 해소 |
| 요소 | 씨앗→꽃 애니메이션 + "묵상하고 있습니다..." + 성경 구절 페이드인 |
| 시간 | 3-5초 (실제 API 응답 시간에 맞춤) |
| 전환 | 자동으로 Dashboard로 |

### 4.6 AI Dashboard (핵심 결과 화면)

| 항목 | 상세 |
|------|------|
| 목적 | 기도 분석 결과 + AI 기도문 재생 |
| 상단 | [← 홈으로] + "기도 정원 🌸" + [↗ 공유] |

**6개 카드 (스크롤):**

| # | 카드 | Free | Premium |
|---|------|------|---------|
| 1 | 📜 오늘의 말씀 — 관련 성경 구절 | ✅ | ✅ |
| 2 | 📖 성경 이야기 — 관련 성경 이야기 요약 | ✅ | ✅ |
| 3 | ✍️ 나의 간증 — 기도 녹음 자동 텍스트 변환 | ✅ | ✅ |
| 4 | 💬 AI 조언 — 기도 내용 기반 맞춤 조언 | 타이틀만 보임, 내용 블러 | ✅ |
| 5 | 🔊 당신을 위한 기도 — AI 기도문 TTS 재생 | 타이틀만 보임, 잠금 | ✅ (목소리 선택) |
| 6 | 🔤 원어의 깊은 뜻 — 히브리어/헬라어 해석 | 타이틀만 보임, 내용 블러 | ✅ |

**프리미엄 잠금 UX:**
- 타이틀 + 아이콘 항상 보임
- 내용 영역 = 블러 처리 (BackdropFilter)
- 하단에 [💎 Premium으로 보기] CTA 버튼
- 사용자가 "이 기능이 뭔지" 알고 → 호기심 → 구독 유도

**하단:** [🏠 홈으로 돌아가기] 큰 버튼

### 4.7 QT Mode

| 항목 | 상세 |
|------|------|
| 목적 | 오늘의 말씀 선택 + 읽기 + 묵상 |
| 요소 | 5개 말씀 카드 (서로 다른 파스텔 컬러) |
| 카드 구성 | 성경 참조 (22pt) + 본문 미리보기 (16pt) + 자연 아이콘 |
| 동작 | 탭 → 카드 확장 (전문 표시) → [🎙️ 묵상 시작하기] → Recording |
| 완료 표시 | ✅ 꽃 피는 체크마크 |
| 데이터 | AI cronjob이 매일 5개 생성 (모든 유저 동일) |
| 저작권 | AI가 성경 본문을 재창작 (직접 인용 아닌 의역/묵상용 텍스트) |

### 4.8 Community Feed

| 항목 | 상세 |
|------|------|
| 목적 | 간증/기도 공유 |
| 필터 | [전체] [간증] [기도요청] — 수평 칩 |
| 글 카드 | 프로필(아바타/익명) + 시간 + 내용(3줄) + [❤️] [💬] [🔖] |
| 댓글 | 인라인 확장 (글 탭 시) |
| 리플라이 | 댓글에 [↩️ Reply] → 대댓글 (1 depth만) |
| 글쓰기 | 우하단 FAB [✏️] → Write Post |

### 4.9 Write Post

| 항목 | 상세 |
|------|------|
| 목적 | 간증/기도 작성 |
| 프라이버시 | [익명 🌿] ↔ [실명] 큰 스위치 |
| 카테고리 | [간증] [기도요청] 2개 칩 |
| 입력 | 큰 텍스트 필드 (18pt, 최소 200px 높이) |
| 가져오기 | [🎙️ 기도에서 가져오기] — Dashboard 간증 텍스트 자동 불러오기 |
| 공유 | [공유하기 🌱] 큰 버튼 |

### 4.10 Prayer Calendar

| 항목 | 상세 |
|------|------|
| 목적 | 기도 습관 추적, 동기부여 |
| 달력 | 월간 그리드, 기도한 날 = 🌸, 오늘 = 골드 테두리 |
| 스트릭 | "🔥 현재 7일 연속 / 🏆 최장 21일" 카드 |
| 히스토리 | 날짜 탭 → 해당 날 기도 목록 → 탭하면 Dashboard 다시보기 |

### 4.11 Settings

| 항목 | 상세 |
|------|------|
| 프로필 | 아바타 + 이름 + 이메일 + 총 기도 횟수/연속일 |
| Premium | Free vs Premium 비교 + 가격 표시 + [시작하기] 버튼 |
| 가격 | 월 $6.99 / 연 $49.99 (Save 40%) / 프로모션: 3개월 $3.99/월 |
| 설정 | 알림(토글+시간), AI 목소리(드롭다운), 언어(드롭다운), 다크모드(토글) |
| 언어 안내 | "AI 분석도 선택한 언어로 제공됩니다" |
| 기타 | 도움말, 약관, 개인정보, 로그아웃, 앱 버전 |

---

## 5. 다국어 (i18n) 전략

### 5.1 구현 방식

Flutter 공식 `flutter_localizations` + ARB 파일.

```
lib/l10n/
├── app_en.arb    ← 영어 (기본, fallback)
├── app_ko.arb    ← 한국어
```

### 5.2 규칙

- UI에 하드코딩 문자열 **0개**
- 모든 텍스트는 `AppLocalizations.of(context).키` 형태
- AI 생성 콘텐츠 (성경, 기도문, 조언)도 사용자 언어 설정에 맞춰 생성
- 언어 전환 시 앱 재시작 없이 즉시 반영
- 날짜/시간 포맷도 로케일에 맞춤 (intl 패키지)

### 5.3 ARB 키 네이밍

```json
{
  "appName": "Abba",
  "welcomeTitle": "기도하면, 하나님이 응답하십니다",
  "getStarted": "시작하기",
  "prayButton": "기도하기",
  "qtButton": "QT하기",
  "greeting": "Good Morning, {name}",
  "@greeting": { "placeholders": { "name": {} } },
  "streakDays": "{count}일 연속 기도",
  "@streakDays": { "placeholders": { "count": {} } },
  "finishPrayer": "기도를 마칩니다",
  "aiLoading": "당신의 기도를 묵상하고 있습니다...",
  "scriptureTitle": "오늘의 말씀",
  "bibleStoryTitle": "성경 이야기",
  "testimonyTitle": "나의 간증",
  "guidanceTitle": "AI 조언",
  "aiPrayerTitle": "당신을 위한 기도",
  "originalLangTitle": "원어의 깊은 뜻",
  "premiumUnlock": "Premium으로 보기",
  "backToHome": "홈으로 돌아가기"
}
```

---

## 6. 수익 모델

### 6.1 무료 vs 유료

| 기능 | Free | Premium |
|------|------|---------|
| 기도/QT | 하루 1회 | **무제한** |
| AI 성경 문구 | ✅ (1개/일) | ✅ (무제한) |
| AI 성경 이야기 | ✅ | ✅ |
| 간증 자동 기록 | ✅ | ✅ |
| AI 조언 | 타이틀만 (블러) | ✅ |
| AI 기도문 TTS | 잠금 | ✅ (목소리 선택) |
| 원어 해석 | 타이틀만 (블러) | ✅ |
| 커뮤니티 | ✅ | ✅ |
| 기도 달력 | ✅ | ✅ |

### 6.2 가격

| 플랜 | 가격 | 비고 |
|------|------|------|
| 월간 | $6.99/월 | 정가 |
| 연간 | $49.99/년 ($4.17/월) | Save 40% |
| 런칭 프로모션 | $3.99/월 (3개월) | 런칭 후 3개월간 |

### 6.3 무료 1회 제한 UX

2번째 기도 시도 시:
```
소프트 모달:
"오늘의 기도를 마쳤습니다 🌸
 내일 다시 만나요!

 Premium으로 무제한 기도하기
 [💎 Premium 시작 — $6.99/월]
 [다음에 하기]"
```

---

## 7. AI 데이터 전략

### 7.1 Phase 1: JSON Mock

모든 AI 데이터를 JSON 파일로 하드코딩. UI 완성 후 API 연결.

```
assets/mock/
├── prayer_result.json      ← 기도 후 대시보드 데이터
├── qt_passages.json        ← 오늘의 QT 말씀 5개
├── community_posts.json    ← 커뮤니티 샘플 글
└── user_profile.json       ← 사용자 프로필
```

### 7.2 Phase 2: 실제 API

| 기능 | API | 모델 |
|------|-----|------|
| 기도 분석 (성경+이야기+조언) | GPT-4o-mini | 1 call, system prompt에 JSON 포맷 지정 |
| AI 기도문 생성 | GPT-4o-mini | 1 call |
| TTS | OpenAI TTS (tts-1) | 목소리 옵션 3개 |
| QT 말씀 생성 | GPT-4o-mini | cronjob, 매일 1 call |
| 원어 해석 | GPT-4o-mini + 원어 DB | 1 call |

### 7.3 JSON Mock 포맷

```json
{
  "scripture": {
    "verse_en": "The LORD is my shepherd; I shall not want.",
    "verse_ko": "여호와는 나의 목자시니 내게 부족함이 없으리로다",
    "reference": "Psalm 23:1"
  },
  "bible_story": {
    "title_en": "David the Shepherd",
    "title_ko": "목자 다윗",
    "summary_en": "Before David became the mighty king of Israel, he was a humble shepherd boy...",
    "summary_ko": "다윗이 이스라엘의 위대한 왕이 되기 전, 그는 겸손한 양치기 소년이었습니다..."
  },
  "testimony": {
    "transcript_en": "Dear Lord, I thank you for this beautiful morning...",
    "transcript_ko": "주님, 이 아름다운 아침에 감사드립니다..."
  },
  "guidance": {
    "title_en": "Guidance",
    "title_ko": "AI 조언",
    "content_en": "Your prayer reflects a deep sense of gratitude...",
    "content_ko": "당신의 기도는 깊은 감사의 마음을 반영하고 있습니다...",
    "is_premium": true
  },
  "ai_prayer": {
    "title_en": "A Prayer for You",
    "title_ko": "당신을 위한 기도",
    "text_en": "Heavenly Father, we come before You with grateful hearts...",
    "text_ko": "하늘의 아버지, 감사하는 마음으로 주 앞에 나아갑니다...",
    "is_premium": true
  },
  "original_language": {
    "title_en": "Original Language",
    "title_ko": "원어의 깊은 뜻",
    "word": "רֹעִי",
    "transliteration": "ro'i",
    "language": "Hebrew",
    "meaning_en": "my shepherd — implies intimate care, personal guidance",
    "meaning_ko": "나의 목자 — 친밀한 돌봄, 개인적인 인도를 의미",
    "context_en": "In ancient Hebrew, a shepherd was not just a job but a covenant relationship...",
    "context_ko": "고대 히브리어에서 목자는 단순한 직업이 아니라 언약적 관계였습니다...",
    "is_premium": true
  }
}
```

---

## 8. 리텐션 & 마케팅 전략

### 8.1 매일 돌아오게 만드는 장치

| 장치 | 구현 |
|------|------|
| 기도 스트릭 | 연속 기도일 카운터 + 꽃 피는 달력 (놓치면 아쉬움) |
| Daily Verse | 매일 새로운 말씀 (Home에 표시) |
| 푸시 알림 | 매일 설정 시간에 "오늘의 기도 시간입니다 🌿" |
| AI 기도문 | "오늘은 어떤 기도를 들려줄까?" — 매일 다른 결과 |
| 커뮤니티 | 다른 사람의 간증 → "나도 기도해야겠다" 동기부여 |

### 8.2 시니어 맞춤 리텐션

| 전략 | 이유 |
|------|------|
| 아침 알림 (오전 5-6시) | 시니어 기도 시간대 |
| "00님, 어제 기도가 아름다웠습니다" | 개인화된 따뜻한 알림 |
| 스트릭 깨져도 벌칙 없음 | 죄책감 X, 격려만 ("다시 시작해도 괜찮아요 🌱") |
| 주간 요약 | "이번 주 5일 기도, 가장 많이 언급한 주제: 감사" |
| 교회 소그룹 공유 | "같이 기도해요" 링크 → 그룹 스트릭 |

### 8.3 자연스러운 유료 전환

| 단계 | 전략 |
|------|------|
| Day 1-3 | 무료로 기도 + 기본 성경 문구 경험 |
| Day 4-5 | Dashboard에서 블러된 AI 조언/기도문 반복 노출 → 호기심 |
| Day 7 | "🎉 7일 연속! 기념으로 Premium 3일 체험" — 무료 체험 유도 |
| Day 10 | 체험 종료 → "Premium이 그리우시면" 소프트 유도 |
| 지속 | 매번 Dashboard에서 블러 카드 노출 (강압 없이) |

---

## 9. 기술 스택

| 항목 | 선택 | 비고 |
|------|------|------|
| 프레임워크 | Flutter (Dart) | iOS + Android 동시 |
| 상태 관리 | Riverpod | |
| 라우터 | go_router | |
| AI Audio Analysis | Gemini 2.0 Flash (멀티모달) | 오디오 transcribe + 분석 1 call, 35 locale 자동 지원, ~$0.004/세션 <br> ~~(구 계획: speech_to_text 온디바이스 $0)~~ Gemini 멀티모달로 전환 (2026-04-22) |
| AI (텍스트 분석) | GPT-4o-mini API | $0.004/세션 |
| TTS | OpenAI TTS (tts-1) | $0.008/세션 |
| 백엔드 | Supabase (app_id: 'abba') | 공유 인프라 |
| 인증 | Supabase Auth (Google/Apple/Email) | |
| 에러 로깅 | Sentry | |
| 결제 | RevenueCat | iOS + Android |
| 다국어 | flutter_localizations + ARB | |
| 푸시 알림 | FCM (Phase 2) | |

---

## 10. 구현 Phase

### Phase 1: UI Shell (JSON Mock)
- 11개 화면 Flutter 구현
- Morning Garden 테마
- 다국어 (en/ko ARB)
- 프리미엄 블러 UI
- JSON mock 데이터
- go_router 네비게이션
- 기본 애니메이션

### Phase 2: Core 기능
- Gemini 2.0 Flash 멀티모달 오디오 분석 연동 (`analyzePrayerFromAudio`) <br> ~~(구 계획: speech_to_text 온디바이스 STT 연동)~~ Gemini 멀티모달로 전환 (2026-04-22)
- GPT-4o-mini API 연동
- OpenAI TTS 연동
- Supabase Auth + DB
- 기도 기록 저장/조회
- **Pending/Retry 아키텍처** (2026-04-23): 유저 원본 즉시 저장(`status='pending'`) → AI 호출 분리 → 실패 시 에러 UI + 클라 3회 재시도 → Edge Function lazy retry (유저 재방문 홈 진입 트리거) → 완성 시 환영 모달. 음성 파일 영구 보존 (회고 기능). 개별/전체 삭제 권한 제공.

### Phase 3: 소셜 + 결제
- 커뮤니티 CRUD (Supabase)
- RevenueCat 구독
- 푸시 알림 (FCM)
- QT cronjob (매일 5개 말씀 생성)

### Phase 4: 배포 + 글로벌
- 앱스토어 제출
- 런칭 프로모션 ($3.99)
- 추가 언어 (일본어, 스페인어...)

---

## 11. 경계 조건

### Always
- 모든 UI 텍스트 → ARB 파일 (하드코딩 금지)
- 버튼 최소 56dp, 텍스트 최소 18pt
- Premium 잠금 → 타이틀 보임 + 내용 블러
- 유저 제출 원본(텍스트/음성) → **AI 호출 전 즉시 Supabase 저장** (status='pending')
- 기도 음성 파일 영구 저장 (유저 회고 목적) — Privacy Policy에 명시, 개별/전체 삭제 권한 제공
- AI 분석 실패 → 명시적 에러 UI + [재시도] 버튼 (클라 세션 3회) + Edge Function lazy retry (유저 재방문 시)
- 완성된 기도(`status='completed'`) → read-only, 재시도 버튼 노출 금지 (토큰 낭비 방지)

### Never
- 시니어에게 복잡한 온보딩 (슬라이드 3장 이상)
- 5개 이상 탭바
- 작은 글씨 (16pt 미만)
- 스트릭 깨졌을 때 부정적 메시지
- AI 실패 시 하드코딩 응답을 "진짜 AI 결과"처럼 표시 (DB 오염 + 신뢰 위반)
- 기도 원본 유실 (AI 실패해도 텍스트/음성은 반드시 보존)

### Ask First
- 새 AI 프롬프트 변경
- Supabase 스키마 변경
- 가격 변경
- Privacy Policy 수정
