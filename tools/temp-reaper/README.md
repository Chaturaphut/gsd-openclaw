# 🧹 Temp File Reaper

Cleans up temporary and debug files before shipping. Run this as part of the `/gsd:ship` workflow to ensure no artifacts make it into your PR.

## Usage

```bash
# Preview what would be removed
./tools/temp-reaper/reap.sh /path/to/project --dry-run

# Actually clean up
./tools/temp-reaper/reap.sh /path/to/project
```

## What It Cleans

### File Patterns
- `*.tmp`, `*.bak`, `*.orig` — Backup/temp files
- `*.swp`, `*.swo` — Vim swap files
- `debug-*` — Debug files
- `*.log` — Log files
- `.DS_Store`, `Thumbs.db` — OS artifacts

### Directories
- `.planning/scratch/` — Scratch work directory
- `tmp/`, `.tmp/` — Temp directories

### Code Cleanup
- Removes `console.log` statements containing "DEBUG" or "debug"
- Removes `// DEBUG` comments

## Integration

Add to your ship workflow:

```bash
# Run reaper before creating PR
./tools/temp-reaper/reap.sh . --dry-run  # Preview first
./tools/temp-reaper/reap.sh .            # Then clean
git add -A && git commit -m "chore: clean up temp files"
```

## Configuration

Customize patterns by editing the `PATTERNS` and `CLEAN_DIRS` arrays in `reap.sh`.
