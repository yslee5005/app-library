#!/bin/zsh
# App Library — Run Phase 3-7 sequentially with Ralph Loop
# Usage: ./run_all_phases.sh [start_phase]
# Example: ./run_all_phases.sh       # runs 3,4,5,6,7
#          ./run_all_phases.sh 5     # runs 5,6,7 only

set -e

export PATH="$HOME/.local/bin:$HOME/.pub-cache/bin:$PATH"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

START_PHASE=${1:-3}

get_phase_name() {
  case $1 in
    3) echo "auth-comments" ;;
    4) echo "theme-notif-l10n" ;;
    5) echo "ui-kit-a-d" ;;
    6) echo "ui-kit-e-i" ;;
    7) echo "showcase-app" ;;
  esac
}

get_phase_packages() {
  case $1 in
    4) echo "packages/theme packages/notifications packages/l10n" ;;
    5) echo "packages/ui_kit" ;;
    7) echo "apps/showcase" ;;
    *) echo "" ;;
  esac
}

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo "${BLUE}[$(date '+%H:%M:%S')] $1${NC}"; }
success() { echo "${GREEN}[$(date '+%H:%M:%S')] ✅ $1${NC}"; }
warn() { echo "${YELLOW}[$(date '+%H:%M:%S')] ⚠️  $1${NC}"; }

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║    App Library — Automated Phase Runner           ║"
echo "║    Phases: $START_PHASE → 7                               ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

for phase in 3 4 5 6 7; do
  if [ "$phase" -lt "$START_PHASE" ]; then
    continue
  fi

  name=$(get_phase_name $phase)
  branch="ralph/phase-${phase}-${name}"
  packages=$(get_phase_packages $phase)

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "Phase $phase: $name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Ensure we're on main
  git checkout main 2>/dev/null || true

  # Add workspace packages if needed
  if [ -n "$packages" ]; then
    log "Adding workspace packages for Phase $phase..."
    for pkg in ${=packages}; do
      pkg_name=$(basename "$pkg")
      if ! grep -q "$pkg" pubspec.yaml; then
        # Append to workspace section
        sed -i '' "/^workspace:/a\\
\\  - $pkg" pubspec.yaml 2>/dev/null || true
      fi
      # Create minimal structure if not exists
      if [ ! -f "$pkg/pubspec.yaml" ]; then
        mkdir -p "$pkg/lib" "$pkg/test"
        if [ "$pkg_name" = "showcase" ]; then
          # Showcase is a Flutter app, not a package
          cat > "$pkg/pubspec.yaml" << 'YAML'
name: showcase
description: App Library component showcase app.
version: 1.0.0
publish_to: none
environment:
  sdk: ^3.7.0
  flutter: ">=3.29.0"
resolution: workspace
dependencies:
  flutter:
    sdk: flutter
  app_lib_core:
    path: ../../packages/core
  app_lib_theme:
    path: ../../packages/theme
  app_lib_ui_kit:
    path: ../../packages/ui_kit
dev_dependencies:
  flutter_test:
    sdk: flutter
YAML
        else
          cat > "$pkg/pubspec.yaml" << YAML
name: app_lib_${pkg_name}
description: App Library ${pkg_name} package.
version: 1.0.0
publish_to: none
environment:
  sdk: ^3.7.0
  flutter: ">=3.29.0"
resolution: workspace
dependencies:
  flutter:
    sdk: flutter
  app_lib_core:
    path: ../core
dev_dependencies:
  flutter_test:
    sdk: flutter
YAML
        fi
        echo "library;" > "$pkg/lib/${pkg_name}.dart"
      fi
    done
    git add -A && git commit -m "chore: prepare Phase $phase workspace" 2>/dev/null || true
  fi

  # Copy phase-specific PROMPT
  log "Loading PROMPT for Phase $phase..."
  cp "prompts/PROMPT_PHASE${phase}.md" .ralph/PROMPT.md

  # Reset Ralph exit signals
  echo "0" > .ralph/.exit_signals 2>/dev/null || true
  echo "CLOSED" > .ralph/.circuit_breaker_state 2>/dev/null || true

  # Create feature branch
  git checkout -b "$branch" 2>/dev/null || git checkout "$branch" 2>/dev/null || true

  # Run Ralph
  log "Starting Ralph for Phase $phase..."
  ralph --live --timeout 20 || true

  # Check results
  commit_count=$(git log main.."$branch" --oneline 2>/dev/null | wc -l | tr -d ' ')

  if [ "$commit_count" -gt "0" ]; then
    success "Phase $phase complete! ($commit_count commits)"
    log "Merging Phase $phase to main..."
    git checkout main
    git merge "$branch" --no-edit
    success "Phase $phase merged to main"
  else
    warn "Phase $phase: no commits. Check .ralph/logs/"
    git checkout main 2>/dev/null || true
  fi

  sleep 2
done

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║    🎉 All Phases Complete!                        ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
log "Final git log:"
git log --oneline | head -20
echo ""
log "Packages:"
ls -1 packages/
echo ""
ls -1 apps/ 2>/dev/null || true
