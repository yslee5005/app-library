# Interaction Matrix

> Ralph가 한 줄씩 구현. 매 행 구현 전 Pitfall Tags 카테고리 `learned-pitfalls.md` 재독.
> Phase 1만 정의. Phase 2-5 INT-XXX는 해당 phase 진입 시 추가.

---

## Phase 1 · Core + Audio 이동 (INT-001 ~ INT-008)

| ID | Screen | Widget | Trigger | Action | Side Effect | Pitfall Tags | Status |
|----|--------|--------|---------|--------|-------------|--------------|--------|
| INT-001 | `prayer_dashboard` | `[PrayerResult.model]` | build-time | `testimony` 필드를 `transcript`로 rename, `audioUrl` 필드를 최상위로 추가 | freezed 재생성 | `code-gen, riverpod-lifecycle` | pending |
| INT-002 | `prayer_dashboard` | `[PrayerResult.fromJson]` | deserialization | 기존 `testimony` 키 → `transcript` 호환 adapter 추가 | 기존 저장 데이터 호환 | `code-gen` | pending |
| INT-003 | `prayer_dashboard` | `[PrayerSummary.model]` | build-time | optional(?) 제거, 항상 non-null, fallback은 빈 리스트 3개 | freezed 재생성 + fallback 갱신 | `code-gen` | pending |
| INT-004 | `prayer_dashboard` | `[prayer_summary_card]` | build | 카드 하단에 **audio player bar** 렌더 (`audioUrl != null` 일 때만) | 기존 testimony audio 로직 이동 | `riverpod-lifecycle, dispose, color-token` | pending |
| INT-005 | `prayer_dashboard` | `[prayer_summary_audio_play_btn]` | `onTap` | 기도 녹음 재생/일시정지 토글 | `audioPlayerProvider.state = playing` | `riverpod-lifecycle, subscription-crash` | pending |
| INT-006 | `prayer_dashboard` | `[testimony_card]` | build | 제목을 `l10n.testimonyTitle` (dual label), 본문 위에 `l10n.testimonyHelperText` 추가, **audioUrl 파라미터 제거** | 기존 audio 로직 삭제 | `i18n, dead-code-sweep` | pending |
| INT-007 | `prayer_dashboard` | `[prayer_dashboard_view]` | build | `TestimonyCard(audioUrl: ...)` 호출 제거, `PrayerSummaryCard(audioUrl: ref.watch(...))`로 이동 | provider 참조 이동 | `riverpod-lifecycle, layer-violation` | pending |
| INT-008 | N/A | `[gemini_service.dart]` | runtime | `_hardcodedPrayerResult` / `_fallbackPrayerResult` / `_hardcodedTranscription` 를 새 구조(`transcript`, `audioUrl`)로 갱신 | hardcoded fallback 호환 | `code-gen` | pending |

## 컬럼 가이드

- **ID**: `INT-NNN` (3자리, 순서대로)
- **Screen**: `prayer_dashboard` = `prayer_dashboard_view.dart` 기준
- **Widget**: `[semantic_name]` — Key 또는 의미적 식별자
- **Trigger**: `build` / `onTap` / `build-time` (코드 생성) / `deserialization`
- **Pitfall Tags**:
  - `riverpod-lifecycle` (§1)
  - `subscription-crash` (§2) — 오디오가 Pro 기능과 연결될 수 있음
  - `i18n` (§4)
  - `dispose` (§1 세부) — 오디오 player controller dispose
  - `color-token` (§12)
  - `code-gen` (§16) — freezed/json_serializable/l10n 재생성
  - `dead-code-sweep` (§13)
  - `layer-violation` (§14)

## Ralph 실행 가이드

1. **매 행 구현 전** Pitfall Tags 카테고리 다시 읽기 (`learned-pitfalls.md`)
2. 구현 → 해당 INT 관련 widget test 작성 → 통과 시 status `done`
3. 모든 INT-001 ~ INT-008 완료 후:
   - `dart run build_runner build --delete-conflicting-outputs` (freezed/json)
   - `flutter gen-l10n` (ARB 신규 키 반영 — Phase 1 `_details/l10n_keys.md` 참조)
   - `flutter analyze apps/abba` 통과
   - `flutter test apps/abba` 통과
4. 모두 통과 → status `verified` → Phase 1 commit → 사용자 Phase 2 진행 승인 대기

## 테스트 매핑 (Phase 1)

| INT | Test file | Test case |
|-----|-----------|-----------|
| INT-001, INT-002 | `test/models/prayer_result_test.dart` | `transcript` field 존재 + 기존 `testimony` JSON 역직렬화 호환 |
| INT-003 | `test/models/prayer_summary_test.dart` | `PrayerSummary()` default = 빈 리스트 3개 |
| INT-004, INT-005 | `test/features/dashboard/widgets/prayer_summary_card_test.dart` | 오디오 플레이어 렌더 / 재생 버튼 동작 / `audioUrl == null`에서 플레이어 숨김 |
| INT-006, INT-007 | `test/features/dashboard/widgets/testimony_card_test.dart` | Dual label 표시 / helper text 표시 / audio 위젯 없음 |
| INT-008 | `test/services/gemini_service_hardcoded_test.dart` | 하드코딩 응답이 `PrayerResult.transcript` / `PrayerResult.audioUrl` 반환 |

## Phase 2-5 INT-XXX (추가 예정)

Phase 1 done 후 Phase 2 spec 작성 시 INT-009부터 이어서 할당.
