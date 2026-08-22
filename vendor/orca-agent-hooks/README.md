# orca-agent-hooks (vendored)

Vendored copies of the two external scripts that `claude/settings.json`
shells out to for its hook events and statusline. Without these files
present on disk, settings.json references commands that don't exist.

## Restore

Copy both scripts to `$HOME/.orca/agent-hooks/` and make them executable:

```sh
mkdir -p "$HOME/.orca/agent-hooks"
cp claude-hook.sh claude-statusline.sh "$HOME/.orca/agent-hooks/"
chmod 755 "$HOME/.orca/agent-hooks/claude-hook.sh" "$HOME/.orca/agent-hooks/claude-statusline.sh"
```

## Runtime requirements

Both scripts need these environment variables set at runtime:

- `ORCA_AGENT_HOOK_PORT`
- `ORCA_AGENT_HOOK_TOKEN`
- `ORCA_PANE_KEY`

If any of the three is unset, each script silently no-ops (exits 0
without doing anything) — no crash, no error output. They also depend
on `curl` and `date` being on `PATH`.

## Not included

The Windows `.cmd` counterparts of these scripts are not part of this
backup — only the POSIX shell versions used on macOS/Linux were vendored.

## Failure mode when absent

If the scripts are missing entirely (e.g. `settings.json` restored
without this vendor directory), the hooks fail open: Claude Code finds
nothing to execute, surfaces no error, and the statusline simply renders
blank instead of showing pane/session info.
