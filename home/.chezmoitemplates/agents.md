# Global agent instructions (Youngjae)

These apply to every repository. Repository `AGENTS.md` files override them.

## Environment
- macOS (Apple Silicon), zsh with vi-mode, Homebrew at `/opt/homebrew`.
- Terminal: Ghostty. Agents usually run inside **herdr** panes (`HERDR_ENV=1`); use the `herdr` skill only when asked to drive panes/agents.
- Runtimes come from **mise** (node, python, go). PHP comes from **Laravel Herd**. Respect `.tool-versions`, `.nvmrc`, `.python-version`, `mise.toml`.
- Editors: Neovim (LazyVim) and VS Code. `$EDITOR` is `nvim`.
- Dotfiles are managed by chezmoi in `~/Dotfiles`. Never edit files under `~` that chezmoi manages; edit the source and run `chezmoi diff`.

## Working style
- Before changing code, read the surrounding code and follow its existing conventions.
- Make the smallest complete change. Do not refactor or reformat unrelated code.
- Run the project's own formatter, linter, and tests for what you touched; report what you ran.
- Prefer `rg`/`fd` for search. Use `gh` for GitHub tasks.
- For non-trivial work, use a git worktree on a branch (`wt <branch>`); never commit directly to `main` unless asked.
- Ask before: pushing, force operations, installing dependencies, network calls, deleting files, DB migrations against non-local databases.

## Secrets
- Never read, print, or commit `.env` files, SSH keys, tokens, or `~/.config/zsh/secrets.zsh`.
- Secrets live in 1Password (vault `Dev`); reference them as `op://Dev/<item>/<field>`, never as literals.
- If you find a secret in code or output, stop and tell me.

## Git
- Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`), imperative mood, ≤72-char subject.
- Keep commits focused; explain *why* in the body when it isn't obvious.

## Languages I use
PHP/Laravel, Go, Python, TypeScript/JavaScript. Use the matching skill (`laravel-conventions`, `go-conventions`, `python-conventions`, `ts-js-conventions`) when working in those stacks.

## Communication
- Be concise. Lead with the result, then the evidence.
- I read Korean and English; reply in English unless I write in Korean.
