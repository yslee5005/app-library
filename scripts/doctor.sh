#!/bin/bash
# Environment doctor — verifies the local dev setup for this workspace.
#
# Exits with a non-zero status when any required piece is missing so CI or
# other scripts can gate on it. Prints actionable fix commands for each
# failure.
#
# Usage: ./scripts/doctor.sh [app_name]
# Example: ./scripts/doctor.sh           # scan every app
#          ./scripts/doctor.sh abba      # scan just one app

set -u

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[34m"
BOLD="\033[1m"
RESET="\033[0m"

FAIL_COUNT=0
WARN_COUNT=0

pass() { echo -e "  ${GREEN}✓${RESET} $1"; }
fail() {
  echo -e "  ${RED}✗${RESET} $1"
  if [ -n "${2:-}" ]; then
    echo -e "      ${BLUE}Fix:${RESET} $2"
  fi
  FAIL_COUNT=$((FAIL_COUNT + 1))
}
warn() {
  echo -e "  ${YELLOW}!${RESET} $1"
  WARN_COUNT=$((WARN_COUNT + 1))
}
section() { echo -e "\n${BOLD}$1${RESET}"; }

# ---------------------------------------------------------------------------
# Root env
# ---------------------------------------------------------------------------
section "Root .env"

if [ ! -f ".env" ]; then
  fail ".env missing" "cp .env.example .env && edit the values"
else
  pass ".env present"
  REQUIRED_ROOT=(SUPABASE_URL SUPABASE_ANON_KEY SUPABASE_SERVICE_ROLE_KEY GEMINI_API_KEY)
  for key in "${REQUIRED_ROOT[@]}"; do
    value=$(grep -E "^${key}=" .env | head -1 | cut -d= -f2-)
    if [ -z "$value" ]; then
      fail "$key is empty in .env" "fill it in (see .env.example for where to get it)"
    fi
  done
fi

# ---------------------------------------------------------------------------
# Flutter tooling
# ---------------------------------------------------------------------------
section "Flutter tooling"

if command -v flutter >/dev/null 2>&1; then
  pass "flutter: $(flutter --version 2>/dev/null | head -1)"
else
  fail "flutter not on PATH" "install Flutter SDK: https://docs.flutter.dev/get-started/install"
fi

if [ -f "pubspec.lock" ]; then
  pass "workspace pub get has been run"
else
  warn "pubspec.lock missing — run: flutter pub get"
fi

# ---------------------------------------------------------------------------
# Per-app checks
# ---------------------------------------------------------------------------
TARGET_APP="${1:-}"

if [ -n "$TARGET_APP" ]; then
  APPS=("apps/$TARGET_APP")
  if [ ! -d "${APPS[0]}" ]; then
    echo -e "${RED}Unknown app: $TARGET_APP${RESET}"
    exit 1
  fi
else
  APPS=()
  for dir in apps/*/; do
    [ -d "$dir" ] && APPS+=("${dir%/}")
  done
fi

for app_path in "${APPS[@]}"; do
  app_name=$(basename "$app_path")
  section "apps/$app_name"

  if [ ! -f "$app_path/pubspec.yaml" ]; then
    warn "no pubspec.yaml — skipping"
    continue
  fi

  # Non-Flutter apps (e.g. Next.js under apps/blacklabelled/web) have no
  # .env.client / runtime — skip gracefully if there's no main.dart.
  if [ ! -f "$app_path/lib/main.dart" ]; then
    warn "no lib/main.dart — skipping env checks (non-Flutter app?)"
    continue
  fi

  if [ -f "$app_path/.env.client" ]; then
    pass ".env.client present"
  else
    fail ".env.client missing" "cp $app_path/.env.example $app_path/.env.client && edit"
    continue
  fi

  if [ -f "$app_path/.env.runtime" ]; then
    pass ".env.runtime generated"
  else
    fail ".env.runtime missing" "./scripts/prepare_env.sh $app_name"
  fi

  # iOS (macOS dev machines only)
  if [ "$(uname)" = "Darwin" ] && [ -d "$app_path/ios" ]; then
    podfile="$app_path/ios/Podfile"
    if [ -f "$podfile" ]; then
      if grep -qE "^platform :ios," "$podfile"; then
        pass "ios/Podfile platform pinned"
      else
        warn "ios/Podfile has no active 'platform :ios, ...' line — RevenueCat UI / Firebase need iOS 15+"
      fi
      if [ -d "$app_path/ios/Pods" ]; then
        pass "ios/Pods installed"
      else
        fail "ios/Pods missing" "cd $app_path/ios && pod install --repo-update"
      fi
    fi
  fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo
if [ "$FAIL_COUNT" -eq 0 ] && [ "$WARN_COUNT" -eq 0 ]; then
  echo -e "${GREEN}${BOLD}All checks passed.${RESET}"
  exit 0
fi

echo -e "${BOLD}Summary:${RESET} ${RED}$FAIL_COUNT failed${RESET}, ${YELLOW}$WARN_COUNT warnings${RESET}"
if [ "$FAIL_COUNT" -gt 0 ]; then
  exit 1
fi
exit 0
