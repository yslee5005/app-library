#!/usr/bin/env python3
"""
Fail when npm dependencies introduce GPL/AGPL, or LGPL outside the sharp
libvips native binary whitelist. Run from inside the npm project directory
(the script invokes `npx license-checker` in CWD).
"""
from __future__ import annotations

import json
import re
import subprocess
import sys

LGPL_WHITELIST_PREFIXES = ("@img/sharp-libvips",)

FORBIDDEN = re.compile(r"\b(AGPL|GPL-?[23]|GPL-3\.0|GPLv[23]|GNU General Public)\b", re.I)
LGPL_PATTERN = re.compile(r"\bLGPL\b", re.I)


def run_license_checker() -> dict:
    out = subprocess.check_output(
        ["npx", "--yes", "license-checker", "--json", "--production", "--excludePrivatePackages"],
        text=True,
    )
    return json.loads(out)


def license_text(entry: dict) -> str:
    lic = entry.get("licenses", "")
    if isinstance(lic, list):
        return ";".join(lic)
    return str(lic)


def main() -> int:
    data = run_license_checker()
    failures: list[tuple[str, str, str]] = []

    for pkg, entry in data.items():
        lic = license_text(entry)
        name = pkg.rsplit("@", 1)[0]

        if FORBIDDEN.search(lic):
            failures.append((pkg, lic, "GPL/AGPL forbidden"))
            continue

        if LGPL_PATTERN.search(lic) and not name.startswith(LGPL_WHITELIST_PREFIXES):
            failures.append((pkg, lic, "LGPL only allowed for sharp libvips"))

    if failures:
        print("License check FAILED:", file=sys.stderr)
        for pkg, lic, reason in failures:
            print(f"  - {pkg}  [{lic}]  -> {reason}", file=sys.stderr)
        return 1

    print(f"License check OK ({len(data)} packages scanned)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
