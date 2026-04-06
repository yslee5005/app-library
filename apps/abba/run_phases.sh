#!/bin/zsh
# ═══════════════════════════════════════════════════════
# Abba App — Phase별 순차 실행 스크립트
# 사용법: chmod +x run_phases.sh && ./run_phases.sh
# 또는 특정 Phase만: ./run_phases.sh 2
# ═══════════════════════════════════════════════════════

PHASE=${1:-1}
APP_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$APP_DIR/../.." && pwd)"

echo "═══════════════════════════════════════════"
echo "  Abba App — Phase $PHASE 실행"
echo "  App Dir: $APP_DIR"
echo "═══════════════════════════════════════════"

case $PHASE in
  1)
    PROMPT_FILE="$APP_DIR/PROMPT.md"
    NEXT_MSG="Phase 1 완료 후 → ./run_phases.sh 2"
    ;;
  2)
    PROMPT_FILE="$APP_DIR/PROMPT_PHASE2.md"
    NEXT_MSG="Phase 2 완료 후 → ./run_phases.sh 3"
    ;;
  3)
    PROMPT_FILE="$APP_DIR/PROMPT_PHASE3.md"
    NEXT_MSG="Phase 3 완료 후 → ./run_phases.sh 4"
    ;;
  4)
    PROMPT_FILE="$APP_DIR/PROMPT_PHASE4.md"
    NEXT_MSG="Phase 4 완료 후 → ./run_phases.sh 5"
    ;;
  5)
    PROMPT_FILE="$APP_DIR/PROMPT_PHASE5.md"
    NEXT_MSG="Phase 5 완료 — 배포 준비 완료! 🎉"
    ;;
  *)
    echo "❌ 유효하지 않은 Phase: $PHASE (1-5)"
    exit 1
    ;;
esac

if [ ! -f "$PROMPT_FILE" ]; then
  echo "❌ PROMPT 파일을 찾을 수 없습니다: $PROMPT_FILE"
  exit 1
fi

echo ""
echo "📄 PROMPT: $PROMPT_FILE"
echo "🚀 Claude Code 새 세션에서 실행합니다..."
echo ""

# Claude Code 새 세션 실행
cd "$ROOT_DIR"
claude --prompt "$(cat <<EOF
@$PROMPT_FILE 를 읽고 Phase $PHASE를 실행해.

실행 규칙:
1. 각 체크리스트 항목마다 Sequential Thinking 5단계 분석
2. 분석 결과: 문제정의 / 핵심발견 / 실행계획 / 예상결과
3. 분석 → 구현 → 검증 (flutter analyze) 사이클
4. 한 항목 완료 후 다음 항목 진행

필수 참고:
- apps/abba/specs/REQUIREMENTS.md
- apps/abba/specs/DESIGN.md

시작해.
EOF
)"

echo ""
echo "═══════════════════════════════════════════"
echo "  ✅ Phase $PHASE 세션 종료"
echo "  $NEXT_MSG"
echo "═══════════════════════════════════════════"
