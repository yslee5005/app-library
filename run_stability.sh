#!/bin/zsh
# App Library — Stability Run: Phase 8A → 8B → 8C → 9
# Usage: ./run_stability.sh [start_phase]
# Example: ./run_stability.sh         # runs 8A,8B,8C,9
#          ./run_stability.sh 8C      # runs 8C,9 only

set -e

export PATH="$HOME/.local/bin:$HOME/.pub-cache/bin:$PATH"

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

START_PHASE=${1:-8A}
PHASES=(8A 8B 8C 9)

get_phase_branch() {
  case $1 in
    8A) echo "provider-layer" ;;
    8B) echo "tests-lint" ;;
    8C) echo "ui-customize" ;;
    9)  echo "showcase-integration" ;;
  esac
}

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log() { echo "${BLUE}[$(date '+%H:%M:%S')] $1${NC}"; }
success() { echo "${GREEN}[$(date '+%H:%M:%S')] ✅ $1${NC}"; }

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║    App Library — Stability Run                    ║"
echo "║    Phases: $START_PHASE → 9                              ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

STARTED=false
for phase in "${PHASES[@]}"; do
  if [ "$STARTED" = false ] && [ "$phase" != "$START_PHASE" ]; then
    continue
  fi
  STARTED=true

  branch_name=$(get_phase_branch $phase)
  branch="ralph/phase-${phase}-${branch_name}"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  log "Phase $phase: $branch_name"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # Ensure on main
  git checkout main 2>/dev/null || true

  # Copy PROMPT
  log "Loading PROMPT for Phase $phase..."
  cp "prompts/PROMPT_PHASE${phase}.md" .ralph/PROMPT.md

  # Reset Ralph
  echo "0" > .ralph/.exit_signals 2>/dev/null || true
  echo "CLOSED" > .ralph/.circuit_breaker_state 2>/dev/null || true

  # Create branch
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
    log "Phase $phase: no commits. Continuing..."
    git checkout main 2>/dev/null || true
  fi

  sleep 2
done

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║    🎉 Stability Run Complete!                     ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""
log "Git log:"
git log --oneline | head -15
echo ""
log "Run showcase to verify:"
echo "  cd apps/showcase && flutter run -d <device_id>"
