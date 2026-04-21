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

## Phase 3-5 (추가 예정)

Phase 2 승인 후 해당 phase 진입 시 작성:
- Phase 3: `PrayerCoaching` + `Scores`
- Phase 4: `HistoricalStoryDeep` (`todayLesson` 추가)
- Phase 5: `AiPrayerDeep` (audioUrl 제거, `citations[]` 추가)

## 참조

- `.claude/rules/multi-tenant-review.md`
- `.claude/rules/supabase.md`
- `.claude/rules/learned-pitfalls.md` §16 (Code Generation — freezed 재생성)
