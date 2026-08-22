#!/usr/bin/env bash
# Secret-shape gate for astack. Called by sync.sh before every commit.
# Exits 1 with the offending path on any hit, 0 otherwise.
set -euo pipefail

REPO_DIR="/Users/andrewwang/git repos/astack"
cd "$REPO_DIR"

fail() {
  echo "scan-secrets: LEAK DETECTED: $1" >&2
  exit 1
}

# 1) Grep the working tree (tracked + untracked, respecting .gitignore) for
#    known token shapes: Claude oauth/org tokens and bare 32-hex-char lines
#    (the daemon control.key shape).
TOKEN_PATTERN='sk-ant-oat01-|sk-ant-ort01-|^[0-9a-fA-F]{32}$'

while IFS= read -r -d '' path; do
  [ -f "$path" ] || continue
  # This script itself legitimately contains the pattern strings as literals
  # for detection purposes, not as an actual leaked secret. Skip it.
  [ "$path" = "scripts/scan-secrets.sh" ] && continue
  if grep -IlE "$TOKEN_PATTERN" -- "$path" >/dev/null 2>&1; then
    fail "$path (matches secret token shape)"
  fi
done < <(git ls-files --cached --others --exclude-standard -z)

# 2) Any tracked path whose name itself matches a sensitive shape.
PATH_PATTERN='\.credentials|/sessions/|control\.key|\.key$'

offending_path="$(git ls-files | grep -E "$PATH_PATTERN" | head -n1 || true)"
if [ -n "$offending_path" ]; then
  fail "$offending_path (path matches sensitive-path pattern)"
fi

echo "scan-secrets: clean"
exit 0
