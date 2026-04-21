# l10n Keys — bible_text_i18n

코드 작성 전 사전 정의 → 35 ARB 파일 일괄 추가.

---

## Phase 1 · 신규 키 (3개)

| Key | EN | KO | 용도 / INT |
|---|---|---|---|
| `scriptureKeyWordHintTitle` | `Today's Key Word` | `오늘의 핵심 단어` | ✨ 섹션 제목 (INT-063) |
| `bibleLookupReferenceHint` | `Find this passage in your Bible and meditate on it.` | `나의 성경으로 이 말씀을 찾아 묵상해 보세요.` | PD 미지원 locale fallback (INT-062) |
| `bibleTranslationAttribution` | `({name}, Public Domain)` | `({name}, Public Domain)` | reference 아래 attribution caption (INT-064, namedArg) |

### namedArgs 정의

```json
"bibleTranslationAttribution": "({name}, Public Domain)",
"@bibleTranslationAttribution": {
  "placeholders": {
    "name": { "type": "String" }
  }
}
```

모든 locale에서 번역본 이름(예: "개역한글", "World English Bible")은 그대로 — placeholder만 삽입.

### 언어별 초안 (주요 locale)

| Locale | scriptureKeyWordHintTitle | bibleLookupReferenceHint |
|--------|---------------------------|--------------------------|
| en | Today's Key Word | Find this passage in your Bible and meditate on it. |
| ko | 오늘의 핵심 단어 | 나의 성경으로 이 말씀을 찾아 묵상해 보세요. |
| ja | 今日のキーワード | ご自分の聖書でこの箇所を見つけて黙想してください。 |
| zh | 今日关键词 | 请在您的圣经中找到这段经文并默想。 |
| es | Palabra clave de hoy | Busca este pasaje en tu Biblia y medítalo. |
| fr | Mot-clé du jour | Trouvez ce passage dans votre Bible et méditez-le. |
| de | Das Schlüsselwort heute | Finden Sie diese Stelle in Ihrer Bibel und meditieren Sie darüber. |
| pt | Palavra-chave de hoje | Encontre esta passagem em sua Bíblia e medite nela. |
| it | Parola chiave di oggi | Trova questo passo nella tua Bibbia e meditalo. |
| ru | Ключевое слово сегодня | Найдите этот отрывок в вашей Библии и размышляйте над ним. |
| ar | الكلمة المفتاحية لليوم | ابحث عن هذا المقطع في كتابك المقدس وتأمل فيه. |

### 35 locale 전략

- 1차: en + ko 정확
- 2차: Phase 3 l10n 스크립트 패턴(`/tmp/add_phase*_l10n.py`) 재사용해 Phase 6용 스크립트 생성, 33개 언어 일괄
- 3차: 출시 전 주요 locale (ja/zh/es/fr/de/pt) 교회 용어 톤 검토

---

## Phase 2 · 신규 키 (추가 예정)

- BibleStory/Guidance single-field 변경은 **UI에 노출되는 신규 문자열 無** → l10n 신규 키 0개

---

## Phase 3 · 신규 키 (추가 예정, Settings Attribution)

예상 5-6 키:
- `settingsBibleTranslations` — "사용된 성경 번역본" 메뉴 라벨
- `settingsBibleTranslationsIntro` — 페이지 상단 설명 문구
- `settingsBibleTranslationsCreditFooter` — "AI 주석은 Abba 창작물" 안내
- `bibleTranslationListItem` — 항목 format `"{locale}: {name} ({year}, {license})"`
- `bibleTranslationPdLabel` — "Public Domain"

---

## 참조

- `.claude/rules/learned-pitfalls.md` §4 i18n
- `apps/abba/lib/l10n/app_en.arb` (기준)
- prayer_output_redesign `/tmp/add_phase*_l10n.py` (스크립트 패턴)
