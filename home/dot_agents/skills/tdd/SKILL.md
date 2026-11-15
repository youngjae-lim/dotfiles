---
name: tdd
description: Test-driven development loop — write a failing test, make it pass, refactor. Use when asked to do TDD, "write tests first", or fix a bug with a regression test.
---

# TDD

1. **Understand** the behavior to add or the bug to fix. Find the existing test file and test style for that code.
2. **Red** — write the smallest test that expresses the next bit of behavior (or reproduces the bug). Run *only* that test and confirm it fails **for the expected reason** (not a typo or import error). Show the failure.
3. **Green** — write the minimum production code to pass. Run the test; then the surrounding test file/package.
4. **Refactor** — clean up names/duplication in code and tests with tests green. Run the broader suite.
5. Repeat for the next behavior. Cover edge cases (empty, nil/null, boundaries, error paths) as separate red/green steps.

Rules:
- Never change a test just to make it pass unless the test itself was wrong — say so explicitly.
- Keep tests deterministic: no real network, clock, or randomness without fakes.
- Test behavior through public interfaces, not implementation details.
- Commands: Go `go test ./pkg -run TestName`; Laravel `vendor/bin/pest --filter name`; Python `uv run pytest path::test_name`; JS `pnpm test -- -t "name"` / `bun test -t "name"`.
