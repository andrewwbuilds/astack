# 0001 — Back up plugins as a lockfile, not vendored source

Date: 2026-08-22
Status: accepted

## Context

`~/.claude/plugins/` is about 18 MB: 10 MB of `marketplaces/` (git clones of six upstream repos) and 7 MB of `cache/` (the installed copies). None of it is code I wrote. All six marketplaces are public GitHub repos, and `installed_plugins.json` already records the exact `gitCommitSha` each plugin was installed from.

Committing it would make the backup 20× larger and turn every upstream plugin update into a large, unreadable diff in my own repo.

## Decision

Track only `installed_plugins.json` and `known_marketplaces.json`, plus `scripts/restore-plugins.sh` that reinstalls from them. `.gitignore` blocks `claude/plugins/cache/`, `claude/plugins/marketplaces/`, and `claude/plugins/data/` so the source cannot be staged by accident.

Skills under `~/.claude/skills/` are treated differently and copied in full — several are mine or locally modified, and there is no lockfile that could reproduce them.

## Consequences

Good: the repo is 2.2 MB instead of ~20 MB. Diffs show only what I actually changed. Cloning is fast.

Bad: restore depends on six upstream repos staying public and available. If one is deleted, that plugin is gone and the lockfile only tells me what it was called.

Also worth knowing: `claude plugin install` resolves the latest version, so a restore does not reproduce the pinned `gitCommitSha` recorded in the lockfile. The shas are a record of what was installed, not a mechanism that reinstalls it. Pinning would need `claude plugin install` to grow a `--commit` flag.

If a plugin ever becomes load-bearing enough that losing it would hurt, vendor that one plugin explicitly rather than reversing this decision wholesale.
