# 이 Feature 관련 함정 체크리스트

> `.claude/rules/learned-pitfalls.md`에서 이 feature와 관련된 카테고리만 link.
> 매 INT-XXX 구현 전 해당 카테고리 다시 읽기.

---

## Phase 1 · 관련 카테고리

전체 16 카테고리 중 Phase 1 작업에 관련된 것:

- [x] **§1 Riverpod 라이프사이클** — audio player provider dispose, `ref.mounted` 체크
  - 특히: 오디오 재생 중 위젯 dispose 시 controller leak 방지
  - autoDispose vs keepAlive 판단 (카드 한정 = autoDispose)
- [x] **§2 Subscription / Payment Crash** — Phase 1엔 직접 영향 없음, **참고용** (Phase 3에서 본격)
- [ ] **§3 Multi-tenant (Supabase)** — Phase 1에선 스키마 변경 없음
- [x] **§4 i18n** — dual label 키 + helper 텍스트 신규 추가. **사전 정의 필수** (754키 사례 재발 방지)
- [ ] **§5 Auth Lifecycle** — 해당 없음
- [ ] **§6 DateTime / Timezone** — 해당 없음
- [ ] **§7 iOS Privacy / Compliance** — 오디오 권한은 Recording 단계에서 이미 확보됨
- [ ] **§8 Navigation** — 라우트 변경 없음
- [ ] **§9 FCM / Webhook** — 해당 없음
- [x] **§10 Optimistic UI** — 오디오 재생 토글(▶️/⏸️)은 즉시 반영 (로컬 상태)
- [x] **§11 성능** — 오디오 플레이어 초기화는 lazy (`audioUrl != null` 확인 후 생성)
- [x] **§12 Color / Design Token** — 오디오 플레이어 진행 바 색은 `AbbaColors.sage` 사용 (하드코딩 금지)
- [x] **§13 Dead Code Sweep** — TestimonyCard의 audio 로직 완전 제거 (주석으로 남기지 않음), `_currentAudioUrlProvider` 위치 이동 후 기존 참조 grep 검증
- [x] **§14 Layer Violation** — 카드에서 Supabase 직접 호출 금지. 현재 Phase 1에선 해당 없으나 패턴 준수
- [ ] **§15 Web 함정** — Flutter 작업이라 해당 없음
- [x] **§16 Code Generation** — 핵심
  - `testimony → transcript` rename → freezed 재생성 필수
  - `audioUrl` 신규 필드 → freezed + json_serializable 재생성
  - ARB 신규 키 → `flutter gen-l10n` 실행 필수
  - workspace root에서 `dart run build_runner build --delete-conflicting-outputs`

## 추가 메모 (Phase 1 특유)

### 1. JSON 역직렬화 호환성
기존 Supabase `prayers.result` JSON에 저장된 레코드는 `testimony` 키를 가지고 있음. `PrayerResult.fromJson`에서 **양쪽 키 모두 허용**:
```dart
factory PrayerResult.fromJson(Map<String, dynamic> json) => _$PrayerResultFromJson({
  ...json,
  'transcript': json['transcript'] ?? json['testimony'] ?? '',
});
```

### 2. Audio Player 위치 이동 시 provider scope
현재 `_currentAudioUrlProvider`는 TestimonyCard에서만 watched. Phase 1 이후 PrayerSummaryCard에서 watch. **타이밍 이슈 체크**:
- 카드 간 state가 독립적인지
- dashboard 재빌드 시 audio 재생 유지되는지 (UX — 카드 사이 스크롤할 때 끊기면 안 됨)

### 3. Dual label 문자열 길이
`Testimony · My prayer` / `나의 간증 · 기도 원문` — 카드 제목으로 긴 편. `AbbaTypography.h2` (20pt) 기준 compact(320dp) overflow 확인 필수. `maxLines: 1` + `overflow: ellipsis` 강제 or `maxLines: 2` 허용.

### 4. Hardcoded fallback 업데이트 순서
`_useHardcodedResponse = true` 상태이므로 **하드코딩부터 새 구조로 먼저 업데이트** → UI 검증 → 실제 API 프롬프트 수정 (API는 다음 Phase에서 활성화될 때).

## 전체 룰 참조

- `.claude/rules/learned-pitfalls.md` (전체 16 카테고리)
- `.claude/rules/error-handling.md` (3상태 필수)
- `.claude/rules/responsive.md` (ScreenSize 4단계)
- `.claude/rules/flutter-layout.md` (ListView 룰)
- `.claude/rules/copy-paste.md` (UI Kit 변경 시)

---

## Phase 2-5 함정 (추가 예정)

Phase 2 진입 시 해당 phase 특유 함정 추가:
- Phase 2: OriginalLangCard 삭제 (§13 dead code), 원어 폰트 렌더링 (히브리어 RTL)
- Phase 3: §2 subscription (Pro gating), asset 로딩 (§11 lazy), prompt 검증 (hallucinate 방지)
- Phase 4: 긴 텍스트 스크롤 (§11, flutter-layout.md)
- Phase 5: TTS 제거 시 기존 audio player dead code (§13), citations UI expandable (§11)
