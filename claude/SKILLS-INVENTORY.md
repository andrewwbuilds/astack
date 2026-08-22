# Every skill you have — complete inventory

**Generated:** 2026-08-20
**Usage data:** 4,996 session transcripts, 2026-07-20 → 2026-08-20, 44 projects.
**Legend:** ✅ used · ⚪ never invoked · 🔴 broken or dead prerequisite

---

## The count

| Scope | Skills | Loads when | Used |
|---|---:|---|---:|
| **User** (`~/.claude/skills/`) | 3 | Every session, everywhere | 0 |
| **Plugin** (7 installed) | 26 | Every session, everywhere | 2 |
| **Built-in** (ship with Claude Code) | 17 | Every session, everywhere | 5 |
| **Project** — `terac/platform` | 19 | Only in that repo | 3 |
| **Project** — `hackathons/intern` | 33 | Only in that repo | 0 |
| **Project** — `my-vault` | 6 | Only in that vault | 0 |
| **TOTAL** | **104** | | **10** |

You have **104 skills**. In a month of heavy use, **10 were ever invoked**.

The three global scopes (46 skills) cost **~3,000 tokens on every session start**. The project scopes add on top when you're in those repos: +1,681 tok in `terac/platform`, +1,514 tok in `hackathons/intern`.

---

## 1. Your own skills — `~/.claude/skills/`

*Always loaded. ~478 tok/session.*

| Skill | Uses | Desc cost | Disk | What it does |
|---|---:|---:|---:|---|
| `obsidian-second-brain` | ⚪ 0 | 309 tok | **21 MB** | Runs an Obsidian vault as a self-rewriting second brain. Both target vaults frozen on install day (2026-07-09). |
| `graphify` | ⚪ 0 | 88 tok | 100 KB | Turns any input into a persistent knowledge graph. Promoted in your global `CLAUDE.md`, still never typed. |
| `frugal` | ✅ 1 | 80 tok | 136 KB | Cost-tiered multi-agent orchestration. First used today. |

---

## 2. Installed plugins — 7 plugins, 26 skills

*Always loaded. ~2,505 tok/session.*

### `aws-startup-advisor` — 5 skills, ⚪ 0 uses, ~1,044 tok, 4.8 MB
| Skill | Desc cost |
|---|---:|
| 🔴 `migration-to-aws` | 359 tok |
| 🔴 `prompt-library-for-startups` | 223 tok |
| 🔴 `knowledge-base-for-startups` | 212 tok |
| 🔴 `start-building-for-startups` | 160 tok |
| 🔴 `architect-for-startups` | 90 tok |

No `aws` CLI, no `~/.aws`, zero AWS work in any transcript. Your single largest context expense.

### `obsidian` — 5 skills, ⚪ 0 uses, ~364 tok, 112 KB
| Skill | Desc cost | Status |
|---|---:|---|
| 🔴 `obsidian-cli` | 116 tok | `obsidian-cli` binary not installed |
| 🔴 `defuddle` | 86 tok | `defuddle` binary not installed — and it claims *any URL*, so it's a live tripwire |
| ⚪ `obsidian-markdown` | 65 tok | Works; vault is dormant |
| ⚪ `obsidian-bases` | 64 tok | Works; `.base` files exist in `~/my-vault` |
| ⚪ `json-canvas` | 56 tok | Works |

### `ponytail` — 6 skills, ⚪ 0 uses, **0 tok (disabled)**, 1.9 MB
`ponytail`, `ponytail-review`, `ponytail-audit`, `ponytail-debt`, `ponytail-gain`, `ponytail-help`

Set to `false` in `settings.json`, so it costs no context — but 1.9 MB is still cached on disk.

### Single-skill plugins
| Plugin | Uses | Desc cost | Disk |
|---|---:|---:|---:|
| `frontend-design` | ✅ **7** | 51 tok | 72 KB |
| `scroll-world` | ✅ 1 | 189 tok | 156 KB |
| `humanizer` | ✅ 1 | 111 tok | 92 KB |
| `karpathy-guidelines` | ⚪ 0 | 54 tok | 84 KB |

---

## 3. Built-in skills — 17

*Ship with Claude Code. Not your overhead to manage, but here's what you actually reach for.*

| Skill | Uses |
|---|---:|
| `claude-api` | ✅ **20** — your most-used skill, across 8 projects |
| `loop` | ✅ **24** (2 tool calls + 22 `/loop` commands) |
| `run` | ✅ 1 |
| `claude-in-chrome` | ✅ 1 (+2 slash) |
| `artifact-design` | ✅ 1 |
| `code-review` · `simplify` · `security-review` | ⚪ 0 |
| `design` · `dataviz` · `artifact-diagramming` · `artifact-capabilities` | ⚪ 0 |
| `update-config` · `keybindings-help` · `fewer-permission-prompts` | ⚪ 0 |
| `schedule` · `init` | ⚪ 0 |

Notable: **`code-review`, `simplify`, and `security-review` have never run** despite a month of shipping code. Also `dataviz` — never invoked, though you've built UI across four projects.

---

## 4. Project skills — `terac/platform` (19)

*Loads only in that repo. ~1,681 tok/session there. This is your real working set.*

| Skill | Uses | What it does |
|---|---:|---|
| `dev-test` | ✅ **8** | Local e2e browser testing + visual self-verification |
| `neon-db` | ✅ 1 | Query the Terac Postgres DB |
| `db-migration` | ✅ 1 | Generate/regenerate Drizzle migrations |
| `frontend-design` | ⚪ 0 | *(duplicate of the global plugin — same 204-char description loaded twice in this repo)* |
| `logging` | ⚪ 0 | Structured logging with `@repo/observability` |
| `context7-mcp` | ⚪ 0 | Version-current library docs |
| `web-design-guidelines` | ⚪ 0 | UI code review for interface guidelines |
| `vercel-react-best-practices` | ⚪ 0 | React/Next perf from Vercel Eng |
| `pr-evidence` | ⚪ 0 | Record a GIF, attach to PR |
| `demo-video` | ⚪ 0 | Narrated WebM of a feature flow |
| `promo-video` | ⚪ 0 | Remotion-based promo video |
| `product-update` | ⚪ 0 | Slack #product-updates announcement |
| `sync-notion-linear-customers` | ⚪ 0 | Notion CRM → Linear customer sync |
| `find-skills` | ⚪ 0 | Discover/install more skills |
| `apple-design` · `emil-design-eng` | ⚪ 0 | Design philosophy packs |
| `animation-vocabulary` · `find-animation-opportunities` · `improve-animations` | ⚪ 0 | A three-skill animation cluster, entirely unused |

**16 of 19 unused.** There's a five-skill design/animation cluster and a three-skill video cluster here that have never fired once.

⚠️ These 19 skills are **duplicated in 5 places**: the repo, `platform-hackathon-banner`, and four worktree copies (`.claude/skills` + `.agents/skills` in each of two worktrees).

---

## 5. Project skills — `hackathons/intern` (33)

*Loads only in that repo. ~1,514 tok/session there. **All 33 unused.***

A complete Convex backend skill pack:

`convex` (947-char description alone) · `convex-add` · `convex-advisor` · `convex-agent` · `convex-auth` · `convex-authz` · `convex-backup` · `convex-billing` · `convex-cost` · `convex-create-component` · `convex-crons` · `convex-deploy-guard` · `convex-design` · `convex-docs` · `convex-domains` · `convex-env` · `convex-expert` · `convex-explain-app` · `convex-improve-convex-plugin` · `convex-insights` · `convex-launch-readiness` · `convex-migrate` · `convex-migrate-rehearse` · `convex-monitor` · `convex-optimize` · `convex-quickstart` · `convex-reviewer` · `convex-seed` · `convex-self-heal` · `convex-sentinel` · `convex-suggest` · `convex-test` · `convex-verify`

The one transcript touching this repo used `claude-in-chrome`, not Convex. If that hackathon is over, this whole pack is dead weight in that directory.

---

## 6. Project skills — `my-vault` (6)

*Loads only in the vault. All ⚪ 0 uses.*

`defuddle` · `json-canvas` · `obsidian-bases` · `obsidian-cli` · `obsidian-markdown` · `qmd`

Five of these are **the same Obsidian skills you already have installed globally** — a third copy of the same descriptions. (A fourth set sits in `my-vault/.shardmind/templates/.claude/skills`.)

---

## What stands out

**1. 10 of 104.** Roughly 90% of what you carry has never run. Skills aren't only manual — most are meant to auto-trigger — so "never invoked" means the model never judged them relevant either.

**2. Four copies of the Obsidian skills.** Global plugin, `my-vault`, the shardmind templates, and a partial overlap in the global user skill. They cost context in each scope and all point at a dormant vault.

**3. Five copies of the terac skills.** Repo + banner fork + four worktree dirs. Worktrees each carry both `.claude/skills` and `.agents/skills`.

**4. Your actual working set is small and clear:** `claude-api` (20), `loop` (24), `dev-test` (8), `frontend-design` (7). Everything else is single-digit or zero. Those four are worth protecting; almost nothing else is earning its keep.

**5. The unused built-ins are the interesting gap.** `code-review`, `simplify`, `security-review`, and `dataviz` cost you nothing extra — they ship with Claude Code — and they map directly onto work you did this month. Unlike the rest of this document, the fix there is to *use them*, not remove them.

---

## Caveats

- **One-month window.** A quarterly-use skill looks identical to a dead one here.
- **Token counts are ~4 chars/token.** Directionally right, not exact.
- **Project skills only cost you in their own repo** — the 33 Convex skills are free everywhere except `hackathons/intern`.
- **Duplicate counting:** the 104 total counts each scope once. It excludes the `node_modules` and `.cursor` skill directories, which aren't yours.

See `SKILLS-AUDIT.md` for the cleanup recommendations and what removing things buys you.
