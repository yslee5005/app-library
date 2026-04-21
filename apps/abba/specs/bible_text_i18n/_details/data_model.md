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

## Phase 1 · BibleTextService (신규 서비스, on-demand download)

### 인터페이스

```dart
abstract class BibleTextService {
  /// Lookup verse text by reference + locale.
  /// Returns null if the locale has no PD bundle or reference not found.
  ///
  /// Triggers download from Supabase Storage on first access per locale.
  /// Subsequent calls use local cache (app support directory).
  ///
  /// Reference format: "Book Chapter:Verse" (e.g., "Psalm 23:1")
  /// For verse ranges: "Book Chapter:Start-End" (e.g., "Psalm 23:1-3")
  Future<String?> lookup(String reference, String locale);

  /// Check if the locale has any PD bundle available (network-free check
  /// of the supportedLocales map).
  bool hasBundleForLocale(String locale);

  /// Localized attribution line for settings page
  /// e.g., "Korean: 개역한글 (Public Domain, 2012)"
  Map<String, String> attributions();

  /// Pre-warm cache for a locale — download if not cached.
  /// Called during AI Loading to parallelize with Gemini call.
  Future<void> preload(String locale);
}
```

### 구현: `SupabaseStorageBibleTextService`

**저장소 구조** (기존 `abba` private bucket 재활용):
```
Supabase Storage > abba/ (private bucket, 기존)
  ├── prayers/          ← 기존 (사용자 음성)
  └── bibles/           ← 신규
      ├── ko_krv.json       (~5MB)
      ├── en_web.json       (~5MB)
      ├── ...                (Phase 3 확장)
      └── manifest.json     (번들 메타데이터: version, sha, translation name)
```

**RLS 정책 추가 (Phase 1 setup)**:
```sql
-- bibles/* 경로에 authenticated user SELECT 허용 (anonymous 포함)
CREATE POLICY "bibles_read_all" ON storage.objects
  FOR SELECT
  TO authenticated
  USING (bucket_id = 'abba' AND (storage.foldername(name))[1] = 'bibles');
```

**로컬 캐시**:
- 위치: `path_provider.getApplicationSupportDirectory()` + `/bibles/{locale}.json`
- TTL: 영구 (번들 변경 시 manifest.json의 `version` 비교해 re-download)
- 메모리 캐시: lookup 후 파싱된 Map을 세션 동안 유지

**다운로드 흐름**:
```dart
Future<String?> lookup(String ref, String locale) async {
  if (!_supportedLocales.contains(locale)) return null;  // fallback UI

  // 1. In-memory cache hit
  if (_memCache.containsKey(locale)) {
    return _memCache[locale]![ref];
  }

  // 2. Local file cache hit
  final file = File('${supportDir}/bibles/${locale}.json');
  if (await file.exists()) {
    final data = jsonDecode(await file.readAsString());
    _memCache[locale] = Map<String, String>.from(data['verses']);
    return _memCache[locale]![ref];
  }

  // 3. Download from Supabase Storage
  final bytes = await Supabase.instance.client.storage
      .from('abba')
      .download('bibles/${locale}.json');
  await file.writeAsBytes(bytes);
  final data = jsonDecode(utf8.decode(bytes));
  _memCache[locale] = Map<String, String>.from(data['verses']);
  return _memCache[locale]![ref];
}
```

**오프라인 대응**:
- 다운로드 실패 (네트워크 없음) → `null` 반환 → ScriptureCard reference-only fallback UI
- 첫 기도 오프라인: AI가 어차피 호출 불가 → 하드코딩 fallback 경로

### 파일 크기 / 비용

- 각 locale JSON: ~2-5MB (전체 성경 66권 기준)
- Phase 1 Supabase Storage: 2 files × 5MB = 10MB
- Phase 3 전체: 27 files × 5MB = **~135MB** — Supabase free tier 1GB 안
- 사용자 데이터: 언어 1개 사용 시 5MB 1회 다운로드 (이후 캐시)

### Bundle JSON 포맷

```json
{
  "locale": "ko",
  "version": "1.0.0",
  "translation": {
    "name": "개역한글",
    "year": 1961,
    "license": "Public Domain (2012 expired)",
    "source": "https://ebible.org/find/details.php?id=kokrv"
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

### Phase 1 bundle 범위 (2개 locale, 전체 성경)

**Phase 1에서는 ko(개역한글) + en(WEB) 2개 언어 전체 성경**. 나머지 25개 locale은 Phase 3 일괄 처리.

- 소스: ebible.org 또는 seven1m/open-bibles GitHub에서 USFM 다운로드
- 변환: `scripts/build_bible_bundles.py` (USFM → JSON)
- 업로드: Supabase Storage abba/bibles/ (service_role key)

---

## Locale별 PD 번역본 선정 표 (확정)

Phase 3에서 각 locale에 대해 다음 번역본을 사용:

| Locale | 번역본 | 발행 | License | Source |
|--------|--------|------|---------|--------|
| ko | 개역한글 | 1961 | PD (2012 만료) | ebible.org |
| en | World English Bible | 2000 | PD | worldenglish.bible |
| es | Reina-Valera 1909 | 1909 | PD | ebible.org |
| fr | Louis Segond 1910 | 1910 | PD | ebible.org |
| de | Luther 1912 | 1912 | PD | ebible.org |
| pt | Almeida Corrigida | 1819 | PD | ebible.org |
| it | Diodati | 1821 | PD | ebible.org |
| ru | Synodal Bible | 1876 | PD | ebible.org |
| zh | 和合本 (CUV) | 1919 | PD | ebible.org |
| ja | 口語訳 (보수: 文語訳 1887) | 1955 | PD 확인 필요 | ebible.org |
| nl | Statenvertaling | 1637 | PD | ebible.org |
| ar | Van Dyck | 1865 | PD | ebible.org |
| el | Vamvas | 1850 | PD | ebible.org |
| pl | Biblia Gdańska | 1632 | PD | ebible.org |
| cs | Kralická | 1613 | PD | ebible.org |
| he | Delitzsch (NT) + Masoretic | 1877 | PD | ebible.org |
| sv | Bibel 1917 | 1917 | PD | ebible.org |
| fi | Raamattu 1933/38 | 1933 | PD | ebible.org |
| hu | Károli | 1908 | PD | ebible.org |
| ro | Cornilescu | 1921 | PD | ebible.org |
| sw | Swahili Union | 1952 | PD (확인 필요) | ebible.org |
| vi | Vietnamese | 1926 | PD | ebible.org |
| th | Thai | 1940 | PD | ebible.org |
| tr | Kitabı Mukaddes | 1941 | PD | ebible.org |
| id | Terjemahan Lama | 1958 | PD (확인 필요) | ebible.org |
| hi | Hindi | 1938 | PD | ebible.org |
| fil | Ang Dating Biblia | 1905 | PD | sacred-texts.com |

### 지원 안 되는 8개 locale (reference-only fallback)

`am, my, ms, da, no, uk, hr, sk` — Phase 3 진입 시 ebible.org 재조사. PD 발견되면 추가.

### 특별 주의 — 일본어

**口語訳 1955** 저작권 논쟁 있음 (일부 출처 PD, 일부 유지 주장). Phase 1 구현 시 직접 확인 (일본성서협회 공식 FAQ 문의). 확인 안 되면 **文語訳 1887**로 대체 — 시니어에게 약간 어려우나 안전.

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

## Phase 2 · BibleStory / Guidance single-field

A-1 패턴 (Phase 4-5 prayer_output_redesign + bible_text_i18n Phase 1) 동일 적용.

### BibleStory — before

```dart
class BibleStory {
  final String titleEn, titleKo;
  final String summaryEn, summaryKo;

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String summary(String locale) => locale == 'ko' ? summaryKo : summaryEn;
}
```

### BibleStory — after

```dart
class BibleStory {
  final String title;
  final String summary;

  const BibleStory({required this.title, required this.summary});

  factory BibleStory.fromJson(Map<String, dynamic> json) {
    return BibleStory(
      title: json['title'] as String?
          ?? json['title_en'] as String?
          ?? json['title_ko'] as String?
          ?? '',
      summary: json['summary'] as String?
          ?? json['summary_en'] as String?
          ?? json['summary_ko'] as String?
          ?? '',
    );
  }
}
```

### Guidance — before

```dart
class Guidance {
  final String contentEn, contentKo;
  final bool isPremium;

  String content(String locale) => locale == 'ko' ? contentKo : contentEn;
}
```

### Guidance — after

```dart
class Guidance {
  final String content;
  final bool isPremium;

  const Guidance({required this.content, required this.isPremium});

  factory Guidance.fromJson(Map<String, dynamic> json) {
    return Guidance(
      content: json['content'] as String?
          ?? json['content_en'] as String?
          ?? json['content_ko'] as String?
          ?? '',
      isPremium: json['is_premium'] as bool? ?? true,
    );
  }
}
```

### 제거되는 getter

- `BibleStory.title(locale)` / `.summary(locale)`
- `Guidance.content(locale)`

### Hardcoded fallback

`_hardcodedPrayerResult(locale)` 이미 locale 인자 받으므로 Bible Story / Guidance 블록만 locale-aware로 변경 (ko / en 분기).

### Legacy DB compat

Phase 6 이전 레코드의 `title_en/ko`, `content_en/ko` 있음 → fromJson 3단 fallback 처리.

---

## Phase 3 · Bundle 확장 (예정)

추가 locale bundle (es/fr/de/zh/ja/pt/it/ru) + Settings attribution UI.

## 참조

- `.claude/rules/learned-pitfalls.md` §3 Multi-tenant, §13 Dead Code Sweep, §16 Code Gen
- prayer_output_redesign/_details/data_model.md Phase 4-5 (A-1 패턴 precedent)
