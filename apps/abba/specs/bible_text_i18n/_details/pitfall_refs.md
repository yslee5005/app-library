# 이 Feature 관련 함정 체크리스트 — bible_text_i18n

`.claude/rules/learned-pitfalls.md` 16 카테고리 중 본 feature 관련 항목만 link.

---

## Phase 1 · Scripture + PD Bundle 관련 함정

- [x] **§2 Subscription / Payment Crash** — Phase 6는 Pro 결제와 무관하나, Scripture는 Free/Pro 공통 카드 → `isPremium` 영향 없음. 영향 없음.
- [x] **§3 Multi-tenant (Supabase)** — `prayers.result` JSONB 스키마 그대로. legacy `verse_en/_ko` 저장된 레코드는 fromJson에서 무시, 다음 조회 시 BibleTextService로 새로 채움.
- [x] **§4 i18n** ★ 중심:
  - 3 신규 키 × 35 locale. namedArg `bibleTranslationAttribution` placeholder 메타 필수
  - Phase 3/5에서 쓴 스크립트 패턴 재사용
- [x] **§11 성능** ★ 핵심:
  - `BibleTextService.lookup` 은 **첫 호출 시 JSON parse**, 이후 메모리 캐시
  - 앱 전체 세션에서 locale 파일 한 번만 parse (rootBundle.loadString + jsonDecode)
  - parse 중 await 블록 있으므로 첫 호출 지연 가능 — **Dashboard 진입 시 pre-warm** 고려 (AI Loading 단계에서)
  - 파일 크기 `ko_krv.json` ~2MB (Phase 1 300절 기준) / full Bible은 5MB
- [x] **§12 Color/Design Token** — keyWordHint 섹션 `softGold α 0.1` — reason/posture green box와 다른 색으로 시각 구분
- [x] **§13 Dead Code Sweep** ★ 핵심:
  - `Scripture.verse(locale)` / `.reason(locale)` / `.posture(locale)` getter 3개 제거
  - 필드 `verseEn`, `verseKo`, `reasonEn`, `reasonKo`, `postureEn`, `postureKo` 제거
  - `ScriptureCard.locale` prop 제거
  - grep 검증: `"scripture\.\(verse\|reason\|posture\)(" apps/abba/` 0 hits
- [x] **§16 Code Generation** ★:
  - `pubspec.yaml` 에 `assets/bibles/` 추가 → `flutter pub get`
  - l10n 신규 키 후 `flutter gen-l10n`
  - build_runner 불필요 (plain class)

---

## Phase 1 특유 주의

### 1. AI Hallucinate 방지 — Scripture 관련

세 가지 hallucinate 위험점:

| 영역 | 위험 | 대응 |
|------|------|------|
| reference 선택 | 존재하지 않는 구절 ("Psalm 200:50") | BibleTextService.lookup 실패 → reference-only fallback UI. Sentry 로그 |
| keyWordHint | 가짜 히브리어/헬라어 단어 | prompt "확신 없으면 빈 문자열" + 출시 전 30 sample fact-check |
| originalWords | 구절에 없는 단어 pair | prompt "해당 구절에 실제 등장하는 단어만" + 검증 layer (선택) |

### 2. PD Bundle 무결성

- JSON 파일 직접 작성 시 escaping 실수 (큰따옴표, 줄바꿈) 위험
- 작성 후 validate 스크립트: Python으로 JSON parse + 100 reference random spot-check
- 파일 encoding UTF-8 (BOM 없음)

### 3. Supabase legacy 레코드 호환

- Phase 5 이전 저장된 레코드: `scripture.verse_en`, `verse_ko` 있음
- Phase 6 fromJson: `verse_en/_ko` 무시 + BibleTextService에서 재조회
- 결과: **한국어 유저가 과거 기도 열 때도 새로 개역한글 표시됨** (과거 개역개정 verbatim일 수 있었던 문제 자동 해결!)
- 덤 효과: 출시 전 legacy 레코드 마이그레이션 불필요

### 4. Scripture 카드 세로 길이

keyWordHint 섹션 + reason + posture + originalWords + PD verse 본문 → 카드가 길어짐. `ExpandableCard` 구조 기본 접힘 + verse만 preview 표시 고려 (Phase 2 이미 접힘 구조).

### 5. 오프라인 동작

- BibleTextService는 assets 기반 → **오프라인 OK**
- AI 생성 reason/posture/keyWordHint는 Gemini 호출 → 오프라인 시 Hardcoded fallback + verse는 assets에서 lookup → 기본 UX 유지

### 6. PD 번역본 품질 편차

- 개역한글(ko): 매우 높은 품질 (시니어 익숙)
- WEB(en): 현대 영어, 읽기 쉬움. NIV보다 literary하지 않음 — 허용 가능
- Reina-Valera 1909(es): 고풍스러운 어투, 현대 사용자에게 낯선 문체 가능. Phase 3 선택 시 재검토
- 口語訳(ja): 문어체, 현대 일본인에게 낯선 느낌 — 新共同訳과 대비. Phase 3 선택 시 재검토

→ Phase 1에서는 ko/en만 bundle. 나머지 locale은 Phase 3에서 locale별 검토 후 채택.

---

## 전체 룰 참조

- `.claude/rules/learned-pitfalls.md` (16 카테고리)
- `.claude/rules/error-handling.md` (3상태)
- `.claude/rules/responsive.md`
- prayer_output_redesign/_details/pitfall_refs.md (A-1 precedent 및 경험치)

---

## Phase 2-3 함정 (추가 예정)

- Phase 2: BibleStory/Guidance single-field — dead code sweep (Scripture와 동일 패턴)
- Phase 3: 8+ PD bundle 품질 검증, attribution 페이지 legal review (혹시 각국 법 다르면)
