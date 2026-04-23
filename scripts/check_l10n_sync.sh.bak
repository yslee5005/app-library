#!/bin/bash
# ═══════════════════════════════════════════════════════
# l10n 키 동기화 검증
# 모든 ARB 파일의 키가 동일한지 체크
# 사용법: ./scripts/check_l10n_sync.sh apps/abba
# ═══════════════════════════════════════════════════════

APP_DIR="${1:-.}"
L10N_DIR="$APP_DIR/lib/l10n"

if [[ ! -d "$L10N_DIR" ]]; then
  echo "❌ l10n 디렉토리 없음: $L10N_DIR"
  exit 1
fi

# 기준: app_en.arb
BASE="$L10N_DIR/app_en.arb"
if [[ ! -f "$BASE" ]]; then
  echo "❌ 기준 파일 없음: $BASE"
  exit 1
fi

BASE_KEYS=$(grep -o '"[a-zA-Z_]*"' "$BASE" | grep -v '@@' | grep -v '^"@' | sort -u)
BASE_COUNT=$(echo "$BASE_KEYS" | wc -l | tr -d ' ')

echo "📋 기준: app_en.arb ($BASE_COUNT 키)"
echo ""

ERRORS=0

for arb in "$L10N_DIR"/app_*.arb; do
  [[ "$arb" == "$BASE" ]] && continue
  LANG=$(basename "$arb" .arb | sed 's/app_//')

  ARB_KEYS=$(grep -o '"[a-zA-Z_]*"' "$arb" | grep -v '@@' | grep -v '^"@' | sort -u)
  ARB_COUNT=$(echo "$ARB_KEYS" | wc -l | tr -d ' ')

  MISSING=$(comm -23 <(echo "$BASE_KEYS") <(echo "$ARB_KEYS"))
  EXTRA=$(comm -13 <(echo "$BASE_KEYS") <(echo "$ARB_KEYS"))

  if [[ -z "$MISSING" && -z "$EXTRA" ]]; then
    echo "✅ $LANG ($ARB_COUNT 키) — 동기화됨"
  else
    if [[ -n "$MISSING" ]]; then
      echo "❌ $LANG — 누락된 키:"
      echo "$MISSING" | sed 's/^/   /'
      ERRORS=$((ERRORS + 1))
    fi
    if [[ -n "$EXTRA" ]]; then
      echo "⚠️  $LANG — 추가된 키 (en에 없음):"
      echo "$EXTRA" | sed 's/^/   /'
    fi
  fi
done

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "❌ $ERRORS 언어에 누락 키 있음"
  exit 1
else
  echo "✅ 모든 언어 동기화 완료"
fi
