# Feature: <NAME>

> Status: draft | Owner: <name> | Updated: YYYY-MM-DD | App: <abba|blacklabelled|...>

## TL;DR
<1-2 문장. 이 feature가 무엇을 하고, 왜 필요한지.>

## 데이터
@./_details/data_model.md

## 화면 (Empty / Loading / Error / Data)
@./_details/screens.md

## 인터랙션 매트릭스 (Ralph가 한 줄씩 구현)
@./_details/interactions.md

## l10n 사전 정의
@./_details/l10n_keys.md

## 이 feature 관련 함정 (learned-pitfalls 부분 link)
@./_details/pitfall_refs.md

## 검증 통과 기준
- [ ] `flutter analyze` 통과
- [ ] 모든 INT-XXX widget test 통과
- [ ] `scripts/harness_check.sh apps/<app>` 통과
- [ ] 사람 smoke test (golden path + edge case 1개씩)
