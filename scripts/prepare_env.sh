#!/bin/bash
# Merges .env.shared (shared client keys) + app .env.client (app-specific)
# → .env.runtime (loaded by Flutter at runtime)
#
# Usage: ./scripts/prepare_env.sh <app_name>
# Example: ./scripts/prepare_env.sh abba

APP=${1:?"Usage: ./scripts/prepare_env.sh <app_name>"}
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SHARED="$ROOT_DIR/.env.shared"
CLIENT="$ROOT_DIR/apps/$APP/.env.client"
OUTPUT="$ROOT_DIR/apps/$APP/.env.runtime"

if [ ! -f "$SHARED" ]; then
  echo "Error: $SHARED not found. Copy .env.shared.example → .env.shared and fill in values."
  exit 1
fi

if [ ! -f "$CLIENT" ]; then
  echo "Error: $CLIENT not found."
  exit 1
fi

# Merge: shared first, then app-specific (app values override shared)
cat "$SHARED" > "$OUTPUT"
echo "" >> "$OUTPUT"
cat "$CLIENT" >> "$OUTPUT"

echo "✓ Generated $OUTPUT"
