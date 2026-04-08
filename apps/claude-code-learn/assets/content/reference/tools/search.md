<!-- Source: https://www.mintlify.com/VineeTagarwaL-code/claude-code/reference/tools/search -->

# Search Tools (Glob & Grep)

## Overview

The documentation describes two specialized search tools: **Glob** for file discovery and **Grep** for content searching. Both are recommended over standard bash commands due to superior permission handling and structured output.

---

## Glob Tool

**Purpose:** Locate files matching name patterns.

### Key Parameters

- `pattern` (required): Glob pattern supporting `*`, `**`, and `?` wildcards
- `path` (optional): Search directory; defaults to current working directory

### Output

File paths sorted by modification time, capped at 100 results.

### Pattern Examples

| Pattern | Matches |
|---------|---------|
| `**/*.ts` | All TypeScript files in tree |
| `src/**/*.tsx` | TSX files under src/ |
| `*.json` | JSON files in current directory |
| `**/{package,tsconfig}.json` | Named files at any depth |
| `tools/*/prompt.ts` | prompt.ts one level deep |

---

## Grep Tool

**Purpose:** Search file contents using regular expressions (ripgrep-powered).

### Key Parameters

- `pattern` (required): Regular expression for content matching
- `path` (optional): File or directory to search
- `glob`: Filter files by pattern
- `type`: Ripgrep file type (js, py, rust, go, java, etc.)
- `output_mode`: Controls return format
- `-i`: Case-insensitive search
- `-n`: Show line numbers (default: true)
- `-A` / `-B`: Context lines after/before matches
- `context`: Lines before and after matches
- `multiline`: Enable newline matching
- `head_limit`: Cap output at N lines (default: 250)
- `offset`: Skip first N entries for pagination

### Output Modes

1. `files_with_matches` (default): Returns matching file paths only
2. `content`: Returns matching lines with optional context
3. `count`: Returns match counts per file

### Automatic Exclusions

Version control directories (`.git`, `.svn`, `.hg`, `.bzr`, `.jj`, `.sl`)
