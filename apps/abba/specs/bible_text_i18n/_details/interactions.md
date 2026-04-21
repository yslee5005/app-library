# Interaction Matrix — bible_text_i18n

> Ralph가 한 줄씩 구현. 매 행 구현 전 Pitfall Tags 카테고리 `learned-pitfalls.md` 재독.
> Phase 1만 정의. Phase 2-3는 해당 phase 진입 시 추가.

---

## Phase 1 · Scripture + BibleTextService + keyWordHint (INT-049 ~ INT-060)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-049 | N/A | `[Scripture.model]` | build-time | `verseEn/Ko`, `reasonEn/Ko`, `postureEn/Ko` 3쌍 → 단일 `verse`/`reason`/`posture`. `keyWordHint: String` 신규 필드 추가. locale getter 3개 제거 | model API 변경 | `code-gen, dead-code-sweep` | pending |
| INT-050 | N/A | `[Scripture.fromJson]` | deserialization | 3단 fallback: `reason` → `reason_en` → `reason_ko` → `''`. `posture` 동일. `verse`는 legacy `verse_en/_ko` 무시 (BibleTextService로 재조회). `key_word_hint` 파싱 추가 | legacy DB compat | `code-gen` | pending |
| INT-051 | N/A | `[Scripture.withVerse]` | runtime | 신규 helper method — immutable copy with `verse` set. BibleTextService lookup 결과를 주입할 때 사용 | 모델 immutable 유지 | `code-gen` | pending |
| INT-052 | N/A | `[assets/bibles/ko_krv.json]` | file-level | 개역한글 JSON bundle 생성. 시편 23편 등 최소 AI가 자주 reference하는 ~300 절 수록 (full Bible은 Phase 3에서) | asset 번들 | `code-gen` | pending |
| INT-053 | N/A | `[assets/bibles/en_web.json]` | file-level | WEB(World English Bible) JSON bundle 동일 ~300 절 | asset 번들 | `code-gen` | pending |
| INT-054 | N/A | `[pubspec.yaml]` | build-time | `assets/bibles/` 경로 등록 | asset 번들 포함 | `code-gen` | pending |
| INT-055 | N/A | `[BibleTextService.interface]` | build-time | 추상 인터페이스: `lookup(ref, locale) -> Future<String?>`, `hasBundleForLocale(locale) -> bool`, `attributions() -> Map<String, String>` | | `code-gen` | pending |
| INT-056 | N/A | `[AssetBibleTextService]` | runtime | 구현체: rootBundle.loadString으로 locale JSON lazy load + 메모리 캐시. reference parse ("Psalm 23:1-3" 범위) + verses map lookup + 결과 join | lazy asset IO | `riverpod-lifecycle, code-gen` | pending |
| INT-057 | N/A | `[bibleTextServiceProvider]` | runtime | Provider 등록 — main.dart에서 `AssetBibleTextService()` override | provider wiring | `riverpod-lifecycle` | pending |
| INT-058 | N/A | `[gemini_service._buildSystemPrompt]` + `[_buildPremiumSystemPrompt]` | runtime | Scripture JSON schema에서 `verse_en/_ko` 제거, `reference`만 요구. `reason`, `posture` 단일 필드 (`$langName`). `key_word_hint` 신규 (1 line). **"Do NOT generate verse text — only select reference"** 지시 추가 | prompt schema 변경 | `subscription-crash` | pending |
| INT-059 | N/A | `[gemini_service._hardcodedPrayerResult]` | runtime | Scripture sample 구조 변경: verse 필드 설정 안 함 (BibleTextService가 runtime에 채움), reason/posture/keyWordHint는 locale-aware. 기존 `"여호와는 나의 목자시니..."` verbatim 제거 | hardcoded API 변경 | `code-gen, dead-code-sweep` | pending |
| INT-060 | N/A | `[PrayerResult.fromJson]` or analyze layer | runtime | Gemini 응답 받은 후 `Scripture` 조립 시 `BibleTextService.lookup(reference, locale)` 호출해서 `verse` 필드 채움. 실패(lookup null)하면 `verse = ''` (UI가 reference-only fallback 렌더) | 비동기 조립 | `riverpod-lifecycle, code-gen` | pending |

## Phase 1 · ScriptureCard Widget (INT-061 ~ INT-066)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-061 | `prayer_dashboard` | `[scripture_card]` | build | `locale` prop 제거. `.verse(locale)`, `.reason(locale)`, `.posture(locale)` 호출 전부 직접 필드 참조로 교체 | API 변경 | `dead-code-sweep` | pending |
| INT-062 | `prayer_dashboard` | `[scripture_card]` | build | `verse` 가 빈 문자열이면 reference-only fallback 렌더: reference(italic) + `l10n.bibleLookupReferenceHint` ("나의 성경으로 찾아보세요" 류) | PD 미지원 locale 대응 | `color-token, i18n` | pending |
| INT-063 | `prayer_dashboard` | `[scripture_card]` | build | verse 본문 바로 아래 **keyWordHint 섹션** 렌더 (`keyWordHint.isNotEmpty` 일 때만): ✨ 아이콘 + hint 텍스트 (bodySmall, warmBrown) | 신규 UX | `color-token, i18n` | pending |
| INT-064 | `prayer_dashboard` | `[scripture_card]` | build | 구절 본문에 PD 번역본 attribution 작게 표시: `"({translation.name}, Public Domain)"` — reference 옆 caption muted | 법적 attribution | `i18n, color-token` | pending |
| INT-065 | `prayer_dashboard` | `[scripture_card]` | build | originalWords 섹션(기존 Phase 2) 유지 — 변경 없음. 단 keyWordHint와 중복성 UX 점검 (기본 접힘 유지) | 기존 패턴 | `i18n` | pending |
| INT-066 | `prayer_dashboard` | `[prayer_dashboard_view]` + `[qt_dashboard_view]` | build | ScriptureCard 호출에서 `locale:` prop 제거 | 호출부 업데이트 | `dead-code-sweep` | pending |

## Phase 1 · Hardcoded Audit (INT-067 ~ INT-068)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-067 | N/A | `[ai_loading_view._setFallbackResult]` | runtime | 남아있는 `BibleStory(titleEn/Ko, summaryEn/Ko)` 참조 Phase 2 스코프 — Phase 1에선 Scripture만 업데이트 (verseEn/Ko 제거). BibleStory 부분은 Phase 2에서 | partial update | `code-gen` | pending |
| INT-068 | N/A | `[openai_service._fallbackPrayerResult]` | runtime | Scripture `verseEn/verseKo` 제거, reference만 남김. legacy 경로 유지 가능하도록 (Phase 2에서 BibleStory도) | partial update | `code-gen` | pending |

## Phase 1 · l10n (INT-069 ~ INT-070)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-069 | N/A | `[l10n]` | build-time | 신규 키 2개 × 35 locale: `scriptureKeyWordHintTitle` (✨ 오늘의 핵심 단어), `bibleLookupReferenceHint` (나의 성경으로 찾아보세요 류) | PD 미지원 locale + keyWordHint 라벨 | `i18n, code-gen` | pending |
| INT-070 | N/A | `[l10n]` | build-time | `bibleTranslationAttribution` 키 추가 — `"{name}, Public Domain"` namedArgs | 35 locale | `i18n` | pending |

## 컬럼 가이드

- ID: `INT-NNN` (prayer_output_redesign의 INT-048 이후 연속)
- Pitfall Tags:
  - `riverpod-lifecycle` (§1)
  - `subscription-crash` (§2)
  - `i18n` (§4)
  - `color-token` (§12)
  - `code-gen` (§16)
  - `dead-code-sweep` (§13)

## Ralph 실행 가이드

1. 매 행 구현 전 Pitfall Tags 카테고리 재독
2. 구현 → widget test → status `done`
3. INT-049 ~ INT-070 완료 후:
   - `dart run build_runner build --delete-conflicting-outputs` (해당되면)
   - `flutter gen-l10n` (INT-069, INT-070 반영)
   - `flutter analyze apps/abba` 0 error
   - grep: `"verseEn\|verseKo\|reasonEn\|reasonKo\|postureEn\|postureKo"` → HistoricalStory 관련 0 hits (이번에 Scripture만)
   - grep: `"여호와는 나의 목자시니"` 같은 개역개정 verbatim 문자열 → 확인 후 PD 매칭되는지 점검
4. 모두 통과 → Phase 1 commit → Phase 2 진행 승인 대기

## 테스트 매핑 (Phase 1)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-049, INT-050 | `test/models/prayer_test.dart` | Scripture.fromJson 신규 + legacy 3단 fallback / keyWordHint 파싱 |
| INT-055, INT-056 | `test/services/bible_text_service_test.dart` (신규) | lookup "Psalm 23:1" (ko/en) / 범위 "Psalm 23:1-3" / 없는 reference null / locale 없음 null |
| INT-061-064 | `test/features/dashboard/widgets/scripture_card_test.dart` (기존/신규) | verse 빈 문자열 fallback UI / keyWordHint 렌더 / PD attribution caption |
| INT-058, INT-059 | `test/services/gemini_service_hardcoded_test.dart` (있으면) | hardcoded Scripture.verse='' 초기값 / BibleTextService 주입 후 verse 채워짐 |

---

## Phase 2 INT-XXX (추가 예정)

Phase 1 done 후 BibleStory + Guidance 리팩터링으로 INT-071부터 이어서 할당.
