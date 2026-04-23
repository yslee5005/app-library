# DESIGN.md — Abba (기도/QT AI 동반자)

> Version: 1.0 | Created: 2026-04-06
> Status: Draft

---

## 1. 프로젝트 구조 (Feature-First)

```
abba/                          ← 독립 repo
├── lib/
│   ├── main.dart              # 엔트리포인트
│   ├── app.dart               # MaterialApp.router + ProviderScope
│   ├── config/
│   │   └── app_config.dart    # appId, supabase, sentry, ai keys
│   ├── theme/
│   │   └── abba_theme.dart    # Morning Garden 디자인 시스템
│   ├── router/
│   │   └── app_router.dart    # go_router (11 routes)
│   ├── l10n/
│   │   ├── app_en.arb         # 영어
│   │   └── app_ko.arb         # 한국어
│   ├── models/
│   │   ├── prayer.dart        # Prayer, PrayerResult
│   │   ├── qt_passage.dart    # QTPassage
│   │   ├── post.dart          # CommunityPost, Comment
│   │   └── user_profile.dart  # UserProfile, SubscriptionStatus
│   ├── services/
│   │   ├── ai_service.dart    # AI API 인터페이스 (Gemini `analyzePrayerFromAudio` 포함)
│   │   │                      # ~~(구 계획: stt_service.dart speech_to_text 래퍼)~~ Gemini 멀티모달로 전환 (2026-04-22)
│   │   ├── tts_service.dart   # TTS 재생 (Phase 2)
│   │   ├── auth_service.dart  # Supabase Auth (Phase 2)
│   │   └── mock_data.dart     # JSON mock 로더 (Phase 1)
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── prayer_provider.dart
│   │   ├── qt_provider.dart
│   │   ├── community_provider.dart
│   │   ├── calendar_provider.dart
│   │   └── subscription_provider.dart
│   ├── features/
│   │   ├── welcome/
│   │   │   └── view/welcome_view.dart
│   │   ├── login/
│   │   │   └── view/login_view.dart
│   │   ├── home/
│   │   │   └── view/home_view.dart
│   │   ├── recording/
│   │   │   └── view/recording_overlay.dart
│   │   ├── ai_loading/
│   │   │   └── view/ai_loading_view.dart
│   │   ├── dashboard/
│   │   │   ├── view/dashboard_view.dart
│   │   │   └── widgets/
│   │   │       ├── scripture_card.dart
│   │   │       ├── bible_story_card.dart
│   │   │       ├── testimony_card.dart
│   │   │       ├── guidance_card.dart      # Premium 블러
│   │   │       ├── ai_prayer_card.dart     # Premium 잠금
│   │   │       └── original_lang_card.dart # Premium 블러
│   │   ├── qt/
│   │   │   └── view/qt_view.dart
│   │   ├── community/
│   │   │   ├── view/community_view.dart
│   │   │   └── view/write_post_view.dart
│   │   ├── calendar/
│   │   │   └── view/calendar_view.dart
│   │   └── settings/
│   │       └── view/settings_view.dart
│   └── widgets/               # 공유 위젯
│       ├── abba_button.dart   # 큰 버튼 (56dp+)
│       ├── abba_card.dart     # Morning Garden 카드
│       ├── premium_blur.dart  # 프리미엄 블러 래퍼
│       ├── streak_badge.dart  # 스트릭 뱃지
│       └── tab_bar.dart       # 4탭 탭바
├── assets/
│   ├── mock/                  # JSON mock 데이터
│   │   ├── prayer_result.json
│   │   ├── qt_passages.json
│   │   ├── community_posts.json
│   │   └── user_profile.json
│   ├── images/                # 배경, 로고
│   └── animations/            # Lottie (씨앗→꽃)
├── pubspec.yaml
├── .env.example
└── analysis_options.yaml
```

---

## 2. 화면 플로우 다이어그램

```
                    ┌──────────┐
                    │ Welcome  │
                    └────┬─────┘
                         │
                    ┌────▼─────┐
                    │  Login   │
                    └────┬─────┘
                         │
              ┌──────────▼──────────┐
              │        HOME         │
              │  [기도하기] [QT하기]  │
              └──┬────────────┬─────┘
                 │            │
         ┌───────▼───┐  ┌────▼─────┐
         │ Recording │  │ QT Page  │
         │ (overlay) │  │ (5 cards)│
         └───────┬───┘  └────┬─────┘
                 │            │
                 │     ┌──────▼──────┐
                 │     │  Recording  │
                 │     │  (overlay)  │
                 │     └──────┬──────┘
                 │            │
              ┌──▼────────────▼──┐
              │  SAVE TO SERVER   │  ← 2026-04-23: 즉시 저장
              │  (status=pending) │
              └────────┬─────────┘
                       │
              ┌────────▼─────────┐
              │   AI Loading     │
              │  (3-5초 자동)    │
              └───┬────────┬─────┘
             성공 │        │ 실패
                 │        ▼
                 │  ┌──────────────┐
                 │  │  Error View  │
                 │  │ [재시도] 3회 │
                 │  │  [홈으로]    │
                 │  └──────┬───────┘
                 │         │ 유저 홈/종료
                 ▼         ▼
              ┌─────────────┐  ┌──────────────────┐
              │ AI Dashboard │  │ status=pending   │
              │ (completed)  │  │ → 다음 홈 진입 시│
              │              │  │   Edge Function  │
              └──────────────┘  │   lazy retry     │
                                │ (10분 cooldown)  │
                                └────────┬─────────┘
                                         │ 성공
                                         ▼
                                ┌──────────────────┐
                                │ 환영 모달 🌸      │
                                │ "기도 완성됐어요" │
                                └──────────────────┘

  ──── 탭바 접근 ────

  [📅 Calendar]  →  기도 달력 + 히스토리 (pending도 🌸로 표시, 스트릭 유지)
  [🌻 Community] →  피드 → 댓글/리플라이 → Write Post
  [⚙️ Settings]  →  프로필 + Premium + 설정 + 데이터 관리(삭제)
```

---

## 3. 라우팅 (go_router)

```dart
GoRouter(
  initialLocation: '/welcome',
  routes: [
    GoRoute(path: '/welcome', builder: WelcomeView),
    GoRoute(path: '/login', builder: LoginView),
    StatefulShellRoute.indexedStack(
      branches: [
        // Tab 0: Home
        GoRouteBranch(routes: [
          GoRoute(path: '/home', builder: HomeView),
          GoRoute(path: '/home/ai-loading', builder: AiLoadingView),
          GoRoute(path: '/home/dashboard', builder: DashboardView),
          GoRoute(path: '/home/qt', builder: QtView),
        ]),
        // Tab 1: Calendar
        GoRouteBranch(routes: [
          GoRoute(path: '/calendar', builder: CalendarView),
        ]),
        // Tab 2: Community
        GoRouteBranch(routes: [
          GoRoute(path: '/community', builder: CommunityView),
          GoRoute(path: '/community/write', builder: WritePostView),
        ]),
        // Tab 3: Settings
        GoRouteBranch(routes: [
          GoRoute(path: '/settings', builder: SettingsView),
        ]),
      ],
    ),
  ],
)

// Recording = showModalBottomSheet (풀스크린 오버레이, 별도 라우트 아님)
```

---

## 4. 데이터 모델

### 4.1 Prayer (기도 기록)

```dart
class Prayer {
  final String id;
  final String userId;
  final String transcript;       // 텍스트 모드 원문 OR AI transcribe 결과 (pending 상태면 텍스트 모드만 채워짐)
  final String? audioStoragePath; // Supabase Storage 경로 (음성 모드, 영구 보존)
  final String mode;              // 'prayer' | 'qt'
  final String? qtPassageRef;     // QT 모드일 때 말씀 참조
  final DateTime createdAt;
  final PrayerAiStatus aiStatus;  // pending | processing | completed | failed
  final DateTime? lastRetryAt;    // Edge Function cooldown 체크용 (10분)
  final PrayerResult? result;     // AI 분석 결과 (completed 때만 채워짐)
}

/// AI 분석 생명주기 상태 (2026-04-23 추가)
enum PrayerAiStatus {
  pending,     // 유저 원본 저장됨, AI 분석 대기 중
  processing,  // Edge Function 실행 중 (짧은 과도기)
  completed,   // AI 분석 완료, result 채워짐
  failed,      // Edge Function 10회 초과 실패 (극히 드문 케이스)
}

class PrayerResult {
  final Scripture scripture;
  final BibleStory bibleStory;
  final String testimony;        // = transcript
  final Guidance? guidance;      // Premium
  final AiPrayer? aiPrayer;      // Premium
  final OriginalLanguage? originalLanguage; // Premium
}

class Scripture {
  final String verse;            // 로케일 기반
  final String reference;        // "Psalm 23:1"
}

class BibleStory {
  final String title;
  final String summary;
}

class Guidance {
  final String content;
  final bool isPremium;
}

class AiPrayer {
  final String text;
  final String? audioUrl;
  final bool isPremium;
}

class OriginalLanguage {
  final String word;             // 히브리어/헬라어 원문
  final String transliteration;
  final String language;         // "Hebrew" | "Greek"
  final String meaning;
  final String context;
  final bool isPremium;
}
```

### 4.2 QTPassage (QT 말씀)

```dart
class QTPassage {
  final String id;
  final String reference;       // "Psalm 23:1-6"
  final String text;            // 본문 (AI 생성, 저작권 free)
  final String icon;            // 🌸🌿🐦☀️💧
  final String colorHex;        // 파스텔 배경색
  final DateTime date;          // 생성 날짜
  final bool isCompleted;       // 오늘 묵상 완료 여부
}
```

### 4.3 CommunityPost (커뮤니티 글)

```dart
class CommunityPost {
  final String id;
  final String userId;
  final String? displayName;    // null = 익명
  final String? avatarUrl;
  final String category;        // 'testimony' | 'prayer_request'
  final String content;
  final int likeCount;
  final int commentCount;
  final bool isLiked;           // 현재 유저가 좋아요 했는지
  final bool isSaved;           // 현재 유저가 저장 했는지
  final DateTime createdAt;
  final List<Comment> comments;
}

class Comment {
  final String id;
  final String userId;
  final String? displayName;
  final String content;
  final String? parentCommentId; // 리플라이 (1 depth)
  final DateTime createdAt;
}
```

### 4.4 UserProfile

```dart
class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final int totalPrayers;
  final int currentStreak;
  final int bestStreak;
  final SubscriptionStatus subscription;
  final String locale;          // 'en' | 'ko'
  final String voicePreference; // 'warm' | 'calm' | 'strong'
  final String? reminderTime;   // "06:00"
  final bool darkMode;
}

enum SubscriptionStatus { free, premium, trial }
```

---

## 5. Morning Garden 디자인 시스템

### 5.1 컬러

```dart
class AbbaColors {
  // Primary
  static const sage = Color(0xFF8FBC8F);       // 세이지 그린
  static const cream = Color(0xFFFFF8F0);      // 크림 배경
  static const warmBrown = Color(0xFF5D4E37);  // 텍스트
  static const softGold = Color(0xFFD4A574);   // 골드 액센트

  // Pastels (QT 카드용)
  static const softPink = Color(0xFFFFB7C5);
  static const softMint = Color(0xFFB2DFDB);
  static const softLavender = Color(0xFFD1C4E9);
  static const softPeach = Color(0xFFFFCCBC);
  static const softSky = Color(0xFFB3E5FC);

  // Functional
  static const premium = Color(0xFFD4A574);    // 골드 (프리미엄)
  static const streak = Color(0xFFFF6B35);     // 스트릭 불꽃
  static const muted = Color(0xFF9E9E8E);      // 비활성 텍스트
  static const error = Color(0xFFE57373);
}
```

### 5.2 타이포그래피

```dart
class AbbaTypography {
  // 시니어 최소 기준: body 18pt, header 24pt
  static const hero = TextStyle(fontSize: 32, fontWeight: FontWeight.w600);
  static const h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static const body = TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.6);
  static const bodySmall = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const label = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const caption = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  // 폰트: Google Fonts — Noto Sans KR (한국어) + Nunito (영어)
  // 둥글고 따뜻한 느낌, 시니어 가독성 우수
}
```

### 5.3 컴포넌트

```dart
class AbbaSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

class AbbaRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;   // 원형
}

// 버튼 최소 높이
const abbaButtonHeight = 56.0;       // 일반 버튼
const abbaHeroButtonHeight = 80.0;   // 메인 큰 버튼
const abbaTabBarHeight = 56.0;
```

---

## 6. Premium 블러 위젯

```dart
/// 프리미엄 콘텐츠 래퍼
/// - isPremium: true → 타이틀 보이고 내용 블러
/// - isPremium: false → 정상 표시
class PremiumBlur extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget content;
  final bool isLocked;
  final VoidCallback onUnlock;

  // isLocked = true 일 때:
  // 1. 타이틀 + 아이콘 표시 (항상 보임)
  // 2. content 위에 BackdropFilter(blur: 10) 오버레이
  // 3. 하단 [💎 Premium으로 보기] 버튼
}
```

---

## 7. Supabase 테이블 (Phase 2)

```sql
-- 기도 기록 (2026-04-23: Pending/Retry 아키텍처 반영)
CREATE TABLE prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  transcript TEXT,                 -- 텍스트 모드 원문 OR AI transcribe 결과 (pending 때 null 가능)
  audio_storage_path TEXT,         -- Supabase Storage path (음성 모드, 영구 보존)
  mode TEXT NOT NULL,              -- 'prayer' | 'qt'
  qt_passage_ref TEXT,
  ai_status TEXT NOT NULL DEFAULT 'completed'
    CHECK (ai_status IN ('pending', 'processing', 'completed', 'failed')),
  last_retry_at TIMESTAMPTZ,       -- Edge Function cooldown 체크 (10분)
  result JSONB,                    -- AI 분석 결과 전체 (completed 때만)
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 홈 진입 시 pending 기도 조회용 인덱스
CREATE INDEX idx_prayers_pending_per_user
  ON prayers (user_id, ai_status, last_retry_at)
  WHERE ai_status IN ('pending', 'processing');

-- QT 말씀 (매일 cronjob)
CREATE TABLE qt_passages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  reference TEXT NOT NULL,
  text_en TEXT NOT NULL,
  text_ko TEXT NOT NULL,
  icon TEXT NOT NULL,
  color_hex TEXT NOT NULL,
  date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 커뮤니티 글 (app-library comments 패키지 참고)
CREATE TABLE community_posts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  display_name TEXT,              -- null = 익명
  category TEXT NOT NULL,         -- 'testimony' | 'prayer_request'
  content TEXT NOT NULL,
  like_count INTEGER DEFAULT 0,
  comment_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 댓글 (1 depth 리플라이)
CREATE TABLE post_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  display_name TEXT,
  content TEXT NOT NULL,
  parent_comment_id UUID REFERENCES post_comments(id),
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 좋아요
CREATE TABLE post_likes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

-- 저장
CREATE TABLE post_saves (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(post_id, user_id)
);

-- 기도 스트릭
CREATE TABLE prayer_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  current_streak INTEGER DEFAULT 0,
  best_streak INTEGER DEFAULT 0,
  last_prayer_date DATE,
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(app_id, user_id)
);

-- RLS: 모든 테이블에 app_id + user_id 기반 정책 적용
```

---

## 8. AI 프롬프트 설계 (Phase 2 참고)

### 기도 분석 프롬프트 (1 call로 전체 생성)

```
System: You are a compassionate Christian AI counselor.
Analyze the user's prayer and respond in {locale} language.
Return JSON with these fields:
- scripture: relevant Bible verse with reference
- bible_story: related Bible story summary (3-4 sentences)
- guidance: personalized spiritual guidance (3-4 sentences)
- ai_prayer: a prayer written for this person (5-6 sentences)
- original_language: one key Hebrew/Greek word from the scripture
  with transliteration, meaning, and context

Be warm, encouraging, biblically accurate.
Never judge. Always point to God's love and grace.
```

---

## 9. 의존성 (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1
  # ~~speech_to_text: ^7.0.0~~ Gemini 멀티모달(`analyzePrayerFromAudio`)로 전환 (2026-04-22)
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1
  shared_preferences: ^2.3.5
  lottie: ^3.1.0
  # Phase 2
  # supabase_flutter: ^2.8.0
  # purchases_flutter: ^8.0.0  (RevenueCat)
  # just_audio: ^0.9.0         (TTS 재생)
  # http: ^1.2.0               (AI API)
```

---

## 10. Pending Prayer Retry Flow (2026-04-23)

AI 실패 시 유저 기도 원본 유실 방지 + 자연스러운 재시도 아키텍처. REQUIREMENTS §11 "Always" 원칙 구현.

### 10.1 책임 분리

| 레이어 | 역할 | 한도 |
|--------|------|------|
| Client (ai_loading_view) | 기도 제출 → 즉시 저장 → AI 호출 → 실패 시 에러뷰 + 수동 재시도 | 세션당 3회 (앱 재시작 시 리셋) |
| Edge Function (`process_pending_prayer`) | 유저 재방문 홈 진입 시 트리거, pending 기도 1개 처리 | 10분 cooldown, 10회 초과 시 `failed` |

### 10.2 플로우

```
[유저 기도 제출]
  ↓ Client
[prayers INSERT (ai_status='pending', audio_storage_path or transcript)]
  ↓ Client
[Gemini 호출]
  ├─ 성공 → UPDATE ai_status='completed', result=...
  └─ 실패 (AiAnalysisException throw)
       ↓ Client
       [에러 뷰: "AI 서비스가 불안정해요" + [재시도] 버튼]
       ↓ 유저 재시도 (세션 카운터 1~3)
       [다시 Gemini 호출 → 성공 or 실패 반복]
       ↓ 3회 실패
       [안내: "저희가 나중에 다시 시도하겠습니다" + [홈으로]]
       ↓ 유저 홈 복귀 or 앱 종료
       [prayers.ai_status='pending' 유지]

[유저 N분/시간/일 뒤 재방문]
  ↓ Home 진입
[SELECT * FROM prayers WHERE user_id=X AND ai_status='pending' LIMIT 1]
  ├─ 없음 → 정상 홈
  └─ 있음 → Edge Function 호출 (trigger)
       ↓ Edge Function
       [last_retry_at NOW - 10min 이상 지났는지 체크]
       ├─ No → SKIP (cooldown)
       └─ Yes → UPDATE ai_status='processing', last_retry_at=NOW
            ↓ Gemini 호출
            ├─ 성공 → UPDATE ai_status='completed', result=...
            │        ↓ Client Realtime 감지
            │        [환영 모달: "기도 분석이 완성됐어요 🌸"]
            └─ 실패 → UPDATE ai_status='pending' (retry_count 없음 — 다음 방문 기다림)
                     ↓ 만약 누적 서버 실패 10회 이상 → ai_status='failed'
                     [상세 뷰: "AI 분석 어려움, 원본은 보관됨" + 수동 [다시 분석] 버튼]
```

### 10.3 완성된 기도 = Read-only

**핵심 원칙**: `ai_status='completed'`인 기도에는 재시도 버튼 **노출 금지**.

이유:
- 토큰/비용 낭비 방지 (유저가 호기심에 계속 재분석)
- AI diversity로 결과 달라짐 → UX 혼란 ("어, 바뀌었네?")
- 기존 result 덮어쓰기/버전 관리 복잡성 제거

상세 뷰 분기:
- `completed` → 음성 재생 + transcript + scripture + **삭제만**
- `pending` / `failed` → "분석 중/어려움" 안내 + [다시 분석해보기] 버튼 (세션 3회)

### 10.4 비용 방어

| 방어 장치 | 효과 |
|-----------|------|
| Client 세션 3회 | 유저 즉흥 과도 재시도 차단 |
| 앱 재시작 시 리셋 | 긴급 상황 유저가 다시 시도할 퇴로 |
| Server 10분 cooldown | 홈 재진입 스팸 시 Edge Function 폭주 방지 |
| Server 10회 초과 `failed` | 진짜 불가능한 기도 (너무 짧음, 비기도 등) 무한 루프 방지 |
| Mock 경로 분리 | `ENABLE_MOCK_AI=true` 시 Gemini 호출 0회 |
