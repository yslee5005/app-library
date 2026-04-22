# SPEC-L10N-35: 다국어 35개 언어 확장

## 목표
앱 UI를 35개 언어로 확장하여 글로벌 기독교 인구의 95%를 커버한다.

## 현재 상태
- 지원 언어: 5개 (ko, en, ja, es, zh)
- arb 키 수: ~224개 (app_en.arb 기준)
- 커버리지: ~45% (글로벌 기독교 인구)

## 추가할 언어 30개

### Tier 1 — 기독교 인구 1억+ (5개)
| 코드 | 언어 | 기독교 인구 |
|------|------|:---------:|
| pt | 포르투갈어 (브라질) | 2.3억 |
| fr | 프랑스어 | 1.5억 |
| hi | 힌디어 | 3천만 |
| fil | 필리핀어 | 9천만 |
| sw | 스와힐리어 | 8천만 |

### Tier 2 — 기독교 인구 3천만+ (10개)
| 코드 | 언어 | 기독교 인구 |
|------|------|:---------:|
| de | 독일어 | 5천만 |
| it | 이탈리아어 | 5천만 |
| pl | 폴란드어 | 3.5천만 |
| ru | 러시아어 | 6천만 |
| id | 인도네시아어 | 3천만 |
| uk | 우크라이나어 | 3.5천만 |
| ro | 루마니아어 | 2천만 |
| nl | 네덜란드어 | 1천만 |
| hu | 헝가리어 | 8백만 |
| cs | 체코어 | 5백만 |

### Tier 3 — 주요 시장 + 커버리지 확대 (15개)
| 코드 | 언어 |
|------|------|
| vi | 베트남어 |
| th | 태국어 |
| tr | 터키어 |
| ar | 아랍어 |
| he | 히브리어 |
| el | 그리스어 |
| sv | 스웨덴어 |
| no | 노르웨이어 |
| da | 덴마크어 |
| fi | 핀란드어 |
| hr | 크로아티아어 |
| sk | 슬로바키아어 |
| ms | 말레이어 |
| am | 암하라어 (에티오피아) |
| my | 미얀마어 |

## 수정 파일 목록

### A. 새로 생성 (30개 arb 파일)
```
lib/l10n/app_{code}.arb × 30개
```
기준: `app_en.arb`의 224개 키를 각 언어로 번역

### B. 수정 (3개 파일)

#### 1. `lib/app.dart` — supportedLocales 확장
```dart
supportedLocales: const [
  Locale('ko'), Locale('en'), Locale('ja'), Locale('es'), Locale('zh'),
  // 추가 30개
  Locale('pt'), Locale('fr'), Locale('hi'), Locale('fil'), Locale('sw'),
  Locale('de'), Locale('it'), Locale('pl'), Locale('ru'), Locale('id'),
  Locale('uk'), Locale('ro'), Locale('nl'), Locale('hu'), Locale('cs'),
  Locale('vi'), Locale('th'), Locale('tr'), Locale('ar'), Locale('he'),
  Locale('el'), Locale('sv'), Locale('no'), Locale('da'), Locale('fi'),
  Locale('hr'), Locale('sk'), Locale('ms'), Locale('am'), Locale('my'),
],
```

#### 2. `lib/features/settings/view/settings_view.dart` — 드롭다운 확장
언어 선택 DropdownButton에 30개 항목 추가.

#### 3. ~~`lib/services/real/openai_service.dart` — _localeName 매핑 확장~~
**폐기됨 (2026-04-21)** — OpenAI 서비스 전체 삭제. Gemini 단독 운영으로 `gemini_service.dart`의 `_localeName` 매핑만 유지한다.

### C. 자동 생성 (flutter gen-l10n)
```
lib/l10n/generated/app_localizations_{code}.dart × 30개
lib/l10n/generated/app_localizations.dart (업데이트)
```

## 실행 순서 (Ralph Task 단위)

### Task 1: Tier 1 arb 생성 (5개)
- app_en.arb 기준으로 pt, fr, hi, fil, sw 번역
- 각 파일 생성 후 JSON 유효성 검증

### Task 2: Tier 2 arb 생성 (10개)
- de, it, pl, ru, id, uk, ro, nl, hu, cs 번역

### Task 3: Tier 3 arb 생성 (15개)
- vi, th, tr, ar, he, el, sv, no, da, fi, hr, sk, ms, am, my 번역

### Task 4: 코드 수정
- app.dart supportedLocales 확장
- settings_view.dart 드롭다운 확장
- gemini_service.dart _localeName 매핑 확장 (openai_service.dart는 2026-04-21 폐기)

### Task 5: 빌드 검증
- flutter pub get (l10n 재생성)
- flutter analyze (전체 정적 분석)
- 각 locale로 앱 실행 가능 여부 확인

## 가격 l10n 규칙
- 각 나라 통화로 표시 (USD $3.49 기준 환산)
- monthlyPrice, yearlyPrice, yearlyPriceMonthly 3개 키
- 환산은 대략적 시장가 기준 (정확한 앱스토어 가격은 RevenueCat에서 관리)

## RTL 언어 주의 (아랍어, 히브리어)
- Flutter의 Directionality 자동 처리 확인
- 하드코딩된 padding/margin에 RTL 대응 필요 여부 체크

## 완료 기준
- [ ] 35개 arb 파일 존재
- [ ] flutter analyze 에러 없음
- [ ] 앱 빌드 성공
- [ ] 설정에서 35개 언어 선택 가능
- [ ] AI 응답이 선택 언어로 생성됨
