#!/usr/bin/env python3
"""
Scan the workspace's resolved Dart/Flutter packages for GPL/LGPL/AGPL.
Reads .dart_tool/package_config.json and inspects each package's LICENSE
file in pub-cache. Run from the repo root after `flutter pub get`.
"""
from __future__ import annotations

import json
import os
import re
import sys
import urllib.parse

PACKAGE_CONFIG = ".dart_tool/package_config.json"

FORBIDDEN = re.compile(
    r"\b(GNU GENERAL PUBLIC LICENSE|GNU LESSER GENERAL PUBLIC|GNU AFFERO|GPL-?[23]|LGPL|AGPL)\b",
    re.I,
)

LICENSE_FILENAMES = ("LICENSE", "LICENSE.md", "LICENSE.txt", "license", "license.md", "COPYING")


def resolve_path(base: str, root_uri: str) -> str:
    if root_uri.startswith("file://"):
        return urllib.parse.unquote(root_uri[7:])
    return os.path.normpath(os.path.join(base, root_uri))


def find_license(path: str) -> tuple[str, str] | None:
    for fn in LICENSE_FILENAMES:
        lp = os.path.join(path, fn)
        if os.path.isfile(lp):
            try:
                with open(lp, encoding="utf-8", errors="ignore") as f:
                    return fn, f.read(8000)
            except OSError:
                return None
    return None


def main() -> int:
    if not os.path.isfile(PACKAGE_CONFIG):
        print(f"Missing {PACKAGE_CONFIG}. Run `flutter pub get` first.", file=sys.stderr)
        return 2

    with open(PACKAGE_CONFIG) as f:
        data = json.load(f)

    base = os.path.abspath(".dart_tool")
    failures: list[tuple[str, str]] = []
    checked = 0

    for pkg in data["packages"]:
        path = resolve_path(base, pkg["rootUri"])
        result = find_license(path)
        if result is None:
            # Flutter SDK and workspace-local packages have no LICENSE file;
            # skip silently — they are not third-party deps.
            continue
        _fn, content = result
        checked += 1
        if FORBIDDEN.search(content[:2000]):
            failures.append((pkg["name"], content.split("\n", 1)[0][:120]))

    if failures:
        print("License check FAILED:", file=sys.stderr)
        for name, head in failures:
            print(f"  - {name}: {head}", file=sys.stderr)
        return 1

    print(f"License check OK ({checked} packages scanned)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
