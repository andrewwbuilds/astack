#!/usr/bin/env bash
# restore-plugins.sh — reinstall Claude Code plugins from the lockfiles in
# claude/plugins/{known_marketplaces.json,installed_plugins.json}.
#
# Re-runnable: skips a marketplace already in `claude plugin marketplace list`
# and a plugin already in `claude plugin list`.
#
# NOTE: this script restores plugin *installation* only. Which plugins are
# enabled vs disabled lives in claude/settings.json under enabledPlugins
# (ponytail is installed but disabled there) — that is restored as part of
# item 04 (copying settings.json back to ~/.claude), not by this script.
#
# Set DRY_RUN=1 to print the commands this script would run without
# executing them.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
marketplaces_json="$repo_root/claude/plugins/known_marketplaces.json"
installed_json="$repo_root/claude/plugins/installed_plugins.json"

run() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    printf '%s\n' "$*"
  else
    "$@"
  fi
}

existing_marketplaces() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    return
  fi
  claude plugin marketplace list 2>/dev/null || true
}

existing_plugins() {
  if [[ "${DRY_RUN:-0}" == "1" ]]; then
    return
  fi
  claude plugin list 2>/dev/null || true
}

marketplaces_snapshot="$(existing_marketplaces)"
plugins_snapshot="$(existing_plugins)"

echo "Restoring marketplaces from $marketplaces_json"
while IFS=$'\t' read -r name repo; do
  [[ -z "$name" ]] && continue
  if [[ "${DRY_RUN:-0}" != "1" ]] && grep -q "$name" <<<"$marketplaces_snapshot"; then
    echo "skip marketplace already present: $name"
    continue
  fi
  run claude plugin marketplace add "$repo"
done < <(jq -r 'to_entries[] | select(.value.source.source == "github") | "\(.key)\t\(.value.source.repo)"' "$marketplaces_json")

echo "Restoring plugins from $installed_json"
while IFS= read -r key; do
  [[ -z "$key" ]] && continue
  if [[ "${DRY_RUN:-0}" != "1" ]] && grep -q "$key" <<<"$plugins_snapshot"; then
    echo "skip plugin already installed: $key"
    continue
  fi
  run claude plugin install "$key" --scope user -y
done < <(jq -r '.plugins | keys[]' "$installed_json")
