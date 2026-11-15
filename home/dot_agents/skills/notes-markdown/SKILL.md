---
name: notes-markdown
description: Youngjae's markdown notes workflow (Google Drive notes, pandoc PDF/beamer export, Korean text). Use when creating, editing, organizing, or exporting notes.
---

# Notes & markdown

Locations (under `$GOOGLE_DRIVE_DIR`, i.e. `~/Google Drive/My Drive`):
- Daily notes: `Notes/src/note-YYYY-MM-DD.md` (PDFs in `Notes/src/pdf/`).
- Topic notes: `Markdown/<topic>/<name>.md`.
- Books: `Books/**/*.pdf`.

CLI (`~/.local/bin/notes`): `notes today | new <dir> <name> | open | pdfs | recent | books | pdf <file> | ppt <file>`.

Writing conventions:
- New notes start with YAML front matter: `title`, `author`, `date` (YYYY-MM-DD).
- Each session appends a `## MM-DD-YYYY HH:MM` heading.
- Notes may mix Korean and English; keep Korean as-is (PDF font: Noto Serif KR via xelatex).
- Use ATX headings, fenced code blocks with a language, and relative links/images.
- For slides (`notes ppt`), use `#`/`##` headings as slide breaks (pandoc beamer).

Export: `notes pdf file.md` → `./pdf/file.pdf`; `notes ppt file.md` → `./presentation/file_p.pdf`. Requires pandoc + a TeX engine with xelatex.
Never delete or move notes without asking; they live in a synced drive.
