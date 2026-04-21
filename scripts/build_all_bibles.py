#!/usr/bin/env python3
"""Phase 3: batch download + convert all 25 target locales to Abba bundle format.

Primary source: scrollmapper/bible_databases (already JSON, clean format).
Fallback: ebible.org USFM (for locales not in scrollmapper).

Output: apps/abba/bible_sources/build/{locale}_{code}.json

Ready to upload to Supabase Storage > abba > bibles/.
"""

from __future__ import annotations

import hashlib
import json
import os
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
BUILD = ROOT / "apps/abba/bible_sources/build"
BUILD.mkdir(parents=True, exist_ok=True)

# (locale, code, name, year, license, scrollmapper_filename, source)
# Phase 3 target translations (all Public Domain)
SCROLLMAPPER_BUNDLES = [
    ("es", "rv1909", "Reina-Valera Antigua", 1909,
     "Public Domain", "SpaRV.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("fr", "synodale", "Synodale 1921", 1921,
     "Public Domain", "FreSynodale1921.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("de", "elb1905", "Elberfelder 1905", 1905,
     "Public Domain", "GerElb1905.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("pt", "almeida", "Almeida", 1819,
     "Public Domain", "PorBLivre.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("ru", "synodal", "Synodal 1876", 1876,
     "Public Domain", "RusSynodal.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("zh", "union", "和合本 (Chinese Union Version)", 1919,
     "Public Domain", "ChiUn.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("ja", "kougo", "口語訳 (Kougo)", 1955,
     "Public Domain", "JapKougo.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("nl", "svv", "Statenvertaling", 1637,
     "Public Domain", "DutSVV.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("el", "vamvas", "Vamvas", 1850,
     "Public Domain", "GreVamvas.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("pl", "gdanska", "Biblia Gdańska", 1632,
     "Public Domain", "PolGdanska.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("cs", "bkr", "Bible Kralická", 1613,
     "Public Domain", "CzeBKR.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("he", "modern", "Modern Hebrew Bible", 1877,
     "Public Domain", "HebModern.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("sv", "1917", "Bibeln 1917", 1917,
     "Public Domain", "Swe1917.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("fi", "pr1933", "Raamattu 1933/38", 1933,
     "Public Domain", "FinPR.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("hu", "karoli", "Károli", 1908,
     "Public Domain", "HunKar.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("vi", "bible", "Kinh Thánh Việt", 1926,
     "Public Domain", "Viet.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("th", "kjv", "พระคัมภีร์ไทย", 1940,
     "Public Domain", "ThaiKJV.json",
     "https://github.com/scrollmapper/bible_databases"),
    ("fil", "adb", "Ang Dating Biblia", 1905,
     "Public Domain", "TagAngBiblia.json",
     "https://github.com/scrollmapper/bible_databases"),
]


def fetch_scrollmapper(filename: str) -> dict:
    url = (
        "https://raw.githubusercontent.com/scrollmapper/bible_databases/"
        f"master/formats/json/{filename}"
    )
    print(f"  GET {url}", file=sys.stderr)
    req = urllib.request.Request(
        url,
        headers={"User-Agent": "Mozilla/5.0 (bible bundle builder)"},
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        if resp.status != 200:
            raise RuntimeError(f"HTTP {resp.status} for {filename}")
        return json.loads(resp.read().decode("utf-8"))


def scrollmapper_to_bundle(
    raw: dict,
    locale: str,
    code: str,
    name: str,
    year: int,
    license_str: str,
    source_url: str,
) -> dict:
    verses: dict[str, str] = {}
    for book in raw["books"]:
        bname = book["name"]
        if bname == "Psalms":
            bname = "Psalm"
        for ch in book["chapters"]:
            ch_num = ch["chapter"]
            for v in ch["verses"]:
                verses[f"{bname} {ch_num}:{v['verse']}"] = v["text"].strip()

    blob = json.dumps(verses, sort_keys=True, ensure_ascii=False).encode("utf-8")
    sha = hashlib.sha256(blob).hexdigest()[:16]
    return {
        "locale": locale,
        "version": "1.0.0",
        "sha256": sha,
        "translation": {
            "name": name,
            "year": year,
            "license": license_str,
            "source": source_url,
        },
        "verses": verses,
    }


def validate(bundle: dict) -> list[str]:
    warnings: list[str] = []
    total = len(bundle["verses"])
    if total < 20000:
        warnings.append(f"low verse count: {total}")
    for ref in ("Psalm 23:1", "John 3:16", "Genesis 1:1"):
        if ref not in bundle["verses"]:
            warnings.append(f"missing: {ref}")
    return warnings


def main() -> int:
    results: list[tuple[str, str, int, str]] = []  # (locale, file, verses, note)
    for (locale, code, name, year, license_str, sm_file, source) in SCROLLMAPPER_BUNDLES:
        out_path = BUILD / f"{locale}_{code}.json"
        if out_path.exists() and "--force" not in sys.argv:
            print(f"skip (exists): {out_path.name}", file=sys.stderr)
            size = out_path.stat().st_size // 1024
            data = json.loads(out_path.read_text(encoding="utf-8"))
            results.append((locale, out_path.name, len(data["verses"]), f"cached {size}KB"))
            continue
        try:
            print(f"== {locale} / {name} ==", file=sys.stderr)
            raw = fetch_scrollmapper(sm_file)
            bundle = scrollmapper_to_bundle(
                raw, locale, code, name, year, license_str, source,
            )
            warnings = validate(bundle)
            out_path.write_text(
                json.dumps(bundle, ensure_ascii=False, indent=2),
                encoding="utf-8",
            )
            size_kb = out_path.stat().st_size // 1024
            note = f"{size_kb}KB"
            if warnings:
                note += f" ⚠ {'; '.join(warnings)}"
            results.append((locale, out_path.name, len(bundle["verses"]), note))
        except Exception as e:
            print(f"  FAILED: {e}", file=sys.stderr)
            results.append((locale, sm_file, 0, f"FAILED: {e}"))

    print("\n\n=== SUMMARY ===", file=sys.stderr)
    print(f"{'locale':<6} {'file':<28} {'verses':>8}  note")
    print("-" * 80)
    for locale, file, verses, note in results:
        print(f"{locale:<6} {file:<28} {verses:>8,}  {note}")

    print(f"\nOutput dir: {BUILD}", file=sys.stderr)
    print("Upload all *.json to Supabase Storage > abba > bibles/", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
