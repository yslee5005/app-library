# Data Model — qt_output_redesign

Phase 1만 상세. Phase 2-5는 해당 phase 진입 시 작성.

---

## Phase 1 · Core (묵상 요약 + Scripture Deep)

### QtMeditationResult (신규 필드 추가)

현재 구조:
```dart
class QtMeditationResult {
  final MeditationAnalysis analysis;
  final ApplicationSuggestion application;
  final RelatedKnowledge knowledge;
  final GrowthStory? growthStory;
}
```

Phase 1 후:
```dart
class QtMeditationResult {
  final MeditationSummary meditationSummary;  // 신규 (Phase 1)
  final Scripture scripture;                  // 신규 (Phase 1, 기존 Scripture 재사용)
  final MeditationAnalysis analysis;          // 유지 (Phase 5에서 축소)
  final ApplicationSuggestion application;    // 유지 (Phase 5 확장)
  final RelatedKnowledge knowledge;           // 유지 (Phase 5 축소)
  final GrowthStory? growthStory;             // 유지 (Pro, Phase 4 품질 강화)
  final QtCoaching? coaching;                 // 신규 (Phase 2, Pro, on-demand)
  final List<Citation> citations;             // 신규 (Phase 3, Pro)
}
```

### MeditationSummary (신규 모델)

```dart
class MeditationSummary {
  final String summary;   // 내 묵상 한 마디 요약 ("하나님의 신실하심 속 안식")
  final String topic;     // 오늘의 QT 주제 ("목자 되신 여호와")

  const MeditationSummary({
    required this.summary,
    required this.topic,
  });

  factory MeditationSummary.fromJson(Map<String, dynamic> json) {
    return MeditationSummary(
      summary: json['summary'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
    );
  }
}
```

### Scripture (기존 재사용)

prayer_output_redesign + bible_text_i18n에서 완성한 Scripture 그대로 사용:
- `reference`, `verse` (PD bundle), `reason`, `posture`, `keyWordHint`, `originalWords`

QT용 추가 의미 부여:
- `reason`: "왜 이 본문이 당신의 묵상에 주어졌는가" (기존 기도 context와 동일)
- `posture`: "이 본문을 어떤 마음으로 계속 묵상할지"
- `originalWords`: 본문 내 핵심 원어 (사용자 요구 D "단어 분석" 여기로 통합)

**코드 재사용**: `ScriptureCard` 위젯 그대로. locale/Pro/verse lookup 등 검증됨.

### BibleTextService 재사용

기존 31 locale PD bundle 그대로. QT에서도 동일 lookup — 추가 작업 0.

### Supabase 스키마 영향

`qt_sessions.result: JSONB` 필드 구조 변경:
- Before: `{analysis, application, knowledge, growth_story}`
- After: `{meditation_summary, scripture, analysis, application, knowledge, growth_story, coaching, citations}`

기존 레코드 legacy compat은 fromJson에서 null 허용.

---

## Phase 2-5 데이터 모델 (예정)

### Phase 2 · QtCoaching / QtScores
Prayer Coaching 미러. 상세 Phase 2 spec 시 작성.

### Phase 3 · Citations 확장
기존 Citation 재사용. `type` enum 확장: quote / science / history / example.

### Phase 4 · GrowthStory single-field
title/summary/lesson 단일 + 품질 강화 (긴 이야기).

### Phase 5 · 나머지 i18n 통일
- MeditationAnalysis: keyTheme 제거 (meditationSummary.topic으로 흡수), insight 단일 필드
- RelatedKnowledge: historicalContext 단일, OriginalWord 이관 후 제거 or 단순화
- ApplicationSuggestion: morningAction/dayAction/eveningAction 3개 확장

## 참조

- prayer_output_redesign/_details/data_model.md (Coaching/Citations/HistoricalStory 패턴)
- bible_text_i18n/_details/data_model.md (Scripture Deep + BibleTextService)
- `.claude/rules/learned-pitfalls.md` §16 Code Gen
