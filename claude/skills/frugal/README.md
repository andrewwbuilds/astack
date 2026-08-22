# /frugal

A Claude Code skill for **cost-tiered agent orchestration**.

Claude Code will happily run every subagent on your most expensive model. `/frugal` routes work by
cost-of-being-wrong instead: Haiku 4.5 does the research and mechanical work, Sonnet 5 does the
engineering, and Opus 5 is reserved for the plan and final judgment.

Target mix is roughly **60% Haiku / 35% Sonnet / 5% Opus**.

## Install

```bash
git clone https://github.com/andrewwbuilds/frugal.git ~/.claude/skills/frugal
```

Restart Claude Code (or start a new session) and the skill is available.

Project-scoped instead of global:

```bash
git clone https://github.com/andrewwbuilds/frugal.git .claude/skills/frugal
```

## Use

```
/frugal <task>                  # run the task as a tiered workflow
/frugal                         # apply tiering to whatever you're already working on
/frugal --plan <task>           # research + plan.md only, stop before implementing
/frugal --no-opus <task>        # hard ceiling at Sonnet
/frugal --max-opus <n> <task>   # allow at most n Opus agents
```

It is **manual-invoke only** by design — the skill won't fire unless you type `/frugal`. Invoking it
is also your explicit opt-in to multi-agent orchestration, which Claude Code otherwise won't do on
its own.

## The roster

| Model | Role | Gets |
|---|---|---|
| Haiku 4.5 | intern | research, doc/web/codebase search, greps, inventories, boilerplate, renames, spec'd mechanical refactors |
| Sonnet 5 | mid-to-senior engineer | implementation, debugging, tests, review, synthesis over Haiku output, verification |
| Opus 5 | staff / architect | system design, the final `plan.md`, cross-cutting tradeoffs, arbitration, one-way-door calls |

Haiku is genuinely excellent at research — most of the research fan-out should be Haiku, with
Sonnet or Opus turning it into the plan.

## How it runs

1. **Scout** — inline, no agents. If a `grep` answers it, don't spawn anything.
2. **Research** — Haiku fan-out, one agent per angle, structured JSON out.
3. **Plan** — one Opus agent reads all the research and writes `plan.md`. The one place Opus reliably earns its cost.
4. **Build** — Sonnet pipeline, one agent per plan item.
5. **Verify** — Sonnet reviewers prompted to *refute*, plus Haiku running the mechanical checks.

Escalation is reactive, not pre-emptive: run Haiku first, retry that one item on Sonnet if the output
is thin. A wasted Haiku agent plus a Sonnet retry still costs less than starting at Opus.

`SKILL.md` has the full routing rules, the workflow template, and the cost rules.

## Requires

Claude Code with the `Workflow` tool (multi-agent orchestration) available.
