#!/bin/bash
# ═══════════════════════════════════════════════════════
# 하드코딩 문자열 감지
# View/Widget 파일에서 l10n 미사용 한국어/영어 텍스트 찾기
# 사용법: ./scripts/check_hardcoded_strings.sh apps/abba
# ═══════════════════════════════════════════════════════

APP_DIR="${1:-.}"
LIB_DIR="$APP_DIR/lib"

if [[ ! -d "$LIB_DIR" ]]; then
  echo "❌ lib 디렉토리 없음: $LIB_DIR"
  exit 1
fi

echo "🔍 하드코딩 문자열 검색: $LIB_DIR/features/ + $LIB_DIR/widgets/"
echo ""

ERRORS=0

# View/Widget 파일에서 Text('한글') 또는 Text('English words') 패턴 검색
# 이모지만 있는 건 제외, l10n 키 사용은 제외
grep -rn "Text(" "$LIB_DIR/features/" "$LIB_DIR/widgets/" 2>/dev/null | \
  grep -v "l10n\." | \
  grep -v "AppLocalizations" | \
  grep -v "_test.dart" | \
  grep -v "// " | \
  grep "'[가-힣a-zA-Z][가-힣a-zA-Z ]*'" | \
  grep -v "style:" | \
  grep -v "key:" | \
  while IFS= read -r line; do
    echo "⚠️  $line"
    ERRORS=$((ERRORS + 1))
  done

if [[ $ERRORS -eq 0 ]]; then
  echo "✅ 하드코딩 문자열 없음"
else
  echo ""
  echo "⚠️  위 항목들을 ARB 키로 교체하세요"
fi
