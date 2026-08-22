# CLAUDE.md — astack

Backup repo for `~/.claude`. It holds a mirror, not an original.

## Layout

```
claude/skills/          mirror of ~/.claude/skills (39 skills, .git stripped)
claude/settings.json    mirror of ~/.claude/settings.json
claude/CLAUDE.md        mirror of the global instructions file
claude/plugins/         installed_plugins.json + known_marketplaces.json only
vendor/orca-agent-hooks/  copies of the hook scripts settings.json calls
scripts/                sync, restore, secret gate, scheduler uninstall
launchd/                the LaunchAgent plist template
docs/decisions/         ADRs
```

## Scripts

| Script | Does |
|---|---|
| `sync.sh` | Mirror `~/.claude` in, gate for secrets, commit and push if changed. `--dry-run` supported. |
| `restore-plugins.sh` | Reinstall marketplaces and plugins from the lockfile. Re-runnable. `DRY_RUN=1` supported. |
| `scan-secrets.sh` | Fail on token-shaped content or sensitive paths. Called by `sync.sh` before every commit. |
| `uninstall-schedule.sh` | Unload and delete the LaunchAgent. |

## Conventions

- Conventional Commits, enforced by habit not by hook: `type(scope): lowercase imperative subject`, no trailing period, ≤72 chars. Sync commits use `chore(sync):`.
- No AI or agent attribution in commit messages. No `Co-Authored-By`, no "Generated with", no bot badges.
- Secrets never get committed. If you add a path to the backup, add its exclusion to `.gitignore` and a pattern to `scan-secrets.sh` in the same commit.

## Gotchas

- **The repo path contains a space** (`~/git repos/astack`). Every path in every script and in the plist must be quoted. Unquoted `$HOME/git repos/...` will split into two arguments and fail in ways that look unrelated.
- **`claude/skills/` is a mirror, not the source.** Edit `~/.claude/skills/`, then sync. Anything you write directly into `claude/skills/` is destroyed by the next `rsync --delete`.
- **`obsidian-second-brain/media/` is dropped on purpose.** It was 21 MB of the 22 MB total. The skill itself works without it.
- **Plugin source is not here.** Restore depends on the upstream GitHub repos still existing. See ADR 0001 for why that tradeoff was taken.
- **`sync.sh` deletes as well as adds.** A skill removed from `~/.claude` disappears from the backup on the next run. That is intended — the repo tracks current state, and git history holds the rest.
