---
name: python-conventions
description: Conventions for Python projects (uv, ruff, pytest, typing). Use when editing or creating Python code.
---

# Python conventions

Python from mise; packages with **uv** (`uv sync`, `uv add`, `uv run`). Don't `pip install` into the global interpreter.

- Detect the project's tooling from `pyproject.toml` / lockfiles and use it (uv, poetry, pip-tools).
- Before finishing: `uv run ruff check --fix . && uv run ruff format .` (or the project's black/isort), `uv run pytest`, and `uv run mypy`/`pyright` if configured.
- Type-hint public functions; prefer `dataclasses`/Pydantic models over loose dicts at boundaries.
- `pathlib` over `os.path`; f-strings; context managers for resources; `logging` not `print` in library code.
- Raise specific exceptions; never bare `except:`; don't swallow errors.
- Tests: pytest functions + fixtures, `parametrize` for tables, `tmp_path` for files, `monkeypatch` over global mocks.
- Keep modules importable without side effects; entry points under `if __name__ == "__main__":` or `[project.scripts]`.
- Secrets from environment variables, never hard-coded; never read `.env` contents into output.
