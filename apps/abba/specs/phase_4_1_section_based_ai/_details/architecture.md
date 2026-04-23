# 아키텍처 — 3-Tier Lazy Generation

## 개요

유저 engagement 곡선(100% / 55% / 45%)에 매핑된 3 tier 구조. 각 tier는 독립 Gemini 호출, 완성 시점에 UI에 등장 + DB에 누적 저장.

## Tier 정의

### T1 — Hero (즉시, streaming)
**목적**: "AI가 내 기도를 이해했구나" 첫인상 완성
**섹션**:
- `summary` (gratitude / petition / intercession 분류)
- `scripture` (Bible verse + reason + posture + key_word_hint)

**특성**:
- **동기 실행** (유저가 로딩 화면에서 대기)
- **SSE streaming** 적용 (`generateContentStream`)
- 첫 토큰 ~600ms 이내 도착
- Scripture validation 포함 (Bible bundle lookup, 환각 시 재시도 1회)
- 완성 시 Dashboard로 라우팅

**출력 토큰**: ~500
**Engagement**: 100% (모든 유저 조회)

### T2 — Depth (자동 백그라운드)
**목적**: 서사적 확장, "이 기도에 이런 이야기도 있구나"
**섹션**:
- `bible_story` (title + summary, 3-4 문장)
- `testimony` (유저 기도를 1인칭 간증문으로 재구성)

**특성**:
- T1 완성 직후 **fire-and-forget**
- 유저는 이미 Dashboard 보고 있음 (T1 결과 읽는 중)
- 완성 시 Progressive FadeIn으로 카드 등장
- T1 결과를 context로 전달 (coherence 유지)

**출력 토큰**: ~700
**Engagement**: ~70% (유저가 스크롤해서 도달)

### T3 — Premium (Pro + Scroll Trigger)
**목적**: Pro 구독 차별 가치 제공
**섹션**:
- `guidance` (목회적 조언, 3P Personal/Practical/Possible)
- `ai_prayer` (AI 작성 300 words 기도문 + citations 2-3)
- `historical_story` (실제 교회사 인물 이야기)

**특성**:
- **Pro 구독자만 생성** (Free 유저는 아예 호출 안 함)
- `VisibilityDetector`로 Premium 카드 영역 scroll 감지 시 트리거
- Phase 4의 pending/retry 시스템과 통합 (실패 시 홈 재진입 시 Edge Function 처리)
- T1+T2 결과를 context로 전달 (중복/모순 방지)

**출력 토큰**: ~1,300
**Engagement**: ~40% (Pro 유저 중 스크롤 도달)

## 호출 플로우

```
[유저 기도 제출]
  ↓
[savePendingPrayer — Phase 3 이미 구현]
  ↓ prayer_id 획득
  ↓
[T1: Gemini streamGenerateContent]
  ↓ Stream chunks 도착 (SSE)
  ├─ Dashboard 라우팅 (첫 토큰 도착 즉시)
  ├─ UI는 타이핑 애니메이션으로 chunks 렌더
  └─ 마지막 토큰 + JSON 파싱 완료
       ↓
       [Scripture validation]
         ├─ 유효 → 통과
         └─ 환각 → 해당 섹션만 retry (1회)
       ↓
       [update_prayer_tier RPC: tier='t1']
       ↓
[T2: Gemini generateContent (non-streaming)]  ← 백그라운드 자동 시작
  ↓ ~7-10초 후 완성
  ↓
  [update_prayer_tier RPC: tier='t2']
  ↓
  [UI: bible_story + testimony 카드 FadeIn]

[유저가 Pro 구독자이고 Premium 섹션 영역까지 스크롤]
  ↓ VisibilityDetector trigger
[T3: Gemini generateContent]
  ↓ ~15-18초 후 완성
  ↓
[update_prayer_tier RPC: tier='t3']
  ↓
[UI: Premium 카드 3개 순차 FadeIn]

[최종 ai_status='completed' when all scheduled tiers done]
```

## Coherence 유지 전략

각 tier는 **이전 tier의 결과를 context로 전달** → 섹션 간 모순/중복 방지.

```typescript
// T2 prompt 예시 (T1 결과를 context로)
const t2Prompt = `
Previously generated:
- Scripture: ${t1.scripture.reference}
- Summary: ${t1.summary.gratitude.join(', ')}

Now generate bible_story and testimony that BUILD ON (not repeat) the above.
Avoid re-using ${t1.scripture.reference} in bible_story.
Testimony should reference the summary's concrete details.
`;
```

**추가 input tokens**: ~300 per call → 월 추가 비용 ~$3 (1K MAU)

## Scripture Validation Layer

T1 완성 시 `scripture.reference` 로컬 검증:

```dart
Future<Scripture> _validateScripture(Scripture draft, String locale) async {
  final verseText = await bibleService.lookup(draft.reference, locale);
  
  if (verseText != null && verseText.isNotEmpty) {
    return draft.copyWith(verse: verseText);  // 정상
  }
  
  // 환각 (예: "Matthew 6:33" 같은 가짜 reference)
  apiLog.warning('[Scripture] Invalid ref: ${draft.reference}');
  
  // 1회 재시도 — 해당 필드만
  final retry = await _geminiService.retryScripture(
    cacheId: cacheId,
    transcript: transcript,
    locale: locale,
    excludeRef: draft.reference,  // 같은 구절 재생성 방지
  );
  
  final retryVerse = await bibleService.lookup(retry.reference, locale);
  if (retryVerse != null) return retry.copyWith(verse: retryVerse);
  
  // 2회 실패 → safe fallback
  return _safeFallbackScripture(locale);
}
```

**실패 시**: Scripture 섹션 미니 UI ("이 기도에 어울리는 말씀을 준비 중이에요")

## Failure Modes

| Mode | 대응 |
|------|------|
| T1 네트워크 실패 | Phase 3 에러 뷰 (기존) |
| T1 streaming 중간에 끊김 | 마지막 유효 token까지 파싱 시도 → 실패 시 에러 뷰 |
| T2 실패 | 조용히 로그 (Sentry), UI는 "T2 준비 중" 영역 숨김 |
| T3 실패 | Phase 4의 Edge Function lazy retry로 이관 |
| Scripture 환각 (1회 retry 후) | Safe fallback UI (minimal scripture 카드) |
| RPC `update_prayer_tier` 실패 | Sentry 로그 + T1 state는 client에 유지 (UX 지속) |

## 비용 모델 (1K MAU)

| Tier | 평균 호출 비율 | Output 토큰 | 월 비용 |
|------|-------------|----------|--------|
| T1 | 100% (54,000) | ~500 | ~$70 |
| T2 | 70% (37,800) | ~700 | ~$70 |
| T3 | 40% × Pro(30,000) | ~1,300 | ~$40 |
| Cached input (shared) | per call | - | ~$3 |
| Cache storage | 1개 × 24/7 | - | $5 |
| **Total** | | | **~$188/월** |

(출시 후 Phase 2 최적화 적용 시 추가 $355 절감 가능)
