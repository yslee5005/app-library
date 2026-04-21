# Screens

> Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 추가. 모든 카드는 4 상태(Empty / Loading / Error / Data) 명시 필수.

화면 단위는 기존 `prayer_dashboard_view.dart`를 재사용. Phase 1에서 바뀌는 **카드 위젯**만 기술.

---

## Phase 1 · Card 1: `PrayerSummaryCard`

오디오 재생 기능을 Testimony에서 이곳으로 **이동**.

| State | Visual | Notes |
|---|---|---|
| **Empty** | 감사/간구/중보 3축 중 비어 있는 축은 해당 섹션 자체 숨김 | 전부 비면 카드 자체 숨김 (현재와 동일 정책) |
| **Loading** | 상위 AI Loading 화면에서 처리 (카드 개별 loading 없음) | Phase 1 내 변경 없음 |
| **Error** | 상위 Dashboard의 `errorGeneric` 메시지 표시 | 변경 없음 |
| **Data** | 기존 3축 리스트 + 신규 **오디오 플레이어 bar** (카드 하단) | 오디오 없을 때 플레이어 숨김 |

### 오디오 플레이어 Bar 스펙
- 위치: 카드 하단, 3축 리스트 **아래**
- 구성: `[▶️/⏸️ 재생/일시정지] [0:00 / 0:45] [──●────]` (진행 바)
- 라벨: `l10n.myPrayerAudioLabel` = "내 기도 녹음" / "My prayer recording"
- 재생 엔진: 기존 TestimonyCard에서 쓰던 audio player 위젯 재사용 (그대로 이동)
- 오디오 없을 때 (`audioUrl == null`): 플레이어 자체 렌더링 안 함 (공간도 차지 X)

### 라우팅
- 카드는 `prayer_dashboard_view.dart` 내 렌더링. 별도 라우트 없음.

### Responsive
- compact (< 600): 오디오 플레이어 full width, 재생 버튼 48dp
- medium (600-839): 동일 레이아웃 + 좌우 여백 증가 (`AbbaSpacing.lg`)
- expanded/large: 카드 max-width 720dp 고정, 중앙 정렬

---

## Phase 1 · Card 2: `TestimonyCard`

오디오 **제거** + 제목을 dual label + 설명 한 줄 추가.

| State | Visual | Notes |
|---|---|---|
| **Empty** | `transcript`가 빈 문자열이면 카드 자체 숨김 | 시니어 UX: 빈 카드 노출 금지 |
| **Loading** | 상위 AI Loading에서 처리 | 변경 없음 |
| **Error** | 상위 Dashboard 에러 | 변경 없음 |
| **Data** | **Dual 제목** + **helper 한 줄** + transcript 본문 (오디오 X) | 오디오 플레이어 완전 제거 |

### Dual 제목 스펙
- 첫 줄: `l10n.testimonyTitle` 값이 ARB에서 `"Testimony · 기도 원문"` (영어) 또는 `"나의 간증 · 기도 원문"` (한국어) 같이 **슬래시 또는 · 구분 병기**
- 구분자: `·` (U+00B7) — 두 언어·의미 병기를 시각적으로 동등하게
- **영어권 locale**: `"Testimony · My prayer"` 형식
- **한국어 locale**: `"나의 간증 · 기도 원문"` 형식
- 기타 언어: "간증/testimony" 의미어 + "기도 원문/my prayer" 의미어 병기 (각 locale 번역자가 적용)

### Helper 한 줄 (신규)
- 제목 아래, transcript 본문 위
- 스타일: `AbbaTypography.bodySmall` + `AbbaColors.muted`
- 내용: `l10n.testimonyHelperText` = "내가 뭐라고 기도했는지 돌아보기 · 커뮤니티 공유에도 사용"
- 영어: "Reflect on your prayer · Can be used to share with community"

### 오디오 제거 영향
- 기존 `TestimonyCard(audioUrl: ...)` 파라미터 **제거**
- `_currentAudioUrlProvider` 참조는 PrayerSummaryCard로 이동
- 기존 테스트(있다면) 업데이트

### Responsive
- compact: transcript 본문 maxLines 없음, 항상 전체 표시 (스크롤로 읽음)
- 모든 사이즈: `SingleChildScrollView` 안에서 자연스럽게 flow

---

---

## Phase 2 · ScriptureCard 확장 + OriginalLangCard 삭제

### Card: `ScriptureCard` (확장)

기존 3개 섹션 (verse / reference / reason green-box) 유지 + **2개 섹션 추가**.

| State | Visual | Notes |
|---|---|---|
| **Empty** | `verse` 없으면 카드 자체 숨김 | 시니어 UX |
| **Loading** | 상위 Loading 처리 | |
| **Error** | 상위 Dashboard 에러 | |
| **Data** | verse / reference / **reason(녹색)** / **posture(녹색, 신규)** / **originalWords expandable(신규)** | |

### 신규 섹션 1: Posture (읽는 자세)

- 위치: `reason` 섹션 **바로 아래**
- 스타일: `reason`과 같은 녹색(sage alpha 0.08) 배경 박스
- 구분법: 라벨과 아이콘으로 차별화
  - reason 라벨: `l10n.scriptureReasonLabel` = "왜 이 말씀을?" (이미 존재)
  - posture 라벨: `l10n.scripturePostureLabel` = "어떤 마음으로 읽을까요?" + 🌿 아이콘
- `posture(locale)` 비어 있으면 섹션 자체 숨김

### 신규 섹션 2: Original Words (원어로 만나는 깊은 뜻)

- 위치: posture 아래
- 기본 **접힘 상태** (expandable) — 시니어 UX: 긴 카드 방지
- 접힘 시: `"원어로 만나는 깊은 뜻 (2)"` 같이 개수 표시
- 펼침 시: 각 `OriginalWord` 세로 나열
  - 큰 글씨 원어 (히브리어/헬라어 hero 32pt)
  - 아래 작은 글씨 transliteration + language
  - 의미 `meaning(locale)` — body 18pt
  - 뉘앙스 `nuance(locale)` — bodySmall muted
  - 각 word 사이 divider 8pt

### RTL 처리

히브리어(he)는 RTL. `OriginalWord.language == 'Hebrew'`일 때 원어 `Text` 위젯 `textDirection: TextDirection.rtl`.

### Card: `OriginalLangCard` (삭제)

- 파일 삭제: `apps/abba/lib/features/dashboard/widgets/original_lang_card.dart`
- 참조 제거:
  - `prayer_dashboard_view.dart` (사용 중일 수 있음 — grep 후 제거)
  - `qt_dashboard_view.dart` (사용 안 하지만 import 확인)

### Responsive (Phase 2)
- compact (< 600): 원어 hero 32pt → 28pt로 축소 권장 (overflow 방지)
- medium 이상: 32pt 유지

---

## Phase 3 · PrayerCoachingCard (신규, Pro 전용)

### Card: `PrayerCoachingCard` (신규)

위치: Prayer Dashboard의 **HistoricalStory 카드 바로 위** (Free 카드 3개 다음, Pro 카드 첫 번째).

| State | Visual | Notes |
|---|---|---|
| **Loading** | `CircularProgressIndicator` + "당신의 기도를 돌아보고 있어요..." | Coaching call 진행 중 |
| **Empty / Locked (Free)** | ProBlur 위젯으로 4 score bar + 제목 + Pro CTA | 기존 ProBlur 패턴 재사용 |
| **Error** | "일시적인 오류 — 잠시 후 다시 시도" + retry 버튼 | Coaching call 실패 시 |
| **Data (Pro)** | 4 score bar + expertLevel 배지 + strengths/improvements 리스트 + overallFeedback | 펼치면 전체 표시 |

### 레이아웃 (Pro Data 상태)

```
┌───────────────────────────────────────────┐
│ 🎯 기도 코칭                    [🌱 Growing] │
├───────────────────────────────────────────┤
│ 구체성            ●●●●○  4/5               │
│ 하나님 중심성     ●●●○○  3/5               │
│ ACTS 균형        ●●●●●  5/5               │
│ 진정성           ●●●●○  4/5               │
├───────────────────────────────────────────┤
│ ✨ 잘하신 점                                │
│ • 어머니의 이름을 구체적으로 언급하신 점이...    │
│ • 감사와 간구를 균형 있게...                  │
│                                           │
│ 💡 더 깊어지려면                             │
│ • 회개 (Confession) 한 문장을 더해 보세요...  │
│ • 하나님의 속성을 한 가지만 더 찬양해...      │
│                                           │
│ ─────────────────────────────────        │
│ 균형 잡힌 기도가 아름답습니다.                 │
│ 오늘 기도에 회개 한 문장을 더하시면 ACTS 4축이  │
│ 완성됩니다. 하나님은 기도하는 당신을 사랑하십니다. │
└───────────────────────────────────────────┘
```

### Score Bar 스펙
- 라벨(캡션 12pt) + 5 dot (또는 짧은 progress bar)
- 색: `AbbaColors.sage` (채워진) / `AbbaColors.muted` α 0.2 (빈)
- 1-5 = 정수. 0 = placeholder (숨김 처리)

### Expert Level 배지
- 위치: 카드 제목 우측
- beginner: `🌱 Beginner` / `🌱 시작하는 중` (soft pink)
- growing: `🌿 Growing` / `🌿 자라는 중` (sage)
- expert: `🌳 Expert` / `🌳 전문가` (warm gold)

### Pro Locked 상태 (Free 유저)
- ProBlur 위젯 사용 (기존 패턴)
- 타이틀 "🎯 기도 코칭" 보임
- 점수/피드백 내용 블러 처리
- 하단 "Pro로 기도 코칭 받기" CTA 버튼
- Icon preview 작은 이미지로 기능 소개 (점수 bar 4개 대략 보이게)

### Responsive
- compact: score bar full width, 제목 + 배지 세로 stack 가능
- medium+: 제목 + 배지 한 줄, score bar 가로 배치 유지

### 데이터 로딩 전략 (Pro)
- 카드가 viewport에 들어올 때 first-time 호출 (`VisibilityDetector` 활용 가능)
- 또는 **Dashboard 진입 시 Premium call + Coaching call 병렬 spawn** (2 call 동시, UX 빠름)
- MVP: Dashboard 진입 시 병렬 (간단), 비용 증가 미미

### 에러 복구
- 3회 retry는 사용자 수동 (retry 버튼)
- Coaching 실패해도 다른 카드는 정상 표시 (Pro 1 call과 분리됐으므로)

---

---

## Phase 4 · HistoricalStoryCard 확장

### Card: `HistoricalStoryCard` (기존 widget)

모델·ProBlur locked 상태는 변경 없음. **unlocked expanded 상태만 품질 향상.**

| State | Visual | Notes |
|---|---|---|
| **Empty** | `isPremium && !isUserPremium` → ProBlur (변경 없음) | |
| **Loading** | 상위 Loading에서 처리 | 변경 없음 |
| **Error** | 상위 Dashboard 에러 | 변경 없음 |
| **Data (Pro)** | reference(italic muted) · **summary (body 18pt, line-height 1.7, paragraph spacing)** · lesson sage box(강조) | 현재 bodySmall에서 승격 |

### Typography 변경

| 요소 | Before | After | 이유 |
|------|--------|-------|------|
| summary 본문 | `AbbaTypography.bodySmall` (16pt line-height 1.5) | `AbbaTypography.body` (18pt) `.copyWith(height: 1.7)` | 시니어 가독성 + 장문 호흡감 |
| lesson 라벨 | `AbbaTypography.caption` (12pt) | `AbbaTypography.label` (14pt) `.copyWith(color: sage, fontWeight: w700)` | "오늘의 교훈" 섹션 명확화 |
| lesson 본문 | `AbbaTypography.bodySmall` (16pt w600) | 유지 | 이미 적절 |
| lesson 박스 padding | `AbbaSpacing.sm` (8) | `AbbaSpacing.md` (16) | 시각적 여유 |

### 문단 렌더링

- Prompt가 summary를 `\n\n`으로 장면 구분 (예: 도입 / 전개 / 절정 / 결말 4단락)
- Flutter `Text` widget은 `\n\n`을 자동으로 두 줄 공백으로 렌더 — 별도 파싱/분리 불필요
- `height: 1.7` 로 문단 내 행간 확보

### Responsive

- compact (< 600): body 18pt 유지, 긴 summary 스크롤은 상위 `ListView`가 담당
- medium 이상: 카드 max-width 720dp (기존 policy) 유지
- **overflow 체크**: compact 320dp + summary 500자 테스트 필수 (`testOverflow` helper)

### RTL

- 히브리어(`he`)의 경우 body Text 자동 RTL (Flutter 기본)
- 이미 Phase 2에서 ScriptureCard의 히브리어 원어만 명시 RTL, 본문은 자동 — 변경 없음

---

## Phase 5 · AiPrayerCard 확장 (single-field + citations)

### Card: `AiPrayerCard` (기존 widget 재설계)

Audio player 원래 포함 안 됨(이미 dead field). 실질 변경:
1. `locale` prop 제거, `.text(locale)` → `.text` 직접 참조
2. citations 존재 시 본문 아래 **expandable citations 섹션**
3. text 분량 증가(~300 words) 대응 typography

| State | Visual | Notes |
|---|---|---|
| **Empty** | `isPremium && !isUserPremium` → ProBlur (기존 유지) | |
| **Loading** | 상위 Loading에서 처리 | |
| **Error** | 상위 Dashboard 에러 | |
| **Data (Pro)** | 기도문 body(18pt, h 1.8) + citations섹션(펼치면 노출) | citations 0개면 섹션 자체 숨김 |

### 레이아웃 (Pro Data 상태, citations 3개 예시)

```
┌──────────────────────────────────────────────┐
│ 🙏 당신을 위한 기도                            │
├──────────────────────────────────────────────┤
│ 하늘에 계신 아버지, 오늘 아침 당신 앞에         │
│ 조용히 무릎 꿇습니다.                          │
│                                              │
│ 주님, 저는 오늘도 가족의 이름을 불러봅니다...   │
│ [~2분 분량 본문, 여러 문단]                   │
│                                              │
│ 주님의 이름으로 기도드립니다. 아멘.            │
├──────────────────────────────────────────────┤
│ 📚 참고 · 인용 (3)         [펼치기 ▼]          │
│                                              │
│ ┌────────────────────────────────────────┐  │
│ │ 💭 명언 · C.S. Lewis, Mere Christianity │  │
│ │ "우리는 영원을 향해 창조된 존재입니다."  │  │
│ ├────────────────────────────────────────┤  │
│ │ 🔬 연구 · Harvard 85년 추적 연구        │  │
│ │ "행복은 관계의 깊이에서 온다."           │  │
│ ├────────────────────────────────────────┤  │
│ │ ✨ 예시                                  │  │
│ │ "염려로 잠 못 이루던 밤의 전화 한 통..."│  │
│ └────────────────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

### Citation Section 스펙

- 본문 아래 구분선 + 섹션 제목 `l10n.aiPrayerCitationsTitle` + 개수 표시
- 기본 **접힘 상태** (기존 ExpandableCard 안의 sub-expandable 패턴 또는 간단 toggle)
- 각 항목:
  - 타입 아이콘: quote `💭` · science `🔬` · example `✨`
  - 타입 라벨: `l10n.citationTypeQuote` / `citationTypeScience` / `citationTypeExample`
  - source italic muted (source가 빈 문자열이면 라벨만)
  - content body, 인용부호 추가
- 항목 사이 divider 1px

### Typography 변경

| 요소 | Before | After | 이유 |
|------|--------|-------|------|
| 기도 본문 | `AbbaTypography.body` (h 1.6) | `AbbaTypography.body.copyWith(height: 1.8)` | 2분 읽기 분량 호흡 |
| citation source | N/A | `AbbaTypography.caption` italic muted | 출처 명시 |
| citation content | N/A | `AbbaTypography.bodySmall` | 본문과 구분 |
| citation type label | N/A | `AbbaTypography.label` + 타입별 accent | 시각적 분류 |

### Responsive

- compact (< 600): citations 각 row 세로 stack (아이콘 + 라벨 상단, content 하단)
- medium 이상: 아이콘/라벨 가로, content wrap

### Reading Time 라벨 (선택)

카드 제목 우측에 `l10n.aiPrayerReadingTime` (e.g., "2분 읽기 / 2 min read") 뱃지 노출 고려. MVP에서는 optional — 카드 제목이 길어지면 생략 가능.

---

### Dead Code Sweep

- `AiPrayerCard.locale` prop → 제거
- `AiPrayer.textEn`, `.textKo`, `.text(locale)` → 제거
- `AiPrayer.audioUrl` 필드 → 제거
- 주석으로 남기지 말 것

## 참조
- `.claude/rules/responsive.md` — ScreenSize 4단계
- `.claude/rules/error-handling.md` — 3상태 필수
- `.claude/rules/flutter-layout.md` — ListView 규칙
- `.claude/rules/learned-pitfalls.md` §1 (Riverpod 라이프사이클 — 오디오 플레이어 provider dispose)
