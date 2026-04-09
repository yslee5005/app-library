#!/bin/bash
# ═══════════════════════════════════════════════════════
# Lilsquare 스타일 페이지 — 순차 Phase 실행
# 사용법: ./run_lilsquare_phases.sh        (전체 실행)
#        ./run_lilsquare_phases.sh 3       (Phase 3부터)
# ═══════════════════════════════════════════════════════

START_PHASE=${1:-1}
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"
ROOT_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

FILES=("PHASE1_NAV_LAYOUT.md" "PHASE2_PROJECTS.md" "PHASE3_PROJECT_DETAIL.md" "PHASE4_ABOUT_PROCESS.md" "PHASE5_CONTACT_MAP.md")
DESCS=("Phase 1 — Navigation + Layout Shell" "Phase 2 — Projects 목록 + 카테고리 필터" "Phase 3 — Project 상세 (갤러리)" "Phase 4 — About + Process" "Phase 5 — Contact + Map")

echo "════════════════════════════════════════════════"
echo "  Lilsquare Style Pages — Sequential Build"
echo "  Starting from Phase $START_PHASE"
echo "════════════════════════════════════════════════"
echo ""

cd "$ROOT_DIR"

for idx in 0 1 2 3 4; do
  PHASE_NUM=$((idx + 1))
  FILE="${FILES[$idx]}"
  DESC="${DESCS[$idx]}"

  if (( PHASE_NUM < START_PHASE )); then
    echo "⏭️  Skipping $DESC"
    continue
  fi

  PROMPT_FILE="$PROMPTS_DIR/$FILE"

  if [[ ! -f "$PROMPT_FILE" ]]; then
    echo "❌ Prompt not found: $PROMPT_FILE"
    exit 1
  fi

  echo ""
  echo "🚀 Starting $DESC"
  echo "────────────────────────────────────────────────"

  echo "@apps/blacklabelled/web/prompts/$FILE 를 읽고 실행해.

실행 규칙:
1. 기존 파일 수정 전 반드시 Read로 확인
2. AGENTS.md 읽고 Next.js 버전 주의
3. 구현 완료 후 npx tsc --noEmit 검증
4. 기존 / 라우트 페이지에 영향 없게 주의

필수 참고:
- apps/blacklabelled/web/AGENTS.md
- apps/blacklabelled/web/src/lib/data.ts
- apps/blacklabelled/web/src/hooks/useScrollReveal.ts
- apps/blacklabelled/web/src/app/globals.css

시작해." | claude

  EXIT_CODE=$?

  if [[ $EXIT_CODE -ne 0 ]]; then
    echo "❌ $DESC failed with exit code $EXIT_CODE"
    echo "   Fix the issue and re-run: ./run_lilsquare_phases.sh $PHASE_NUM"
    exit $EXIT_CODE
  fi

  echo "✅ $DESC completed"
  echo ""

  # Git 커밋
  echo "📦 Committing $DESC..."
  cd "$ROOT_DIR"
  git add apps/blacklabelled/web/
  git commit -m "feat(blacklabelled/lilsquare): $DESC

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>" 2>/dev/null || echo "  (nothing to commit)"

  echo "════════════════════════════════════════════════"
done

echo ""
echo "🎉 All phases completed!"
echo ""
echo "Visit: http://localhost:3000/lilsquare"
echo "  /lilsquare           — Main"
echo "  /lilsquare/projects  — Projects"
echo "  /lilsquare/projects/[slug] — Detail"
echo "  /lilsquare/about     — About"
echo "  /lilsquare/process   — Process"
echo "  /lilsquare/contact   — Contact"
echo "  /lilsquare/map       — Map"
