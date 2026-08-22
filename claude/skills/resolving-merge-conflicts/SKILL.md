---
name: resolving-merge-conflicts
description: "Work an in-progress git merge/rebase conflict hunk by hunk, resolving each by *intent* traced back to its primary source (commit messages, PRs, original issues) rather than by picking lines; never runs --abort. Use for conflicts where the two sides disagree semantically and you need to understand why each change was made. For a fast, non-interactive resolution of mechanical conflicts, use fix-merge-conflicts instead."
---

1. **See the current state** of the merge/rebase. Check git history, and the conflicting files.

2. **Find the primary sources** for each conflict. Understand deeply why each change was made, and what the original intent was. Read the commit messages, check the PRs, check original issues/tickets.

3. **Resolve each hunk.** Preserve both intents where possible. Where incompatible, pick the one matching the merge's stated goal and note the trade-off. Do **not** invent new behaviour. Always resolve; never `--abort`.

4. Discover the project's **automated checks** and run them, typically typecheck, then tests, then format. Fix anything the merge broke.

5. **Finish the merge/rebase.** Stage everything and commit. If rebasing, continue the rebase process until all commits are rebased.
