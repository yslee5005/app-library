# Feature Spec Template

새 feature 시작:
```bash
cp -r templates/feature_spec apps/<app>/specs/<feature_name>
```

그 후:
1. `SPEC.md`의 `<NAME>`, TL;DR 채우기
2. `_details/` 5개 파일 채우기 (데이터 → 화면 → 인터랙션 → l10n → pitfall 순서 권장)
3. Ralph에게 `apps/<app>/specs/<feature_name>/SPEC.md` 보고 implement 요청
4. 모든 INT-XXX 구현 후 `scripts/harness_check.sh apps/<app>` 통과 확인
