#!/usr/bin/env bash
# uninstall-schedule.sh — stop and remove the daily sync LaunchAgent.
# Leaves the repo and all its content alone; only the schedule goes away.
set -euo pipefail

LABEL="com.andrewwang.astack-sync"
dest="$HOME/Library/LaunchAgents/$LABEL.plist"

if [[ -f "$dest" ]]; then
  launchctl unload -w "$dest" 2>/dev/null || true
  rm -f "$dest"
  echo "astack: removed $LABEL"
else
  echo "astack: $LABEL not installed, nothing to do"
fi

if launchctl list | grep -q "$LABEL"; then
  echo "astack: WARNING: still listed, try: launchctl remove $LABEL" >&2
  exit 1
fi
