#!/bin/bash
# Supabase 테이블 쿼리 스크립트 (개발용)
#
# 사용법:
#   ./scripts/query.sh select "abba.user_settings"
#   ./scripts/query.sh select "abba.prayers" "user_id=eq.xxx"
#   ./scripts/query.sh sql "SELECT 1"
#
# sql 모드는 Supabase에 pg_net 또는 exec_sql RPC가 필요합니다.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# .env에서 키 로드
if [ -f "$ROOT_DIR/.env" ]; then
  set -a
  source "$ROOT_DIR/.env"
  set +a
fi

SUPABASE_URL="${SUPABASE_URL:?'SUPABASE_URL not set in .env'}"
KEY="${SUPABASE_SERVICE_ROLE_KEY:?'SUPABASE_SERVICE_ROLE_KEY not set in .env'}"

MODE="${1:?'Usage: ./scripts/query.sh select|sql ...'}"

case "$MODE" in
  select)
    # PostgREST SELECT: ./scripts/query.sh select "schema.table" ["filter"]
    TABLE="${2:?'Table required: e.g. abba.prayers'}"
    SCHEMA="${TABLE%%.*}"
    TABLE_NAME="${TABLE##*.}"
    FILTER="${3:-}"

    URL="${SUPABASE_URL}/rest/v1/${TABLE_NAME}?${FILTER}&limit=100"

    curl -s -X GET "$URL" \
      -H "apikey: ${KEY}" \
      -H "Authorization: Bearer ${KEY}" \
      -H "Accept-Profile: ${SCHEMA}" \
      -H "Content-Type: application/json" \
      | python3 -m json.tool 2>/dev/null
    ;;

  count)
    # Row count: ./scripts/query.sh count "schema.table"
    TABLE="${2:?'Table required'}"
    SCHEMA="${TABLE%%.*}"
    TABLE_NAME="${TABLE##*.}"

    curl -s -X GET "${SUPABASE_URL}/rest/v1/${TABLE_NAME}?select=count" \
      -H "apikey: ${KEY}" \
      -H "Authorization: Bearer ${KEY}" \
      -H "Accept-Profile: ${SCHEMA}" \
      -H "Prefer: count=exact" \
      -H "Range: 0-0" \
      -D - -o /dev/null 2>/dev/null \
      | grep -i content-range | sed 's/.*\///'
    ;;

  *)
    echo "Unknown mode: $MODE"
    echo "Usage: ./scripts/query.sh select|count \"schema.table\" [\"filter\"]"
    exit 1
    ;;
esac
