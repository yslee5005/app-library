# PROMPT — Abba Dashboard 분리 재설계

> Ralph 자율 실행용 프롬프트
> 목표: 기도 후 Dashboard와 QT 묵상 후 Dashboard를 완전히 분리하고 새로운 섹션 구현

---

## 실행 규칙

1. 각 파일 수정 전 반드시 Read로 읽기
2. ARB 키 추가 시 5개 언어 모두 동시 추가 (en, ko, ja, es, zh)
3. 수정 후 `flutter gen-l10n` + `flutter analyze` 검증
4. 모든 수정 완료 후 `flutter test` 통과 확인

---

## 필수 읽기

- `apps/abba/specs/DESIGN.md` — 섹션 8 (AI 프롬프트)
- `apps/abba/lib/models/prayer.dart` — 현재 PrayerResult 모델
- `apps/abba/lib/services/real/openai_service.dart` — 현재 AI 프롬프트
- `apps/abba/lib/features/dashboard/view/dashboard_view.dart` — 현재 Dashboard
- `apps/abba/lib/features/dashboard/widgets/` — 현재 카드 위젯들
- `apps/abba/lib/router/app_router.dart` — 현재 라우팅
- `apps/abba/lib/features/ai_loading/view/ai_loading_view.dart` — AI 로딩 뷰
- `apps/abba/lib/providers/providers.dart` — 현재 프로바이더

---

## Phase A: 모델 재설계

### A-1. PrayerResult 모델 확장 (prayer.dart)

기존 PrayerResult에 새 필드 추가:

```dart
class PrayerSummary {
  final List<String> gratitude;  // 감사 항목들
  final List<String> petition;   // 간구 항목들
  final List<String> intercession; // 중보 항목들
  final int durationSeconds;     // 기도 시간

  // fromJson factory
}

class HistoricalStory {
  final String titleEn;
  final String titleKo;
  final String reference;       // "사무엘상 1-2장"
  final String summaryEn;
  final String summaryKo;
  final String lessonEn;        // 교훈
  final String lessonKo;
  final bool isPremium;

  String title(String locale) => locale == 'ko' ? titleKo : titleEn;
  String summary(String locale) => locale == 'ko' ? summaryKo : summaryEn;
  String lesson(String locale) => locale == 'ko' ? lessonKo : lessonEn;
  // fromJson factory
}

class PrayerResult {
  // 기존 유지
  final Scripture scripture;
  final BibleStory bibleStory;    // 이건 삭제하거나 유지 (아래 결정)
  final String testimony;
  final Guidance? guidance;        // 삭제 (성찰 질문 삭제됨)
  final AiPrayer? aiPrayer;
  final OriginalLanguage? originalLanguage; // 삭제 (기도에는 불필요)

  // 새로 추가
  final PrayerSummary? prayerSummary;
  final HistoricalStory? historicalStory;
}
```

주의: 기존 필드를 삭제하면 mock JSON과 다른 곳에서 에러 발생. 기존 필드는 유지하되 nullable로 두고, 새 필드를 추가하는 방식으로.

### A-2. QtMeditationResult 모델 신규 (qt_meditation_result.dart)

```dart
class QtMeditationResult {
  final MeditationAnalysis analysis;
  final ApplicationSuggestion application;
  final RelatedKnowledge knowledge;
  final GrowthStory? growthStory;    // Premium

  // fromJson factory
}

class MeditationAnalysis {
  final String keyThemeEn;
  final String keyThemeKo;
  final String insightEn;
  final String insightKo;

  String keyTheme(String locale) => ...;
  String insight(String locale) => ...;
  // fromJson factory
}

class ApplicationSuggestion {
  final String actionEn;
  final String actionKo;
  final String whenEn;
  final String whenKo;
  final String contextEn;
  final String contextKo;

  String action(String locale) => ...;
  String when(String locale) => ...;
  String context(String locale) => ...;
  // fromJson factory
}

class RelatedKnowledge {
  final OriginalWord? originalWord;
  final String historicalContextEn;
  final String historicalContextKo;
  final List<String> crossReferences;

  // fromJson factory
}

class OriginalWord {
  final String word;           // מְנֻחוֹת
  final String transliteration; // menukhot
  final String language;        // Hebrew
  final String meaningEn;
  final String meaningKo;

  // fromJson factory
}

class GrowthStory {
  final String titleEn;
  final String titleKo;
  final String summaryEn;
  final String summaryKo;
  final String lessonEn;
  final String lessonKo;
  final bool isPremium;

  // fromJson factory
}
```

---

## Phase B: AI 프롬프트 변경

### B-1. 기도 분석 프롬프트 (openai_service.dart)

기존 `_buildSystemPrompt`를 수정하여 새 JSON 구조 요청:

```
System: You are a compassionate Christian AI counselor.
Analyze the user's prayer and respond in {locale} language.
Return a JSON object with these exact fields:

{
  "prayer_summary": {
    "gratitude": ["감사 항목1", "감사 항목2"],
    "petition": ["간구 항목1"],
    "intercession": ["중보 항목1"]
  },
  "scripture": {
    "verse_en": "...", "verse_ko": "...", "reference": "..."
  },
  "historical_story": {
    "title_en": "Hannah's Prayer",
    "title_ko": "한나의 기도",
    "reference": "1 Samuel 1-2",
    "summary_en": "Hannah desperately prayed for a child...",
    "summary_ko": "한나는 간절히 아이를 위해 기도했습니다...",
    "lesson_en": "The deepest love for our children is entrusting them to God.",
    "lesson_ko": "자녀를 향한 가장 깊은 사랑은 하나님께 맡기는 것입니다.",
    "is_premium": true
  },
  "ai_prayer": {
    "text_en": "...", "text_ko": "...", "is_premium": true
  },
  "testimony": {
    "transcript_en": "...", "transcript_ko": "..."
  }
}

The historical_story should be a real Bible story or church history story that relates to the prayer's main theme. Include a practical lesson.
Be warm, encouraging, biblically accurate. Never judge.
```

### B-2. QT 묵상 분석 프롬프트 (openai_service.dart에 새 메서드 추가)

AiService 인터페이스에 새 메서드 추가:
```dart
abstract class AiService {
  Future<PrayerResult> analyzePrayer({...});
  Future<QtMeditationResult> analyzeMeditation({
    required String passageReference,
    required String passageText,
    required String meditationText,
    required String locale,
  });
}
```

QT 묵상 분석 시스템 프롬프트:
```
System: You are a wise Bible study guide.
The user has meditated on a Bible passage and shared their reflection.
Analyze their meditation and respond in {locale} language.

Passage: {passageReference}
Passage Text: {passageText}

Return a JSON object:
{
  "analysis": {
    "key_theme_en": "Rest and Peace",
    "key_theme_ko": "쉼과 평안",
    "insight_en": "Your meditation reveals a longing for rest...",
    "insight_ko": "당신의 묵상에서 쉼에 대한 갈망이 느껴집니다..."
  },
  "application": {
    "action_en": "Take 15 minutes of intentional rest today",
    "action_ko": "오늘 15분간 의도적으로 쉬는 시간을 가져보세요",
    "when_en": "During lunch break",
    "when_ko": "점심시간에",
    "context_en": "At your workplace",
    "context_ko": "직장에서"
  },
  "knowledge": {
    "original_word": {
      "word": "מְנֻחוֹת",
      "transliteration": "menukhot",
      "language": "Hebrew",
      "meaning_en": "still waters, waters of rest — reflects sheep's fear of rushing water",
      "meaning_ko": "쉴만한 물, 안식의 물 — 급류를 두려워하는 양의 습성에서 나온 표현"
    },
    "historical_context_en": "Ancient Palestinian shepherds would create calm pools...",
    "historical_context_ko": "고대 팔레스타인 목자는 양을 위해 잔잔한 웅덩이를 만들어...",
    "cross_references": ["Matthew 11:28", "Hebrews 4:9-11", "Psalm 46:10"]
  },
  "growth_story": {
    "title_en": "George Müller's Faith — Feeding 2,000 Orphans",
    "title_ko": "조지 뮬러의 믿음 — 2천 명의 고아를 먹이다",
    "summary_en": "George Müller never asked anyone for money...",
    "summary_ko": "조지 뮬러는 단 한 번도 사람에게 돈을 구하지 않았습니다...",
    "lesson_en": "Trusting God's provision means resting in His timing.",
    "lesson_ko": "하나님의 공급을 신뢰하는 것은 그분의 때에 안식하는 것입니다.",
    "is_premium": true
  }
}

Make the application SPECIFIC and ACTIONABLE (not vague like "live better").
The growth_story should be a real story from Bible or church history.
```

Mock 구현도 동일한 구조의 JSON을 반환하도록.

---

## Phase C: Dashboard 뷰 분리

### C-1. 기도 Dashboard (prayer_dashboard_view.dart) — 기존 dashboard_view.dart 수정

6개 카드:
1. **PrayerSummaryCard** — 감사/간구/중보 분류 리스트 + 기도 시간
2. **ScriptureCard** — 기존 유지 (성경 구절 + 위로 한 줄)
3. **PrayerTopicCard** — 기도 제목 추적 카드 (신규)
4. **HistoricalStoryCard** — 역사 스토리 + 교훈 (신규, Premium)
5. **AiPrayerCard** — 기존 유지 (TTS, Premium)
6. **PrayerPatternCard** — 기도 패턴 (기존 유지 가능, Premium)

### C-2. QT Dashboard (qt_dashboard_view.dart) — 신규 생성

5개 카드:
1. **MeditationAnalysisCard** — AI 묵상 분석 (핵심 테마 + 인사이트) (신규)
2. **ApplicationCard** — 오늘의 적용 (무엇을/언제/상황) (신규)
3. **RelatedKnowledgeCard** — 원어 + 역사 배경 + 크로스레퍼런스 (신규)
4. **GrowthStoryCard** — 영적 성장 스토리 + 교훈 (신규, Premium)
5. **YesterdayCheckCard** — 어제 적용 점검 (했어요/부분적/못했어요) (신규)

### C-3. 라우팅 분기

현재 기도/QT 모두 `/home/ai-loading` → `/home/dashboard` 로 이동.
변경: 기도 모드/QT 모드를 구분하여 다른 Dashboard로 이동.

방법: `currentTranscriptProvider` 옆에 `currentPrayerModeProvider` 추가.
```dart
final currentPrayerModeProvider = StateProvider<String>((ref) => 'prayer'); // 'prayer' | 'qt'
```

- 기도 모드: `/home/ai-loading` → `/home/prayer-dashboard`
- QT 모드: `/home/ai-loading` → `/home/qt-dashboard`

라우터에 새 경로 추가:
```dart
GoRoute(path: 'prayer-dashboard', builder: PrayerDashboardView),
GoRoute(path: 'qt-dashboard', builder: QtDashboardView),
```

기존 `/home/dashboard` 는 `prayer-dashboard`로 리다이렉트 또는 삭제.

### C-4. AI Loading 뷰 분기

`ai_loading_view.dart`에서:
- `currentPrayerModeProvider`가 'prayer'이면 → `analyzePrayer()` 호출 → `/home/prayer-dashboard`
- 'qt'이면 → `analyzeMeditation()` 호출 → `/home/qt-dashboard`

QT 모드에서는 추가로 `currentPassageRefProvider`와 `currentPassageTextProvider` 필요.

---

## Phase D: Mock 데이터

### D-1. prayer_result.json 업데이트

기존 필드 유지 + `prayer_summary`, `historical_story` 추가.

### D-2. qt_meditation_result.json 신규

```json
{
  "analysis": {
    "key_theme_en": "Rest and Peace",
    "key_theme_ko": "쉼과 평안",
    "insight_en": "Your meditation reveals a deep longing for rest in God's presence...",
    "insight_ko": "당신의 묵상에서 하나님 안에서의 쉼에 대한 깊은 갈망이 느껴집니다..."
  },
  "application": {
    "action_en": "Take 15 minutes of intentional rest today",
    "action_ko": "오늘 15분간 의도적으로 쉬는 시간을 가져보세요",
    "when_en": "During lunch break",
    "when_ko": "점심시간에",
    "context_en": "At your workplace",
    "context_ko": "직장에서"
  },
  "knowledge": {
    "original_word": {
      "word": "מְנֻחוֹת",
      "transliteration": "menukhot",
      "language": "Hebrew",
      "meaning_en": "Still waters, waters of rest — reflects sheep's fear of rushing water",
      "meaning_ko": "쉴만한 물, 안식의 물 — 급류를 두려워하는 양의 습성에서 나온 표현"
    },
    "historical_context_en": "Ancient Palestinian shepherds would create calm pools by damming streams, because sheep refuse to drink from rushing water. The shepherd's care extended to reshaping the environment for the flock's comfort.",
    "historical_context_ko": "고대 팔레스타인 목자는 양이 급류에서 물을 마시지 않으므로 시냇물에 둑을 쌓아 잔잔한 웅덩이를 만들어주었습니다. 목자의 돌봄은 양떼의 편안함을 위해 환경까지 바꾸는 것이었습니다.",
    "cross_references": ["Matthew 11:28", "Hebrews 4:9-11", "Psalm 46:10"]
  },
  "growth_story": {
    "title_en": "Corrie ten Boom — Finding Peace in a Concentration Camp",
    "title_ko": "코리 텐 붐 — 수용소에서 평안을 찾다",
    "summary_en": "During World War II, Corrie ten Boom was imprisoned in a Nazi concentration camp. Even in the darkest conditions, she found God's peace through daily Scripture meditation and prayer with her sister Betsie.",
    "summary_ko": "2차 세계대전 중 코리 텐 붐은 나치 수용소에 갇혔습니다. 가장 어두운 환경 속에서도 언니 벳시와 함께 매일 말씀 묵상과 기도를 통해 하나님의 평안을 찾았습니다.",
    "lesson_en": "True rest is not the absence of hardship, but the presence of God in any circumstance.",
    "lesson_ko": "진정한 안식은 고난이 없는 것이 아니라, 어떤 상황에서든 하나님이 함께 계시는 것입니다.",
    "is_premium": true
  }
}
```

---

## Phase E: ARB 키 추가

새로 필요한 키 (~20개):

```
prayerSummaryTitle, gratitudeLabel, petitionLabel, intercessionLabel,
prayerTimeLabel, prayerTopicsTitle, keepPraying, answered,
historicalStoryTitle, todayLesson,
meditationAnalysisTitle, keyThemeLabel, applicationTitle,
applicationWhat, applicationWhen, applicationContext,
relatedKnowledgeTitle, originalWordLabel, historicalContextLabel,
crossReferencesLabel, growthStoryTitle,
yesterdayCheckTitle, yesterdayDid, yesterdayPartial, yesterdayDidNot,
yesterdayEncouragement,
qtDashboardTitle, prayerDashboardTitle
```

각 키에 대해 en, ko, ja, es, zh 5개 언어 번역 제공.

---

## Phase F: 위젯 구현

### F-1. 기도 Dashboard 위젯 (신규 + 수정)

- `prayer_summary_card.dart` — 감사/간구/중보 분류 리스트
- `prayer_topic_card.dart` — 기도 제목 추적 카드
- `historical_story_card.dart` — 역사 스토리 + 교훈 (Premium blur)
- `scripture_card.dart` — 기존 유지
- `ai_prayer_card.dart` — 기존 유지

### F-2. QT Dashboard 위젯 (전부 신규)

- `meditation_analysis_card.dart` — 핵심 테마 + AI 인사이트
- `application_card.dart` — 오늘의 적용 (무엇을/언제/상황)
- `related_knowledge_card.dart` — 원어 + 배경 + 크로스레퍼런스
- `growth_story_card.dart` — 영적 성장 스토리 (Premium blur)
- `yesterday_check_card.dart` — 어제 적용 점검 3버튼

---

## 완료 조건

- [ ] `flutter gen-l10n` 성공
- [ ] `flutter analyze` — 0 에러
- [ ] `flutter test` — 전체 통과
- [ ] 기도 모드: Home 기도탭 → 기도 → AI Loading → **Prayer Dashboard** (6개 카드)
- [ ] QT 모드: Home QT탭 → QT 선택 → 묵상 → AI Loading → **QT Dashboard** (5개 카드)
- [ ] 두 Dashboard가 완전히 다른 카드 구성
- [ ] Premium 카드에 blur 적용
- [ ] 5개 언어 모두 동작
