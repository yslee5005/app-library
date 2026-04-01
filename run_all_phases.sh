#!/bin/bash
# App Library — Run Phase 3-7 sequentially with Ralph Loop
# Usage: ./run_all_phases.sh [start_phase]
# Example: ./run_all_phases.sh       # runs 3,4,5,6,7
#          ./run_all_phases.sh 5     # runs 5,6,7 only

set -e

export PATH="$HOME/.local/bin:$PATH"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

START_PHASE=${1:-3}
PHASES=(3 4 5 6 7)
PHASE_NAMES=(
  [3]="auth-comments"
  [4]="theme-notif-l10n"
  [5]="ui-kit-a-d"
  [6]="ui-kit-e-i"
  [7]="showcase-app"
)

# Workspace packages to add per phase
declare -A PHASE_PACKAGES
PHASE_PACKAGES[4]="packages/theme packages/notifications packages/l10n"
PHASE_PACKAGES[5]="packages/ui_kit"
PHASE_PACKAGES[7]="apps/showcase"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo -e "${BLUE}[$(date '+%H:%M:%S')] $1${NC}"; }
success() { echo -e "${GREEN}[$(date '+%H:%M:%S')] ✅ $1${NC}"; }
warn() { echo -e "${YELLOW}[$(date '+%H:%M:%S')] ⚠️  $1${NC}"; }
error() { echo -e "${RED}[$(date '+%H:%M:%S')] ❌ $1${NC}"; }

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║    App Library — Automated Phase Runner           ║"
echo "║    Phases: $START_PHASE → 7                               ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

for phase in "${PHASES[@]}"; do
  # Skip phases before start
  if [ "$phase" -lt "$START_PHASE" ]; then
    continue
  fi

  name="${PHASE_NAMES[$phase]}"
  branch="ralph/phase-${phase}-${name}"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "Phase $phase: $name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Ensure we're on main
  git checkout main 2>/dev/null || true

  # Add workspace packages if needed for this phase
  if [ -n "${PHASE_PACKAGES[$phase]}" ]; then
    log "Adding workspace packages for Phase $phase..."
    for pkg in ${PHASE_PACKAGES[$phase]}; do
      pkg_name=$(basename "$pkg")
      if ! grep -q "$pkg" pubspec.yaml; then
        # Add before the last line of workspace section
        sed -i '' "/^workspace:/,/^[^ ]/{
          /^  - /!b
          :a
          n
          /^  - /ba
          i\\
  - $pkg
        }" pubspec.yaml 2>/dev/null || true
      fi
      # Create minimal structure if not exists
      if [ ! -f "$pkg/pubspec.yaml" ]; then
        mkdir -p "$pkg/lib" "$pkg/test"
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
  app_lib_theme:
    path: ../theme
dev_dependencies:
  flutter_test:
    sdk: flutter
YAML
        echo "library;" > "$pkg/lib/${pkg_name}.dart"
      fi
    done
    git add -A && git commit -m "chore: prepare Phase $phase workspace" 2>/dev/null || true
  fi

  # Copy phase-specific PROMPT.md
  log "Loading PROMPT for Phase $phase..."
  cp "prompts/PROMPT_PHASE${phase}.md" .ralph/PROMPT.md

  # Reset Ralph exit signals for fresh start
  echo "0" > .ralph/.exit_signals 2>/dev/null || true
  echo "CLOSED" > .ralph/.circuit_breaker_state 2>/dev/null || true

  # Create feature branch
  git checkout -b "$branch" 2>/dev/null || git checkout "$branch" 2>/dev/null || true

  # Run Ralph (--live instead of --monitor to avoid tmux nesting issues)
  log "Starting Ralph for Phase $phase..."
  ralph --live --timeout 20 || true

  # Check results
  commit_count=$(git log main.."$branch" --oneline 2>/dev/null | wc -l | tr -d ' ')

  if [ "$commit_count" -gt "0" ]; then
    success "Phase $phase complete! ($commit_count commits)"

    # Merge to main
    log "Merging Phase $phase to main..."
    git checkout main
    git merge "$branch" --no-edit
    success "Phase $phase merged to main"
  else
    warn "Phase $phase: no commits produced. Check .ralph/logs/"
    # Continue anyway — next phase might work
    git checkout main 2>/dev/null || true
  fi

  # Brief pause between phases
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
log "Package summary:"
ls -1 packages/
echo ""
ls -1 apps/ 2>/dev/null && echo "" || true
