#!/bin/bash
# ═══════════════════════════════════════════════════════
# 레이어 위반 감지
# ARCHITECTURE.md 규칙: View → Service 직접 import 금지
# 사용법: ./scripts/check_layer_violations.sh apps/abba
# ═══════════════════════════════════════════════════════

APP_DIR="${1:-.}"
LIB_DIR="$APP_DIR/lib"

if [[ ! -d "$LIB_DIR" ]]; then
  echo "❌ lib 디렉토리 없음: $LIB_DIR"
  exit 1
fi

echo "🔍 레이어 위반 검사: $LIB_DIR"
echo ""

ERRORS=0

# Rule 1: features/view/ → services/ 직접 import 금지 (providers 통해서만)
echo "Rule 1: View → Service 직접 import 금지"
VIOLATIONS=$(grep -rn "import.*services/" "$LIB_DIR/features/" 2>/dev/null | \
  grep -v "error_logging_service" | \
  grep -v "stt_service.dart" | \
  grep -v "tts_service.dart" | \
  grep -v "auth_service.dart" | \
  grep -v "network_checker")

if [[ -n "$VIOLATIONS" ]]; then
  echo "$VIOLATIONS" | while IFS= read -r line; do
    echo "  ⚠️  $line"
  done
else
  echo "  ✅ 위반 없음"
fi

# Rule 2: models/ → services/, features/, providers/ import 금지
echo ""
echo "Rule 2: Model → Service/Feature/Provider import 금지"
VIOLATIONS=$(grep -rn "import.*\(services\|features\|providers\)/" "$LIB_DIR/models/" 2>/dev/null)

if [[ -n "$VIOLATIONS" ]]; then
  echo "$VIOLATIONS" | while IFS= read -r line; do
    echo "  ❌ $line"
    ERRORS=$((ERRORS + 1))
  done
else
  echo "  ✅ 위반 없음"
fi

# Rule 3: widgets/ → services/, providers/, features/ import 금지
echo ""
echo "Rule 3: Widget → Service/Provider/Feature import 금지"
VIOLATIONS=$(grep -rn "import.*\(services\|providers\|features\)/" "$LIB_DIR/widgets/" 2>/dev/null | \
  grep -v "premium_blur\|premium_modal\|milestone_modal\|milestone_share\|streak_garden\|abba_snackbar")

if [[ -n "$VIOLATIONS" ]]; then
  echo "$VIOLATIONS" | while IFS= read -r line; do
    echo "  ⚠️  $line"
  done
else
  echo "  ✅ 위반 없음"
fi

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "❌ $ERRORS 심각한 레이어 위반"
  exit 1
else
  echo "✅ 레이어 검사 통과"
fi
