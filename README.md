# astack

A private snapshot of `~/.claude` — the skills, settings, and plugin lockfile behind my Claude Code setup. It exists so a dead laptop costs an afternoon, not a rebuild from memory.

A LaunchAgent syncs it once a day. You can also run the sync by hand.

## What is captured

| Path | What it is |
|---|---|
| `claude/skills/` | All 39 skills, nested `.git` dirs stripped |
| `claude/settings.json` | Hooks, statusline, enabled plugins, model and effort defaults |
| `claude/CLAUDE.md` | Global instructions applied to every project |
| `claude/plugins/*.json` | Plugin lockfile: which marketplaces, which plugins, which versions |
| `vendor/orca-agent-hooks/` | The external scripts `settings.json` shells out to |
| `scripts/` | sync, restore, secret gate |

## What is deliberately not captured

Credentials, session transcripts, telemetry, shell snapshots, and the 13 GB of job history. All of it is in `.gitignore`, and `scripts/scan-secrets.sh` runs before every commit as a second line of defence.

Plugin *source* is not vendored either — only the lockfile that reinstalls it. See [ADR 0001](docs/decisions/0001-plugins-lockfile-not-vendored.md).

## Sync

```bash
bash "$HOME/git repos/astack/scripts/sync.sh"
```

It mirrors `~/.claude` into the repo, runs the secret gate, and commits and pushes only if something changed. Running it on an unchanged machine exits 0 and creates no commit.

To see what would change without writing anything:

```bash
bash "$HOME/git repos/astack/scripts/sync.sh" --dry-run
```

### The daily schedule

A LaunchAgent at `~/Library/LaunchAgents/com.andrewwang.astack-sync.plist` runs the sync every day at 09:00. It runs inside your login session, which is what lets `git push` reach the osxkeychain credential helper — a cron job cannot.

Install:

```bash
launchctl load -w "$HOME/Library/LaunchAgents/com.andrewwang.astack-sync.plist"
```

Remove:

```bash
bash "$HOME/git repos/astack/scripts/uninstall-schedule.sh"
```

Logs land in `/tmp/astack-sync.log` and `/tmp/astack-sync.err`.

## Restore onto a fresh Mac

1. Install Claude Code and sign in.
2. Clone this repo to `~/git repos/astack`.
3. Copy the config back:
   ```bash
   cp -R "$HOME/git repos/astack/claude/skills" "$HOME/.claude/"
   cp "$HOME/git repos/astack/claude/settings.json" "$HOME/.claude/"
   cp "$HOME/git repos/astack/claude/CLAUDE.md" "$HOME/.claude/"
   mkdir -p "$HOME/.claude/plugins"
   cp "$HOME/git repos/astack/claude/plugins/"*.json "$HOME/.claude/plugins/"
   ```
4. Reinstall plugins from the lockfile:
   ```bash
   bash "$HOME/git repos/astack/scripts/restore-plugins.sh"
   ```
   Preview it first with `DRY_RUN=1` if you want to see the commands.
5. Restore the hook scripts, or the statusline stays blank and the hooks silently no-op:
   ```bash
   mkdir -p "$HOME/.orca/agent-hooks"
   cp "$HOME/git repos/astack/vendor/orca-agent-hooks/"*.sh "$HOME/.orca/agent-hooks/"
   chmod 755 "$HOME/.orca/agent-hooks/"*.sh
   ```
   They also need `ORCA_AGENT_HOOK_PORT`, `ORCA_AGENT_HOOK_TOKEN`, and `ORCA_PANE_KEY` in the environment.
6. Install the LaunchAgent (see above).

## Status

Working. Skills, settings, and the plugin lockfile sync daily. Plugin enable/disable state rides along inside `settings.json`, so `restore-plugins.sh` only has to handle installation.
