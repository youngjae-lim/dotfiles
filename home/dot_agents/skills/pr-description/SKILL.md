---
name: pr-description
description: Draft a pull request title and description from the current branch, and optionally open it with gh. Use when asked to open/create a PR or write a PR description.
---

# PR description

1. Gather context: `git log --oneline main..HEAD`, `git diff --stat main...HEAD`, and the full diff for anything non-obvious. Use the repo's default branch if not `main` (`gh repo view --json defaultBranchRef`).
2. Title: Conventional Commits style (`feat: ...`), ≤72 chars.
3. Body (use the repo's `.github/pull_request_template.md` if present, else):

   ```markdown
   ## What
   <1–3 sentences on the change>

   ## Why
   <problem / motivation; link issues: Closes #123>

   ## How
   - <key implementation points a reviewer should know>

   ## Testing
   - <commands run and results; manual steps>

   ## Notes
   <risks, follow-ups, screenshots, migration steps — omit if none>
   ```
4. Ask before pushing. Then: `gh pr create --draft --title "..." --body-file <tmp>` (draft unless told otherwise).
