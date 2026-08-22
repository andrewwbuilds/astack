#!/usr/bin/env bash
# install-schedule.sh — install the daily sync LaunchAgent.
#
# Copies the plist template into ~/Library/LaunchAgents and loads it.
# Re-runnable: unloads an existing copy first.
set -euo pipefail

LABEL="com.andrewwang.astack-sync"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
src="$repo_root/launchd/$LABEL.plist"
dest="$HOME/Library/LaunchAgents/$LABEL.plist"

[[ -f "$src" ]] || { echo "missing plist: $src" >&2; exit 1; }

mkdir -p "$HOME/Library/LaunchAgents"
cp "$src" "$dest"
plutil -lint "$dest"

launchctl unload "$dest" 2>/dev/null || true
launchctl load -w "$dest"

echo "astack: loaded $LABEL (daily at 09:00)"
launchctl list | grep "$LABEL" || echo "astack: WARNING: not listed after load"
