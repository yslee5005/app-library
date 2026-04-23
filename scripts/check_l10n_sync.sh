#!/bin/bash
# ═══════════════════════════════════════════════════════
# l10n 키 동기화 검증 (Python 래퍼)
#
# 실제 로직은 scripts/check_l10n_sync.py 에 있음.
# bash 버전의 naive regex 가 ARB 값을 "키" 로 오탐하는
# 버그가 있어서 Python JSON 기반으로 재작성됨
# (CLAUDE.md learned-pitfalls §4 참고).
#
# 이전 bash 구현은 check_l10n_sync.sh.bak 에 보관.
#
# 사용법: ./scripts/check_l10n_sync.sh apps/abba
# ═══════════════════════════════════════════════════════

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec python3 "$SCRIPT_DIR/check_l10n_sync.py" "$@"
