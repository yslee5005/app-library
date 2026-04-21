# l10n Keys (사전 정의)

> 코드 작성 **전** 모든 키를 여기 정의 → `app_en.arb` / `app_ko.arb`에 추가 → 코드에서 사용.
> **나중에 정리하면 미사용 키 폭증** (praybell 754개 정리 사례).

## 키 목록

| Key | EN | KO | Used in (Screen / INT) |
|---|---|---|---|
| `<feature>Title` | `<English>` | `<한국어>` | screen 1 |
| `<feature>Cta` | `<English>` | `<한국어>` | INT-001 |
| `<feature>Error` | `<English>` | `<한국어>` | error state |
| `<feature>Empty` | `<English>` | `<한국어>` | empty state |

## namedArgs (있는 경우)

```json
"<feature>Greeting": "Hello, {name}",
"@<feature>Greeting": {
  "placeholders": {
    "name": { "type": "String" }
  }
}
```

## 다른 언어
- 1차: en + ko 동시 작성
- 2차: 나머지 33 언어는 fallback (영어). 출시 직전 일괄 추가.

## 참조
- `.claude/rules/learned-pitfalls.md` § 4 (i18n)
- `apps/abba/lib/l10n/app_en.arb` (예시)
- `scripts/check_hardcoded_strings.sh` (검증)
