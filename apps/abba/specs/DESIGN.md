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
              │   AI Loading     │
              │  (3-5초 자동)    │
              └────────┬─────────┘
                       │
              ┌────────▼─────────┐
              │   AI Dashboard   │
              │  6 cards (scroll)│
              │  [공유] [홈으로]  │
              └──────────────────┘

  ──── 탭바 접근 ────

  [📅 Calendar]  →  기도 달력 + 히스토리
  [🌻 Community] →  피드 → 댓글/리플라이 → Write Post
  [⚙️ Settings]  →  프로필 + Premium + 설정
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
  final String transcript;      // Gemini 멀티모달 transcribe 결과 텍스트 (구: STT 변환)
  final String mode;             // 'prayer' | 'qt'
  final String? qtPassageRef;    // QT 모드일 때 말씀 참조
  final DateTime createdAt;
  final PrayerResult? result;    // AI 분석 결과
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
-- 기도 기록
CREATE TABLE prayers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  app_id TEXT NOT NULL DEFAULT 'abba',
  user_id UUID NOT NULL REFERENCES auth.users(id),
  transcript TEXT NOT NULL,
  mode TEXT NOT NULL,              -- 'prayer' | 'qt'
  qt_passage_ref TEXT,
  result JSONB,                    -- AI 분석 결과 전체
  created_at TIMESTAMPTZ DEFAULT now()
);

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
