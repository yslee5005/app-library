# Interaction Matrix — qt_output_redesign

> Ralph가 한 줄씩 구현 (CLAUDE.md 3+ files → Ralph).
> Phase 1만 정의. Phase 2-5는 해당 phase 진입 시 INT 번호 이어서 할당.

INT 번호는 bible_text_i18n Phase 2 (INT-078) 이후로 **INT-101**부터 시작 (100번대 = QT feature).

---

## Phase 1 · Core (INT-101 ~ INT-110)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-101 | N/A | `[MeditationSummary.model]` | build-time | 신규 클래스 (summary, topic) + fromJson | | `code-gen` | pending |
| INT-102 | N/A | `[QtMeditationResult.model]` | build-time | `meditationSummary` + `scripture` 필드 추가. fromJson 업데이트 | | `code-gen` | pending |
| INT-103 | N/A | `[gemini_service._buildMeditationPrompt]` | runtime | 프롬프트 JSON schema 재설계: meditationSummary {summary, topic} + scripture (Scripture Deep 필드 전체) + analysis + application + knowledge. 모두 $langName 단일 필드 | prompt 품질/구조 변경 | `subscription-crash` | pending |
| INT-104 | N/A | `[gemini_service._hardcodedMeditationResult]` | runtime | 신규 구조에 맞춰 locale-aware 하드코딩. Scripture reference = "Psalm 23:1-3", verse='' (BibleTextService 주입) | hardcoded 일관 | `code-gen` | pending |
| INT-105 | N/A | `[_parseMeditationJson]` | runtime | QtMeditationResult.fromJson 신규 필드 파싱 + legacy fallback (기존 JSON에 meditation_summary 없으면 analysis.key_theme에서 추출) | legacy DB compat | `code-gen` | pending |
| INT-106 | N/A | `[BibleTextService.lookup 재사용]` | runtime | Gemini analyzeMeditation 결과 받은 후 Scripture.reference로 PD bundle lookup → Scripture.withVerse 주입. prayer_output의 _enrichScriptureVerse 패턴 그대로 | | `riverpod-lifecycle` | pending |
| INT-107 | `qt_dashboard` | `[meditation_summary_card]` | build | 신규 위젯 — 🌱 제목 + summary (body) + topic (label caption) | 첫 카드 UX | `color-token, i18n` | pending |
| INT-108 | `qt_dashboard` | `[qt_scripture_card]` | build | ScriptureCard 재사용 (위젯 그대로). 차이 없음 | 코드 재사용 | `dead-code-sweep` | pending |
| INT-109 | `qt_dashboard` | `[qt_dashboard_view]` | build | 카드 순서 재정렬: MeditationSummary → Scripture → 기존(Analysis/Application/Knowledge) → GrowthStory | provider 재배열 | `riverpod-lifecycle` | pending |
| INT-110 | N/A | `[l10n]` | build-time | 4 신규 키 × 35 locale: meditationSummaryTitle (🌱 오늘의 묵상), meditationTopicLabel (주제), meditationSummaryLabel (한 마디), qtScriptureTitle (📜 오늘의 말씀) | | `i18n, code-gen` | pending |

### Phase 1 추가 작업

- `supabase_qt_repository.dart` (있으면): 저장 format에 meditation_summary + scripture 추가
- `_parseMeditationJson` legacy compat: 기존 `analysis.key_theme` 을 `meditationSummary.topic` 에 자동 이관

### 테스트 매핑 (Phase 1)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-101, INT-102 | `test/models/qt_meditation_result_test.dart` | MeditationSummary / QtMeditationResult.fromJson 신규 + legacy |
| INT-103 | 없음 (prompt 문자열이라 test 어려움) | 수동 Gemini 호출 검증 |
| INT-106 | `test/features/ai_loading/enrich_test.dart` (있으면) | QT result Scripture.verse 주입 검증 |
| INT-107 | `test/features/dashboard/widgets/meditation_summary_card_test.dart` | 렌더 + compact/medium overflow |

---

## Phase 2 INT-XXX (예정)

Phase 1 done 후 QtCoaching + qt_guide.md asset + l10n 14 키로 INT-111부터 할당.

## Phase 3 INT-XXX (예정)

Citations + Citation type 확장 + QtCitationsCard로 INT-12X~

## Phase 4 INT-XXX (예정)

GrowthStory single-field + 품질 강화 + Hardcoded locale 분기로 INT-13X~

## Phase 5 INT-XXX (예정)

나머지 i18n 통일 + Application 확장 + l10n 마무리로 INT-14X~

## Ralph 실행 가이드

1. 매 행 구현 전 Pitfall Tags 카테고리 재독
2. 구현 → widget test → status `done`
3. INT-101 ~ INT-110 완료 후:
   - `flutter gen-l10n` (INT-110 반영)
   - `flutter analyze apps/abba` 0 error
   - grep 검증 (기존 `.keyTheme(locale)` 등 Phase 5에서 정리)
4. 모두 통과 → Phase 1 commit → Phase 2 승인 대기
