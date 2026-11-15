---
name: code-review
description: Review a diff, branch, or PR for real bugs, security issues, and design problems. Use when asked to review code, a PR, a branch, or "check my changes".
---

# Code review

Scope: `git diff` (unstaged), `git diff --staged`, `git diff main...HEAD` (branch), or `gh pr diff <n>` (PR). Ask if unclear.

Report only issues that matter, highest severity first:
1. **Bugs** — logic errors, off-by-one, nil/null handling, error paths ignored, race conditions, wrong API use.
2. **Security** — injection (SQL, shell, template), authz/authn gaps, secrets in code, unsafe deserialization, mass assignment (Laravel `$fillable`/`$guarded`), SSRF, path traversal.
3. **Data** — migrations that lose data or lock tables, N+1 queries, missing transactions/indexes.
4. **Tests** — changed behavior without tests; tests that don't assert anything meaningful.
5. **Design** — only when it will cause real maintenance pain.

Rules:
- Read surrounding code before flagging; confirm the issue is real (run the test or reproduce if cheap).
- Each finding: `file:line`, what's wrong, why it matters, and a concrete fix.
- Skip style nits the formatter/linter would catch.
- If everything looks good, say so briefly. Don't invent findings.
