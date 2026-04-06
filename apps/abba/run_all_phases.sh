#!/bin/zsh
# ═══════════════════════════════════════════════════════
# Abba App — 전체 Phase 순차 실행 (검증 포함)
# 사용법: chmod +x run_all_phases.sh && ./run_all_phases.sh
# 특정 Phase부터: ./run_all_phases.sh 3  (Phase 3부터 시작)
# ═══════════════════════════════════════════════════════

START_PHASE=${1:-1}
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$APP_DIR/../.." && pwd)"

echo "═══════════════════════════════════════════"
echo "  Abba App — Phase $START_PHASE~5 순차 실행"
echo "═══════════════════════════════════════════"

run_phase() {
  local PHASE=$1
  local PROMPT_FILE

  case $PHASE in
    1) PROMPT_FILE="$APP_DIR/PROMPT.md" ;;
    2) PROMPT_FILE="$APP_DIR/PROMPT_PHASE2.md" ;;
    3) PROMPT_FILE="$APP_DIR/PROMPT_PHASE3.md" ;;
    4) PROMPT_FILE="$APP_DIR/PROMPT_PHASE4.md" ;;
    5) PROMPT_FILE="$APP_DIR/PROMPT_PHASE5.md" ;;
  esac

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  🚀 Phase $PHASE 시작"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  cd "$ROOT_DIR"
  claude --prompt "$(cat <<EOF
@$PROMPT_FILE 를 읽고 Phase $PHASE를 실행해.

실행 규칙:
1. 각 체크리스트 항목마다 Sequential Thinking 5단계 분석
2. 분석 결과: 문제정의 / 핵심발견 / 실행계획 / 예상결과
3. 분석 → 구현 → 검증 (flutter analyze) 사이클
4. 한 항목 완료 후 다음 항목 진행
5. 모든 항목 완료 후 최종 검증:
   - flutter analyze (0 에러)
   - 완료된 체크리스트 요약 출력

필수 참고:
- apps/abba/specs/REQUIREMENTS.md
- apps/abba/specs/DESIGN.md

시작해.
EOF
)"

  local EXIT_CODE=$?

  if [ $EXIT_CODE -ne 0 ]; then
    echo "  ❌ Phase $PHASE 실패 (exit code: $EXIT_CODE)"
    echo "  → 수동으로 확인 후 다시 실행: ./run_all_phases.sh $PHASE"
    exit 1
  fi

  # Phase 간 검증
  echo ""
  echo "  📋 Phase $PHASE 후 검증 중..."
  cd "$ROOT_DIR"

  # flutter analyze 실행 (앱 디렉토리가 있으면)
  if [ -f "$APP_DIR/pubspec.yaml" ]; then
    cd "$APP_DIR"
    flutter analyze 2>&1 | tail -5
    local ANALYZE_EXIT=$?
    cd "$ROOT_DIR"

    if [ $ANALYZE_EXIT -ne 0 ]; then
      echo "  ⚠️ Phase $PHASE analyze 경고/에러 있음"
      echo "  계속 진행합니다... (Phase 5에서 최종 수정)"
    else
      echo "  ✅ Phase $PHASE analyze 통과"
    fi
  fi

  # git 커밋 (Phase 완료 단위)
  cd "$ROOT_DIR"
  git add -A
  git commit -m "feat(abba): complete Phase $PHASE

Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>" 2>/dev/null

  echo "  ✅ Phase $PHASE 완료 + 커밋"
}

# 순차 실행
for PHASE in $(seq $START_PHASE 5); do
  run_phase $PHASE
done

echo ""
echo "═══════════════════════════════════════════"
echo "  🎉 전체 Phase 완료!"
echo "═══════════════════════════════════════════"
