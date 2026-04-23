# 함정 참조 (learned-pitfalls 연결)

## 관련 있는 기존 §

### §2. Subscription / Payment Crash 방지
Phase 4.1과 직접 연관 없음. 그러나 T3 호출 시 Pro 구독 체크 시 RevenueCat `isPremiumProvider` 재사용 필요.

### §2-1. AI fallback 하드코딩으로 인한 DB 오염 (Phase 3 완성)
- **Phase 3에서 해결 완료**: 하드코딩 fallback 반환 → throw AiAnalysisException
- Phase 4.1가 이 원칙 연장:
  - Tier별 실패 시도 하드코딩 fallback 없음 (Scripture는 safe fallback UI만)
  - `section_status` 컬럼으로 "어느 tier 완성됐나" 명시적 추적
  - 부분 완성도 유저에게 표시 (가짜 데이터 없이)

### §3. Multi-tenant (Supabase)
- `section_status` 컬럼 추가 → RLS COALESCE NULL defense 필요 (데이터 추가 시)
- `public.system_config` 신규 테이블 → RLS policy 설정 필수 (모든 유저 read, service_role만 write)
- `abba.update_prayer_tier` RPC → SECURITY DEFINER + `WHERE user_id` 암묵 인증 (자기 prayer만 update)

### §4. i18n
- **Rubric 영어 작성 + locale 예시만 혼합** 원칙 (globalization.md)
- ARB 키 19개 신규 → en + ko 우선, 33 locale 영어 fallback
- `scripts/check_l10n_sync.sh` naive regex 버그 주의 → Python JSON 기반 검증

### §5. Auth Lifecycle
- Phase 4.1은 auth 건드리지 않음
- 단, Tier3 (Pro) 호출 시 `isPremiumProvider` 체크 → anonymous 유저도 Pro 가능 (Phase 2 설계 반영)

### §11. 성능 (N+1, fire-and-forget, lazy)
- **T2 fire-and-forget** 패턴 활용 (T1 완성 후 T2 호출, await 안 함)
- **Lazy Cache 생성**: 유저 첫 호출 시만 cache create (cron 제거)
- **Scripture validation**: bundle lookup은 로컬 (~50ms), 네트워크 0
- N+1 주의: `section_status` 쿼리는 prayer row 자체에 있어 추가 쿼리 없음

### §16. Code Generation 누락
- ARB 변경 후 **`flutter gen-l10n` 필수**
- Migration push 후 Supabase Dart types 재생성 권장 (optional)
- Freezed 모델 변경 없음 (PrayerResult는 JSONB 구조 그대로)

### §17. Sentry 에러 로깅
- Tier별 실패 → `apiLog.error(error: e, stackTrace: st)` 유지
- Scripture 환각 감지 → `apiLog.warning('[Scripture] Invalid ref: $ref')` (Sentry 미승격)
- Cache miss → `apiLog.warning(...)` (비용 알림용)
- Template fallback 사용 → `apiLog.info(...)` (통계용)

### §18. Git 멀티계정 운영
- Commit은 yslee5005 계정 (`memory/git_commit_account.md`)
- `--global` 플래그 금지

### §19. MoAI Phase별 Pre-Execution Report 룰
- **이 SPEC이 Phase 4.1 Pre-Execution Report 역할**
- 각 INT-XXX는 독립 단위 (Ralph가 순차 실행)
- 유저 중간 승인 (rubric 검토, migration push)

---

## 새로 추가해야 할 함정 (Phase 4.1 과정에서 발견 예상)

### §20 후보: Rubric token bloat
- Rubric 1200 토큰 상한 넘으면 Gemini instruction adherence 저하 (Liu 2024)
- 각 rubric 작성 후 token count 검증 강제
- `scripts/check_rubric_tokens.sh` 추가 고려

### §21 후보: Cache version mismatch
- Rubric 파일 변경했는데 bundle hash 계산 버그로 cache 재생성 안 되면 → old rubric으로 돌아감
- 방어: 앱 시작 시 "current hash ≠ stored hash" 경고 로그
- 수동 재생성 CLI 스크립트 제공

### §22 후보: Streaming chunk 파싱 실패
- Gemini SSE chunks가 중간에 끊기면 JSON 불완전
- 방어: 마지막 유효 `{...}` 블록까지 파싱 시도 + fallback
- `parseStreamingJson()` 헬퍼 추가

### §23 후보: Scripture bundle locale mismatch
- 유저 locale 'ko'인데 bundle에 ko 파일 없음 → fallback to en
- 방어: `bibleService.lookup()` 내부 locale fallback 체인
- 이미 구현돼있을 수도 (Phase 1에서)

### §24 후보: Tier coherence 실패
- T2/T3가 T1 context 무시하고 같은 구절 재사용
- 방어: coherence 검증 후처리 (T2 결과에 T1의 scripture.reference가 있으면 warning)
- Phase 2에서 평가

---

## learned-pitfalls.md 업데이트 계획

Phase 4.1 완료 후 다음 섹션 추가 (별도 커밋):

```markdown
## 20. AI Tier 기반 생성 시 주의 (2026-04-23 추가)
- Tier별 coherence 유지: 이전 tier 결과를 context로 반드시 주입
- Streaming SSE 중간 끊김: 마지막 유효 JSON 블록까지 파싱 + fallback
- Cache hash 기반 버전 관리: rubric 변경 시 자동 재생성 체크
- Scripture 환각 1회 retry 패턴 (2회 실패 시 safe fallback UI)
- Section_status JSONB로 partial 완성 추적
```

---

## 검증 체크리스트

출시 전 이 pitfall 참조 검증:

- [ ] §2-1 원칙 (하드코딩 fallback 금지) 모든 tier에 적용
- [ ] §3 RLS COALESCE NULL 체크 (section_status 포함)
- [ ] §4 i18n — 하드코딩 문자열 0개
- [ ] §11 T2 fire-and-forget 패턴 적용
- [ ] §16 ARB 변경 후 gen-l10n 실행
- [ ] §17 Sentry 에러 로깅 일관성
- [ ] §19 Pre-Execution Report (이 SPEC) 작성 완료

## 새 pitfall 발견 시 기록 위치

Phase 4.1 구현 중 새 함정 발견:
1. 즉시 `apps/abba/specs/phase_4_1_section_based_ai/_details/pitfall_refs.md` (이 파일)에 추가
2. Phase 완료 후 `.claude/rules/learned-pitfalls.md`로 이관
3. commit 분리 (docs)

예:
> 2026-04-23: Gemini streaming chunks의 first `{` 이전에 markdown code fence `​```json` 삽입될 수 있음 — regex로 제거 필요
