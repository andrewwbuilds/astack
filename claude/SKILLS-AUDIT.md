# Claude Skills Audit — what you actually use

**Generated:** 2026-08-20
**Evidence base:** 4,996 session transcripts (2.6 GB) spanning 2026-07-20 → 2026-08-20, across 44 projects.
**Method:** counted every `Skill` tool invocation and every `/slash` command in the transcript corpus, then checked whether each skill's real-world prerequisites (binaries, credentials, target files) exist on this machine.

---

## The headline

You have **~29 skills** installed. In a month of heavy use (4,996 sessions), **13 were invoked at least once** and **16 were never invoked a single time**.

The unused ones are not free. Every skill's `description` is injected into the system prompt of **every session you start**, whether you use it or not:

| Source | Always-on cost |
|---|---|
| Your 3 user skills | ~478 tokens/session |
| Plugin skills (20) | ~2,505 tokens/session |
| **Total** | **~2,980 tokens/session** |

Roughly **1,900 of those ~3,000 tokens belong to skills you have never once invoked.** That is ~64% pure overhead, paid on every session start, forever.

---

## Usage counts (the raw numbers)

### Actually used

| Skill | Invocations | Notes |
|---|---:|---|
| `claude-api` | 20 | Your most-used skill by a wide margin. Used across 8 different projects. |
| `dev-test` | 8 | Project-scoped (terac-platform). |
| `loop` | 24 | 2 tool calls + 22 `/loop` slash commands. Genuinely part of your workflow. |
| `frontend-design` | 7 | Used across 4 projects. |
| `scroll-world` | 1 | |
| `humanizer` | 1 | |
| `claude-in-chrome` | 1 | +2 slash invocations. |
| `artifact-design` | 1 | |
| `run` | 1 | |
| `xlsx` | 1 | |
| `neon-db` | 1 | Project-scoped. |
| `db-migration` | 1 | Project-scoped. |
| `commit-push-pr` | 1 | Project-scoped. |

### Never invoked — not once, in 4,996 sessions

| Skill | Always-on cost | Disk | Verdict |
|---|---:|---:|---|
| `aws-startup-advisor` (5 skills) | **~1,044 tok** | **4.8 MB** | 🔴 Delete |
| `obsidian-second-brain` | ~309 tok | **21 MB** | 🔴 Delete |
| `obsidian` plugin (5 skills) | ~364 tok | 112 KB | 🟠 Trim |
| `ponytail` (6 skills) | 0 tok (disabled) | **1.9 MB** | 🔴 Delete |
| `graphify` | ~88 tok | 100 KB | 🟡 Decide |
| `karpathy-guidelines` | ~54 tok | 84 KB | 🟡 Cheap, harmless |
| `dataviz` | built-in | — | 🟢 Leave alone |

---

## The findings that matter

### 1. `aws-startup-advisor` — the single biggest waste 🔴

**Cost:** ~1,044 tokens on every session start. 4.8 MB on disk. Five skills, all unused.

The `migration-to-aws` description alone is **1,436 characters (~359 tokens)** — a wall of trigger phrases about migrating off GCP — loaded into your context every time you open Claude Code, on every project.

The prerequisites do not exist on this machine:

- No `aws` CLI installed
- No `~/.aws` directory (no credentials, no config)
- Zero AWS work in any of the 4,996 transcripts

This skill pack cannot function even if it were triggered. It is 35% of your entire always-on skill overhead, doing nothing.

**Action:** `/plugin uninstall aws-startup-advisor@claude-plugins-official`

---

### 2. `ponytail` — already disabled, still on disk 🔴

You set `"ponytail@ponytail": false` in `settings.json`, so it costs zero context. But **1.9 MB** of plugin cache is still sitting in `~/.claude/plugins/cache/ponytail/`.

You clearly evaluated it and decided against it. Finish the job.

**Action:** `/plugin uninstall ponytail@ponytail` — reclaims 1.9 MB, no context change.

---

### 3. `obsidian-second-brain` — the vault is frozen 🔴

**Cost:** 21 MB on disk (your largest single skill), a 72 KB `SKILL.md`, and ~309 tokens/session — the most expensive description of any skill you own.

The damning evidence is in the vaults themselves:

| Vault | Files | Last modified |
|---|---:|---|
| `~/my-vault` | 126 `.md` | **2026-07-09** |
| `~/Documents/Obsidian Vault` | **1** `.md` (`Welcome.md`) | **2026-07-09** |

Both vaults are frozen on the exact day you installed the skill, six weeks ago. The 126 files in `~/my-vault` are the skill's own bootstrap scaffolding — templates, READMEs, index stubs. **Zero notes you actually wrote.** The real Obsidian vault your app points at contains only the default welcome file.

The skill's own pitch is "scheduled agents maintain the vault while you sleep." Nothing has maintained anything. This is a second brain that was never given a first thought.

**Action:** `rm -rf ~/.claude/skills/obsidian-second-brain` — reclaims 21 MB and the single most expensive description you carry.

---

### 4. `obsidian` plugin — two of five skills are structurally broken 🟠

Never invoked, ~364 tokens/session. Worse, two of them would **fail on contact** because their required binaries are absent:

| Skill | Requires | Present? |
|---|---|---|
| `obsidian:obsidian-cli` | `obsidian-cli` binary | ❌ Not installed |
| `obsidian:defuddle` | `defuddle` CLI | ❌ Not installed |

`obsidian:defuddle` is the sharper problem. Its description tells me to use it **"instead of WebFetch when the user provides a URL"** — a very broad, high-frequency trigger. If it ever fires, it fails, and I fall back to WebFetch having wasted a turn. It is a live tripwire, not just dead weight.

There is a genuine counterpoint: you do have Obsidian installed with `.base` files on disk, so `obsidian-bases`, `json-canvas`, and `obsidian-markdown` are at least *pointed at something real*. They are cheap (~64/56/65 tokens). If you ever restart the vault habit, they work without extra setup.

**Action:** at minimum uninstall to kill the broken `defuddle` trigger. If you want to keep the vault option open, uninstall the plugin and reinstall only when you actually return to Obsidian — reinstalling is a one-line command, and carrying it costs you every session in between.

---

### 5. `graphify` — your own skill, zero uses 🟡

Never invoked, despite being **promoted in your global `CLAUDE.md`**, which instructs every session: *"When the user types `/graphify`, use the installed graphify skill before doing anything else."*

You built it, you wired it into your global instructions, and in a month you never typed `/graphify` once. It is cheap (~88 tokens, 100 KB), so this is not a cost argument — it is a signal question. Either the workflow it serves has not come up, or the trigger never crosses your mind when it would help.

**Action:** your call. Keep it (it is nearly free), but consider whether the `CLAUDE.md` promotion is earning its place. Note that `frugal` — also yours, also unused until today — is in the same category.

---

### 6. `karpathy-guidelines` — cheapest thing you own 🟡

Never invoked, but ~54 tokens/session and 84 KB. It is behavioral guidance rather than a tool, so it is the kind of skill that shapes output when it loads rather than being something you reach for by name. Not worth the keystrokes to remove.

**Action:** leave it.

---

## Recommended cleanup

Run in order of impact:

```bash
# 1. Biggest win: 4.8 MB + ~1,044 tok/session, prerequisites don't exist
/plugin uninstall aws-startup-advisor@claude-plugins-official

# 2. Already disabled, just reclaiming disk: 1.9 MB
/plugin uninstall ponytail@ponytail

# 3. Dead vault, largest disk + most expensive description: 21 MB + ~309 tok/session
rm -rf ~/.claude/skills/obsidian-second-brain

# 4. Never used, two skills structurally broken: 112 KB + ~364 tok/session
/plugin uninstall obsidian@obsidian-skills
```

### What that buys you

| | Before | After | Saved |
|---|---:|---:|---:|
| Always-on context | ~2,980 tok | ~**1,263 tok** | **~1,717 tok/session (58%)** |
| Skill disk | ~28 MB | ~**0.4 MB** | **~27.6 MB** |
| Skills carried | ~29 | ~**13** | 16 |

At 4,996 sessions/month, ~1,717 tokens/session is roughly **8.5M tokens of pure prompt overhead per month** — paid to describe tools you never call.

---

## What to keep, and why

| Skill | Reason |
|---|---|
| `claude-api` | 20 uses across 8 projects. Your workhorse. |
| `loop` | 24 invocations. Real workflow infrastructure. |
| `frontend-design` | 7 uses across 4 projects. Earning it. |
| `frugal`, `graphify` | Yours, cheap, low-friction to keep. |
| `humanizer` | 1 use, but 447-char description for a distinctive capability. Fine. |
| `scroll-world` | 1 use, and it maps directly to your portfolio work. |
| `karpathy-guidelines` | ~54 tokens. Below the threshold of caring. |
| Built-ins (`code-review`, `dataviz`, `artifact-*`, `run`, `claude-in-chrome`) | Ship with Claude Code, not your overhead to manage. |

---

## Caveats

- **The window is one month.** A skill used quarterly (a migration, an annual report) would look dead here. `aws-startup-advisor` and `obsidian-second-brain` survive that objection because their *prerequisites are missing entirely* — that is independent of how often you'd reach for them.
- **Token estimates use ~4 chars/token.** Directionally right, not exact.
- **Auto-triggered skills count the same as manual ones.** A skill that never fired never fired, whether you'd have typed its name or not — that is arguably the stronger indictment, since these are meant to trigger on their own.
- **Reinstalling is cheap.** Every uninstall above is one command to reverse. Nothing here is a one-way door.
