#!/bin/bash
# ═══════════════════════════════════════════════════════
# RLS 정책 검증
# migration SQL에서 CREATE TABLE 후 ENABLE ROW LEVEL SECURITY 누락 감지
# 사용법: ./scripts/check_rls.sh
# ═══════════════════════════════════════════════════════

echo "🔍 RLS 정책 검증..."
echo ""

ERRORS=0

for sql in $(find . -path "*/migrations/*.sql" -o -path "*/supabase/*.sql" 2>/dev/null); do
  # CREATE TABLE 찾기
  TABLES=$(grep -i "CREATE TABLE" "$sql" | grep -iv "IF NOT EXISTS" | sed 's/.*CREATE TABLE[[:space:]]*//i' | sed 's/[[:space:]]*(.*//' | tr -d '"')
  TABLES="$TABLES $(grep -i "CREATE TABLE IF NOT EXISTS" "$sql" | sed 's/.*CREATE TABLE IF NOT EXISTS[[:space:]]*//i' | sed 's/[[:space:]]*(.*//' | tr -d '"')"

  for table in $TABLES; do
    [[ -z "$table" ]] && continue

    # ENABLE ROW LEVEL SECURITY 확인
    if ! grep -qi "ALTER TABLE.*$table.*ENABLE ROW LEVEL SECURITY" "$sql"; then
      echo "❌ $sql: 테이블 '$table'에 RLS 없음"
      ERRORS=$((ERRORS + 1))
    fi

    # app_id 컬럼 확인
    if ! grep -qi "app_id" "$sql"; then
      echo "⚠️  $sql: app_id 컬럼 없을 수 있음"
    fi

    # COALESCE NULL 방어 확인
    if grep -qi "POLICY.*$table" "$sql" && ! grep -qi "COALESCE" "$sql"; then
      echo "⚠️  $sql: COALESCE NULL 방어 없을 수 있음"
    fi
  done
done

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo "❌ $ERRORS 테이블에 RLS 누락"
  exit 1
else
  echo "✅ 모든 테이블 RLS 확인 완료"
fi
