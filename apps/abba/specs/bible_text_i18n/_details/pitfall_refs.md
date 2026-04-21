# 이 Feature 관련 함정 체크리스트 — bible_text_i18n

`.claude/rules/learned-pitfalls.md` 16 카테고리 중 본 feature 관련 항목만 link.

---

## Phase 1 · Scripture + PD Bundle 관련 함정

- [x] **§2 Subscription / Payment Crash** — Phase 6는 Pro 결제와 무관하나, Scripture는 Free/Pro 공통 카드 → `isPremium` 영향 없음. 영향 없음.
- [x] **§3 Multi-tenant (Supabase)** ★:
  - `prayers.result` JSONB 스키마 그대로. legacy `verse_en/_ko` 저장된 레코드는 fromJson에서 무시, 다음 조회 시 BibleTextService로 새로 채움.
  - **Supabase Storage RLS 정책 추가 필요** — 기존 `abba` private bucket에 `bibles/*` 경로 SELECT 정책 (authenticated user). RLS COALESCE NULL defense 적용 (anonymous user가 JWT null일 때 대비)
  - bucket 구조 변경 없음, 신규 폴더만 추가 → 기존 `prayers/` 에는 영향 0
- [x] **§4 i18n** ★ 중심:
  - 3 신규 키 × 35 locale. namedArg `bibleTranslationAttribution` placeholder 메타 필수
  - Phase 3/5에서 쓴 스크립트 패턴 재사용
- [x] **§11 성능** ★ 핵심:
  - `BibleTextService.lookup` 은 **3-tier cache** — memory → local file → Supabase download
  - 첫 locale 사용 시: 다운로드 5MB + JSON parse (WiFi 1-2초, 모바일 5-10초)
  - **AI Loading 단계에서 preload(locale) 병렬 호출** — 사용자가 로딩 애니메이션 보는 동안 다운로드 완료
  - 이후 모든 조회는 메모리 캐시 (즉시)
  - 파일 크기 ~2-5MB per locale (전체 성경 66권 기준)
- [x] **§12 Color/Design Token** — keyWordHint 섹션 `softGold α 0.1` — reason/posture green box와 다른 색으로 시각 구분
- [x] **§13 Dead Code Sweep** ★ 핵심:
  - `Scripture.verse(locale)` / `.reason(locale)` / `.posture(locale)` getter 3개 제거
  - 필드 `verseEn`, `verseKo`, `reasonEn`, `reasonKo`, `postureEn`, `postureKo` 제거
  - `ScriptureCard.locale` prop 제거
  - grep 검증: `"scripture\.\(verse\|reason\|posture\)(" apps/abba/` 0 hits
- [x] **§16 Code Generation** ★:
  - `pubspec.yaml` assets 변경 **불필요** (Supabase Storage runtime download)
  - l10n 신규 키 후 `flutter gen-l10n`
  - build_runner 불필요 (plain class)
  - **`scripts/build_bible_bundles.py`** 신규 작성 — USFM → JSON 자동 변환 (Phase 3에서 재사용)

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

- JSON 파일 수작업 작성 금지 — **USFM → JSON 자동 변환 스크립트 (`scripts/build_bible_bundles.py`) 필수**
- USFM 원본은 ebible.org 또는 seven1m/open-bibles GitHub에서 1차 다운로드
- 검증: 변환 후 100 random reference spot-check + 전체 절 수 (신약 7957, 구약 23214, 총 31171) 기대값 대조
- 파일 encoding UTF-8 (BOM 없음)
- Supabase 업로드 전 manifest.json의 sha256 계산 → 버전 추적

### 3. Supabase legacy 레코드 호환

- Phase 5 이전 저장된 레코드: `scripture.verse_en`, `verse_ko` 있음
- Phase 6 fromJson: `verse_en/_ko` 무시 + BibleTextService에서 재조회
- 결과: **한국어 유저가 과거 기도 열 때도 새로 개역한글 표시됨** (과거 개역개정 verbatim일 수 있었던 문제 자동 해결!)
- 덤 효과: 출시 전 legacy 레코드 마이그레이션 불필요

### 4. Scripture 카드 세로 길이

keyWordHint 섹션 + reason + posture + originalWords + PD verse 본문 → 카드가 길어짐. `ExpandableCard` 구조 기본 접힘 + verse만 preview 표시 고려 (Phase 2 이미 접힘 구조).

### 5. 오프라인 동작

- **첫 locale 사용은 네트워크 필요** (Supabase Storage 다운로드)
- 이후 조회는 로컬 캐시 → **완전 오프라인 OK**
- 사용자 시나리오:
  - 시니어 첫 앱 설치 → 첫 기도 시 WiFi 권장 (다운로드 1-2초)
  - 캐시 완료 후 비행기/시골 등 오프라인 환경에서도 평소 사용 가능
- 네트워크 실패 + 캐시 미존재 → `null` 반환 → ScriptureCard reference-only fallback UI ("Psalm 23:1 — 나의 성경으로 찾아보세요") 

### 6. Supabase Storage RLS 함정

- **anonymous user JWT**: Abba는 Anonymous-First 인증, 대부분 유저가 anon auth token 보유
- RLS 정책에서 `TO authenticated` 사용 시 **anon JWT도 포함됨** (Supabase auth.uid() not null 기준)
- 단 로그아웃 상태 (JWT 없음) 시 download 실패 — 현재 Abba 구조상 발생 불가 (앱 시작 시 자동 anon sign-in)
- COALESCE NULL defense: `USING (coalesce(auth.uid(), '00000000-0000-0000-0000-000000000000'::uuid) IS NOT NULL AND ...)` 패턴 권장

### 7. 일본어 口語訳 저작권 리스크

- Phase 1 구현 전 **일본성서협회 공식 확인 필수**
- 확인 안 되면 文語訳 1887 (PD 확실) 사용
- 결정 결과를 `_details/data_model.md` 번역본 표에 반영

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
