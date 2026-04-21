# Bible Bundle Copyright Audit — 2026-04-21

> 실사 책임자: yslee5005 · 상업 앱 (Pro $6.99/mo) 기준 리스크 평가.

## 요약

34개 locale 후보 중 **3개 제거 (am, th, no)**, **26개 Public Domain + 5개 CC BY-SA/ND**로 최종 구성. 총 **31개 locale** 지원.

`ar` (Arabic) 는 별도로 깨끗한 PD 소스 미발견 → reference-only fallback 유지.

최종 미지원 locale (reference-only fallback, 4개): **am, ar, no, th**

## 제거된 번들 (3개)

| Locale | File | 제거 사유 |
|---|---|---|
| **am** | am_amh.json | © United Bible Societies / Bible Society of Ethiopia. "Every commercial use needs written permission" — Abba(상업 앱)에 **명시적 금지** |
| **th** | th_kjv.json | © 2003 Philip Pope. **CC BY-NC-ND** — "NonCommercial" 명시. 상업 이용 **법적 침해** |
| **no** | no_norsk.json | Det Norske Bibelselskap 1930 — "free non-commercial distribution"만 허용. 상업 이용 라이선스 조건 위반 가능 |

## CC 라이선스 번들 (5개) — commercial OK with attribution

| Locale | 번역본 | 라이선스 | 주의사항 |
|---|---|---|---|
| hi | Hindi Common Version | CC BY-SA 4.0 (© Biblica) | 텍스트 수정 금지, Biblica® 상표 오용 금지 |
| id | Alkitab BahasaKita (Albata) | CC BY-SA 4.0 (© Yayasan Alkitab BahasaKita) | 〃 |
| ms | Kitab Suci (Malay NT) | CC BY-ND 4.0 (© Pengamat Kitab Mulia) | 파생 저작물 금지 (format 변환은 통상 허용) |
| sk | Nádej pre každého (Slovak NT) | CC BY-SA 4.0 (© Biblica) | Biblica® 상표 오용 금지 |
| tr | Open Basic Turkish NT | CC BY-SA 4.0 (© Biblica) | 〃 |

**ShareAlike 해석**: USFM/JSON 포맷 변환 자체는 derivative work 아님 (내용 불변). 텍스트 **수정 없음** 유지 필수.

**Attribution**: Settings > "사용된 성경 번역본" 페이지에 번역본 이름 + 라이선스 전부 표시 — BibleTranslationsView 구현.

## Public Domain 확정 (26개)

| Locale | 번역본 | 발행 | 출처 |
|---|---|---|---|
| cs | Bible Kralická | 1613 | scrollmapper |
| da | Dansk 1871/1907 | 1871 | scrollmapper |
| de | Elberfelder 1905 | 1905 | scrollmapper |
| el | Βάμβας | 1850 | scrollmapper |
| en | World English Bible | 2000 | scrollmapper (PD 명시) |
| es | Reina-Valera 1909 | 1909 | scrollmapper |
| fi | Raamattu 1933/38 | 1933 | scrollmapper |
| fil | Ang Dating Biblia | 1905 | scrollmapper |
| fr | Synodale 1921 | 1921 | scrollmapper |
| he | Modern Hebrew Bible | 1877 | scrollmapper |
| hr | Croatian Bible (Šarić) | 1960 | ebible.org (PD 명시) |
| hu | Károli | 1908 | scrollmapper |
| it | Diodati 1927 | 1927 | ebible.org |
| ja | 口語訳 | 1955 | scrollmapper (2006 PD 만료) |
| ko | 개역한글 (KRV) | 1961 | scrollmapper (2012 PD 만료) |
| my | Judson 1835 | 1835 | scrollmapper |
| nl | Statenvertaling | 1637 | scrollmapper |
| pl | Biblia Gdańska | 1632 | scrollmapper |
| pt | Almeida | 1819 | scrollmapper |
| ro | Cornilescu 1924 | 1924 | ebible.org (PD 명시) |
| ru | Synodal 1876 | 1876 | scrollmapper |
| sv | Bibeln 1917 | 1917 | scrollmapper |
| sw | Swahili 1850 | 1850 | ebible.org |
| uk | Огієнко | 1962 | scrollmapper |
| vi | Kinh Thánh Việt | 1926 | scrollmapper |
| zh | 和合本 (Chinese Union Version) | 1919 | scrollmapper |

## 조사 방법론

1. 각 번들 파일 무결성 점검 (`Psalm 23:1`, `John 3:16`, `Genesis 1:1` 존재 확인)
2. Source 확인 (scrollmapper vs ebible.org)
3. 각 번역본 ebible.org details 페이지 조회 → 공식 라이선스 정보
4. 라이선스 문구 해석:
   - "Public Domain" → ✅ 상업 OK
   - "CC BY" / "CC BY-SA" → ✅ attribution 필수, 상업 OK
   - "CC BY-ND" → ✅ 수정 금지, 포맷 변환은 허용 해석
   - "CC BY-NC*" / "NonCommercial" → ❌ 상업 앱 부적합
   - 개별 "commercial permission required" → ❌ 허가 획득 전 사용 금지

## 재정적 리스크 평가

### 현재 구성 (31 locale) 시 리스크: **거의 0**

- PD 26개: 법적 리스크 0
- CC 5개: Attribution 명시로 라이선스 준수. 저작권자가 이의 제기 시 최악 "내려달라" 요청 → 즉시 대응 가능. 소송 확률 매우 낮음
- 제거한 am/th/no: Abba 노출 0

### 만약 am/th를 남겼다면 (가상 시나리오)

- **am (UBS)**: DMCA takedown → 확률 중. 소송 확률 낮으나 가능
- **th (CC BY-NC-ND)**: Philip Pope가 이의 제기 시 App Store takedown → 확률 중상. CC 라이선스 위반은 DMCA 유효 근거
- **App Store 리스팅 제거** 시 Abba 서비스 중단. 복구에 수주-수개월 소요

## 재발 방지 checklist (향후 bundle 추가 시)

1. [ ] ebible.org details 페이지 공식 라이선스 확인
2. [ ] "Public Domain" 또는 "CC BY" / "CC BY-SA" 만 허용
3. [ ] "NonCommercial" 또는 "permission required" 있으면 **즉시 제외**
4. [ ] Biblica 등 대형 저작권자 제품은 CC BY-SA여도 trademark 유의
5. [ ] 번들 추가 후 Settings attribution 페이지 업데이트 확인

## 참고 링크

- [Biblica Permissions](https://www.biblica.com/permissions/)
- [eBible.org Copyright](https://ebible.org/Scriptures/copyright.php)
- [Open.Bible — Scripture Engagement](https://scripture-engagement.org/content/open-bible/)
- [Creative Commons Licenses](https://creativecommons.org/licenses/)
