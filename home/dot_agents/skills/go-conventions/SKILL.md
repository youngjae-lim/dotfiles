---
name: go-conventions
description: Conventions for Go projects (modules, error handling, testing, tooling). Use when editing or creating Go code.
---

# Go conventions

Toolchain from mise (`go`), respect `go.mod`'s `go`/`toolchain` lines.

- Before finishing: `gofmt -l .` (or `go fmt ./...`), `go vet ./...`, `go test ./...`; `golangci-lint run` if `.golangci.yml` exists.
- Errors: return them, wrap with context `fmt.Errorf("doing x: %w", err)`; check with `errors.Is/As`. No `panic` for expected failures. Don't log *and* return the same error.
- `context.Context` is the first param for anything doing I/O; respect cancellation.
- Keep interfaces small and defined where they're consumed; accept interfaces, return structs.
- Zero values should be useful; avoid unnecessary pointers and getters/setters.
- Concurrency: every goroutine has a clear owner and exit path; use `errgroup`, guard shared state, run `go test -race` when touching concurrency.
- Tests: table-driven with `t.Run`, `t.Helper()` in helpers, `t.Parallel()` where safe, `httptest` for HTTP. Put fixtures in `testdata/`.
- Standard library first (`net/http` routing, `log/slog`, `database/sql`); add deps only when they clearly pay off — ask first.
- SQL: parameterized queries only; migrations via `golang-migrate` if the project uses it.
- Naming: short receiver names, `MixedCaps`, no stutter (`user.User` → `user.Model` only if the codebase does).
