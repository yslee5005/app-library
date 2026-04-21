# Data Model — bible_text_i18n

Phase 1만 상세. Phase 2-3은 해당 phase 진입 시 작성.

---

## Phase 1 · Scripture 리팩터링

### 현재 상태 (before, prayer_output_redesign Phase 5 commit 후)

```dart
class Scripture {
  final String verseEn;           // AI 생성 (저작권 위험)
  final String verseKo;           // AI 생성 (저작권 위험)
  final String reference;
  final String reasonEn;
  final String reasonKo;
  final String postureEn;
  final String postureKo;
  final List<ScriptureOriginalWord> originalWords;

  String verse(String locale) => locale == 'ko' ? verseKo : verseEn;
  String reason(String locale) => locale == 'ko' ? reasonKo : reasonEn;
  String posture(String locale) => locale == 'ko' ? postureKo : postureEn;
}
```

### 변경 후 (Phase 1 after)

```dart
class Scripture {
  final String reference;                        // "Psalm 23:1-3" (locale-neutral)
  final String verse;                            // BibleTextService 에서 lookup된 PD 번역 (AI 아님)
  final String reason;                           // AI 창작 (사용자 locale)
  final String posture;                          // AI 창작 (사용자 locale)
  final String keyWordHint;                      // 신규 — ✨ 핵심 단어 원-라이너 AI 창작
  final List<ScriptureOriginalWord> originalWords; // Phase 2 유지

  const Scripture({
    required this.reference,
    this.verse = '',                             // PD 번들 없으면 빈 값
    this.reason = '',
    this.posture = '',
    this.keyWordHint = '',
    this.originalWords = const [],
  });

  factory Scripture.fromJson(Map<String, dynamic> json) {
    return Scripture(
      reference: json['reference'] as String? ?? '',
      // 'verse' 필드는 BibleTextService 호출 후 set, fromJson 시엔 비움
      // legacy compat: 과거 저장된 verse_en/ko 있어도 무시 (다음 재조회 시 PD bundle에서 가져옴)
      verse: json['verse'] as String? ?? '',
      reason: json['reason'] as String?
          ?? json['reason_en'] as String?
          ?? json['reason_ko'] as String?
          ?? '',
      posture: json['posture'] as String?
          ?? json['posture_en'] as String?
          ?? json['posture_ko'] as String?
          ?? '',
      keyWordHint: json['key_word_hint'] as String? ?? '',
      originalWords: (json['original_words'] as List<dynamic>?)
              ?.map((e) => ScriptureOriginalWord.fromJson(e as Map<String, dynamic>))
              .toList() ?? const [],
    );
  }

  Scripture withVerse(String verseText) => Scripture(
        reference: reference,
        verse: verseText,
        reason: reason,
        posture: posture,
        keyWordHint: keyWordHint,
        originalWords: originalWords,
      );
}
```

### 제거되는 getter (dead code sweep)

- `Scripture.verse(locale)` → 제거
- `Scripture.reason(locale)` → 제거
- `Scripture.posture(locale)` → 제거
- 필드: `verseEn`, `verseKo`, `reasonEn`, `reasonKo`, `postureEn`, `postureKo` → 제거

### keyWordHint 설계

- 짧은 한 줄 (max ~80자 권장)
- 형식: `"'단어' = 원어 로마자 (언어) — 짧은 설명"`
- 예 (ko): `"'나의 목자' = 히브리어 '로이' — 직업이 아닌 '나를 돌보시는 분'"`
- 예 (en): `"'my shepherd' = Hebrew 'ro'i' — not a job title, but 'the one who tends me personally'"`
- 구절에 등장하는 단어 중 **가장 핵심적인 1개** 선정
- `originalWords` 첫 번째 항목과 중복 가능 (그래도 OK — hint는 바로 보이는 핵심, originalWords는 더 깊은 탐구)

### ScriptureOriginalWord (기존 유지)

변경 없음. 단 Gemini prompt에 "**실제 해당 구절에 등장하는 단어만**, 확신 없으면 생략" 지시 강화.

---

## Phase 1 · BibleTextService (신규 서비스)

### 인터페이스

```dart
abstract class BibleTextService {
  /// Lookup verse text by reference + locale.
  /// Returns null if the locale has no PD bundle or reference not found.
  ///
  /// Reference format: "Book Chapter:Verse" (e.g., "Psalm 23:1")
  /// For verse ranges: "Book Chapter:Start-End" (e.g., "Psalm 23:1-3")
  Future<String?> lookup(String reference, String locale);

  /// Check if the locale has any PD bundle available.
  bool hasBundleForLocale(String locale);

  /// Localized attribution line for settings page
  /// e.g., "Korean: 개역한글 (Public Domain, 2012)"
  Map<String, String> attributions();
}
```

### 구현: `AssetBibleTextService`

- `assets/bibles/{locale}.json` 파일을 lazy load (첫 lookup 때 parse)
- 메모리 캐시 (앱 세션 동안 유지)
- 파일 크기: 신약/구약 전체 기준 locale별 2-5MB

### Bundle JSON 포맷

```json
{
  "locale": "ko",
  "translation": {
    "name": "개역한글",
    "year": 1961,
    "license": "Public Domain (2012 expired)",
    "source": "https://www.bible.com/ko/versions/88-krv"
  },
  "verses": {
    "Psalm 23:1": "여호와는 나의 목자시니 내게 부족함이 없으리로다",
    "Psalm 23:2": "그가 나를 푸른 풀밭에 누이시며 쉴 만한 물가로 인도하시는도다",
    "Psalm 23:3": "내 영혼을 소생시키시고 자기 이름을 위하여 의의 길로 인도하시는도다",
    "...": "..."
  }
}
```

### 범위 매칭 전략

- Reference가 `"Psalm 23:1-3"` 범위형이면 각 절 lookup 후 공백으로 join
- Reference가 단절 (`"Psalm 23:1"`) 이면 해당 절만 반환
- 파싱 실패 시 null

### Phase 1 bundle 범위 (2개 locale만)

Phase 1에서는 ko (개역한글) + en (WEB) 2개만. 나머지 8개 locale은 Phase 3.

### Supabase 영향

없음. `prayers.result.scripture` JSONB 내 `verse` 필드는 여전히 저장되지만, 다음 조회 시 `BibleTextService.lookup`으로 덮어씀 (legacy 호환).

---

## Phase 1 · Hardcoded Audit 플랜

### 현재 hardcoded 위치

1. `gemini_service.dart` `_hardcodedPrayerResult(locale)` — Scripture 부분
2. `ai_loading_view.dart` `_setFallbackResult` — Scripture + BibleStory 부분 (아직 _en/_ko 쓰는 경우)
3. `openai_service.dart` `_fallbackPrayerResult` — Scripture 부분
4. `test/helpers/test_app.dart` testPrayerResult — testPrayer 샘플

### 점검 procedure

1. 각 위치 verse text에 대해 개역개정 수록 여부 확인
2. 개역한글 있으면 해당으로 교체 (wording 미묘하게 다름 가능성)
3. 개역한글에도 없는 절은 WEB 기준으로 교체하거나 Psalm 23 같이 안전한 절로 변경
4. grep `"여호와는 나의 목자시니 내게 부족함이 없으리로다"` 형식 문자열 fact-check

### 시편 23:1 특수성

- 개역개정 `"여호와는 나의 목자시니 내게 부족함이 없으리로다"` 
- 개역한글 `"여호와는 나의 목자시니 내게 부족함이 없으리로다"`
- **완전 동일** — 우연히 안전. 다른 구절은 차이 있을 수 있음

---

## Phase 2 · BibleStory / Guidance (예정)

Phase 1 승인 후 상세 작성. 간단 미리보기:

```dart
class BibleStory {
  final String title;    // was titleEn/Ko
  final String summary;  // was summaryEn/Ko
  // fromJson 3단 fallback
}

class Guidance {
  final String content;  // was contentEn/Ko
  final bool isPremium;
}
```

## Phase 3 · Bundle 확장 (예정)

추가 locale bundle (es/fr/de/zh/ja/pt/it/ru) + Settings attribution UI.

## 참조

- `.claude/rules/learned-pitfalls.md` §3 Multi-tenant, §13 Dead Code Sweep, §16 Code Gen
- prayer_output_redesign/_details/data_model.md Phase 4-5 (A-1 패턴 precedent)
