#!/usr/bin/env python3
# ═══════════════════════════════════════════════════════
# l10n 키 동기화 검증 (Python / JSON 기반)
# 모든 ARB 파일의 키가 app_en.arb 와 일치하는지 체크
# 사용법: python3 scripts/check_l10n_sync.py apps/abba
#
# 기존 bash 버전은 naive regex 로 ARB 값(value)까지 "키" 로
# 오탐했음 (learned-pitfalls §4). 이 스크립트는 json.load 로
# 정확하게 top-level 키를 추출하고 '@' 로 시작하는 메타키는
# 제외하여 비교한다.
# ═══════════════════════════════════════════════════════

from __future__ import annotations

import json
import sys
from pathlib import Path


def extract_keys(arb_path: Path) -> set[str] | None:
    """ARB 파일에서 사용자 정의 키 집합 추출. `@` prefix 메타키는 제외.

    JSON 파싱 실패 시 None 반환 (caller 가 skip 처리).
    """
    try:
        with arb_path.open("r", encoding="utf-8") as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"⚠️  {arb_path.name}: JSON 파싱 오류 (line {e.lineno}, col {e.colno}) — skip")
        return None
    except OSError as e:
        print(f"⚠️  {arb_path.name}: 읽기 실패 ({e}) — skip")
        return None

    if not isinstance(data, dict):
        print(f"⚠️  {arb_path.name}: top-level 이 object 가 아님 — skip")
        return None

    return {k for k in data.keys() if not k.startswith("@")}


def main(argv: list[str]) -> int:
    app_dir = Path(argv[1]) if len(argv) > 1 else Path(".")
    l10n_dir = app_dir / "lib" / "l10n"

    if not l10n_dir.is_dir():
        print(f"❌ l10n 디렉토리 없음: {l10n_dir}")
        return 1

    base = l10n_dir / "app_en.arb"
    if not base.is_file():
        print(f"❌ 기준 파일 없음: {base}")
        return 1

    base_keys = extract_keys(base)
    if base_keys is None:
        print(f"❌ 기준 파일 파싱 실패: {base}")
        return 1

    print(f"📋 기준: app_en.arb ({len(base_keys)} keys)")
    print()

    arb_files = sorted(p for p in l10n_dir.glob("app_*.arb") if p.is_file())
    other_files = [p for p in arb_files if p != base]

    desync_count = 0
    total_locales = len(other_files)

    for arb in other_files:
        lang = arb.stem.replace("app_", "")
        keys = extract_keys(arb)

        if keys is None:
            # 파싱 실패는 extract_keys 내부에서 이미 경고 출력
            desync_count += 1
            print()
            continue

        missing = sorted(base_keys - keys)
        extra = sorted(keys - base_keys)

        print(f"🔍 app_{lang}.arb: {len(keys)} keys")

        if not missing and not extra:
            print("   ✅ 동기화 OK")
        else:
            desync_count += 1
            print(f"   ❌ missing({len(missing)}): {', '.join(missing) if missing else ''}")
            print(f"   ❌ extra({len(extra)}): {', '.join(extra) if extra else ''}")
        print()

    if desync_count > 0:
        print(f"❌ {desync_count}/{total_locales} locales 비동기화")
        return 1

    print(f"✅ {total_locales}/{total_locales} locales 동기화 완료")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
