#!/bin/bash
# ═══════════════════════════════════════════════════════
# 하네스 검증 — 전체 실행
# 모든 검증 스크립트를 한 번에 실행
# 사용법: ./scripts/harness_check.sh apps/abba
# ═══════════════════════════════════════════════════════

APP_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "═══════════════════════════════════════════════"
echo "  🔧 Harness Check — $APP_DIR"
echo "═══════════════════════════════════════════════"
echo ""

TOTAL_ERRORS=0

# 1. Flutter analyze
if [[ -f "$APP_DIR/pubspec.yaml" ]]; then
  echo "▶ flutter analyze"
  cd "$APP_DIR"
  RESULT=$(flutter analyze 2>&1)
  if echo "$RESULT" | grep -q "No issues found"; then
    echo "  ✅ No issues"
  else
    echo "  ❌ Issues found"
    echo "$RESULT" | grep -E "error|warning" | head -5
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  fi
  cd - > /dev/null
  echo ""
fi

# 2. l10n 동기화
if [[ -d "$APP_DIR/lib/l10n" ]]; then
  echo "▶ l10n 동기화"
  bash "$SCRIPT_DIR/check_l10n_sync.sh" "$APP_DIR"
  [[ $? -ne 0 ]] && TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  echo ""
fi

# 3. 하드코딩 문자열
if [[ -d "$APP_DIR/lib/features" ]]; then
  echo "▶ 하드코딩 문자열"
  bash "$SCRIPT_DIR/check_hardcoded_strings.sh" "$APP_DIR"
  echo ""
fi

# 4. 레이어 위반
if [[ -d "$APP_DIR/lib" ]]; then
  echo "▶ 레이어 위반"
  bash "$SCRIPT_DIR/check_layer_violations.sh" "$APP_DIR"
  [[ $? -ne 0 ]] && TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  echo ""
fi

# 5. RLS 검증
echo "▶ RLS 정책"
bash "$SCRIPT_DIR/check_rls.sh"
[[ $? -ne 0 ]] && TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
echo ""

# 6. Flutter test
if [[ -d "$APP_DIR/test" ]]; then
  echo "▶ flutter test"
  cd "$APP_DIR"
  RESULT=$(flutter test 2>&1 | tail -1)
  if echo "$RESULT" | grep -q "All tests passed"; then
    echo "  ✅ $RESULT"
  else
    echo "  ❌ $RESULT"
    TOTAL_ERRORS=$((TOTAL_ERRORS + 1))
  fi
  cd - > /dev/null
  echo ""
fi

echo "═══════════════════════════════════════════════"
if [[ $TOTAL_ERRORS -gt 0 ]]; then
  echo "  ❌ $TOTAL_ERRORS 검증 실패"
  exit 1
else
  echo "  ✅ 모든 검증 통과"
fi
echo "═══════════════════════════════════════════════"
