#!/bin/zsh
# ═══════════════════════════════════════════════════════
# Abba App — 단일 Phase 실행
# 사용법: ./run_phases.sh 1   (Phase 1만 실행)
# ═══════════════════════════════════════════════════════

PHASE=${1:-1}
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$APP_DIR/../.." && pwd)"

case $PHASE in
  1) PROMPT_FILE="$APP_DIR/PROMPT.md" ;;
  2) PROMPT_FILE="$APP_DIR/PROMPT_PHASE2.md" ;;
  3) PROMPT_FILE="$APP_DIR/PROMPT_PHASE3.md" ;;
  4) PROMPT_FILE="$APP_DIR/PROMPT_PHASE4.md" ;;
  5) PROMPT_FILE="$APP_DIR/PROMPT_PHASE5.md" ;;
  *) echo "❌ 유효하지 않은 Phase: $PHASE (1-5)"; exit 1 ;;
esac

echo "🚀 Abba Phase $PHASE 실행"
cd "$ROOT_DIR"

echo "@$PROMPT_FILE 를 읽고 Phase $PHASE를 실행해.

실행 규칙:
1. 각 체크리스트 항목마다 Sequential Thinking 5단계 분석
2. 분석 결과: 문제정의 / 핵심발견 / 실행계획 / 예상결과
3. 분석 → 구현 → 검증 (flutter analyze) 사이클
4. 한 항목 완료 후 다음 항목 진행

필수 참고:
- apps/abba/specs/REQUIREMENTS.md
- apps/abba/specs/DESIGN.md

시작해." | claude
