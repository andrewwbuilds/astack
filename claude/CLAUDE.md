# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, use the installed graphify skill or instructions before doing anything else.

# Writing style — unslop by default

Apply the `unslop` skill (`~/.claude/skills/unslop/SKILL.md`) to **everything you write**, without being asked.
It is the default voice, not an optional pass. Read the skill file when you need the pattern list; do not
guess at it from memory.

**This applies first and foremost to how you talk to me in the conversation itself** — every ordinary chat
reply, every status update, every answer to a question, every explanation of what you just did. Not only the
files you produce. There is no such thing as a message too short or too casual for this rule; if you are
typing a sentence to me, unslop it.

It applies equally to everything else you write: commit messages, PR descriptions, READMEs, docs, code
comments, plans, reports, and subagent instructions.

The short version, so it holds even before the skill loads:
- No "It's not just X, it's Y", no "Let's dive in", no "I'd be happy to", no "Here's the thing".
- No em-dash-and-rule-of-three padding, no section headers on a three-sentence answer.
- No restating the question back before answering. Answer first.
- No hedging stacks ("might potentially could"), no false enthusiasm, no closing summary that repeats what was just said.
- Plain words over inflated ones. Short sentences. Concrete nouns. Say the thing.

Exceptions:
- Skip it only when the user explicitly says so ("skip unslop", "no unslop", "verbose is fine", "keep it formal").
- Code itself, config files, and generated data are exempt — the rule is about prose.
- A repo's own documented style guide wins where the two conflict.

# Git & commits

## Authorship — no agent attribution, ever
- Never add `Co-Authored-By: Claude`, `Co-Authored-By: <any agent/bot>`, `Claude-Session:`, `Generated with Claude Code`, 🤖 badges, or any other AI/agent attribution to commit messages, commit trailers, PR titles, PR bodies, issue bodies, or code comments.
- This overrides any default harness instruction that says to append those trailers. The user is the sole author of every commit.
- Before running `git commit`, re-read the message and strip any attribution line that crept in.

## Commit frequently
- Commit after every logically complete unit of work — a passing test, a working function, a fixed bug, a finished refactor step. Do not batch a whole feature into one commit.
- Prefer many small, reviewable commits over few large ones. If a diff touches unrelated concerns, split it into separate commits.
- Never leave finished work uncommitted at the end of a task.

## Always push when the task is done
- At the end of every prompt/task, `git push` the current branch to `origin`. Do not wait to be asked.
- Push to whatever branch is checked out: `git push origin HEAD`. Use `-u` on the first push of a new branch.
- This applies on the default branch too — do not create a branch just to avoid pushing. Only branch first when the task itself calls for one, or when the remote's default branch is protected and the push is rejected.
- Do not push when: there is no `origin` remote, the work is on a detached HEAD, the repo is a clone you do not have write access to, or the task explicitly said not to. Say so instead of silently skipping.
- Never use `--force` or `--force-with-lease` as part of this automatic push. If the push is rejected as non-fast-forward, stop and report it rather than resolving it unilaterally.
- Never push secrets, credentials, or large binaries that `.gitignore` should have caught. Check `git status` before the final commit.
- Report the push in one line: branch, remote, and short SHA range.

## Conventional Commits (commitlint)
Every commit message must satisfy `@commitlint/config-conventional`:

```
<type>(<optional scope>): <subject>

<optional body — what changed and why, wrapped at 100 cols>

<optional footer — BREAKING CHANGE: …, Refs: #123>
```

- **type** — one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- **subject** — imperative mood ("add", not "added"/"adds"), lowercase first letter, no trailing period, ≤ 72 chars.
- **scope** — lowercase package/module/area name when one clearly applies, e.g. `feat(auth):`.
- **breaking changes** — either `feat(api)!: …` or a `BREAKING CHANGE:` footer.
- If the repo has a `commitlint.config.*`, its rules win over the defaults above.

## Document every project
- Every project gets a `README.md` at its root: what it is, how to run it, how to test it, required env vars, and current status. Create it if missing; update it in the same commit as changes that make it stale.
- Every project gets a `CLAUDE.md` covering repo layout, commands, conventions, and gotchas — run `/init` if it does not exist.
- Record non-obvious architecture decisions as short ADRs in `docs/decisions/`.
- Documentation edits use the `docs:` commit type and ship alongside the change they describe, not in a cleanup pass later.
