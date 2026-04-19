#!/usr/bin/env python3
"""
Parse a ScanCode JSON report and fail if any source file inside apps/ or
packages/ is detected as GPL/LGPL/AGPL. Used by the monthly license-audit
workflow to catch GPL text pasted into our own source code (e.g., from AI
suggestions or copy-paste).
"""
from __future__ import annotations

import json
import sys

GPL_KEYS = ("gpl", "agpl", "lgpl")


def is_forbidden(license_key: str) -> bool:
    key = license_key.lower()
    return any(k in key for k in GPL_KEYS)


def main(report_path: str) -> int:
    with open(report_path) as f:
        report = json.load(f)

    findings: list[tuple[str, list[str]]] = []
    for f_entry in report.get("files", []):
        path = f_entry.get("path", "")
        if not (path.startswith("apps/") or path.startswith("packages/")):
            continue

        bad: list[str] = []
        for det in f_entry.get("license_detections", []):
            for match in det.get("matches", []):
                lic = match.get("license_expression") or match.get("spdx_license_key", "")
                if is_forbidden(lic):
                    bad.append(lic)
        for lic in f_entry.get("detected_license_expression", "").split() if f_entry.get("detected_license_expression") else []:
            if is_forbidden(lic):
                bad.append(lic)

        if bad:
            findings.append((path, sorted(set(bad))))

    if findings:
        print("ScanCode found GPL/LGPL/AGPL text in source files:", file=sys.stderr)
        for path, licenses in findings:
            print(f"  - {path}  [{', '.join(licenses)}]", file=sys.stderr)
        return 1

    print("ScanCode audit OK (no GPL-family text in apps/ or packages/)")
    return 0


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("usage: check_scancode_report.py <report.json>", file=sys.stderr)
        sys.exit(2)
    sys.exit(main(sys.argv[1]))
