#!/bin/bash
# Merge the root .env (minus server-only keys) with apps/<app>/.env.client
# and write the result to apps/<app>/.env.runtime — the file Flutter loads
# at launch via flutter_dotenv.
#
# Usage: ./scripts/prepare_env.sh <app_name>
# Example: ./scripts/prepare_env.sh abba

APP=${1:?"Usage: ./scripts/prepare_env.sh <app_name>"}
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MASTER="$ROOT_DIR/.env"
CLIENT="$ROOT_DIR/apps/$APP/.env.client"
OUTPUT="$ROOT_DIR/apps/$APP/.env.runtime"

# Server-only keys — MUST NOT be bundled into the client app.
# Add any secret here that should stay on the server (CLI, Edge Functions).
EXCLUDED_KEYS=(
  "SUPABASE_SERVICE_ROLE_KEY"
)

if [ ! -f "$MASTER" ]; then
  echo "Error: $MASTER not found. Copy .env.example → .env and fill in values."
  exit 1
fi

if [ ! -f "$CLIENT" ]; then
  echo "Error: $CLIENT not found."
  exit 1
fi

# Regex: ^(KEY1|KEY2)=
EXCLUDE_REGEX=$(IFS='|'; echo "^(${EXCLUDED_KEYS[*]})=")

# Master (server-only keys stripped) then app-specific overrides.
grep -Ev "$EXCLUDE_REGEX" "$MASTER" > "$OUTPUT"
echo "" >> "$OUTPUT"
cat "$CLIENT" >> "$OUTPUT"

echo "✓ Generated $OUTPUT"
echo "  Excluded from runtime: ${EXCLUDED_KEYS[*]}"
