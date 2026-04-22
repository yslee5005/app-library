# PROMPT — Abba AI 품질 + UI 개선

> Ralph 자율 실행용 프롬프트
> 목표: AI 프롬프트 품질 대폭 강화 + UI 개선 4가지

---

## 실행 규칙

1. 각 파일 수정 전 반드시 Read로 읽기
2. ARB 키 추가 시 5개 언어 모두 동시 추가
3. 수정 후 `flutter analyze` 검증
4. 모든 수정 완료 후 `flutter test` 통과 확인

---

## 필수 읽기

- `apps/abba/lib/features/home/view/home_view.dart` — 기도 중 UI
- `apps/abba/lib/models/prayer.dart` — PrayerResult, Scripture 모델
- `apps/abba/lib/models/qt_meditation_result.dart` — ApplicationSuggestion, RelatedKnowledge
- `apps/abba/lib/services/real/gemini_service.dart` — AI 프롬프트 (구 openai_service.dart는 2026-04-21 폐기)
- `apps/abba/lib/services/mock/mock_ai_service.dart` — Mock 구현
- `apps/abba/lib/features/dashboard/widgets/scripture_card.dart`
- `apps/abba/lib/features/dashboard/widgets/application_card.dart`
- `apps/abba/lib/features/dashboard/widgets/related_knowledge_card.dart`
- `apps/abba/lib/features/dashboard/widgets/growth_story_card.dart`
- `apps/abba/lib/features/dashboard/widgets/historical_story_card.dart`
- `apps/abba/lib/features/dashboard/view/prayer_dashboard_view.dart`
- `apps/abba/lib/features/dashboard/view/qt_dashboard_view.dart`
- `apps/abba/assets/mock/prayer_result.json`
- `apps/abba/assets/mock/qt_meditation_result.json`

---

## 변경 1: 기도 중 Transcript 위치 이동 (home_view.dart)

현재: 펄스 원 아래 + 타이머 위에 `maxLines: 3`으로 잘림
변경: 타이머 아래에 축적되는 형태

home_view.dart의 `_buildActivePrayer` 메서드에서:

현재 구조:
```
[텍스트 전환 버튼]
[Spacer]
[펄스 원]
[transcript (maxLines: 3)] ← 여기서 제거
[타이머]
[Spacer]
[버튼들]
```

변경 구조:
```
[텍스트 전환 버튼]
[펄스 원] (크기 약간 축소: 160→140)
[타이머]
[transcript 축적 영역] ← Expanded + SingleChildScrollView
  - 전체 텍스트 표시 (maxLines 제거)
  - 아래로 자동 스크롤
  - 텍스트가 쌓이는 느낌
[버튼들]
```

구현:
- 펄스 원 외곽: 160→140, 내부: 120→100 으로 축소
- transcript 부분을 타이머 아래로 이동
- Expanded로 감싸서 남은 공간 사용
- SingleChildScrollView + 자동 하단 스크롤
- maxLines, overflow 제거 (전체 표시)
- 기존 Spacer들 제거하고 Expanded로 transcript 영역 확보

```dart
// 변경 후 구조
Column(
  children: [
    // 텍스트 전환 버튼 (상단 우측)
    ...
    const SizedBox(height: AbbaSpacing.md),
    // 펄스 원 (축소)
    if (_isTextMode)
      TextField(...)
    else
      _buildPulseCircle(), // 140px로 축소
    const SizedBox(height: AbbaSpacing.md),
    // 타이머
    Text(_formattedTime, ...),
    const SizedBox(height: AbbaSpacing.md),
    // Transcript 축적 영역
    if (!_isTextMode)
      Expanded(
        child: SingleChildScrollView(
          reverse: true, // 새 텍스트가 아래에 추가되므로 아래부터 보이도록
          padding: EdgeInsets.symmetric(horizontal: AbbaSpacing.xl),
          child: Text(
            _transcript,
            style: AbbaTypography.body.copyWith(
              color: AbbaColors.warmBrown,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
    else
      const Spacer(),
    // 버튼들
    ...
  ],
)
```

---

## 변경 2: QT 적용 모델 간소화

### 2-1. ApplicationSuggestion 모델 변경 (qt_meditation_result.dart)

현재:
```dart
class ApplicationSuggestion {
  final String actionEn;
  final String actionKo;
  final String whenEn;
  final String whenKo;
  final String contextEn;
  final String contextKo;
}
```

변경: locale 기반 단일 언어로 변경하고 when/context 삭제
```dart
class ApplicationSuggestion {
  final String action; // 사용자 언어로 된 구체적 행동 한 문장

  const ApplicationSuggestion({required this.action});

  factory ApplicationSuggestion.fromJson(Map<String, dynamic> json) {
    return ApplicationSuggestion(
      action: json['action'] as String? ?? '',
    );
  }
}
```

주의: 기존 en/ko 필드가 있는 fromJson이 깨지지 않도록 fallback 처리:
```dart
factory ApplicationSuggestion.fromJson(Map<String, dynamic> json) {
  // 새 형식 (단일 action)
  if (json.containsKey('action') && json['action'] is String) {
    return ApplicationSuggestion(action: json['action'] as String);
  }
  // 기존 형식 fallback (action_ko 또는 action_en)
  return ApplicationSuggestion(
    action: json['action_ko'] as String? ?? json['action_en'] as String? ?? '',
  );
}
```

### 2-2. application_card.dart 변경

현재: 무엇을/언제/어디서 3개 필드 표시
변경: action 하나만 큰 텍스트로 표시

```dart
// 변경 후
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        Text('✏️', style: TextStyle(fontSize: 24)),
        SizedBox(width: AbbaSpacing.sm),
        Text(l10n.applicationTitle, style: AbbaTypography.h2),
      ],
    ),
    SizedBox(height: AbbaSpacing.md),
    Text(
      result.application.action,
      style: AbbaTypography.body.copyWith(
        color: AbbaColors.warmBrown,
        height: 1.6,
      ),
    ),
  ],
)
```

---

## 변경 3: AI 프롬프트 품질 대폭 강화 (gemini_service.dart — 구 openai_service.dart는 2026-04-21 폐기)

### 3-1. 기도 분석 프롬프트 (`_buildSystemPrompt`)

완전히 새로 작성:

```
You are the world's most compassionate and wise Christian prayer counselor.
The user has just finished praying. Analyze their prayer with deep empathy and biblical wisdom.

CRITICAL RULES:
1. Respond ENTIRELY in {langName}. Do NOT mix languages.
2. Every field must be in {langName} only.
3. The user's prayer transcript is their raw spoken words — summarize and organize it in {langName}.

Return a JSON object:

{
  "prayer_summary": {
    "gratitude": ["감사 항목 — 사용자가 감사한 것을 {langName}로 정리"],
    "petition": ["간구 항목 — 사용자가 구한 것을 {langName}로 정리"],
    "intercession": ["중보 항목 — 다른 사람을 위한 기도를 {langName}로 정리"]
  },
  "scripture": {
    "verse": "성경 구절 전문 ({langName}로)",
    "reference": "Book Chapter:Verse",
    "reason": "이 말씀을 선택한 이유를 2-3문장으로 논리적으로 설명. 기도 내용과 말씀이 어떻게 연결되는지."
  },
  "testimony": "사용자의 기도를 {langName}로 간증 형태로 다듬어 정리. 원문의 핵심을 살리되, 읽기 좋게 정리.",
  "historical_story": {
    "title": "역사/성경 스토리 제목",
    "reference": "출처 (성경 장절 또는 역사적 출처)",
    "story": "기승전결 구조의 이야기 (7-10문장 이상).

[기] 배경 설정: 인물이 어떤 상황에 있었는지 생생하게 묘사.
[승] 갈등/위기: 어떤 어려움, 고난, 시험에 직면했는지. 처절하고 극적으로.
[전] 전환점: 하나님과의 만남, 믿음의 결단, 기도의 응답이 어떻게 왔는지.
[결] 결과와 교훈: 어떻게 변화되었는지, 무엇을 배울 수 있는지.

단순 사건 나열이 아닌, 독자가 감정적으로 공감하고 교훈을 얻을 수 있는 이야기.",
    "lesson": "이 이야기에서 오늘 기도하신 분에게 전하는 구체적 교훈 (2-3문장)",
    "is_premium": true
  },
  "ai_prayer": {
    "text": "세계 최고의 기도문 작가가 쓴 것처럼 작성.

[시작] 하나님을 부르며, 그분의 속성(사랑, 신실함, 전능함)을 고백
[감사] 사용자의 기도 내용에서 감사할 것을 구체적으로 언급
[간구] 사용자가 구한 것을 하나님의 약속과 연결하여 논리적으로 기도
[위탁] 모든 것을 하나님의 뜻에 맡기는 신뢰의 고백
[마무리] 예수 그리스도의 이름으로, 아멘

전체 기도문이 하나의 흐름으로 연결되어야 하며, 읽는 사람의 마음을 움직이고 눈물이 날 정도로 진정성이 있어야 합니다.
5-8문장.",
    "is_premium": true
  }
}

IMPORTANT:
- The historical_story must be a REAL story from the Bible or verified church history.
- Do NOT make up stories. Use real biblical figures (Abraham, Moses, David, Elijah, Hannah, Paul, etc.) or real church history figures (Corrie ten Boom, George Müller, Hudson Taylor, etc.).
- The ai_prayer must flow logically from gratitude → petition → trust → surrender.
- Be warm, encouraging, biblically accurate. NEVER judge the prayer.
```

### 3-2. QT 묵상 분석 프롬프트 (`_buildMeditationSystemPrompt`)

완전히 새로 작성:

```
You are the world's most insightful Bible study guide and spiritual mentor.
The user has meditated on a Bible passage and shared their reflection.

CRITICAL RULES:
1. Respond ENTIRELY in {langName}. Do NOT mix languages.
2. Every field must be in {langName} only.

Passage: {passageReference}
Passage Text: {passageText}

Return a JSON object:

{
  "analysis": {
    "key_theme": "묵상의 핵심 테마 (2-3단어)",
    "insight": "사용자의 묵상을 깊이 분석한 인사이트 (3-4문장). 사용자가 발견한 것을 인정하고, 더 깊은 의미를 추가로 알려줌."
  },
  "application": {
    "action": "매우 구체적인 오늘의 적용 한 문장.

나쁜 예: '더 감사하며 살겠습니다' (추상적, 실천 불가)
나쁜 예: '하나님을 더 신뢰하겠습니다' (모호함)
좋은 예: '오늘 저녁 식사 때 가족에게 올해 감사한 것 3가지를 이야기하기'
좋은 예: '내일 아침 출근 전 5분간 시편 23편을 소리 내어 읽기'
좋은 예: '오늘 갈등 중인 동료에게 커피를 사며 먼저 인사하기'

반드시 '누구에게/무엇을/어떻게' 가 포함된 실천 가능한 행동이어야 합니다."
  },
  "knowledge": {
    "original_word": {
      "word": "원어 단어 (히브리어 또는 헬라어)",
      "transliteration": "음역",
      "language": "Hebrew 또는 Greek",
      "meaning": "원어의 깊은 뜻 설명 (2-3문장). 단순 사전적 의미가 아닌, 문화적/신학적 배경까지."
    },
    "historical_context": "이 본문의 역사적/문화적 배경 설명 (3-4문장). 당시 독자들에게 이 말씀이 어떤 의미였는지.",
    "cross_references": [
      {
        "reference": "Book Chapter:Verse",
        "text": "해당 구절의 전문을 {langName}로"
      }
    ]
  },
  "growth_story": {
    "title": "영적 성장 스토리 제목",
    "story": "기승전결 구조의 감동적인 실화 (8-12문장).

[기] 평범한 일상 또는 배경 설정. 이 사람은 누구이고 어떤 상황이었는지.
[승] 위기의 시작. 신앙을 시험하는 극적인 사건, 고난, 절망의 순간.
     구체적인 장면 묘사 — 독자가 그 자리에 있는 듯한 생생함.
[전] 전환점. 말씀과의 만남, 기도의 응답, 또는 믿음의 결단.
     하나님이 어떻게 역사하셨는지 — 극적인 반전.
[결] 변화와 열매. 그 경험 이후 어떻게 달라졌는지.
     오늘 묵상한 말씀과의 연결점.

이 스토리는 실존 인물의 실화여야 합니다 (성경 인물 또는 검증된 교회사 인물).
단순 사건 나열이 아닌, 독자가 눈물짓거나 결단하게 만드는 이야기.",
    "lesson": "이 이야기가 오늘 묵상과 어떻게 연결되는지, 그리고 독자에게 주는 구체적 교훈 (2-3문장)",
    "is_premium": true
  }
}

IMPORTANT:
- cross_references: Include 2-3 verses. Each must have both "reference" and full "text" in {langName}.
- application.action: Must be SPECIFIC and ACTIONABLE. Include who/what/how.
- growth_story: Must be a REAL story. Minimum 8 sentences.
- Do NOT use generic phrases. Every response must be personalized to THIS meditation.
```

### 3-3. PrayerResult 모델 변경 (prayer.dart)

Scripture 모델에 reason 필드 추가 (기존 en/ko 유지하면서):
```dart
class Scripture {
  final String verseEn;
  final String verseKo;
  final String reference;
  final String reasonEn;  // 새로 추가
  final String reasonKo;  // 새로 추가

  String verse(String locale) => locale == 'ko' ? verseKo : verseEn;
  String reason(String locale) => locale == 'ko' ? reasonKo : reasonEn;
}
```

주의: 기존 fromJson이 깨지지 않도록 nullable default:
```dart
factory Scripture.fromJson(Map<String, dynamic> json) {
  return Scripture(
    verseEn: json['verse_en'] as String? ?? json['verse'] as String? ?? '',
    verseKo: json['verse_ko'] as String? ?? json['verse'] as String? ?? '',
    reference: json['reference'] as String,
    reasonEn: json['reason_en'] as String? ?? json['reason'] as String? ?? '',
    reasonKo: json['reason_ko'] as String? ?? json['reason'] as String? ?? '',
  );
}
```

### 3-4. RelatedKnowledge 모델 변경 (qt_meditation_result.dart)

cross_references를 String 리스트에서 구조체 리스트로:
```dart
class CrossReference {
  final String reference;
  final String text; // 구절 본문

  const CrossReference({required this.reference, required this.text});

  factory CrossReference.fromJson(Map<String, dynamic> json) {
    return CrossReference(
      reference: json['reference'] as String,
      text: json['text'] as String? ?? '',
    );
  }
}

class RelatedKnowledge {
  final OriginalWord? originalWord;
  final String historicalContext; // 단일 언어
  final List<CrossReference> crossReferences; // 변경
  ...
}
```

기존 `List<String>` fromJson fallback:
```dart
// 기존 형식: ["Matthew 11:28", "Hebrews 4:9"]
// 새 형식: [{"reference": "...", "text": "..."}]
crossReferences: (json['cross_references'] as List<dynamic>?)
  ?.map((e) {
    if (e is String) return CrossReference(reference: e, text: '');
    return CrossReference.fromJson(e as Map<String, dynamic>);
  })
  .toList() ?? [],
```

---

## 변경 4: 위젯 업데이트

### 4-1. scripture_card.dart — reason 표시 추가

기존 구절 아래에 "이 말씀을 드리는 이유:" + reason 텍스트 추가.
```dart
if (scripture.reason(locale).isNotEmpty) ...[
  SizedBox(height: AbbaSpacing.md),
  Container(
    padding: EdgeInsets.all(AbbaSpacing.sm),
    decoration: BoxDecoration(
      color: AbbaColors.sage.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(AbbaRadius.md),
    ),
    child: Text(
      scripture.reason(locale),
      style: AbbaTypography.bodySmall.copyWith(
        color: AbbaColors.sage,
        fontStyle: FontStyle.italic,
        height: 1.5,
      ),
    ),
  ),
]
```

### 4-2. related_knowledge_card.dart — 구절 본문 표시

cross_references를 reference + text로 표시:
```dart
for (final ref in knowledge.crossReferences)
  Padding(
    padding: EdgeInsets.only(bottom: AbbaSpacing.sm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ref.reference,
          style: AbbaTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AbbaColors.sage,
          ),
        ),
        if (ref.text.isNotEmpty)
          Text(
            ref.text,
            style: AbbaTypography.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
      ],
    ),
  ),
```

---

## 변경 5: Mock JSON 업데이트

### prayer_result.json — 한국어 품질 업그레이드

scripture에 reason 추가, historical_story 기승전결 확장, ai_prayer 감동적으로.

### qt_meditation_result.json — 한국어 품질 업그레이드

application을 구체적 한 문장으로, cross_references에 본문 추가, growth_story 기승전결 확장.

---

## 변경 6: ARB 키

새로 필요한 키:
```
scriptureReasonLabel: "이 말씀을 드리는 이유" / "Why this Scripture"
```

5개 언어 모두 추가.

---

## 완료 조건

- [ ] `flutter analyze` — 0 에러
- [ ] `flutter test` — 전체 통과
- [ ] 기도 중: transcript가 타이머 아래에 축적 (스크롤 가능)
- [ ] QT 적용: action 하나만 구체적으로 표시
- [ ] 관련 구절: reference + 한글 본문 함께 표시
- [ ] Scripture에 "이 말씀을 드리는 이유" 표시
- [ ] Mock JSON이 기승전결 스토리 포함
- [ ] 5개 언어 ARB 동기화
