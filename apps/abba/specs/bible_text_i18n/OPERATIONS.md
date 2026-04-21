# Operations — bible_text_i18n

사용자(yslee5005)가 **수동으로 실행해야 하는 작업** 정리. Claude는 실행 불가.

## Phase 1 수동 작업 (1회)

### 1. Supabase RLS 정책 적용

```bash
# Supabase CLI 로그인 (이미 되어 있으면 skip)
supabase login

# 마이그레이션 push (사용자 승인 필요한 작업)
supabase db push --linked
```

또는 **Supabase Dashboard** 사용:
1. `https://supabase.com/dashboard/project/<project-id>` 접속
2. SQL Editor 열기
3. `supabase/migrations/20260421000001_abba_bible_bundles_rls.sql` 내용 복사 → 실행

### 2. PD 성경 USFM 파일 다운로드

각 번역본을 ebible.org에서 다운로드:

**한국어 (개역한글 1961)**

ebible.org에는 1910 판만 있어서 scrollmapper/bible_databases (GitHub) 의
KorRV.json을 사용. 이미 JSON 포맷이라 USFM 파싱 불필요.

```bash
mkdir -p apps/abba/bible_sources
curl -L -o apps/abba/bible_sources/ko_krv_1961.json \
  https://raw.githubusercontent.com/scrollmapper/bible_databases/master/formats/json/KorRV.json

# Convert to Abba bundle format (book 순회 → flat verse map)
python3 <<'PY'
import hashlib, json, os
src = "apps/abba/bible_sources/ko_krv_1961.json"
dst = "apps/abba/bible_sources/build/ko_krv.json"
os.makedirs(os.path.dirname(dst), exist_ok=True)
raw = json.load(open(src, encoding="utf-8"))
verses = {}
for book in raw["books"]:
    name = book["name"]
    if name == "Psalms":
        name = "Psalm"
    for ch in book["chapters"]:
        for v in ch["verses"]:
            verses[f"{name} {ch['chapter']}:{v['verse']}"] = v["text"].strip()
blob = json.dumps(verses, sort_keys=True, ensure_ascii=False).encode("utf-8")
sha = hashlib.sha256(blob).hexdigest()[:16]
bundle = {
    "locale": "ko", "version": "1.0.0", "sha256": sha,
    "translation": {"name": "개역한글 (KRV)", "year": 1961,
        "license": "Public Domain (copyright expired 2012)",
        "source": "https://github.com/scrollmapper/bible_databases"},
    "verses": verses,
}
open(dst, "w", encoding="utf-8").write(json.dumps(bundle, ensure_ascii=False, indent=2))
print(f"DONE: {len(verses)} verses, sha={sha}")
PY
```

**영어 (WEB — World English Bible)**
```bash
curl -O https://ebible.org/Scriptures/eng-web_usfm.zip
mkdir -p apps/abba/bible_sources/en_web
unzip eng-web_usfm.zip -d apps/abba/bible_sources/en_web/
```

(참고: `apps/abba/bible_sources/` 는 `.gitignore` 권장 — 원본 USFM 30MB+.)

### 3. USFM → JSON 변환

```bash
# 영어 WEB (USFM → JSON)
python3 scripts/build_bible_bundles.py \
  --src apps/abba/bible_sources/en_web \
  --locale en \
  --code web \
  --name "World English Bible" \
  --year 2000 \
  --license "Public Domain" \
  --source "https://eBible.org/engwebp/"

# 결과: apps/abba/bible_sources/build/en_web.json

# 한국어는 이미 JSON이라 위 scrollmapper 변환 블록 참조
# 결과: apps/abba/bible_sources/build/ko_krv.json
```

**파일 검증**:
- 각 파일 1-5MB 사이
- 총 verse count ~31,000 (warning 0개가 이상적)
- `Psalm 23:1`, `John 3:16`, `Genesis 1:1` 3개 존재 spot-check 자동

### 4. Supabase Storage 업로드

**Supabase Dashboard**:
1. `https://supabase.com/dashboard/project/<id>/storage/buckets/abba`
2. `bibles/` 폴더 생성 (없으면)
3. `ko_krv.json` + `en_web.json` 업로드

**또는 CLI / script** (service_role key 필요):
```bash
# supabase-js 또는 curl로 service_role key 사용
# (권한 위험하니 개발 PC에서만)
```

### 5. 동작 확인

```bash
# 앱 실행 (실기기)
flutter run --profile apps/abba

# 기도 완료 후 Dashboard 진입
# → 시편 23편 등 표시 확인 (verse 텍스트 로드되어야 함)
# → Settings에서 locale 변경 → 해당 언어 5MB 다운로드 → 표시
```

Sentry/로그에서 `bible_text_not_found` 이벤트 모니터링 (있으면 번들에 해당 reference 누락).

---

## Phase 3 수동 작업 (나머지 25 locale)

Phase 1 검증 후 Phase 3 진입 시:

```bash
# 모든 locale 자동 처리
for locale_code in "es rv1909" "fr lsg1910" "de luther1912" "pt almeida1819" ...; do
  set -- $locale_code
  locale=$1
  code=$2
  curl -O "https://ebible.org/Scriptures/${locale}_${code}_usfm.zip"
  # ... (스크립트 반복)
done

# 27 bundle 일괄 Supabase 업로드
```

Phase 3 spec에 자세한 순서 + locale별 ebible.org ID 정리.

---

## 주의

- **service_role key**는 `.env` 루트 파일에만. git 커밋 금지.
- USFM 원본 파일(`bible_sources/`) gitignore 권장 — 용량 + 라이센스 파일 섞임
- 생성된 JSON bundle(`build/`)은 Supabase Storage만 — repo에 커밋 불필요
- `curl`로 ebible.org 받을 때 User-Agent 설정 필요할 수 있음: `curl -A "Mozilla/5.0" ...`
