# Abba 테스트 백로그

> 2026-04-22 기준. 병렬 조사에서 🔴 중요 + 테스트 없음으로 식별된 파일 목록.
> Ralph #5에서 핵심 2개 필수 작성 후, 나머지는 여기 문서화하여 후속 작업으로 관리.

---

## 상태

### ✅ Ralph #5에서 완료 (2026-04-22)

| 파일 | 테스트 수 | 커버 범위 |
|------|----------|----------|
| `test/services/cached_ai_service_test.dart` | 10 | 메서드별 독립 캐시, 오디오 bypass, LRU eviction (50 경계 + promotion) |
| `test/widgets/pro_blur_test.dart` | 3 | locked/unlocked 렌더, `/settings/membership` push |

**Before**: 157 pass / 2 fail
**After**: 170 pass / 2 fail (+13, 동일 2 pre-existing E2E fail 유지)

### 📋 Ralph #5에서 의도적으로 스킵

| 대상 | 스킵 이유 |
|------|---------|
| `supabase_prayer_repository_test.dart` (serialization) | `PrayerResult.toJson/fromJson` roundtrip은 이미 `test/models/prayer_test.dart`가 커버. `_resultToJson` 은 `result.toJson()` 얇은 래퍼라 중복 |
| `supabase_qt_repository_test.dart` | Supabase client mock 필요 복잡도 + 현실적 가치는 integration test가 큼 → 아래 백로그 항목으로 이관 |

---

## 📋 Backlog — 🔴 중요 (출시 후 우선)

### 서비스 레이어

- **`lib/services/real/gemini_service.dart`** — HTTP mock + JSON 파싱 검증
  - 현재: `_useHardcodedResponse=true`로 API 호출 bypass 중. 플래그 off 후 필수
  - 우선순위: **CRITICAL**

- **`lib/services/real/supabase_prayer_repository.dart`** — RLS + CRUD
  - Supabase integration test 권장 (mock < real DB)
  - 단위 테스트는 이미 모델 레벨 roundtrip이 커버
  - 우선순위: High

- **`lib/services/real/supabase_community_repository.dart`** — 좋아요/저장 optimistic UI
  - Race condition + optimistic rollback 시나리오
  - 우선순위: High (커뮤니티 핵심 동작)

- **`lib/services/real/supabase_qt_repository.dart`** — passage CRUD + error handling
  - Ralph #5에서 스킵 (mock 복잡도)
  - `QtPassagesUnavailableException` throw 분기 포함
  - 우선순위: Medium

- **`lib/services/real/real_notification_service.dart`** — FCM + 로컬 알림 스케줄
  - timezone + permission 분기
  - 우선순위: Medium

- **`lib/services/community_repository.dart`** (abstract) — 인터페이스 계약
  - Mock + Supabase 양쪽이 동일 시그니처 준수 확인
  - 우선순위: Low

### UI 레이어

- **`lib/features/recording/view/recording_overlay.dart`** — STT/녹음 + 텍스트 전환
  - 우선순위: **CRITICAL** (핵심 입력)

- **`lib/features/ai_loading/view/ai_loading_view.dart`** — loading state + 자동 전환
  - 우선순위: High

- **`lib/router/app_router.dart`** — guard + 딥링크
  - 우선순위: Medium

- **`lib/providers/providers.dart`** — override 합성
  - 테스트 helpers (`test_app.dart`)에서 간접 커버 중
  - 우선순위: Low

### 초기화

- **`lib/main.dart`** — RevenueCat init 순서, Sentry init
  - E2E 영역 (integration test)
  - 우선순위: Low

---

## 📋 Backlog — 🟡 중요 (권장)

### Dashboard widgets (13개)

Ralph #6에서 3-5개 작성 예정. 나머지:

- `meditation_summary_card`, `scripture_card`, `application_card`
- `related_knowledge_card`, `historical_story_card`, `bible_story_card`
- `prayer_coaching_card`, `guidance_card`, `ai_prayer_card`, `original_lang_card`
- `testimony_card`, `prayer_summary_card`, `posture_card`

### Pro UX

- ✅ `lib/widgets/pro_blur.dart` (Ralph #5 완료)
- `lib/widgets/pro_gate.dart`
- `lib/widgets/pro_modal.dart`

### 기타 위젯

- `prayer_player.dart` — TTS UI (재생/일시정지)
- `prayer_heatmap.dart` — tap → selected info 표시
- `milestone_modal.dart`, `milestone_share_card.dart`

---

## 📋 Backlog — 🟢 낮음

- 설정 화면 (Settings/Notification/BibleTranslations)
- 공용 테마/버튼/카드 (`AbbaButton`/`AbbaCard` 등)
- 애니메이션 위젯 (`StaggeredFadeIn`, `StreakGarden`)
- `l10n/generated/*` (자동생성, 불필요)

---

## 진행 순서 권장

### Phase 1 (출시 후 즉시)

1. `recording_overlay` widget test — 핵심 입력
2. `gemini_service` mock HTTP test — API 계약
3. `ai_loading_view` widget test — 핵심 플로우

### Phase 2 (한 달 내)

4. `supabase_*_repository` integration test (실 DB)
5. Dashboard widgets 13개 (3-4개씩 묶어서)

### Phase 3 (분기별)

6. Router / providers / main / 전체 E2E
7. Low priority 위젯들

---

## 관련 문서

- `apps/abba/specs/LAUNCH_CHECKLIST.md` §5 코드 품질
- `apps/abba/specs/REQUIREMENTS.md`

---

*생성: 2026-04-22 (Ralph #5)*
