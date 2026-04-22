# 이 Feature 관련 함정 체크리스트 — qt_output_redesign

`.claude/rules/learned-pitfalls.md` 16 카테고리 중 본 feature 관련 항목만 link.

---

## Phase 1 · Core 관련 함정

- [x] **§1 Riverpod 라이프사이클** — qt_meditation_result_provider + BibleTextService 재사용 (기존 prayer_output 패턴). async gap `ref.mounted` 체크 필수
- [x] **§3 Multi-tenant (Supabase)** — `qt_sessions.result: JSONB` 스키마 변경 없음. legacy `analysis.key_theme` → `meditation_summary.topic` 이관 시 fromJson fallback
- [x] **§4 i18n** — 4 신규 키 × 35 locale. Phase 3/5에 추가 키
- [x] **§11 성능** — Scripture PD bundle 재사용 (이미 검증됨). meditationSummary는 짧은 String이라 부담 無
- [x] **§12 Color/Design Token** — MeditationSummaryCard는 sage/softGold 재사용 (하드코딩 금지)
- [x] **§13 Dead Code Sweep** ★ Phase 5에서 중요:
  - `MeditationAnalysis.keyTheme` Phase 1에서 meditationSummary.topic으로 흡수 → Phase 5에 필드 제거
  - `RelatedKnowledge.historicalContext` 단일화 전 legacy getter 제거 검증
- [x] **§16 Code Generation** — plain class라 build_runner 불필요. l10n 키 후 `flutter gen-l10n`

## Phase 1 특유 주의

### 1. Scripture 재사용 — QT 맥락 프롬프트 톤
- `reason` 필드 의미: 기도 = "왜 이 말씀이 당신 기도에" / QT = "왜 이 말씀이 당신 묵상에"
- prompt에서 context 차이만 주면 되고, **Scripture 모델/위젯은 동일**
- Cross-feature 품질 일관성 유지 (keyWordHint 원어 정확도, originalWords 검증 등)

### 2. BibleTextService ko_krv 다운로드 재활용
- Phase 1에서 QT가 Scripture.verse 사용 → BibleTextService.lookup(ref, locale)
- 이미 기도로 다운로드된 번들이면 즉시 mem-hit
- 언어 전환 preload 훅도 기도와 공용 (Settings onChanged)

### 3. _hardcodedMeditationResult(locale) 시그니처
- 현재 인자 없음. Phase 1에서 locale 인자 추가 필요
- `analyzeMeditation(..., locale)` 호출부에서 locale 전달
- 호출 체인: analyzeMeditation → _hardcodedMeditationResult(locale) → locale 분기

### 4. AI Hallucinate
- meditationSummary.summary: 사용자 묵상 transcript 참조해 요약 (사실 기반)
- meditationSummary.topic: 본문의 주제 (Bible 내용 기반 — 확실)
- Scripture.originalWords: 본문에 있는 원어만 (Scripture Deep 기존 룰)

## Phase 2-5 (예정)

### Phase 2 함정
- qt_guide.md 토큰 (2,500-3,000) system prompt 삽입 비용
- Hallucinate 금지어 필터 (부족/못 하다/잘못)
- prayer_guide.md와 교차 참조 방지 (각 feature 독립)

### Phase 3 함정
- Citations hallucinate (quote 저자 misattribution, science study 날조) — Phase 5 AiPrayer 대응 그대로 강화
- Citation type `history` 신규 — historical source 엄격 검증

### Phase 4 함정
- GrowthStory 긴 내러티브 → hallucinate 위험 ★ (Historical Story 경험 적용)
- 실존 인물만, 불확실하면 다른 이야기 선택

### Phase 5 함정
- MeditationAnalysis.keyTheme 제거 시 legacy 레코드 호환 (fromJson)
- Application 확장 시 기존 단일 action 레코드 호환

---

## 전체 룰 참조

- `.claude/rules/learned-pitfalls.md`
- prayer_output_redesign / bible_text_i18n / testimony single-field 이전 경험
- `apps/abba/specs/bible_text_i18n/COPYRIGHT.md` — QT Scripture도 동일 31 locale PD bundle 사용
