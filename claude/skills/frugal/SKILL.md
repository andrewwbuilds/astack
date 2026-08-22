---
name: frugal
description: "Manual-invoke only. Run the current task as a cost-tiered multi-agent workflow: Haiku 4.5 does research and menial work, Sonnet 5 does the engineering, Opus 5 is reserved for architecture and final judgment. Use ONLY when the user explicitly types /frugal — never infer it, never auto-apply the tiering to normal turns."
---

# /frugal — cost-tiered agent orchestration

Invoking this skill is the user's explicit opt-in to multi-agent orchestration via the `Workflow` tool. Without `/frugal` (or another explicit request), do not fan out agents.

The point: stop burning Opus tokens on work a cheaper model does just as well. Opus stays in the loop only where a wrong call is expensive to undo.

## Usage

```
/frugal <task>                  # run the task as a tiered workflow
/frugal                         # apply tiering to whatever we're already working on
/frugal --plan <task>           # research + plan.md only, stop before implementing
/frugal --no-opus <task>        # hard ceiling at Sonnet; Sonnet writes the plan
/frugal --max-opus <n> <task>   # allow at most n Opus agents (default 1–2)
```

## The roster

| Model | Role | Give it |
|---|---|---|
| **Haiku 4.5** (`haiku`) | intern / entry-level | Research, doc reading, web + codebase search, file inventory, grep sweeps, dependency listing, boilerplate, renames, test-data generation, mechanical refactors with an exact spec, formatting, changelog entries |
| **Sonnet 5** (`sonnet`) | mid-to-senior engineer | Implementation, debugging, code review, writing tests, integration, refactors that require judgment, synthesizing Haiku's research into findings, verification passes |
| **Opus 5** (`opus`) | staff / architect | System design, the final `plan.md`, cross-cutting tradeoffs, ambiguous requirements, arbitrating conflicting agent reports, security-critical or one-way-door decisions |

Haiku is exceptional at research — the majority of research fan-out should be Haiku. Sonnet or Opus turns that research into the plan.

**Default budget shape:** ~60% Haiku agents, ~35% Sonnet, ≤5% Opus. If a run has more than 2 Opus agents, justify each in a `log()` line or downgrade it.

## Routing rules

Route by *cost of being wrong*, not by how impressive the task sounds.

- **Read-only, bounded, verifiable → Haiku.** Anything where the output can be checked mechanically (does the file exist, does the grep match, does the test pass).
- **Writes code that others depend on → Sonnet.** Also every verification/review agent, and every synthesis step over Haiku output.
- **The decision constrains everything downstream → Opus.** One per phase, at most. Typically: the plan, and the final adversarial judgment.

Escalate, don't pre-emptively upgrade: run Haiku first, and if its output is thin or contradictory, re-run that one item at Sonnet. A failed Haiku agent plus a Sonnet retry is still cheaper than starting at Opus.

Never send Opus to *gather* anything. Opus reads what Haiku found.

Pair the tier with `effort`: Haiku research at `low`, Sonnet implementation at `medium`, Opus planning/judging at `high` (`xhigh` only for genuinely hard architecture).

## Standard shape

Phase 1 **Scout (inline, Haiku-equivalent cost)** — before writing the workflow, cheaply establish the work-list yourself: which files, which subsystems, how many items. Do not spawn agents to discover something a `grep` answers.

Phase 2 **Research fan-out (Haiku, parallel)** — one agent per angle, not one per file when files are small. Each returns structured JSON via `schema`, never prose.

Phase 3 **Synthesize → plan.md (Opus ×1, or Sonnet under `--no-opus`)** — a single agent reads all research output and writes the plan. This is the one place Opus reliably earns its cost.

Phase 4 **Implement (Sonnet, pipeline)** — one agent per plan item, `isolation: 'worktree'` only if they touch the same files concurrently.

Phase 5 **Verify (Sonnet, parallel)** — independent reviewers per changed area, prompted to *refute*. Haiku may run the mechanical checks (tests, lint, build) alongside.

Stop after Phase 3 when `--plan` is passed.

## Workflow template

```js
export const meta = {
  name: 'frugal-run',
  description: 'Cost-tiered: Haiku researches, Sonnet builds, Opus plans',
  phases: [
    { title: 'Research', detail: 'Haiku fan-out over angles' },
    { title: 'Plan',     detail: 'single Opus synthesis → plan.md', model: 'opus' },
    { title: 'Build',    detail: 'Sonnet per plan item' },
    { title: 'Verify',   detail: 'Sonnet reviewers + Haiku mechanical checks' },
  ],
}

const FINDINGS = {
  type: 'object',
  properties: {
    angle: { type: 'string' },
    facts: { type: 'array', items: { type: 'string' } },
    files: { type: 'array', items: { type: 'string' } },
    unknowns: { type: 'array', items: { type: 'string' } },
  },
  required: ['angle', 'facts'],
}

phase('Research')
const ANGLES = args.angles ?? []          // established inline before launching
const research = (await parallel(ANGLES.map(a => () =>
  agent(`Research: ${a}. Report only what you verified by reading files or running commands. No recommendations.`,
    { label: `research:${a}`, phase: 'Research', model: 'haiku', effort: 'low', schema: FINDINGS })
))).filter(Boolean)

log(`${research.length}/${ANGLES.length} research agents returned`)

phase('Plan')
const plan = await agent(
  `Here is the verified research:\n${JSON.stringify(research)}\n\n` +
  `Write plan.md: ordered, independently-implementable items, each with files touched and an acceptance check. ` +
  `Flag anything the research left unknown rather than guessing.`,
  { label: 'plan', phase: 'Plan', model: 'opus', effort: 'high',
    schema: { type: 'object', properties: { items: { type: 'array', items: {
      type: 'object',
      properties: { id: {type:'string'}, task: {type:'string'}, files: {type:'array',items:{type:'string'}}, check: {type:'string'} },
      required: ['id','task','check'] } } }, required: ['items'] } })

phase('Build')
const built = await pipeline(
  plan.items,
  item => agent(`Implement: ${item.task}\nFiles: ${(item.files||[]).join(', ')}\nAcceptance: ${item.check}`,
    { label: `build:${item.id}`, phase: 'Build', model: 'sonnet', effort: 'medium' }),
  (result, item) => agent(`Verify item ${item.id} against its acceptance check: ${item.check}. Try to refute that it works. Report pass/fail with evidence.`,
    { label: `verify:${item.id}`, phase: 'Verify', model: 'sonnet', effort: 'medium',
      schema: { type:'object', properties:{ pass:{type:'boolean'}, evidence:{type:'string'} }, required:['pass','evidence'] } })
)

return { plan: plan.items, results: built.filter(Boolean) }
```

## Rules that keep the bill down

1. **Never spawn an agent to answer something a single `grep` or `ls` answers.** Do it inline.
2. **Schemas, not prose.** Every research and verify agent returns a `schema` object. Prose reports cost tokens twice — once to write, once for the next agent to re-read.
3. **`pipeline()` over `parallel()`.** Barriers idle fast agents while slow ones finish; idle agents that get re-prompted later cost real money.
4. **One Opus per phase, max.** If two Opus agents would see the same context, it's one agent.
5. **Cap the fan-out.** More than ~12 research agents means the angles are too narrow — merge them. `log()` anything you dropped.
6. **No Opus verifiers.** Three Sonnet refuters beat one Opus reviewer and cost less.
7. **Reuse the run.** Iterate with `Workflow({scriptPath, resumeFromRunId})` — the unchanged prefix returns cached, so fixing the last phase doesn't re-pay for research.
8. **If `budget.total` is set**, scale the Haiku pool, not the Opus count: `const POOL = budget.total ? Math.min(12, Math.floor(budget.total / 60_000)) : 5`.

## Reporting back

After the run, tell the user in three lines: what shipped, what the verify pass rejected, and the tier mix actually used (e.g. "9 Haiku / 4 Sonnet / 1 Opus"). If you escalated anything off its default tier, say which and why.
