---
name: commit
description: Write a Conventional Commits message for staged changes and commit. Use when asked to commit, write a commit message, or "save my work" in git.
---

# Commit

1. Inspect what will be committed: `git status --short` and `git diff --staged`.
   If nothing is staged, show `git diff --stat` and ask what to stage. Never `git add -A` blindly.
2. Check the staged diff for secrets (`.env`, keys, tokens). If any, stop and warn.
3. Write the message:
   - Subject: `<type>(<optional scope>): <imperative summary>`, ≤72 chars, no trailing period.
   - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
   - Breaking change: `feat!:` and a `BREAKING CHANGE:` footer.
   - Body (optional, wrapped at 72): *why* the change was made, not a restatement of the diff.
   - Reference issues in the footer: `Refs #123` / `Closes #123`.
4. If the staged diff mixes unrelated changes, propose splitting it instead of committing.
5. Show the message, then run `git commit` (ask first unless told to commit directly).
