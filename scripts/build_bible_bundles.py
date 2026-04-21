#!/usr/bin/env python3
"""Convert USFM Bible files to Abba's JSON bundle format.

Input:  apps/abba/bible_sources/<code>/<book>.usfm (one USFM file per book)
Output: apps/abba/bible_sources/build/<locale>_<code>.json

Format:
  {
    "locale": "ko",
    "version": "1.0.0",
    "sha256": "...",
    "translation": {
      "name": "개역한글",
      "year": 1961,
      "license": "Public Domain (2012 expired)",
      "source": "https://ebible.org/details.php?id=..."
    },
    "verses": {
      "Psalm 23:1": "여호와는 나의 목자시니 내게 부족함이 없으리로다",
      ...
    }
  }

Usage:
  python3 scripts/build_bible_bundles.py \
    --src apps/abba/bible_sources/ko_krv \
    --locale ko \
    --code krv \
    --name 개역한글 \
    --year 1961 \
    --license "Public Domain (2012 expired)" \
    --source https://ebible.org/details.php?id=kokrv

The output JSON is ready to upload to Supabase Storage:
  Supabase Dashboard > Storage > abba > bibles/ > Upload
  (filename: ko_krv.json, en_web.json, ...)
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path


# USFM book code → English book name (standard SIL/UBS 3-letter codes).
# Uses names that match references AI emits (e.g., "Psalm 23:1", "1 Corinthians 1:1").
BOOK_NAMES: dict[str, str] = {
    # Old Testament
    "GEN": "Genesis", "EXO": "Exodus", "LEV": "Leviticus", "NUM": "Numbers",
    "DEU": "Deuteronomy", "JOS": "Joshua", "JDG": "Judges", "RUT": "Ruth",
    "1SA": "1 Samuel", "2SA": "2 Samuel", "1KI": "1 Kings", "2KI": "2 Kings",
    "1CH": "1 Chronicles", "2CH": "2 Chronicles", "EZR": "Ezra", "NEH": "Nehemiah",
    "EST": "Esther", "JOB": "Job", "PSA": "Psalm", "PRO": "Proverbs",
    "ECC": "Ecclesiastes", "SNG": "Song of Solomon", "ISA": "Isaiah",
    "JER": "Jeremiah", "LAM": "Lamentations", "EZK": "Ezekiel", "DAN": "Daniel",
    "HOS": "Hosea", "JOL": "Joel", "AMO": "Amos", "OBA": "Obadiah",
    "JON": "Jonah", "MIC": "Micah", "NAM": "Nahum", "HAB": "Habakkuk",
    "ZEP": "Zephaniah", "HAG": "Haggai", "ZEC": "Zechariah", "MAL": "Malachi",
    # New Testament
    "MAT": "Matthew", "MRK": "Mark", "LUK": "Luke", "JHN": "John",
    "ACT": "Acts", "ROM": "Romans", "1CO": "1 Corinthians", "2CO": "2 Corinthians",
    "GAL": "Galatians", "EPH": "Ephesians", "PHP": "Philippians", "COL": "Colossians",
    "1TH": "1 Thessalonians", "2TH": "2 Thessalonians", "1TI": "1 Timothy",
    "2TI": "2 Timothy", "TIT": "Titus", "PHM": "Philemon", "HEB": "Hebrews",
    "JAS": "James", "1PE": "1 Peter", "2PE": "2 Peter", "1JN": "1 John",
    "2JN": "2 John", "3JN": "3 John", "JUD": "Jude", "REV": "Revelation",
}

EXPECTED_TOTAL_OT = 23214  # Approximate, varies by canon
EXPECTED_TOTAL_NT = 7957
EXPECTED_TOTAL = EXPECTED_TOTAL_OT + EXPECTED_TOTAL_NT  # 31171

# USFM marker regex
RE_BOOK_ID = re.compile(r"\\id\s+([A-Z1-3]{3})")
RE_CHAPTER = re.compile(r"\\c\s+(\d+)")
RE_VERSE = re.compile(r"\\v\s+(\d+(?:-\d+)?)\s*(.*?)(?=\\v\s+\d|\\c\s+\d|\Z)", re.DOTALL)
RE_MARKER_STRIP = re.compile(r"\\[a-z0-9*]+\*?\s?")
RE_MULTI_WHITESPACE = re.compile(r"\s+")


def parse_usfm_file(path: Path) -> tuple[str, dict[str, str]]:
    """Parse one USFM file, return (book_code, {"chapter:verse": text, ...})."""
    raw = path.read_text(encoding="utf-8-sig")  # BOM 제거

    book_match = RE_BOOK_ID.search(raw)
    if not book_match:
        raise ValueError(f"No \\id marker in {path}")
    book_code = book_match.group(1).upper()

    # Find chapters
    chapters_out: dict[str, str] = {}
    # Split by chapter markers
    chapter_chunks = re.split(r"\\c\s+(\d+)", raw)
    # chapter_chunks: [header_garbage, chNum1, chContent1, chNum2, chContent2, ...]
    for i in range(1, len(chapter_chunks), 2):
        ch_num = chapter_chunks[i]
        ch_text = chapter_chunks[i + 1]
        for m in RE_VERSE.finditer(ch_text):
            verse_num = m.group(1)
            verse_text = m.group(2)
            # Strip remaining markers
            clean = RE_MARKER_STRIP.sub(" ", verse_text)
            clean = RE_MULTI_WHITESPACE.sub(" ", clean).strip()
            if clean:
                key = f"{ch_num}:{verse_num}"
                chapters_out[key] = clean

    return book_code, chapters_out


def build_bundle(
    src_dir: Path,
    locale: str,
    code: str,
    name: str,
    year: int,
    license_str: str,
    source_url: str,
) -> dict:
    """Walk through USFM files in src_dir, build the bundle dict."""
    verses: dict[str, str] = {}
    usfm_files = sorted(src_dir.glob("*.usfm")) + sorted(src_dir.glob("*.sfm"))
    if not usfm_files:
        raise FileNotFoundError(f"No USFM files found in {src_dir}")

    for f in usfm_files:
        book_code, book_verses = parse_usfm_file(f)
        if book_code not in BOOK_NAMES:
            print(f"  SKIP unknown book code: {book_code} ({f.name})", file=sys.stderr)
            continue
        book_name = BOOK_NAMES[book_code]
        for ch_verse, text in book_verses.items():
            ref = f"{book_name} {ch_verse}"
            verses[ref] = text
        print(f"  {book_name}: {len(book_verses)} verses", file=sys.stderr)

    # Build dict WITHOUT sha256, compute sha256 of the verses dict, add sha256 last
    bundle_core = {
        "locale": locale,
        "version": "1.0.0",
        "translation": {
            "name": name,
            "year": year,
            "license": license_str,
            "source": source_url,
        },
        "verses": verses,
    }
    # sha256 of verses JSON (sorted keys for stability)
    verses_blob = json.dumps(verses, sort_keys=True, ensure_ascii=False).encode("utf-8")
    sha = hashlib.sha256(verses_blob).hexdigest()[:16]
    bundle_core["sha256"] = sha

    return bundle_core


def validate_bundle(bundle: dict) -> list[str]:
    """Return list of warnings (empty = OK)."""
    warnings: list[str] = []
    verses = bundle["verses"]
    total = len(verses)
    if total < 20000:
        warnings.append(f"Low verse count: {total} (expected ~{EXPECTED_TOTAL})")
    elif total > 35000:
        warnings.append(f"Unusually high verse count: {total}")

    # Spot-check: Psalm 23:1 and John 3:16 exist
    for ref in ("Psalm 23:1", "John 3:16", "Genesis 1:1"):
        if ref not in verses:
            warnings.append(f"Missing expected reference: {ref}")

    return warnings


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--src", required=True, help="Directory containing USFM files")
    ap.add_argument("--locale", required=True, help="Locale code (ko, en, ...)")
    ap.add_argument("--code", required=True, help="Translation short code (krv, web, ...)")
    ap.add_argument("--name", required=True, help="Translation display name")
    ap.add_argument("--year", type=int, required=True)
    ap.add_argument("--license", required=True)
    ap.add_argument("--source", required=True, help="Source URL")
    ap.add_argument("--out", help="Output JSON path (default: <src>/../build/<locale>_<code>.json)")
    args = ap.parse_args()

    src = Path(args.src).expanduser().resolve()
    if not src.is_dir():
        print(f"ERROR: src not a directory: {src}", file=sys.stderr)
        return 1

    out_path = Path(args.out).expanduser().resolve() if args.out else (
        src.parent / "build" / f"{args.locale}_{args.code}.json"
    )
    out_path.parent.mkdir(parents=True, exist_ok=True)

    print(f"Building bundle from {src} → {out_path}", file=sys.stderr)
    bundle = build_bundle(
        src_dir=src,
        locale=args.locale,
        code=args.code,
        name=args.name,
        year=args.year,
        license_str=args.license,
        source_url=args.source,
    )

    warnings = validate_bundle(bundle)
    for w in warnings:
        print(f"  WARN: {w}", file=sys.stderr)

    out_path.write_text(
        json.dumps(bundle, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    size_mb = out_path.stat().st_size / 1024 / 1024
    print(
        f"DONE: {len(bundle['verses'])} verses, {size_mb:.1f}MB, sha256={bundle['sha256']}",
        file=sys.stderr,
    )
    print(f"  Upload to: Supabase > Storage > abba > bibles/{args.locale}_{args.code}.json")
    return 0 if not warnings else 2


if __name__ == "__main__":
    sys.exit(main())
