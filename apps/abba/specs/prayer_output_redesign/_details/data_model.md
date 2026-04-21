# Data Model

> Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 추가 작성.

---

## Phase 1 · Core + Audio 이동

### 현재 상태 (before)

```dart
// apps/abba/lib/models/prayer.dart (현재)
@freezed
class PrayerResult {
  PrayerSummary? prayerSummary;  // 감사/간구/중보 3축 (optional)
  Scripture scripture;            // verse + reference
  String testimony;               // STT transcript (String 직접)
  HistoricalStory? historicalStory;
  AiPrayer? aiPrayer;             // text + audioUrl
  OriginalLanguage? originalLanguage;
}
```

오디오는 현재 **TestimonyCard에서 `audioUrl`을 받아 재생** (`prayer_dashboard_view.dart:176`).

### 변경 (Phase 1 after)

```dart
@freezed
class PrayerResult {
  PrayerSummary prayerSummary;   // optional 제거 — 항상 생성
  String transcript;              // rename: testimony → transcript
  String? audioUrl;               // 신규: PrayerResult 최상위로 이동 (사용자 기도 녹음)
  Scripture scripture;            // Phase 2에서 확장 예정
  HistoricalStory? historicalStory;
  AiPrayer? aiPrayer;             // Phase 5에서 audioUrl 제거 예정
  OriginalLanguage? originalLanguage; // Phase 2에서 Scripture로 편입 예정
}

@freezed
class PrayerSummary {
  List<String> gratitude;         // 감사
  List<String> petition;          // 간구
  List<String> intercession;      // 중보
}
```

### 마이그레이션 규칙

1. `testimony` 필드명 → `transcript` 변경 (전역 참조 갱신 필수)
2. `audioUrl`: PrayerResult 최상위로 이동. Phase 1 단계에선 `aiPrayer.audioUrl`도 유지 (Phase 5에서 일괄 제거)
3. `prayerSummary` optional 제거: 항상 non-null. 기존 fallback 데이터에 기본값 추가

### Supabase 스키마 영향

- **변경 없음** (prayers 테이블의 `result: JSONB` 필드에 통째 저장되므로 schema 변경 불필요)
- **단**: JSON 역직렬화 호환성 — 기존 저장된 prayers의 `testimony` 키를 `transcript`로 읽을 수 있게 `PrayerResult.fromJson` 커스텀 adapter 추가

### Hardcoded Fallback 영향

`gemini_service.dart`의 `_hardcodedPrayerResult()`, `_fallbackPrayerResult()` 두 함수 — 새 구조(transcript, audioUrl)에 맞춰 업데이트.

현재 `_hardcodedTranscription` 상수 그대로 사용. `audioUrl`은 하드코딩 단계에선 `null` (실 audioUrl은 Recording flow에서 주입).

---

---

## Phase 2 · Scripture Deep (원어 편입)

### 실제 현재 상태 (Phase 1 commit 이후)

`Scripture` 클래스 이미 보유:
- `verseEn/Ko` (구절)
- `reference` (참조)
- `reasonEn/Ko` (**이미 있음** — "왜 이 말씀인가")

→ 사용자 요구 "왜 이 말씀" **이미 구현됨**. Phase 2는 **`posture` 추가 + 원어 편입**만.

### 변경 (Phase 2 after)

```dart
class Scripture {
  final String verseEn;
  final String verseKo;
  final String reference;
  final String reasonEn;
  final String reasonKo;
  final String postureEn;              // 신규 — "이 말씀을 읽고 가질 자세"
  final String postureKo;              // 신규
  final List<OriginalWord> originalWords; // 신규 — 원어 해석 편입 (0-2개)
  // ... (생성자 업데이트)
}

class OriginalWord {
  final String word;                   // 히브리어/헬라어
  final String transliteration;        // 로마자 발음
  final String language;               // "Hebrew" | "Greek"
  final String meaningEn;
  final String meaningKo;
  final String nuanceEn;               // 신규 — 번역과의 뉘앙스 차이
  final String nuanceKo;               // 신규

  String meaning(String locale) => locale == 'ko' ? meaningKo : meaningEn;
  String nuance(String locale) => locale == 'ko' ? nuanceKo : nuanceEn;
}
```

### PrayerResult 변경

```dart
class PrayerResult {
  // Scripture에 originalWords 편입
  final Scripture scripture;
  // ...
  // REMOVE: final OriginalLanguage? originalLanguage;  ← Phase 2에서 제거
}
```

### 기존 `OriginalLanguage` 클래스 처리

- **DELETE**: `OriginalLanguage` 클래스 전체 삭제 (`prayer.dart`)
- 새 `OriginalWord` 클래스가 대체 (간소화 + nuance 필드 추가)
- 기존 `OriginalLanguage.fromJson` 참조 전부 제거

### Supabase 스키마 영향

변경 없음 (여전히 `result: JSONB` 통째 저장).  
단 `fromJson` 커스텀 adapter: 기존 DB 레코드의 `original_language` 키를 Scripture.originalWords[0]로 마이그레이션 (lossy 호환).

### Hardcoded Fallback 영향

`_hardcodedPrayerResult()`의 Scripture 부분:
- `postureEn/Ko` 필드 신규 하드코딩
- `originalWords` 배열 1-2개 하드코딩 (예: "ברך" barak + "חסד" chesed)
- `originalLanguage` 필드 제거

---

---

## Phase 3 · Prayer Coaching (신규 카드)

### 신규 모델

```dart
class PrayerCoaching {
  final CoachingScores scores;
  final List<String> strengths;      // 2-4 items
  final List<String> improvements;   // 2-4 items
  final String overallFeedbackEn;
  final String overallFeedbackKo;
  final String expertLevel;          // "beginner" | "growing" | "expert"
  final bool isPremium;              // always true for Phase 3

  const PrayerCoaching({
    required this.scores,
    required this.strengths,
    required this.improvements,
    required this.overallFeedbackEn,
    required this.overallFeedbackKo,
    required this.expertLevel,
    this.isPremium = true,
  });

  String overallFeedback(String locale) =>
      locale == 'ko' ? overallFeedbackKo : overallFeedbackEn;

  factory PrayerCoaching.fromJson(Map<String, dynamic> json) {
    return PrayerCoaching(
      scores: CoachingScores.fromJson(json['scores'] as Map<String, dynamic>),
      strengths: (json['strengths'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? [],
      improvements: (json['improvements'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ?? [],
      overallFeedbackEn: json['overall_feedback_en'] as String? ?? '',
      overallFeedbackKo: json['overall_feedback_ko'] as String? ?? '',
      expertLevel: json['expert_level'] as String? ?? 'growing',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  factory PrayerCoaching.placeholder() => const PrayerCoaching(
        scores: CoachingScores(
          specificity: 0,
          godCenteredness: 0,
          actsBalance: 0,
          authenticity: 0,
        ),
        strengths: [],
        improvements: [],
        overallFeedbackEn: 'Unlock your personal prayer coaching feedback...',
        overallFeedbackKo: 'Pro로 당신의 기도에 대한 맞춤 코칭을 받아보세요...',
        expertLevel: 'growing',
      );
}

class CoachingScores {
  final int specificity;       // 1-5, 0 = placeholder
  final int godCenteredness;   // 1-5
  final int actsBalance;       // 1-5
  final int authenticity;      // 1-5

  const CoachingScores({
    required this.specificity,
    required this.godCenteredness,
    required this.actsBalance,
    required this.authenticity,
  });

  factory CoachingScores.fromJson(Map<String, dynamic> json) {
    return CoachingScores(
      specificity: (json['specificity'] as num?)?.toInt() ?? 0,
      godCenteredness: (json['god_centeredness'] as num?)?.toInt() ?? 0,
      actsBalance: (json['acts_balance'] as num?)?.toInt() ?? 0,
      authenticity: (json['authenticity'] as num?)?.toInt() ?? 0,
    );
  }

  double get average =>
      (specificity + godCenteredness + actsBalance + authenticity) / 4.0;
}
```

### PrayerResult 확장

```dart
class PrayerResult {
  // ... 기존 필드
  final PrayerCoaching? coaching;  // 신규, nullable (Pro만, on-demand)
}
```

`copyWithPremium` 함수에 `coaching` 추가, `fromJson`에 `json['coaching']` 파싱 추가.

### PremiumContent 확장 (on-demand 로드용)

```dart
class PremiumContent {
  // ... 기존 (historicalStory, aiPrayer, guidance)
  final PrayerCoaching? coaching;
}
```

단, Coaching은 **별도 call** (`analyzePrayerCoaching`)이므로 `PremiumContent`에 포함하지 않고 **독립 provider** 사용 가능.

### 설계 결정: 어디에 저장?

- 옵션 A: `PrayerResult.coaching` (기존 모델 확장) — Premium과 다른 라이프사이클이라 섞이면 복잡
- 옵션 B: **독립 provider `prayerCoachingProvider`** — Pro 유저 coaching 카드 first-view 시 호출, cache
- → **옵션 B 권장**. Coaching은 on-demand 단일 호출. `_premiumContent` 와 별도 state.

### Supabase 스키마 영향

기존 `prayers.result: JSONB` 재사용. Coaching 결과 저장 시 `result.coaching` 키로 추가. **저장은 옵션** (재계산 가능하므로):
- MVP: Supabase에 저장 안 함 (매번 신규 호출) — 간단
- v2: 저장 → 이전 기도 review 시 coaching 재사용

Phase 3 MVP는 **저장 안 함** 결정.

### Hardcoded Fallback

`gemini_service.dart` 신규 `_hardcodedCoachingResult()` 함수 추가. 시편 23:1 기반 샘플 기도 코칭.

---

## Phase 4 · Historical Deep (A-1: single-field i18n)

### 결정 (2026-04-21)

사용자가 35 locale 대응 방식으로 **Option A (locale별 prompt에서 직접 생성)** 채택. 동시에 `HistoricalStory` 모델을 **single-field**로 정리 (en/ko 이원 필드 → 사용자 locale에 맞춰 하나의 `title`/`summary`/`lesson`). Phase 4가 이 패턴의 pilot — 결과 좋으면 후속 phase에서 Scripture/BibleStory 등에도 확장.

### 현재 상태 (before)

```dart
class HistoricalStory {
  final String titleEn, titleKo;
  final String reference;          // locale 무관 (e.g., "Bristol, 1838")
  final String summaryEn, summaryKo;
  final String lessonEn, lessonKo;
  final bool isPremium;

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String summary(String locale) => locale == 'ko' ? summaryKo : summaryEn;
  String lesson(String locale) => locale == 'ko' ? lessonKo : lessonEn;
  // ...
}
```

### 변경 후 (Phase 4 after)

```dart
class HistoricalStory {
  final String title;       // 사용자 locale로 생성된 단일 값
  final String reference;    // locale 무관 (기존과 동일)
  final String summary;      // 사용자 locale
  final String lesson;       // 사용자 locale
  final bool isPremium;

  const HistoricalStory({
    required this.title,
    required this.reference,
    required this.summary,
    required this.lesson,
    required this.isPremium,
  });

  factory HistoricalStory.fromJson(Map<String, dynamic> json) {
    return HistoricalStory(
      // 신규 포맷 우선, 기존 _en/_ko 포맷 legacy fallback
      title: json['title'] as String?
          ?? json['title_en'] as String?
          ?? json['title_ko'] as String?
          ?? '',
      reference: json['reference'] as String? ?? '',
      summary: json['summary'] as String?
          ?? json['summary_en'] as String?
          ?? json['summary_ko'] as String?
          ?? '',
      lesson: json['lesson'] as String?
          ?? json['lesson_en'] as String?
          ?? json['lesson_ko'] as String?
          ?? '',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }

  factory HistoricalStory.placeholder(String locale) => HistoricalStory(
    title: locale == 'ko' ? '믿음의 이야기' : 'A Story of Faith',
    reference: '',
    summary: locale == 'ko'
        ? '성경 역사 속 감동적인 이야기를 만나보세요...'
        : 'Unlock to discover a powerful story from Bible history...',
    lesson: '',
    isPremium: true,
  );
}
```

### 제거되는 getter

- `HistoricalStory.title(locale)` / `.summary(locale)` / `.lesson(locale)` → **전부 제거**
- 호출부는 직접 `story.title` / `.summary` / `.lesson` 참조
- 영향 파일: `HistoricalStoryCard` (locale prop은 유지하되 model getter 호출은 제거)

### Legacy DB compat

Supabase `prayers.result: JSONB` 안에 Phase 3 이전 저장된 레코드는 `title_en`/`title_ko` 형태로 저장됨. `fromJson`의 3단 fallback 체인(new → en → ko)으로 **lossy 호환**:
- 기존 사용자가 한국어(`ko`) 유저였다 해도, `json['title_en']`이 fallback 체인 2번째라 영어가 먼저 잡힐 수 있음 → 기존 레코드는 잘못된 언어로 표시될 수 있으나 앱이 크래시되지 않음
- MVP 판단: 다음 기도 시 재생성되면서 새 포맷으로 저장됨. 과거 레코드 정확성은 포기

### Hardcoded fallback locale 인자

`GeminiService._hardcodedPrayerResult()`에 `String locale` 인자 추가. HistoricalStory 생성 시 locale 에 따라 ko/en 샘플 선택. 다른 필드(Scripture, BibleStory 등)는 여전히 ko/en 이원 구조이므로 영향 없음 (Phase 4 scope 밖).

### 프롬프트 schema 변경

기존:
```json
"historical_story": {
  "title_en": "...", "title_ko": "...",
  "summary_en": "...", "summary_ko": "...",
  "lesson_en": "...", "lesson_ko": "...",
  "reference": "...", "is_premium": true
}
```

변경 후 (사용자 locale로 생성):
```json
"historical_story": {
  "title": "<사용자 locale로 생성>",
  "reference": "<locale 무관 — 출처/시대>",
  "summary": "<사용자 locale, 8-10 문장>",
  "lesson": "<사용자 locale, 2-4 문장>",
  "is_premium": true
}
```

### 검증 기준

- summary 길이: 공백 제외 locale별 최소 300자 (한/일/중 CJK) / 800자 (영·유럽어)
- Legacy 호환: 과거 레코드 로드 시 crash 없음 (fromJson 3단 fallback)
- hallucinate: 인물/사건 실존 여부는 prompt + Sentry 샘플로 모니터링

---

## Phase 5 (추가 예정)

Phase 4 승인 후 진입 시 작성:
- Phase 5: `AiPrayer` 재설계 (audioUrl 제거, `citations[]` 추가)

## 참조

- `.claude/rules/multi-tenant-review.md`
- `.claude/rules/supabase.md`
- `.claude/rules/learned-pitfalls.md` §16 (Code Generation — freezed 재생성)
