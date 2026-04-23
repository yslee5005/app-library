# Globalization — 35 Locale 중립 원칙

## 왜 중요한가

이전 대화의 3인 reviewer(목사/권사/학자)는 모두 한국 Protestant 배경 → 편향. abba는 35 locale 앱으로 Catholic(60%), Protestant(32%), Orthodox(8%) 크리스천 모두 포함. Rubric은 **universal Christian principles**만 포함하고 지역 표현은 runtime variable로 주입.

## 15 Universal "Never Say" (모든 섹션 공통)

1. 특정 교단을 맞다/틀리다 단정
2. 마리아/성인 **중보 명령** or **부정** (가톨릭/정교회 유저 존중)
3. Sola scriptura를 **universal Christian doctrine**으로 단정
4. 신체 치유/재정 번영/특정 결과 **약속**
5. 영적 전쟁/귀신 진단 (질병, 가난, 정신건강에 대해)
6. 죄 용서, 매고 푸는 권한, 사죄 선언
7. 약물/치료/상담 중단 권유
8. 예언 (미래 사건 선언) or 개인적 "주님의 말씀" 전달
9. 성경 번역 우열 평가
10. 정치적 발언 (민족주의, 당파적 이슈)
11. 종말론 세부 (rapture 시점, millennium 해석) 단정
12. Locale에 부적절한 친밀함 (예: 존댓말 locale에 반말)
13. 특정 polity 암시하는 clergy title 편향 (Father/Pastor/Elder — 유저 큐만 따라)
14. 니케아 신경에 위배되는 내용 (minimum 공유 confession)
15. "성경학자들 모두 동의한다" 거짓 consensus appeal

## Per-Locale Register (기도 어투)

Runtime에 `{{LOCALE_NAME}}` + 아래 register 가이드가 user prompt에 삽입됨.

| Locale | Pronoun toward God | 비고 |
|--------|-----|------|
| Korean (ko) | 존댓말, ~하소서 / ~주시옵소서 | 시니어는 ~하여 주시옵소서 운율 선호 |
| English (en) | Modern "you" + reverent | Thee/thou 회피 (BCP 제외) |
| Spanish (es) | tú | 거의 universal (Catholic 포함) |
| Portuguese (pt-BR/PT) | tu / Senhor vocative | context 의존 |
| French (fr) | tu | Vatican II 이후 universal |
| German (de) | du | Lutheran + Catholic consensus |
| Italian (it) | tu | Universal |
| Polish (pl) | Ty (capitalized) | Reverence via capitalization |
| Russian/Ukrainian (ru/uk) | Ты (capitalized) | Orthodox sensibility |
| Greek (el) | Modern demotic + biblical echoes | Pure Katharevousa 회피 |
| Japanese (ja) | 丁寧語, 敬語 stacking 회피 | 따뜻함 우선 |
| Chinese (zh) | 祢 (God) | Traditional honorific character |
| Arabic (ar) | Modern Standard Arabic | Qur'anic register 회피 (구분) |
| Hebrew (he) | Modern Hebrew + biblical phrasing | Rabbinic formulae 회피 |

**Rule**: Reverent, intimate, simple — in whatever form the locale natively expresses.

## Bible Translation Specification (Top 10 Locales)

| Locale | Primary | Secondary | PD Fallback |
|--------|---------|-----------|-------------|
| ko | 개역개정 | 새번역 | 개역한글 |
| en | NIV | ESV / NLT | KJV / WEB |
| es | RVR1960 | NVI / DHH | Reina-Valera 1909 |
| pt | ARC / NVI | NVT | Almeida Corrigida Fiel |
| fr | Louis Segond 1910 | BDS / NBS | LSG (PD) |
| de | Lutherbibel 2017 | Schlachter 2000 | Luther 1912 |
| it | CEI 2008 | Nuova Riveduta | Diodati |
| ja | 新共同訳 | 新改訳2017 | 口語訳 |
| zh | 和合本 | 新译本 | 和合本 (PD) |
| ru | Синодальный | Новый Русский | Синодальный (PD) |

**현재 번들 구현**: `apps/abba/bible_sources/build/{locale}_*.json` 파일 존재.
- Locale별로 bundled translation 고정
- Rubric은 "verse 생성 금지, reference만 출력" 원칙
- 실제 verse text는 client의 `bible_text_service.lookup()` 결과 사용

## Over-used Verses — Locale별 blacklist

각 locale의 "너무 들은" 구절. `scripture_rubric.md`에 rotation 로직으로 반영.

| Tradition | 클리셰 (회피) |
|-----------|------------|
| Korean Protestant | Jer 29:11, Phil 4:13, Ps 23, Rom 8:28, Prov 3:5-6, Matt 11:28, 1 Thess 5:18 |
| American Evangelical | Jer 29:11, Phil 4:13, Prov 3:5-6, Rom 8:28 |
| Latin Catholic | Ps 23, Matt 11:28, Magnificat (Luke 1:46-55) |
| African Pentecostal | Jer 29:11, Isa 54:17, Ps 91, Deut 28 |
| European Mainline | Ps 23, John 3:16, Beatitudes |
| Orthodox | Ps 51 (LXX 50), Ps 103, Ps 23 |

**Rule**: Rotate across Wisdom / Prophets / Gospels / Epistles / Psalms. 한 유저의 최근 10개 기도에서 **top-5 구절 중복 금지**.

## Denomination-Sensitive Handling Matrix

| Term / Topic | Neutral Phrasing |
|-----|------|
| Eucharist (성찬) | "주의 만찬을 기념하며" (no transubstantiation claim) |
| Baptism (세례) | "세례를 통해 신앙을 고백한" (no regeneration claim) |
| Soteriology | "은혜로 구원받고 열매로 나타나는" |
| Mary (마리아) | "예수님의 어머니 마리아" (Catholic/Orthodox 중보 요청 X, Protestant 부정 X) |
| Saints (성인) | "믿음의 선진" |
| Purgatory (연옥) | 언급 금지 |
| Rosary (묵주기도) | "중보기도" (중립) |
| Speaking in tongues | "성령의 인도하심" (Pentecostal 요구 X, Cessationist 부정 X) |
| Healing (신유) | "주님의 뜻 안에서의 치유" (단서 필수) |
| Rapture/Millennium | "주님의 재림을 소망하며" (시점 단정 X) |
| Church authority | "유저가 속한 교회 전통 존중" |

## Examples 언어 전략

**결정**: 영어 rubric + locale 예시 **3개 locale만 샘플** (ko, es, en).

**왜 3개만**:
- 35 locale 전체 예시 작성 = 유지보수 불가
- 3개 샘플로 Gemini가 패턴 일반화 (Shi 2023)
- ko: 아시아 대표 (Korean speakers ~80M)
- es: 라틴계 (Spanish speakers ~500M, 가톨릭 주류)
- en: 글로벌 기준

**적용 방식**:
```markdown
### GOOD-1 (Korean)
User: "아들이 수능 앞두고..."
Output: "..."

### GOOD-2 (Spanish)
User: "Mi madre está enferma..."
Output: "..."

### GOOD-3 (English)
User: "I've been struggling with..."
Output: "..."
```

AI는 이 3개를 보고 다른 locale에도 같은 **구조/톤/원칙**을 적용.

## Senior Accommodation (locale별 차이)

유니버설 원칙:
- Short sentences (12-18 words)
- Concrete imagery
- No jargon
- No emojis

Locale 특화:
- Korean seniors: 개역 cadence acceptable (아어체 부담 최소화)
- Anglo seniors: NIV-level readability, Gen-Z idiom 회피
- Latino Catholic seniors: rosary rhythm OK if user initiates
- European mainline seniors: BCP / liturgical echoes 가능
- African seniors: proverb-friendly, "we" communal framing

## User Data Fields to Respect

Runtime에 user profile에서 읽어서 prompt에 주입:

```dart
final userContext = {
  'locale': userProfile.locale,           // 'ko', 'en', 'es', ...
  'denomination': userProfile.denomination, // 'catholic'|'protestant'|'orthodox'|null
  'name': userProfile.name,                // "권사님" or "John" (optional)
  'age_bracket': userProfile.ageBracket,   // '50-70' or null
};
```

- `denomination` 필드 있으면 rubric의 handling matrix 활용
- `name` 있으면 "By name" mention 가능
- 미제공 필드는 neutral default

## Phase 2 확장 (출시 후)

데이터 기반 판단:

1. **저자원 locale 품질 저하** (Amharic, Burmese 등) 감지 시:
   - 해당 locale만 per-locale appendix 추가 (Strategy C 하이브리드)
   - 월 추가 비용 ~$2/locale (storage)

2. **특정 locale에서 특정 섹션 실패율 ↑** 감지 시:
   - 해당 섹션만 locale-specific few-shot 확장
   - Rubric file 자체 변경 없음 (appendix만)

3. **새 locale 추가** (36th, 37th...):
   - Translation matrix 업데이트
   - Register appendix 추가
   - Rubric 파일 변경 없음 (universal)

## 검증 체크리스트 (출시 전)

- [ ] 15개 "Never Say" rule이 모든 rubric에 반영됨
- [ ] Translation matrix 10 locale 모두 bundle 파일 존재 확인
- [ ] Per-locale register 가이드 `system_base.md`에 포함
- [ ] Over-used verses list per tradition 반영
- [ ] Denomination-sensitive matrix 준수
- [ ] Examples ko/es/en 3 샘플 각 rubric 포함
- [ ] 한국 bias 표현 strip 완료 (~하여 주시옵소서 기본값 제거 등)
