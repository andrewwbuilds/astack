#!/usr/bin/env bash
# sync.sh — mirror ~/.claude into this repo, then commit and push if anything moved.
#
# Idempotent: running it with nothing changed exits 0 and creates no commit.
# Safe to run unattended (this is what the daily LaunchAgent calls).
#
# The rsync --delete plus the .git prune below are what keep this working as
# skills come and go: a skill you deleted disappears from the backup, and a
# newly added skill that carries its own .git does not become a stray gitlink.
#
# Flags:
#   --dry-run   copy nothing, commit nothing; just report what would change
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
ORCA_HOOKS_DIR="$HOME/.orca/agent-hooks"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
cd "$repo_root"

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

log() { printf 'astack: %s\n' "$*"; }

if [[ ! -d "$CLAUDE_DIR" ]]; then
  echo "astack: FATAL: $CLAUDE_DIR does not exist" >&2
  exit 1
fi

rsync_flags=(-a --delete
  --exclude='.git/'
  --exclude='.DS_Store'
  --exclude='obsidian-second-brain/media/')
[[ "$DRY_RUN" == "1" ]] && rsync_flags+=(--dry-run --itemize-changes)

# 1) Skills — the bulk of the backup.
mkdir -p claude/skills
rsync "${rsync_flags[@]}" "$CLAUDE_DIR/skills/" claude/skills/

# 2) Belt and braces: rsync's --exclude stops .git being *copied*, but a
#    nested .git already present in the destination from an earlier run
#    would survive. Remove any.
if [[ "$DRY_RUN" == "0" ]]; then
  find claude/skills -name .git -prune -exec rm -rf {} + 2>/dev/null || true
fi

# 3) Config surface that lives inside ~/.claude.
for f in settings.json settings.json.bak CLAUDE.md SKILLS-AUDIT.md SKILLS-INVENTORY.md; do
  if [[ -f "$CLAUDE_DIR/$f" ]]; then
    if [[ "$DRY_RUN" == "1" ]]; then
      cmp -s "$CLAUDE_DIR/$f" "claude/$f" || log "would update claude/$f"
    else
      cp "$CLAUDE_DIR/$f" "claude/$f"
    fi
  fi
done

# 4) Plugin lockfiles only. Source is never vendored — see docs/decisions/0001.
mkdir -p claude/plugins
for f in installed_plugins.json known_marketplaces.json; do
  if [[ -f "$CLAUDE_DIR/plugins/$f" ]]; then
    if [[ "$DRY_RUN" == "1" ]]; then
      cmp -s "$CLAUDE_DIR/plugins/$f" "claude/plugins/$f" || log "would update claude/plugins/$f"
    else
      cp "$CLAUDE_DIR/plugins/$f" "claude/plugins/$f"
    fi
  fi
done

# 5) External hook scripts settings.json shells out to. Absent on a machine
#    that never installed orca; that is fine, keep whatever we already have.
if [[ -d "$ORCA_HOOKS_DIR" && "$DRY_RUN" == "0" ]]; then
  mkdir -p vendor/orca-agent-hooks
  for f in claude-hook.sh claude-statusline.sh; do
    [[ -f "$ORCA_HOOKS_DIR/$f" ]] && cp "$ORCA_HOOKS_DIR/$f" "vendor/orca-agent-hooks/$f"
  done
fi

if [[ "$DRY_RUN" == "1" ]]; then
  log "dry run complete, nothing written"
  exit 0
fi

# 6) Gate: never commit anything token-shaped, whatever ~/.claude's layout
#    turns into in future. This runs before every single commit.
bash scripts/scan-secrets.sh

# 7) Stage and bail out cleanly if nothing actually changed.
git add -A
if git diff --cached --quiet; then
  log "no changes"
  exit 0
fi

changed="$(git diff --cached --name-only | wc -l | tr -d ' ')"
git commit -q -m "chore(sync): update claude config snapshot $(date +%F)"
log "committed $changed changed path(s)"

git push -q origin main
log "pushed to origin/main"
