# PROMPT — Abba l10n 하드코딩 전수 수정

> Ralph 자율 실행용 프롬프트
> 목표: 모든 뷰/위젯에서 하드코딩된 문자열을 l10n(ARB) 키로 교체

---

## 실행 규칙

1. 각 파일 수정 전 반드시 해당 파일을 Read로 읽기
2. 필요한 ARB 키를 **5개 언어 모두** (en, ko, ja, es, zh)에 동시 추가
3. 수정 후 `flutter gen-l10n` + `flutter analyze` 검증
4. 모든 수정 완료 후 `flutter test` 통과 확인

---

## 필수 읽기

- `apps/abba/lib/l10n/app_en.arb` — 현재 키 목록 확인
- `apps/abba/lib/l10n/app_ko.arb`
- `apps/abba/lib/l10n/app_ja.arb`
- `apps/abba/lib/l10n/app_es.arb`
- `apps/abba/lib/l10n/app_zh.arb`

---

## 수정 체크리스트

### 1. abba_tab_bar.dart — 탭 라벨 l10n 전환
- [ ] 현재: `'Home'`, `'Calendar'`, `'Community'`, `'Settings'` 하드코딩
- [ ] 변경: NavigationDestination에 BuildContext 전달하여 l10n 사용
- [ ] 이미 존재하는 ARB 키: `tabHome`, `tabCalendar`, `tabCommunity`, `tabSettings`
- [ ] 방법: AbbaTabBar를 StatelessWidget으로 유지하되 build(context)에서 `AppLocalizations.of(context)!` 사용

### 2. calendar_view.dart — 요일 헤더 로케일 대응
- [ ] 현재: `['S', 'M', 'T', 'W', 'T', 'F', 'S']` 하드코딩
- [ ] 변경: `intl` 패키지의 `DateFormat.E(locale)` 사용하여 로케일별 요일 약어 생성
- [ ] 예: `DateFormat('E', locale).format(DateTime(2024, 1, i))` 로 일~토 생성 후 첫 글자 사용
- [ ] 또는 ARB에 `weekdayMon`, `weekdayTue` 등 추가

### 3. premium_blur.dart — Premium 버튼 텍스트
- [ ] 현재: `'💎 Premium'` 하드코딩 (약 line 88-92)
- [ ] 변경: `l10n.premiumUnlock` 사용 (이미 존재하는 키)
- [ ] BuildContext에서 AppLocalizations 가져오기
- [ ] Semantics label도 l10n 키 사용

### 4. streak_garden.dart — 성장 단계 라벨
- [ ] 현재: `streakGardenLabel()` 함수에서 locale switch로 하드코딩
- [ ] 변경: 새 ARB 키 추가 후 l10n 사용
- [ ] 새 키 필요: `gardenSeed`, `gardenSprout`, `gardenBud`, `gardenBloom`, `gardenTree`
- [ ] en: "A seed of faith", "Growing sprout", "Budding flower", "Full bloom", "Strong tree"
- [ ] ko: "믿음의 씨앗", "자라나는 새싹", "꽃봉오리", "만개한 꽃", "든든한 나무"
- [ ] ja: "信仰の種", "育つ芽", "つぼみ", "満開の花", "大きな木"
- [ ] es: "Semilla de fe", "Brote creciendo", "Capullo", "Flor en plena", "Árbol fuerte"
- [ ] zh: "信心的种子", "成长的嫩芽", "花蕾", "盛开的花", "参天大树"
- [ ] 함수 시그니처를 `streakGardenLabel(int days, AppLocalizations l10n)` 으로 변경
- [ ] 호출하는 곳 (home_view.dart, calendar_view.dart) 업데이트

### 5. milestone_modal.dart — 공유/감사 버튼 텍스트
- [ ] 현재: `locale == 'ko' ? '공유하기' : 'Share'` 등 하드코딩
- [ ] 변경: 새 ARB 키 추가
- [ ] 새 키 필요: `milestoneShare`, `milestoneThankGod`
- [ ] en: "Share", "Thank God!"
- [ ] ko: "공유하기", "감사합니다!"
- [ ] ja: "共有する", "神に感謝!"
- [ ] es: "Compartir", "¡Gracias a Dios!"
- [ ] zh: "分享", "感谢上帝!"
- [ ] BuildContext에서 l10n 가져와서 사용

### 6. milestone_share_card.dart — 공유 텍스트/라벨
- [ ] 현재: `_shareText()`, `_daysLabel`, `_subtitle` 모두 switch 하드코딩
- [ ] 변경: 새 ARB 키 추가
- [ ] 새 키 필요: `shareStreakText`, `shareDaysLabel`, `shareSubtitle`
- [ ] `shareStreakText`: "{count} day prayer streak! My prayer journey with Abba #Abba #Prayer"
- [ ] `shareDaysLabel`: "day prayer streak"
- [ ] `shareSubtitle`: "Daily prayer with God"
- [ ] 주의: 이 위젯은 RepaintBoundary 안에서 렌더링되어 BuildContext 접근 제한적
- [ ] 해결: 호출하는 쪽에서 l10n 텍스트를 파라미터로 전달

### 7. settings_view.dart — Premium 관련 텍스트
- [ ] 현재: `'✅ Premium'`, `'1x/day'`, `'Unlimited'` 등 하드코딩
- [ ] 변경: 새 ARB 키 추가
- [ ] 새 키 필요: `premiumActive`, `planOncePerDay`, `planUnlimited`
- [ ] en: "Premium Active", "1x/day", "Unlimited"
- [ ] ko: "프리미엄 활성", "1일 1회", "무제한"
- [ ] ja: "プレミアム有効", "1日1回", "無制限"
- [ ] es: "Premium Activo", "1x/día", "Ilimitado"
- [ ] zh: "已订阅Premium", "每天1次", "无限"

### 8. recording_overlay.dart — Semantics 라벨
- [ ] 현재: `'Close recording'` 하드코딩
- [ ] 변경: 새 ARB 키 추가
- [ ] 새 키: `closeRecording`
- [ ] en: "Close recording"
- [ ] ko: "녹음 닫기"
- [ ] ja: "録音を閉じる"
- [ ] es: "Cerrar grabación"
- [ ] zh: "关闭录音"

### 9. 에러 메시지 통일 — 4개 파일
- [ ] `dashboard_view.dart:47` — `'Error: $e'` → `l10n.errorGeneric`
- [ ] `qt_view.dart:52` — `'Error: $e'` → `l10n.errorGeneric`
- [ ] `community_view.dart:91` — `'Error: $e'` → `l10n.errorGeneric`
- [ ] `calendar_view.dart:338` — `'Error: $e'` → `l10n.errorGeneric`
- [ ] `errorGeneric` 키는 이미 존재함: "Something went wrong. Please try again later."

### 10. abba_snackbar.dart — Retry fallback
- [ ] 현재: `'Retry'` 하드코딩 fallback
- [ ] 변경: `retryButton` 키 이미 존재 → l10n 사용
- [ ] BuildContext 필요시 파라미터로 전달

---

## ARB 키 추가 요약 (새로 필요한 키)

```
gardenSeed, gardenSprout, gardenBud, gardenBloom, gardenTree,
milestoneShare, milestoneThankGod,
shareStreakText, shareDaysLabel, shareSubtitle,
premiumActive, planOncePerDay, planUnlimited,
closeRecording
```

**총 ~14개 신규 키 × 5개 언어 = 70개 번역 항목**

---

## 완료 조건

- [ ] `flutter gen-l10n` 성공
- [ ] `flutter analyze` — 0 에러
- [ ] `flutter test` — 전체 통과
- [ ] 모든 하드코딩 문자열이 l10n 키로 교체됨
- [ ] 5개 언어 ARB 파일 키 수 동일
